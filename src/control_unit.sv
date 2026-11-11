// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Control Unit (descripcion creada con apoyo de IA, 
// para seguir el formato de los modulos proporcionados en el capitulo 1)
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
// 11/11/2026  | Gabriel Fernández Hidalgo  | Decodificación Tipo R: add, sub, and, or
// 11/11/2026  | Gabriel Fernández Hidalgo  | Decodificación completa, se agregan casos addi, lw y sw
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
        // 1. Valores por defecto seguros (evita latches) y para
        // que una instrucción no soportada no escriba nada.
        RegWrite   = 1'b0;
        ALUSrc     = 1'b0;
        MemWrite   = 1'b0;
        ResultSrc  = 1'b0;
        ImmSrc     = IMM_I;
        ALUControl = ALU_ADD;

        // 2. Decodificación por opcode
        case (op)
            // Tipo R: add, sub, and, or  (rd = rs1 op rs2)
            // ALUSrc 0
            // Se revisa funct7, add y sub tienen el mismo funct3, solo los distingue funct7.
            // ------------------------------------------------
            OP_RTYPE: begin
                if (funct3 == F3_ADD_SUB && funct7 == F7_NORMAL) begin
                    RegWrite   = 1'b1;          // add
                    ALUControl = ALU_ADD;
                end
                else if (funct3 == F3_ADD_SUB && funct7 == F7_SUB) begin
                    RegWrite   = 1'b1;          // sub
                    ALUControl = ALU_SUB;
                end
                else if (funct3 == F3_AND && funct7 == F7_NORMAL) begin
                    RegWrite   = 1'b1;          // and
                    ALUControl = ALU_AND;
                end
                else if (funct3 == F3_OR && funct7 == F7_NORMAL) begin
                    RegWrite   = 1'b1;          // or
                    ALUControl = ALU_OR;
                end
                else begin
                    // xor, sll, slt, mul... no soportadas:
                    // se quedan los valores por defecto (RegWrite = 0).
                end
            end
            // Tipo I addi 
            // NO se revisa funct7
            OP_ITYPE: begin
                if (funct3 == F3_ADD_SUB) begin
                    RegWrite   = 1'b1;
                    ALUSrc     = 1'b1;          // segundo operando = ImmExt
                    ImmSrc     = IMM_I;
                    ALUControl = ALU_ADD;
                end
                else begin
                    // xori, slti, ori... no soportadas.
                end
            end

            // lw 
            // La ALU suma rs1 + imm para calcular la dirección, y ResultSrc = 1
            // hace que rd reciba ReadData en vez de ALUResult.
            OP_LOAD: begin
                if (funct3 == F3_WORD) begin
                    RegWrite   = 1'b1;
                    ALUSrc     = 1'b1;
                    ImmSrc     = IMM_I;         // lw usa inmediato tipo I
                    ResultSrc  = 1'b1;          // rd <- ReadData
                    ALUControl = ALU_ADD;
                end
                else begin
                    // lb, lh, lbu, lhu no soportadas.
                end
            end
            // sw  
            // RegWrite en 0 
            // ResultSrc no importa se deja en 0.
            OP_STORE: begin
                if (funct3 == F3_WORD) begin
                    ALUSrc     = 1'b1;
                    ImmSrc     = IMM_S;
                    MemWrite   = 1'b1;
                    ALUControl = ALU_ADD;
                end
                else begin
                    // sb, sh no soportadas: MemWrite queda en 0.
                end
            end

            default: begin
                // Opcode no soportado 
            end

        endcase
    end

endmodule
