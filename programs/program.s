# Proyecto: Procesador RISC-V uniciclo - Capitulo 2
# Curso: EL-3310 Diseno de Sistemas Digitales | Grupo: Samara
# Responsable: Andres Rojas Viquez (borrador elaborado con apoyo de IA)
# Primera version: 14/11/2026
# Historial: 14/11/2026 | Andres Rojas Viquez / apoyo de IA | Programa ilustrativo
# Historial: 14/11/2026 | Andres Rojas Viquez / apoyo de IA | Programa propio minimo
# Cubre add, sub, and, or, addi, sw y lw, sin pseudoinstrucciones.
# Todos los operandos se inicializan antes de usarse; x0 siempre lee cero.
.text
addi x1, x0, 12       # PC=0x00 | 00c00093 | x1=12
addi x2, x0, -5       # PC=0x04 | ffb00113 | x2=-5
add  x3, x1, x2       # PC=0x08 | 002081b3 | x3=7
sub  x4, x1, x2       # PC=0x0c | 40208233 | x4=17
and  x5, x1, x2       # PC=0x10 | 0020f2b3 | x5=8
or   x6, x1, x2       # PC=0x14 | 0020e333 | x6=-1
sw   x5, 224(x0)      # PC=0x18 | 0e502023 | Mem[0xe0]=8
lw   x7, 224(x0)      # PC=0x1c | 0e002383 | x7=8
