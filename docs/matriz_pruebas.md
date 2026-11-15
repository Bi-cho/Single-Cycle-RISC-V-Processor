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


## Revision local del Capitulo 2 - 14/11/2026

Regresion repetida sobre los modulos del repositorio, base `3faca060163f7ccfe453aa4934048b117fbfd1c3`: Icarus Verilog 13.0, `-Wall -g2012`. Capitulo 1: 13/13 PASS; unidad de control: 15/15 PASS. Esta revision es local; no reemplaza la evidencia historica de EDA ni afirma una nueva ejecucion con Icarus 12. Los casos CTRL tambien estan descritos en el [TB de control](../testbench/control_unit_tb.sv).

| ID | Modulo | Esperado | Obtenido local 14/11 | Estado |
|---|---|---|---|---|
| ALU-01 | alu | Result=00000008; Zero=0 | Result=00000008; Zero=0 | PASS |
| ALU-02 | alu | Result=fffffffe; Zero=0 | Result=fffffffe; Zero=0 | PASS |
| ALU-03 | alu | Result=00000000; Zero=1 | Result=00000000; Zero=1 | PASS |
| ALU-04 | alu | Result=00000007; Zero=0 | Result=00000007; Zero=0 | PASS |
| RF-01 | register_file | RD1=00000019 | RD1=00000019 | PASS |
| RF-02 | register_file | RD1=00000019; RD2=00000032 | RD1=00000019; RD2=00000032 | PASS |
| RF-03 | register_file | RD1=00000000; RD2=00000000 | RD1=00000000; RD2=00000000 | PASS |
| IMM-01 | imm_gen | ImmExt=00000005 | ImmExt=00000005 | PASS |
| IMM-02 | imm_gen | ImmExt=ffffffff | ImmExt=ffffffff | PASS |
| IMM-03 | imm_gen | ImmExt=00000025 | ImmExt=00000025 | PASS |
| IMM-04 | imm_gen | ImmExt=fffffff0 | ImmExt=fffffff0 | PASS |
| MUX-01 | mux | Y=12345678 | Y=12345678 | PASS |
| MUX-02 | mux | Y=abcdef00 | Y=abcdef00 | PASS |
| CTRL-01 | control_unit | RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-02 | control_unit | RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0001 | RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0001 | PASS |
| CTRL-03 | control_unit | RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0010 | RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0010 | PASS |
| CTRL-04 | control_unit | RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0011 | RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0011 | PASS |
| CTRL-05 | control_unit | RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-06 | control_unit | RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=1 ImmSrc=00 ALUControl=0000 | RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=1 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-07 | control_unit | RegWrite=0 ALUSrc=1 MemWrite=1 ResultSrc=0 ImmSrc=01 ALUControl=0000 | RegWrite=0 ALUSrc=1 MemWrite=1 ResultSrc=0 ImmSrc=01 ALUControl=0000 | PASS |
| CTRL-08 | control_unit | RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-09 | control_unit | RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-10 | control_unit | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-11 | control_unit | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-12 | control_unit | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-13 | control_unit | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-14 | control_unit | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |
| CTRL-15 | control_unit | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000 | PASS |

Logs y resumen: [evidencia_cap2](evidencia_cap2/). Los IDs del Capitulo 1 se conservan: estas filas documentan su regresion, no casos nuevos. Los 15 CTRL son los casos de Gabriel, repetidos localmente.

## Integracion del procesador - casos preparados

**PENDIENTE de ejecutar contra el RTL final.** Faltan PC, memorias y top en `src/`. Los valores esperados de los programas se contrastaron con Ripes RV32I; eso no constituye un obtenido del procesador del equipo. No se rellenan resultados ni PASS de integracion a partir de Ripes o del modelo temporal usado para comprobar el TB.

La condicion inicial comun es RF sin reset (solo x0 garantizado), DMEM inicializada por su modulo y programas que inicializan sus operandos. Entre ambos programas se conserva RF y DMEM. Los detalles de cada caso y el procedimiento estan en la [guia](verificacion_cap2.md).

| ID | Instruccion o secuencia | Condicion inicial | Esperado | Obtenido en el DUT | Estado |
|---|---|---|---|---|---|
| INT-01 | Reset inicial | IMEM en cero; reset=1; flanco positivo | PC=00000000 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-02 | PC del ilustrativo | PC=0; seis instrucciones | 0,4,8,12,16,20; PC final=24 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-03 | Ilustrativo x1 | Programa ilustrativo completo | x1=0000000a | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-04 | Ilustrativo x2 | Programa ilustrativo completo | x2=00000014 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-05 | Ilustrativo x3 | Programa ilustrativo completo | x3=0000001e | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-06 | Ilustrativo x4 | Programa ilustrativo completo | x4=00000014 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-07 | Ilustrativo x5 | Programa ilustrativo completo | x5=00000014 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-08 | sw/lw ilustrativo | x4=20; direccion 0x00 | DMEM[0]=00000014 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-09 | Reset antes del flanco | PC=24; reset sube con clk=0 | PC permanece en 00000018 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-10 | Reset en el flanco | reset=1; sin borrar RF ni DMEM | PC=00000000 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-11 | PC del programa propio | PC=0; 23 instrucciones | PC+4 cada flanco; final=0000005c | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-12 | Primer sw a 0xe4 | Ejecutadas primeras 11 instrucciones | DMEM[57]=0000000e antes de sobrescribir | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-13 | Propio x1 | Programa propio completo; operandos inicializados | x1=0000000c | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-14 | Propio x2 | Programa propio completo; operandos inicializados | x2=0000000a | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-15 | Propio x3 | Programa propio completo; operandos inicializados | x3=00000016 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-16 | Propio x4 | Programa propio completo; operandos inicializados | x4=00000002 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-17 | Propio x5 | Programa propio completo; operandos inicializados | x5=00000008 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-18 | Propio x6 | Programa propio completo; operandos inicializados | x6=0000000e | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-19 | Propio x7 | Programa propio completo; operandos inicializados | x7=fffffffb | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-20 | Propio x8 | Programa propio completo; operandos inicializados | x8=00000004 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-21 | Propio x9 | Programa propio completo; operandos inicializados | x9=00000008 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-22 | Propio x10 | Programa propio completo; operandos inicializados | x10=000000e0 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-23 | Propio x11 | Programa propio completo; operandos inicializados | x11=000000e8 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-24 | Propio x12 | Programa propio completo; operandos inicializados | x12=00000016 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-25 | Propio x13 | Programa propio completo; operandos inicializados | x13=fffffffb | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-26 | Propio x14 | Programa propio completo; operandos inicializados | x14=00000011 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-27 | Propio x15 | Programa propio completo; operandos inicializados | x15=fffffffe | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-28 | Propio x16 | Programa propio completo; operandos inicializados | x16=0000000a | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-29 | Propio x17 | Programa propio completo; operandos inicializados | x17=ffffffff | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-30 | Propio x18 | Programa propio completo; operandos inicializados | x18=00000004 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-31 | Propio Mem[0xe0] | sw/lw alineados en el rango permitido | DMEM[56]=00000008 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-32 | Propio Mem[0xe4] | sw/lw alineados en el rango permitido | DMEM[57]=00000016 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-33 | Propio Mem[0xfc] | sw/lw alineados en el rango permitido | DMEM[63]=fffffffb | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-34 | Proteccion de x0 | Intento addi x0,x0,123; instruccion cero al terminar | RD1=00000000; x18 comprobado en INT-30 | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-35 | Control no soportadas | Inyectar xor,mul,xori,lb,sb,00000000 | RegWrite=0 y MemWrite=0 en las seis | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-36 | RF no soportadas | Instantanea x1..x31 | Sin cambios despues de cada instruccion | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-37 | DMEM no soportadas | Instantanea de las 64 palabras | Sin cambios despues de cada instruccion | Sin ejecutar sobre RTL final | PENDIENTE |
| INT-38 | PC no soportadas | PC=92; seis instrucciones | PC+4 cada flanco; final=116 | Sin ejecutar sobre RTL final | PENDIENTE |
