"""Regresion local. Requiere Icarus Verilog; no instala herramientas.

Ejecutar desde cualquier carpeta:
  python scripts/run_verification.py --iverilog RUTA/iverilog.exe
  python scripts/run_verification.py --integration
En Windows se agrega el directorio del compilador a PATH para sus DLL.
"""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / "build"
CASES = [
    ("alu_tb", "alu.sv", 4),
    ("register_file_tb", "register_file.sv", 3),
    ("imm_gen_tb", "imm_gen.sv", 4),
    ("mux_tb", "mux.sv", 2),
    ("control_unit_tb", "control_unit.sv", 15),
]
PROCESS_FLAGS = {"creationflags": subprocess.CREATE_NO_WINDOW} if os.name == "nt" else {}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--iverilog", default="iverilog")
    parser.add_argument("--vvp", default=None)
    parser.add_argument("--integration", action="store_true")
    args = parser.parse_args()
    compiler = shutil.which(args.iverilog)
    if not compiler:
        parser.error("No se encontro Icarus. Use --iverilog con su ruta.")
    compiler = Path(compiler).resolve()
    runner = args.vvp or str(compiler.with_name("vvp.exe" if os.name == "nt" else "vvp"))
    if not shutil.which(runner):
        parser.error("No se encontro vvp. Use --vvp con su ruta.")
    env = os.environ.copy()
    env["PATH"] = str(compiler.parent) + os.pathsep + env.get("PATH", "")
    BUILD.mkdir(exist_ok=True)
    version = subprocess.run([str(compiler), "-V"], env=env, capture_output=True,
                             stdin=subprocess.DEVNULL, text=True, timeout=30, **PROCESS_FLAGS).stdout.splitlines()[0]
    results = []
    for top, module, expected in CASES:
        results.append(run_case(compiler, runner, env, top,
                                [ROOT / "src" / module], expected, ROOT))
    if args.integration:
        needed = ["program_counter.sv", "instr_mem.sv", "data_mem.sv", "riscv_single_cycle.sv"]
        missing = [name for name in needed if not (ROOT / "src" / name).exists()]
        if missing:
            print("Integracion PENDIENTE: faltan " + ", ".join(missing))
            results.append({"top": "riscv_single_cycle_tb", "status": "PENDING", "missing": missing})
        else:
            results.append(run_case(compiler, runner, env, "riscv_single_cycle_tb",
                                    sorted((ROOT / "src").glob("*.sv")), 38, ROOT / "programs"))
    summary = {"compiler": version, "results": results}
    (BUILD / "summary.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    return 0 if all(result["status"] == "PASS" for result in results) else 1


def run_case(compiler, runner, env, top, sources, expected, cwd):
    output = BUILD / (top + ".vvp")
    compile_result = subprocess.run(
        [str(compiler), "-Wall", "-g2012", "-s", top, "-o", str(output)]
        + [str(path) for path in sources] + [str(ROOT / "testbench" / (top + ".sv"))],
        cwd=ROOT, env=env, stdin=subprocess.DEVNULL, capture_output=True, text=True, timeout=30, **PROCESS_FLAGS)
    (BUILD / (top + ".compile.log")).write_text(
        compile_result.stdout + compile_result.stderr, encoding="utf-8")
    if compile_result.returncode:
        print(f"{top}: FAIL al compilar, codigo {compile_result.returncode} (ver build/)")
        return {"top": top, "status": "FAIL", "stage": "compile",
                "exit_code": compile_result.returncode}
    sim = subprocess.run([runner, str(output)], cwd=cwd, env=env,
                         stdin=subprocess.DEVNULL, capture_output=True, text=True, timeout=30, **PROCESS_FLAGS)
    log = sim.stdout + sim.stderr
    (BUILD / (top + ".log")).write_text(log, encoding="utf-8")
    passes = re.findall(r"^([A-Z]+-\d+) PASS\s*$", log, re.MULTILINE)
    failures = re.findall(r"^([A-Z]+-\d+) FAIL\s*$", log, re.MULTILINE)
    # Los TB anteriores usan $finish incluso al fallar; por eso tambien
    # se comprueban FAIL, la cantidad esperada y los identificadores unicos.
    ok = (sim.returncode == 0 and not failures and len(passes) == expected
          and len(set(passes)) == expected and "ERROR:" not in log and "FATAL:" not in log)
    status = "PASS" if ok else "FAIL"
    print(f"{top}: {len(passes)}/{expected} PASS, {len(failures)} FAIL -> {status}")
    return {"top": top, "status": status, "passes": passes, "failures": failures,
            "expected_cases": expected, "exit_code": sim.returncode}


if __name__ == "__main__":
    sys.exit(main())
