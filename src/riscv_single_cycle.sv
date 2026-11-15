// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Módulo: Top - Procesador RISC-V Uniciclo
//
// Descripción:
// Integra todos los módulos del datapath (PC, memorias, RF, ALU,
// imm_gen, muxes y control) para ejecutar una instrucción por ciclo.
// Soporta add, sub, and, or, addi, lw y sw.
// PCNext siempre es PC+4 (sin saltos en Cap. 2).
//
// Autor / Líder:
// Nombre: Ricardo García Aragón
// Fecha de primera versión: 13/11/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                      | Descripción
// ------------------------------------------------------------
// 13/11/2026  | Ricardo García Aragón      | Primera versión (integración, declaracion de señales y conexiones)
// 15/11/2026  | Ricardo García Aragón      | Segunda versión (corrección de errores y revisión de nombres de señales y archivos)
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// clk   : Reloj. Todo el estado se actualiza en posedge clk.
// reset : Reset síncrono activo en alto. Solo afecta al PC (PC=0).
//
// SALIDAS
// ------------------------------------------------------------
// (ninguna externa; el estado se observa por jerarquía desde el TB)
// ============================================================

module riscv_single_cycle (
    input  logic clk,
    input  logic reset
);

    // ========================================================
    // SEÑALES INTERNAS (nombres fijos del contrato / diagrama)
    // ========================================================
    logic [31:0] PC;
    logic [31:0] PCPlus4;
    logic [31:0] PCNext;
    logic [31:0] Instr;
    logic [31:0] SrcA;
    logic [31:0] WriteData;
    logic [31:0] ImmExt;
    logic [31:0] SrcB;
    logic [31:0] ALUResult;
    logic        Zero;
    logic [31:0] ReadData;
    logic [31:0] Result;

    // Señales de control
    logic        RegWrite;
    logic        ALUSrc;
    logic        MemWrite;
    logic        ResultSrc;
    logic [1:0]  ImmSrc;
    logic [3:0]  ALUControl;

    // ========================================================
    // SUMADOR PC + 4 (en el TOP para que sea visible en el TB)
    // ========================================================
    assign PCPlus4 = PC + 32'd4;
    assign PCNext  = PCPlus4;   // sin saltos en Cap. 2

    // =========================================================================
    // INSTANCIAS (nombres y conexiones fijas del diagrama general del programa)
    // =========================================================================

    // Program Counter
    program_counter u_pc (
        .clk    (clk),
        .reset  (reset),
        .PCNext (PCNext),
        .PC     (PC)
    );

    // Memoria de instrucciones
    instr_mem u_imem (
        .A  (PC),
        .RD (Instr)
    );

    // Unidad de control
    control_unit u_ctrl (
        .op         (Instr[6:0]),
        .funct3     (Instr[14:12]),
        .funct7     (Instr[31:25]),
        .RegWrite   (RegWrite),
        .ALUSrc     (ALUSrc),
        .MemWrite   (MemWrite),
        .ResultSrc  (ResultSrc),
        .ImmSrc     (ImmSrc),
        .ALUControl (ALUControl)
    );

    // Banco de registros
    register_file u_rf (
        .clk      (clk),
        .A1       (Instr[19:15]),
        .A2       (Instr[24:20]),
        .A3       (Instr[11:7]),
        .WD3      (Result),
        .RegWrite (RegWrite),
        .RD1      (SrcA),
        .RD2      (WriteData)
    );

    // Generador de inmediatos
    imm_gen u_imm (
        .Instr  (Instr),
        .ImmSrc (ImmSrc),
        .ImmExt (ImmExt)
    );

    // MUX SrcB (RD2 o inmediato)
    mux2to1 u_mux_srcb (
        .A      (WriteData),
        .B      (ImmExt),
        .Select (ALUSrc),
        .Y      (SrcB)
    );

    // ALU
    alu u_alu (
        .A          (SrcA),
        .B          (SrcB),
        .ALUControl (ALUControl),
        .Result     (ALUResult),
        .Zero       (Zero)
    );

    // Memoria de datos
    data_mem u_dmem (
        .clk (clk),
        .WE  (MemWrite),
        .A   (ALUResult),
        .WD  (WriteData),
        .RD  (ReadData)
    );

    // MUX Result (ALUResult o ReadData)
    mux2to1 u_mux_result (
        .A      (ALUResult),
        .B      (ReadData),
        .Select (ResultSrc),
        .Y      (Result)
    );

endmodule
