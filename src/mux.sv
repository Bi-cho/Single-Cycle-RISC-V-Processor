// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Multiplexor 2 a 1 (Parametrizable)
//
// Descripción:
// Multiplexor combinacional que selecciona entre dos entradas (A o B)
// dependiendo del valor de la señal Select.
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
// PARÁMETROS: WIDTH (ancho de bits, por defecto 32)
// ENTRADAS: A[WIDTH-1:0], B[WIDTH-1:0], Select
// SALIDAS:  Y[WIDTH-1:0]
// ============================================================

module mux2to1 #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             Select,
    output logic [WIDTH-1:0] Y
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================
    assign Y = Select ? B : A;

endmodule