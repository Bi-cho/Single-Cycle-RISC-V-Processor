# Proyecto: Procesador RISC-V uniciclo - Capitulo 2
# Curso: EL-3310 Diseno de Sistemas Digitales | Grupo: Samara
# Responsable: Andres Rojas Viquez (borrador elaborado con apoyo de IA)
# Primera version: 14/11/2026
# Historial: 14/11/2026 | Andres Rojas Viquez / apoyo de IA | Programa ilustrativo
# Sin pseudoinstrucciones. Los hex se contrastan con Ripes.
# Final: x1=10, x2=20, x3=30, x4=20, x5=20, Mem[0x00]=20.
.text
addi x1, x0, 10       # PC=0x00 | 00a00093
addi x2, x0, 20       # PC=0x04 | 01400113
add  x3, x1, x2       # PC=0x08 | 002081b3
sub  x4, x3, x1       # PC=0x0c | 40118233
sw   x4, 0(x0)        # PC=0x10 | 00402023
lw   x5, 0(x0)        # PC=0x14 | 00002283
