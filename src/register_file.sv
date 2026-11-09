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
// Nombre: Luis Montoya Madrigal
// Fecha de primera versión: 24/10/2026
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 24/10/2026 | Luis Montoya Madrigal | Primera versión
// ____/____/  | _________________  | ________________________
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// clk          : Señal de reloj.
// A1           : Dirección del primer registro a leer.
// A2           : Dirección del segundo registro a leer.
// A3           : Dirección del registro a escribir.
// WD3          : Dato de 32 bits que será escrito.
// RegWrite     : Habilita la escritura en el banco de registros.
//
// SALIDAS
// ------------------------------------------------------------
// RD1          : Dato leído del registro seleccionado por A1.
// RD2          : Dato leído del registro seleccionado por A2.
//
// CONDICIÓN ESPECIAL
// ------------------------------------------------------------
// El registro x0 debe conservar siempre el valor 0.
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