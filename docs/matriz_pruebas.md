# Matriz de pruebas - Sámara

Verificador: Andrés Rojas Viquez.
Fecha de ejecución en EDA Playground: 25/10/2026 18:27 (Costa Rica).

Los 13 casos se ejecutaron en EDA Playground con Icarus Verilog 12.0 y opciones `-Wall -g2012`, usando los mismos módulos y testbenches subidos en la versión fd8430e9a8595bef6d8233d60cf8a485584db7a1 del repositorio. Resultado: 13 PASS. También se habían obtenido 13 PASS en la simulación local con Icarus Verilog 13.0.

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

Simulaciones: [ALU](https://edaplayground.com/x/N9xm), [Register File](https://edaplayground.com/x/YxXV), [Immediate Generator](https://edaplayground.com/x/wYfw), [MUX](https://edaplayground.com/x/i8md).


## Capítulo 2 - verificación de integración

El 14/11/2026 se repitieron las pruebas del Capítulo 1 y de la unidad de control con Icarus Verilog 13.0 (`-Wall -g2012`). Se obtuvieron 13/13 PASS y 15/15 PASS, respectivamente. Los resultados anteriores del Capítulo 1 se mantienen en la tabla de arriba.

El programa propio se encuentra en `programs/program.s` y `programs/program.hex` y contiene ocho instrucciones. Sus resultados esperados se comprobaron en Ripes con el procesador uniciclo RV32I. La dirección de byte 0xe0 corresponde a la posición 56 de la memoria de datos.

El 15/11/2026 se probó el procesador completo con Icarus Verilog 13.0 y las opciones `-Wall -g2012`. Se usaron los módulos y el testbench de la versión `5e34967` del repositorio. Los nueve casos obtuvieron **PASS**. Los resultados del procesador coincidieron con los esperados en Ripes.

La simulación del equipo está disponible en [EDA Playground](https://edaplayground.com/x/wYH8).

| ID | Instrucción o secuencia | Condición inicial | Esperado | Obtenido local (Icarus 13) | Estado |
|---|---|---|---|---|---|
| INT-01 | Reset | reset=1; flanco positivo | PC=00000000 | PC=00000000 | PASS |
| INT-02 | Secuencia del PC | PC=0; ejecutar ocho instrucciones | 0,4,8,12,16,20,24,28,32 | 0,4,8,12,16,20,24,28,32 | PASS |
| INT-03 | addi | x0=0; cargar 12 y -5 | x1=0000000c; x2=fffffffb | x1=0000000c; x2=fffffffb | PASS |
| INT-04 | add | x1=12; x2=-5 | x3=00000007 | x3=00000007 | PASS |
| INT-05 | sub | x1=12; x2=-5 | x4=00000011 | x4=00000011 | PASS |
| INT-06 | and | x1=0000000c; x2=fffffffb | x5=00000008 | x5=00000008 | PASS |
| INT-07 | or | x1=0000000c; x2=fffffffb | x6=ffffffff | x6=ffffffff | PASS |
| INT-08 | sw | x5=8; dirección 0xe0 | DMEM[56]=00000008 | DMEM[56]=00000008 | PASS |
| INT-09 | lw | Mem[0xe0]=8 | x7=00000008 | x7=00000008 | PASS |
