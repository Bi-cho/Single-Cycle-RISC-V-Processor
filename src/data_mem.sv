// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Data Memory
//
// Descripción:
// Memoria de datos con capacidad para 64 palabras de 32 bits.
// Permite lectura combinacional y escritura síncrona habilitada
// por la señal WE (MemWrite).
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
// ENTRADAS
// ------------------------------------------------------------
// clk : Señal de reloj.
// WE  : Habilitación de escritura (MemWrite).
// A   : Dirección de byte (proviene de ALUResult).
// WD  : Dato a escribir (proviene de RD2 del Register File).
//
// SALIDAS
// ------------------------------------------------------------
// RD  : Dato leído, combinacional.
// ============================================================

module data_mem (
    input  logic        clk,
    input  logic        WE,
    input  logic [31:0] A,
    input  logic [31:0] WD,
    output logic [31:0] RD
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================
    
    // Arreglo interno de 64 palabras de 32 bits
    logic [31:0] mem [0:63];

    // Inicialización en ceros para evitar estados X en simulación
    initial begin
        for (int i = 0; i < 64; i++) begin
            mem[i] = 32'h00000000;
        end
    end

    // Escritura síncrona
    always_ff @(posedge clk) begin
        if (WE) begin
            mem[A[7:2]] <= WD;
        end
    end

    // Lectura combinacional
    assign RD = mem[A[7:2]];

endmodule