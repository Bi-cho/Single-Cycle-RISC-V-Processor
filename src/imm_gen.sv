// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Immediate Generator
//
// Descripción:
// Genera y extiende a 32 bits el valor inmediato contenido en
// una instrucción RISC-V. En esta etapa del proyecto se deben
// implementar los formatos de inmediato indicados en la
// especificación del Capítulo 1.
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
// ____/____/  | _________________  | ________________________
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// Instr        : Instrucción RISC-V de 32 bits.
// ImmSrc       : Selecciona el formato del inmediato.
//
// SALIDAS
// ------------------------------------------------------------
// ImmExt       : Inmediato extendido a 32 bits.
// ============================================================

module imm_gen (
    input  logic [31:0] Instr,
    input  logic [1:0]  ImmSrc,
    output logic [31:0] ImmExt
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    // Códigos de formato de inmediato para I type y S type
    localparam logic [1:0] IMM_I = 2'b00;
    localparam logic [1:0] IMM_S = 2'b01;

    // Selección del formato y extensión de signo con Instr[31]
    always_comb begin
        case (ImmSrc)
            // I type
            IMM_I:   ImmExt = {{20{Instr[31]}}, Instr[31:20]};
            // S type
            IMM_S:   ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};            
        endcase
    end

endmodule
