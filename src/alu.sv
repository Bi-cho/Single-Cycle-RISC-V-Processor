// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: ALU
//
// Descripción:
// Implementa las operaciones aritméticas y lógicas requeridas
// por el procesador RISC-V.
//
// Autor / Developer:
// Nombre: Gabriel Fernández Hidalgo
// Fecha de primera versión: 22/10/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                      | Descripción
// ------------------------------------------------------------
// 22/10/2026  | Gabriel Fernández Hidalgo  | Primera versión
// 23/10/2026  | Gabriel Fernández Hidalgo  | Implementación del default para evitar latches
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// A            : Operando de 32 bits.
// B            : Operando de 32 bits.
// ALUControl   : Código que determina la operación.
//
// SALIDAS
// ------------------------------------------------------------
// Result       : Resultado de la operación.
// Zero         : 1 cuando Result es igual a cero.
// ============================================================

module alu (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUControl,
    output logic [31:0] Result,
    output logic        Zero
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    // Códigos internos de operación de la alu
    localparam logic [3:0] ALU_ADD = 4'b0000;
    localparam logic [3:0] ALU_SUB = 4'b0001;
    localparam logic [3:0] ALU_AND = 4'b0010;
    localparam logic [3:0] ALU_OR  = 4'b0011;

    // Seleccion de cada operacion en la alu
    always_comb begin
        case (ALUControl)
            ALU_ADD: Result = A + B;
            ALU_SUB: Result = A - B;
            ALU_AND: Result = A & B;
            ALU_OR:  Result = A | B;        
            default: Result = 32'b0;   // para evitar latches en codigos no definidos  
        endcase
    end

    // Bandera Zero
    assign Zero = (Result == 32'b0);

endmodule
