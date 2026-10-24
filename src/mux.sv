// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Multiplexor 2 a 1
//
// Descripción:
// Implementa un multiplexor 2 a 1 parametrizable que permite
// seleccionar una de dos entradas de datos.
//
// Autor / Developer:
// Nombre: Luis
// Fecha de primera versión: 24/10/2026
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