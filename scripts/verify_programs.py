"""Ejecuta los .s y los .hex (convertidos a binario) en Ripes RV32I.

Uso: python scripts/verify_programs.py --ripes RUTA/Ripes.exe
No es un ensamblador: Ripes ensambla los .s. Los .hex contienen palabras
ya codificadas; el script solo cambia su representacion a bytes.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / "build" / "ripes"


def run_ripes(executable, source, kind):
    args = [str(executable), "--mode", "cli", "--src", str(source), "-t", kind,
            "--proc", "RV32_SS", "--timeout", "5000", "--regs", "--cycles",
            "--iret", "--runinfo", "--json"]
    result = subprocess.run(args, stdin=subprocess.DEVNULL, capture_output=True, text=True, timeout=20)
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    report = json.loads(result.stdout)
    if (report.get("runinfo", {}).get("processor") != "RV32_SS"
            or report.get("runinfo", {}).get("ISA extensions") != []):
        raise ValueError("Ripes no esta usando el modelo RV32I uniciclo sin extensiones")
    # Solo normalizar la ruta de entrada; conservar las mediciones de Ripes.
    if "runinfo" in report:
        report["runinfo"]["source file"] = source.name
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ripes", type=Path, required=True)
    args = parser.parse_args()
    executable = args.ripes.resolve()
    if not executable.is_file():
        parser.error("No se encontro el ejecutable de Ripes")
    BUILD.mkdir(parents=True, exist_ok=True)
    reports = {}
    for name, count in [("program", 6), ("prog2", 23)]:
        source = ROOT / "programs" / (name + ".s")
        hex_file = source.with_suffix(".hex")
        words = hex_file.read_text(encoding="utf-8").split()
        if len(words) != count or not all(re.fullmatch(r"[0-9a-fA-F]{8}", word) for word in words):
            raise ValueError("Cantidad o formato de palabras incorrecto: " + str(hex_file))
        binary = BUILD / (name + ".bin")
        binary.write_bytes(b"".join(int(word, 16).to_bytes(4, "little") for word in words))
        assembly_report = run_ripes(executable, source, "asm")
        hex_report = run_ripes(executable, binary, "bin")
        if assembly_report["registers"] != hex_report["registers"]:
            raise ValueError(name + ": los registros de .s y .hex difieren")
        for report in [assembly_report, hex_report]:
            if report["# instructions retired"] != count or report["cycles"] != count:
                raise ValueError(name + ": numero de instrucciones/ciclos inesperado")

        # La CLI de Ripes 2.2.6 reporta registros, no un volcado de DMEM.
        # Un sufijo de observacion carga las palabras finales en x28..x30.
        # Este sufijo NO se incluye en los programas entregados ni en el DUT.
        if name == "program":
            suffix = "lw x28, 0(x0)\n"
            suffix_words = [0x00002E03]
            memory_registers = {"0x00": "x28"}
            expected_memory = {"0x00": 20}
        else:
            suffix = "addi x31, x0, 224\nlw x28, 0(x31)\nlw x29, 4(x31)\nlw x30, 28(x31)\n"
            suffix_words = [0x0E000F93, 0x000FAE03, 0x004FAE83, 0x01CFAF03]
            memory_registers = {"0xe0": "x28", "0xe4": "x29", "0xfc": "x30"}
            expected_memory = {"0xe0": 8, "0xe4": 22, "0xfc": 0xFFFFFFFB}
        probe_source = BUILD / (name + "_memory_probe.s")
        probe_source.write_text(source.read_text(encoding="utf-8") + "\n" + suffix, encoding="utf-8")
        probe_binary = BUILD / (name + "_memory_probe.bin")
        probe_binary.write_bytes(binary.read_bytes() + b"".join(word.to_bytes(4, "little") for word in suffix_words))
        probe = run_ripes(executable, probe_source, "asm")
        probe_hex = run_ripes(executable, probe_binary, "bin")
        if probe["registers"] != probe_hex["registers"]:
            raise ValueError(name + ": memoria observada de .s y .hex difiere")
        expected_count = count + len(suffix_words)
        if any(report["cycles"] != expected_count or report["# instructions retired"] != expected_count
               for report in [probe, probe_hex]):
            raise ValueError(name + ": el sufijo de observacion no termino correctamente")
        memory = {address: probe["registers"][register] for address, register in memory_registers.items()}
        if memory != expected_memory:
            raise ValueError(name + ": memoria final inesperada")
        for label, report in [("asm", assembly_report), ("hex", hex_report),
                              ("memory_asm", probe), ("memory_hex", probe_hex)]:
            (BUILD / (name + "_" + label + ".json")).write_text(
                json.dumps(report, indent=2) + "\n", encoding="utf-8")
        reports[name] = {"instructions": count, "cycles": assembly_report["cycles"],
                         "asm_hex_registers_equal": True, "memory": memory,
                         "registers": assembly_report["registers"],
                         "sha256_s": hashlib.sha256(source.read_bytes()).hexdigest(),
                         "sha256_hex": hashlib.sha256(hex_file.read_bytes()).hexdigest()}
        if name == "prog2":
            # Observar tambien el 14 que luego sera sobrescrito por 22.
            instructions = [line for line in source.read_text(encoding="utf-8").splitlines()
                            if line.strip() and not line.lstrip().startswith(("#", "."))]
            partial_source = BUILD / "prog2_intermediate.s"
            partial_source.write_text(".text\n" + "\n".join(instructions[:11])
                                      + "\naddi x31,x0,224\nlw x29,4(x31)\n", encoding="utf-8")
            partial_binary = BUILD / "prog2_intermediate.bin"
            partial_binary.write_bytes(binary.read_bytes()[:44]
                                       + (0x0E000F93).to_bytes(4, "little")
                                       + (0x004FAE83).to_bytes(4, "little"))
            for label, path, kind in [("asm", partial_source, "asm"),
                                      ("hex", partial_binary, "bin")]:
                partial = run_ripes(executable, path, kind)
                if partial["registers"]["x29"] != 14 or partial["cycles"] != 13:
                    raise ValueError("El primer sw a 0xe4 no produjo 14")
                (BUILD / ("prog2_intermediate_" + label + ".json")).write_text(
                    json.dumps(partial, indent=2) + "\n", encoding="utf-8")
            reports[name]["memory_after_11_instructions"] = {"0xe4": 14}
        print(f"{name}: .s y .hex coinciden en Ripes; {count} ciclos; memoria {memory}")
    (BUILD / "summary.json").write_text(json.dumps(reports, indent=2) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
