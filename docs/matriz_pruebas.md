# Matriz de pruebas - Sámara

Verificador: Andrés Rojas Viquez.
Fecha de ejecución: 25/10/2026 17:57 (Costa Rica).

Los 13 casos se ejecutaron localmente con Icarus Verilog 13.0 sobre los módulos del repositorio Bi-cho/Single-Cycle-RISC-V-Processor, versión 155ed2f9360005b46606c203052273c923be451b. Resultado: 13 PASS. La ejecución oficial en EDA Playground sigue pendiente.

| ID | Módulo | Entrada / condición | Esperado | Obtenido | Estado |
|---|---|---|---|---|---|
| ALU-01 | ALU | ADD: 5 + 3 | Result=00000008; Zero=0 | Result=00000008; Zero=0 | PASS |
| ALU-02 | ALU | SUB: 3 - 5 = -2; resultado negativo | Result=fffffffe; Zero=0 | Result=fffffffe; Zero=0 | PASS |
| ALU-03 | ALU | AND: 5 AND 2 = 0; comprobar Zero=1 | Result=00000000; Zero=1 | Result=00000000; Zero=1 | PASS |
| ALU-04 | ALU | OR: 5 OR 3 = 7 | Result=00000007; Zero=0 | Result=00000007; Zero=0 | PASS |
| RF-01 | Register File | Escribir x5=25 y leer x5 | RD1=00000019 | RD1=00000019 | PASS |
| RF-02 | Register File | Escribir x6=50; leer x5 y x6 simultáneamente | RD1=00000019; RD2=00000032 | RD1=00000019; RD2=00000032 | PASS |
| RF-03 | Register File | Intentar escribir x0=100; leer x0 por ambos puertos | RD1=00000000; RD2=00000000 | RD1=00000000; RD2=00000000 | PASS |
| IMM-01 | Immediate Generator | I-type positivo; Instr=00508113; ImmSrc=00 | ImmExt=00000005 | ImmExt=00000005 | PASS |
| IMM-02 | Immediate Generator | I-type negativo; Instr=FFF08113; ImmSrc=00 | ImmExt=ffffffff | ImmExt=ffffffff | PASS |
| IMM-03 | Immediate Generator | S-type positivo; Instr=0220A2A3; ImmSrc=01 | ImmExt=00000025 | ImmExt=00000025 | PASS |
| IMM-04 | Immediate Generator | S-type negativo; Instr=FE20A823; ImmSrc=01 | ImmExt=fffffff0 | ImmExt=fffffff0 | PASS |
| MUX-01 | MUX | A=12345678; B=ABCDEF00; Select=0 | Y=12345678 | Y=12345678 | PASS |
| MUX-02 | MUX | A=12345678; B=ABCDEF00; Select=1 | Y=abcdef00 | Y=abcdef00 | PASS |

La resta de ALU-02 cubre el resultado negativo y ALU-03 cubre resultado cero y Zero=1.
