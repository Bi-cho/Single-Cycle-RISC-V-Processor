// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Register File
//
// Descripción:
// Implementa el banco de 32 registros de 32 bits del procesador.
// Permite leer dos registros simultáneamente y escribir un
// registro cuando la señal RegWrite está habilitada.
//
// Autor / Developer:
// Nombre: Luis
// Fecha de primera versión: 24/10/2026
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