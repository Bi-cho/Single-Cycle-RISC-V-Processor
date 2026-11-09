// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Control Unit
//
// Descripción:
// Decodifica la instrucción actual (op, funct3 y funct7) y genera
// las señales de control del datapath para las siete instrucciones
// soportadas: add, sub, and, or, addi, lw y sw.
// Usa decodificación completa: RegWrite y MemWrite solo valen 1
// cuando op + funct3 (+ funct7 en tipo R) coinciden exactamente con
// una instrucción soportada. Cualquier otra combinación deja todas
// las salidas en 0, así no se escriben registros ni memoria.
//
// Autor / Developer:
// Nombre: Gabriel Fernández Hidalgo
// Fecha de primera versión: 09/11/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                      | Descripción
// ------------------------------------------------------------
// 09/11/2026  | Gabriel Fernández Hidalgo  | Primera versión (esqueleto)
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// op           : Opcode de la instrucción, Instr[6:0].
// funct3       : Campo funct3, Instr[14:12].
// funct7       : Campo funct7, Instr[31:25].
//
// SALIDAS
// ------------------------------------------------------------
// RegWrite     : 1 = escribe Result en el registro rd.
// ALUSrc       : Segundo operando de la ALU. 0 = RD2, 1 = ImmExt.
// MemWrite     : 1 = escribe WriteData en la memoria de datos.
// ResultSrc    : Dato que se escribe en rd. 0 = ALUResult, 1 = ReadData.
// ImmSrc       : Formato del inmediato. 00 = tipo I, 01 = tipo S.
// ALUControl   : Operación de la ALU (códigos del Cap. 1).
// ============================================================

module control_unit (
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       RegWrite,
    output logic       ALUSrc,
    output logic       MemWrite,
    output logic       ResultSrc,
    output logic [1:0] ImmSrc,
    output logic [3:0] ALUControl
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    // Opcodes de las instrucciones soportadas
    localparam logic [6:0] OP_RTYPE = 7'b0110011;  // add, sub, and, or
    localparam logic [6:0] OP_ITYPE = 7'b0010011;  // addi
    localparam logic [6:0] OP_LOAD  = 7'b0000011;  // lw
    localparam logic [6:0] OP_STORE = 7'b0100011;  // sw

    // Valores de funct3
    localparam logic [2:0] F3_ADD_SUB = 3'b000;    // add, sub, addi
    localparam logic [2:0] F3_AND     = 3'b111;
    localparam logic [2:0] F3_OR      = 3'b110;
    localparam logic [2:0] F3_WORD    = 3'b010;    // lw, sw (palabra de 32 bits)

    // Valores de funct7 (solo tienen sentido en tipo R)
    localparam logic [6:0] F7_NORMAL = 7'b0000000; // add, and, or
    localparam logic [6:0] F7_SUB    = 7'b0100000; // sub

    // Códigos de la ALU (deben coincidir con alu.sv)
    localparam logic [3:0] ALU_ADD = 4'b0000;
    localparam logic [3:0] ALU_SUB = 4'b0001;
    localparam logic [3:0] ALU_AND = 4'b0010;
    localparam logic [3:0] ALU_OR  = 4'b0011;

    // Formatos de inmediato (deben coincidir con imm_gen.sv)
    localparam logic [1:0] IMM_I = 2'b00;
    localparam logic [1:0] IMM_S = 2'b01;

    always_comb begin
        // ----------------------------------------------------
        // 1. Valores por defecto seguros
        // Se asignan antes del case para que todas las salidas
        // tengan valor en cualquier camino (evita latches) y para
        // que una instrucción no soportada no escriba nada.
        // ----------------------------------------------------
        RegWrite   = 1'b0;
        ALUSrc     = 1'b0;
        MemWrite   = 1'b0;
        ResultSrc  = 1'b0;
        ImmSrc     = IMM_I;
        ALUControl = ALU_ADD;

        // ----------------------------------------------------
        // 2. Decodificación por opcode
        // Dentro de cada rama solo se cambian las señales que
        // difieren del valor por defecto.
        // ----------------------------------------------------
        case (op)

            OP_RTYPE: begin
                // TODO (Gabriel): add, sub, and, or.
                // - Comparar funct3 Y funct7 con un if / else if.
                // - Solo si la combinación es válida: RegWrite = 1 y
                //   ALUControl = la operación que corresponda.
                // - ¿Qué valor necesita ALUSrc aquí? ¿Hay que cambiarlo?
                // - Rama else final: no hacer nada (xor, sll, slt...
                //   se quedan con los valores por defecto).
            end

            OP_ITYPE: begin
                // TODO (Gabriel): addi.
                // - Revisar solo funct3. ¿Por qué NO se revisa funct7?
                //   (pensar en addi x1, x0, -1)
                // - Señales: RegWrite, ALUSrc, ImmSrc, ALUControl.
            end

            OP_LOAD: begin
                // TODO (Gabriel): lw.
                // - Revisar funct3 (lb y lh comparten este opcode).
                // - ¿Qué señal hace que rd reciba el dato de memoria?
            end

            OP_STORE: begin
                // TODO (Gabriel): sw.
                // - Revisar funct3 (sb y sh comparten este opcode).
                // - ¿Por qué RegWrite queda en 0?
                // - ¿Qué formato de inmediato usa sw?
            end

            default: begin
                // Opcode no soportado (incluye 0x00000000 al final del
                // programa): se mantienen los valores por defecto.
            end

        endcase
    end

endmodule
