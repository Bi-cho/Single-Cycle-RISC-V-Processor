// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Instruction Memory
//
// Descripción:
// Memoria de instrucciones de solo lectura con capacidad para 
// 64 palabras de 32 bits (256 bytes). Carga el programa desde 
// un archivo hexadecimal.
//
// Autor / Developer 1:
// Nombre: Luis Montoya Madrigal
// Fecha de primera versión: 10/11/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                      | Descripción
// ------------------------------------------------------------
// 10/11/2026  | Luis Montoya Madrigal      | Primera versión
//
// ============================================================

// ============================================================
// PARÁMETROS
// ------------------------------------------------------------
// MEM_FILE : Nombre del archivo hexadecimal con el programa.
//
// ENTRADAS
// ------------------------------------------------------------
// A        : Dirección de byte proveniente del PC.
//
// SALIDAS
// ------------------------------------------------------------
// RD       : Instrucción leída (combinacional).
// ============================================================

module instr_mem #(
    parameter MEM_FILE = "program.hex"
)(
    input  logic [31:0] A,
    output logic [31:0] RD
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================
    // Arreglo de 64 posiciones, cada una de 32 bits
    logic [31:0] mem [0:63];

    // Inicialización de la memoria
    initial begin
        // 1. Llenar toda la memoria con ceros (NOPs o instrucciones no soportadas)
        for (int i = 0; i < 64; i++) begin
            mem[i] = 32'h00000000;
        end
        // 2. Cargar el programa real encima
        $readmemh(MEM_FILE, mem);
    end

    // Lectura combinacional indexando con A[7:2]
    assign RD = mem[A[7:2]];

endmodule