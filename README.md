# Procesador RISC-V Uniciclo

## Diseño de Sistemas Digitales

### Capítulo 1 - Los cimientos

Módulos fundamentales verificados: ALU, Register File, Immediate Generator y MUX.

### Capítulo 2 - El datapath cobra vida

Integración de los módulos del Cap. 1 con PC, memorias, unidad de control y top para ejecutar `add`, `sub`, `and`, `or`, `addi`, `lw` y `sw` (una instrucción por ciclo). `PCNext = PC + 4` siempre.

## Grupo

Nombre de grupo: Equipo Sámara

## Integrantes y roles

- Team Lead: Ricardo García Aragón
- Hardware Developer 1: Luis Montoya Madrigal
- Hardware Developer 2: Gabriel Fernández Hidalgo
- Verification Engineer: Andrés Rojas Viquez
- Documentation & Configuration Engineer: Franco Jesús Plano

## Estructura

```text
Single-Cycle-RISC-V-Processor/
├── src/
│   ├── alu.sv
│   ├── control_unit.sv
│   ├── data_mem.sv
│   ├── imm_gen.sv
│   ├── instr_mem.sv
│   ├── mux.sv
│   ├── program_counter.sv
│   ├── register_file.sv
│   └── riscv_single_cycle.sv
├── testbench/
│   ├── alu_tb.sv
│   ├── control_unit_tb.sv
│   ├── imm_gen_tb.sv
│   ├── mux_tb.sv
│   ├── register_file_tb.sv
│   └── riscv_single_cycle_tb.sv
├── programs/
│   ├── program.s
│   └── program.hex
├── docs/
│   └── matriz_pruebas.md
└── README.md
```

## Módulos del Capítulo 2

- Program Counter (`program_counter`): registro de 32 bits con reset síncrono activo en alto.
- Instruction Memory (`instr_mem`): 64 palabras, lectura combinacional `mem[A[7:2]]`, carga con `$readmemh`.
- Data Memory (`data_mem`): 64 palabras, lectura combinacional y escritura síncrona con `WE`.
- Control Unit (`control_unit`): decodificación completa de las 7 instrucciones. Instrucciones no soportadas dejan `RegWrite=0` y `MemWrite=0`.
- Top (`riscv_single_cycle`): integra todo el datapath. Puertos solo `clk` y `reset`.

## Ambiente de trabajo

Simulación oficial: EDA Playground con Icarus Verilog 12 (`-Wall -g2012`).

## Características del diseño

- El reset se activa con un 1 y reinicia el PC en el flanco positivo del reloj.
- Las memorias usan los bits `A[7:2]` para seleccionar la palabra que se lee o se escribe.
- El banco de registros no tiene reset; `x0` siempre lee cero.

## Estado de los módulos

| Módulo | Implementación | Verificación | Estado |
|---|---|---|---|
| ALU | Implementada | 4/4 PASS | Verificado |
| Register File | Implementado | 3/3 PASS | Verificado |
| Immediate Generator | Implementado | 4/4 PASS | Verificado |
| MUX | Implementado | 2/2 PASS | Verificado |
| Control Unit | Implementada | 15/15 PASS | Verificado |
| Program Counter | Implementado | Integración PASS | Verificado |
| Instruction Memory | Implementado | Integración PASS | Verificado |
| Data Memory | Implementado | Integración PASS | Verificado |
| Top (`riscv_single_cycle`) | Implementado | INT-01 a INT-09 PASS | Verificado |

## Verificación

- Cap. 1: 13/13 PASS (ALU, RF, imm_gen, MUX).
- Control Unit: 15/15 PASS en EDA Playground.
- Integración Cap. 2: programa propio de 8 instrucciones. Resultados: x1=12, x2=-5, x3=7, x4=17, x5=8, x6=-1, x7=8, Mem[56]=8.
- Todos los casos de integración (INT-01 a INT-09) obtuvieron PASS en EDA Playground.

Se revisaron los campos de los formatos R, I y S para obtener el código hexadecimal de cada instrucción. Luego se ejecutaron el programa en ensamblador y su versión binaria en Ripes 2.2.6, con el procesador uniciclo RV32I sin extensiones. En ambos casos se obtuvieron los mismos valores en los registros y la memoria.

## Enlaces de EDA Playground

| Módulo | Enlace |
|---|---|
| ALU | [Abrir](https://edaplayground.com/x/N9xm) |
| Register File | [Abrir](https://edaplayground.com/x/YxXV) |
| Immediate Generator | [Abrir](https://edaplayground.com/x/wYfw) |
| MUX | [Abrir](https://edaplayground.com/x/i8md) |
| Control Unit | [Abrir](https://edaplayground.com/x/TUw6) |
| **Integración (top)** | [Abrir](https://edaplayground.com/x/wYH8) |

## Cómo ejecutar la simulación en EDA Playground

1. Se seleccionan SystemVerilog e Icarus Verilog 12, con las opciones `-Wall -g2012`.
2. Se agregan al diseño todos los archivos de `src/`, incluido `riscv_single_cycle.sv`.
3. Se agrega `testbench/riscv_single_cycle_tb.sv` como archivo de pruebas.
4. Se crea un archivo llamado `program.hex` en la raíz del Playground y se copia el contenido de `programs/program.hex`.
5. Se pulsa Run. La simulación comprueba el reset, el avance del PC y los resultados de las siete instrucciones, mediante los casos INT-01 a INT-09.

