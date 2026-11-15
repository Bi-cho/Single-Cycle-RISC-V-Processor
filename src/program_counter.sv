// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Program Counter
//
// Descripción:
// Registro de 32 bits que almacena la dirección de la 
// instrucción actual. Se actualiza en el flanco positivo 
// del reloj e incluye un reset síncrono activo en alto.
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
// clk      : Señal de reloj.
// reset    : Reset síncrono activo en alto.
// PCNext   : Próxima dirección a cargar (ej. PC + 4).
//
// SALIDAS
// ------------------------------------------------------------
// PC       : Dirección de la instrucción actual.
// ============================================================

module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] PCNext,
    output logic [31:0] PC
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================
    always_ff @(posedge clk) begin
        if (reset) begin
            PC <= 32'h00000000;
        end else begin
            PC <= PCNext;
        end
    end

endmodule