# Proyecto: Procesador RISC-V uniciclo - Capitulo 2
# Curso: EL-3310 Diseno de Sistemas Digitales | Grupo: Samara
# Responsable: Andres Rojas Viquez (borrador elaborado con apoyo de IA)
# Primera version: 14/11/2026
# Historial: 14/11/2026 | Andres Rojas Viquez / apoyo de IA | Programa propio
# Cubre las siete instrucciones, inmediatos negativos, dependencias, x0,
# desplazamientos negativos y tres direcciones de datos: 0xe0, 0xe4 y 0xfc.
# Los datos estan despues del codigo tambien en Ripes (memoria unificada).
.text
addi x1, x0, 12       # PC=0x00 | 00c00093 | x1=12
addi x2, x0, 10       # PC=0x04 | 00a00113 | x2=10
add  x3, x1, x2       # PC=0x08 | 002081b3 | x3=22
sub  x4, x1, x2       # PC=0x0c | 40208233 | x4=2
and  x5, x1, x2       # PC=0x10 | 0020f2b3 | x5=8
or   x6, x1, x2       # PC=0x14 | 0020e333 | x6=14
addi x7, x0, -5       # PC=0x18 | ffb00393 | x7=-5
addi x8, x7, 9        # PC=0x1c | 00938413 | x8=4
addi x10, x0, 224     # PC=0x20 | 0e000513 | base=0xe0
sw   x5, 0(x10)       # PC=0x24 | 00552023 | Mem[0xe0]=8
sw   x6, 4(x10)       # PC=0x28 | 00652223 | Mem[0xe4]=14
sw   x7, 28(x10)      # PC=0x2c | 00752e23 | Mem[0xfc]=-5
lw   x9, 0(x10)       # PC=0x30 | 00052483 | x9=8
addi x11, x10, 8      # PC=0x34 | 00850593 | x11=0xe8
sw   x3, -4(x11)      # PC=0x38 | fe35ae23 | Mem[0xe4]=22
lw   x12, -4(x11)     # PC=0x3c | ffc5a603 | x12=22
lw   x13, 28(x10)     # PC=0x40 | 01c52683 | x13=-5
add  x14, x12, x13    # PC=0x44 | 00d60733 | x14=17
sub  x15, x2, x1      # PC=0x48 | 401107b3 | x15=-2
and  x16, x7, x6      # PC=0x4c | 0063f833 | x16=10
or   x17, x7, x6      # PC=0x50 | 0063e8b3 | x17=-1
addi x0, x0, 123      # PC=0x54 | 07b00013 | x0 debe seguir en cero
add  x18, x0, x8      # PC=0x58 | 00800933 | x18=4, observa x0 por lectura
