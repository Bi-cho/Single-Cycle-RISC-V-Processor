# Verificacion del Capitulo 2 - Andres

Responsable: Andres Rojas Viquez. Preparado el 14/11/2026 con apoyo de IA.
El estudiante y el equipo deben revisar, comprender y adaptar este borrador antes de entregarlo.

## Estado y alcance

- Regresion local del Capitulo 1: **13/13 PASS**, Icarus Verilog 13.0.
- Unidad de control: **15/15 PASS** en la repeticion local con Icarus Verilog 13.0.
- Programas: ensamblados y ejecutados en **Ripes 2.2.6, RV32_SS, sin extensiones**, desde la CLI.
- Integracion real: **PENDIENTE**. Faltan `program_counter.sv`, `instr_mem.sv`, `data_mem.sv` y `riscv_single_cycle.sv` en `src/`.
- EDA Playground con Icarus 12: falta ejecutar el TB de integracion cuando llegue el RTL completo.

Los historiales de los cuatro TB del Capitulo 1 y los encabezados de los modulos de Luis ya estan completados en la base `3faca060163f7ccfe453aa4934048b117fbfd1c3`. No se inventaron fechas nuevas ni se modificaron esos archivos.

La evidencia de esta revision se encuentra en [evidencia_cap2](evidencia_cap2/). Los resultados historicos de EDA del README y de la matriz anterior se conservan; no se presentan como una nueva ejecucion de EDA.

## Programas y resultados de referencia

Cada `.hex` contiene una palabra de 32 bits por linea. `program.s` tiene 6 instrucciones y `prog2.s`, 23; ambos estan por debajo del limite de 64. Los comentarios de los `.s` identifican PC, hexadecimal y resultado. Ninguno usa pseudoinstrucciones, saltos ni instrucciones fuera de las siete soportadas.

### Programa ilustrativo: program.s / program.hex

Resultado de Ripes: 6 instrucciones retiradas en 6 ciclos.

| Elemento | Decimal | Hexadecimal |
|---|---:|---|
| x1 | 10 | 0000000a |
| x2 | 20 | 00000014 |
| x3 | 30 | 0000001e |
| x4 | 20 | 00000014 |
| x5 | 20 | 00000014 |
| Mem[0x00], palabra 0 | 20 | 00000014 |

### Programa propio: prog2.s / prog2.hex

Resultado de Ripes: 23 instrucciones retiradas en 23 ciclos.

| Registro | Decimal con signo | Hexadecimal |
|---|---:|---|
| x0 | 0 | 00000000 |
| x1 | 12 | 0000000c |
| x2 | 10 | 0000000a |
| x3 | 22 | 00000016 |
| x4 | 2 | 00000002 |
| x5 | 8 | 00000008 |
| x6 | 14 | 0000000e |
| x7 | -5 | fffffffb |
| x8 | 4 | 00000004 |
| x9 | 8 | 00000008 |
| x10 | 224 | 000000e0 |
| x11 | 232 | 000000e8 |
| x12 | 22 | 00000016 |
| x13 | -5 | fffffffb |
| x14 | 17 | 00000011 |
| x15 | -2 | fffffffe |
| x16 | 10 | 0000000a |
| x17 | -1 | ffffffff |
| x18 | 4 | 00000004 |

| Direccion de byte | Indice en DMEM | Resultado final |
|---|---:|---|
| 0xe0 | 56 | 8 (00000008) |
| 0xe4 | 57 | 22 (00000016); primero se escribe 14 |
| 0xfc | 63 | -5 (fffffffb) |

`sw x3,-4(x11)` y `lw x12,-4(x11)` calculan 232 - 4 = 228 = 0xe4. Prueban el inmediato S e I negativos sin salir del rango alineado. `addi x0,x0,123` intenta escribir x0 y `add x18,x0,x8` permite observar que la lectura sigue siendo cero. El TB observa tambien el puerto RD1 al terminar, nunca presupone que el elemento interno `rf[0]` este inicializado.

Solo se comparan los registros que el programa define. Los valores iniciales por defecto de Ripes no deben usarse como requisito para registros sin inicializar del RTL.

## Como se codificaron y validaron las instrucciones

1. Se escribieron los programas sin pseudoinstrucciones y se desglosaron sus campos R/I/S para preparar las palabras hexadecimales. No se desarrollo un programa ensamblador.
2. Ripes ensamblo y ejecuto cada archivo `.s` con su ensamblador propio.
3. Se convirtieron las palabras ya escritas en `.hex` a bytes little-endian y se ejecutaron como binario en Ripes, desde PC=0. Los 32 registros y la cantidad de ciclos/instrucciones coincidieron entre ambas entradas. Esto es una comprobacion funcional cruzada; no se afirma que la CLI haya exportado los `.hex`.
4. La CLI 2.2.6 no ofrece un volcado de memoria entre sus opciones de reporte. Para observarla se agrego, en copias temporales, un sufijo de cargas a x28..x30. Se ejecuto tanto su version ensamblador como binaria y se compararon los resultados. Tambien se ejecuto el prefijo de 11 instrucciones del programa propio con una carga de observacion para confirmar el 14 intermedio en 0xe4. Estos sufijos NO forman parte de los programas entregados ni requieren ampliar el procesador.
5. Los reportes guardan los valores originales de Ripes; solo se normaliza la ruta del archivo de entrada para que la evidencia no dependa de la carpeta local. El resumen incluye SHA-256 de los dos archivos de cada programa.

Sufijo del programa ilustrativo: `lw x28,0(x0)` (`00002e03`). Sufijo del propio: `addi x31,x0,224; lw x28,0(x31); lw x29,4(x31); lw x30,28(x31)` (`0e000f93`, `000fae03`, `004fae83`, `01cfaf03`). Estos registros auxiliares no afectan los resultados originales.

### Comprobacion manual 1: addi x7,x0,-5

Formato I: `imm[11:0] | rs1 | funct3 | rd | opcode`.

- -5 en complemento a dos de 12 bits: 4096 - 5 = 4091 = 0xffb = `111111111011`.
- rs1=x0: `00000`; funct3: `000`; rd=x7: `00111`; opcode: `0010011`.
- Concatenacion: `111111111011 | 00000 | 000 | 00111 | 0010011` = **ffb00393**.
- El generador extiende el signo a `fffffffb`. Los bits 31:25 son inmediato; no deben provocar SUB.

### Comprobacion manual 2: sw x3,-4(x11)

Formato S: `imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode`.

- -4 en 12 bits: 4096 - 4 = 4092 = 0xffc = `111111111100`.
- imm[11:5]=`1111111`, imm[4:0]=`11100`.
- rs2=x3: `00011`; rs1=x11: `01011`; funct3: `010`; opcode: `0100011`.
- Concatenacion: `1111111 | 00011 | 01011 | 010 | 11100 | 0100011` = **fe35ae23**.
- El inmediato NO esta en un solo campo continuo: el RTL debe reunir ambos fragmentos antes de extender el signo.

### Harvard y Ripes

Ripes utiliza un espacio de memoria unificado; IMEM y DMEM del contrato son arreglos separados. En el ejemplo, escribir en 0x00 modifica una instruccion ya ejecutada en Ripes; el flujo secuencial no vuelve a ella. En el programa propio los datos empiezan en 0xe0 y el codigo termina en 0x5b, por lo que no se superponen. Incluso el sufijo de observacion termina antes de 0xe0. No se deben mover las escrituras encima de instrucciones futuras.

## Como funciona el testbench de integracion

- Respeta los nombres de modulo, puerto, instancia y arreglos del contrato.
- Genera exactamente un flanco positivo por llamada a `ciclo`; observa despues de las actualizaciones no bloqueantes.
- Carga instrucciones cero durante los flancos de reset. El reset del PC no inhibe por si mismo las escrituras de los demas modulos.
- Ejecuta exactamente 6 instrucciones del ejemplo, reinicia solamente el PC y ejecuta las 23 del programa propio sin borrar RF ni DMEM.
- Verifica cada paso del PC, ambos aspectos del reset sincrono, los registros definidos y la memoria. La escritura intermedia de 14 se observa antes de que otra instruccion la reemplace por 22.
- Tras los programas, inyecta seis instrucciones no soportadas directamente en IMEM. Compara las habilitaciones y el estado completo de RF (x1..x31) y DMEM despues de cada flanco. Esta prueba negativa esta separada de los programas de las siete instrucciones.
- Usa `===` para que un X no pase por un resultado conocido. En las instantaneas de registros no utilizados, la igualdad de cuatro estados comprueba conservacion, sin exigir valores iniciales inexistentes.
- Imprime 38 casos `INT-01` a `INT-38`, esperado/obtenido, PASS/FAIL y resumen. Termina con `$fatal` si hay fallos; tiene limite de tiempo.

Para validar el TB antes de recibir el RTL se construyo un modelo temporal del contrato en `build/`, excluido de Git. Compilo y obtuvo 38/38 PASS. Con avance PC+8 detecto 28 fallos; con una lectura de DMEM desplazada detecto 5; con reset asincrono detecto 1. Esas comprobaciones validan el TB y **no son resultados de integracion del procesador del equipo**. La matriz real permanece PENDIENTE.

## Como repetir las pruebas

Desde la raiz del repositorio, con Python 3 e Icarus instalados:

```text
python scripts/run_verification.py
python scripts/verify_programs.py --ripes RUTA_A_RIPES
```

Si Icarus no esta en PATH:

```text
python scripts/run_verification.py --iverilog RUTA_A_IVERILOG
```

Los resultados y logs se escriben en `build/`, excluido de Git. El script comprueba los codigos de salida, las lineas FAIL y la cantidad de casos; los TB antiguos terminan con `$finish` incluso ante un fallo.

Cuando se reciban los cuatro modulos pendientes, copiarlos en `src/` respetando el contrato y ejecutar:

```text
python scripts/run_verification.py --integration
```

Sin esos modulos, el comando ejecuta los unitarios, reporta la integracion PENDIENTE y devuelve codigo 1. No incluye sustitutos dentro de `src/` ni genera un falso PASS. Se compila desde la raiz; el ejecutable de integracion se corre desde `programs/`, donde estan los `.hex` que espera `$readmemh`.

### EDA Playground (con el RTL completo)

1. Elegir SystemVerilog e Icarus Verilog 12; opciones `-Wall -g2012`.
2. Poner `riscv_single_cycle_tb.sv` en el panel de testbench.
3. Agregar los nueve modulos de `src/` al panel de diseno o sus pestanas. Si se usan archivos separados, incluirlos una sola vez desde `design.sv`. No incluir los TB unitarios, para que sus `$finish` no interrumpan la integracion.
4. Agregar `program.hex` y `prog2.hex` como archivos de texto, con esos nombres exactos en la raiz del Playground.
5. Ejecutar, comprobar los 38 PASS y conservar log/enlace. Si algun caso falla, registrar el obtenido real y corregir la causa antes de marcarlo PASS en la matriz.

## Preparacion para la defensa

Andres debe poder explicar: los dos desgloses manuales; por que se indexa con A[7:2]; por que el reset no borra todo; cuando ocurre la escritura en cada ciclo; como se evita observar antes de las asignaciones no bloqueantes; la diferencia entre direccion de byte e indice; y por que ejecutar un TB contra un modelo temporal no demuestra que el RTL final del equipo funcione.

Referencia de la interfaz CLI: [documentacion oficial de Ripes](https://github.com/mortbopet/Ripes/blob/v2.2.6/docs/cli.md). Los nombres de opciones utilizados tambien se comprobaron con `Ripes.exe --help` de la version local.
