// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Register File
//
// Descripción:
// Banco de 32 registros de 32 bits. Permite lectura combinacional
// simultánea en dos puertos y escritura síncrona en un puerto.
// El registro x0 está protegido y siempre retorna 0.
//
// Autor: Luis Montoya Madrigal
// Fecha de primera versión: 24/10/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                      | Descripción
// ------------------------------------------------------------
// 24/10/2026  | Luis Montoya Madrigal      | Primera versión
// 10/11/2026  | Luis Montoya Madrigal      | Actualización de encabezado Cap. 2
//
// ============================================================
// ENTRADAS: clk, A1[4:0], A2[4:0], A3[4:0], WD3[31:0], RegWrite
// SALIDAS:  RD1[31:0], RD2[31:0]
// ============================================================

module register_file (
    input  logic        clk,
    input  logic [4:0]  A1,
    input  logic [4:0]  A2,
    input  logic [4:0]  A3,
    input  logic [31:0] WD3,
    input  logic        RegWrite,
    output logic [31:0] RD1,
    output logic [31:0] RD2
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================
    logic [31:0] rf [31:0];

    always_ff @(posedge clk) begin
        if (RegWrite && A3 != 5'b00000) begin
            rf[A3] <= WD3;
        end
    end

    assign RD1 = (A1 != 5'b00000) ? rf[A1] : 32'b0;
    assign RD2 = (A2 != 5'b00000) ? rf[A2] : 32'b0;

endmodule