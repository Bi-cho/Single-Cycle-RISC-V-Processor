// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Testbench: Control Unit
//
// Descripción:
// Verifica la unidad de control con instrucciones reales de 32 bits.
// El TB separa cada instrucción en op, funct3 y funct7 igual que el
// top (Instr[6:0], Instr[14:12], Instr[31:25]) y compara las seis
// salidas contra la tabla de control del contrato de interfaces.
// Casos:
//   CTRL-01..07 : las 7 instrucciones soportadas.
//   CTRL-08..09 : addi cuyos bits 31:25 parecen un funct7 (trampa
//                 addi contra sub); deben dar ADD, nunca SUB.
//   CTRL-10..15 : instrucciones no soportadas que comparten opcode
//                 (xor, mul, xori, lb, sb) y una instrucción en cero;
//                 deben dejar todas las salidas en 0.
// Las codificaciones se calcularon con los campos del formato RISC-V
// (ver comentario de cada caso) y se pueden revisar en rvcodec.js.
//
// Autor / Developer:
// Nombre: Gabriel Fernández Hidalgo
// Fecha de primera versión: 11/11/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                      | Descripción
// ------------------------------------------------------------
// 11/11/2026  | Gabriel Fernández Hidalgo  | Primera versión (Tipo R)
// 11/11/2026  | Gabriel Fernández Hidalgo  | se agregan casos addi, lw y sw
// 11/11/2026  | Gabriel Fernández Hidalgo  | se agregan casos no soportados
// ============================================================

`timescale 1ns/1ps

module control_unit_tb;
    logic [31:0] Instr;
    logic [6:0]  op, funct7;
    logic [2:0]  funct3;

    logic       RegWrite, ALUSrc, MemWrite, ResultSrc;
    logic [1:0] ImmSrc;
    logic [3:0] ALUControl;

    assign op     = Instr[6:0];
    assign funct3 = Instr[14:12];
    assign funct7 = Instr[31:25];

    control_unit dut (.op(op), .funct3(funct3), .funct7(funct7),
                      .RegWrite(RegWrite), .ALUSrc(ALUSrc), .MemWrite(MemWrite),
                      .ResultSrc(ResultSrc), .ImmSrc(ImmSrc), .ALUControl(ALUControl));

    initial begin
        // ================= Instrucciones soportadas =================
        // CTRL-01: add x3, x1, x2 (op=0110011 f3=000 f7=0000000).
        Instr = 32'h002081B3;
        #10;
        $display("CTRL-01 esperado=RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-01 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b1 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-01 PASS");
        else $display("CTRL-01 FAIL");

        // sub (op=0110011 f3=000 f7=0100000).
        Instr = 32'h40118233;
        #10;
        $display("CTRL-02 esperado=RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0001");
        $display("CTRL-02 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b1 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0001)
            $display("CTRL-02 PASS");
        else $display("CTRL-02 FAIL");

        // and (op=0110011 f3=111 f7=0000000).
        Instr = 32'h0020F2B3;
        #10;
        $display("CTRL-03 esperado=RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0010");
        $display("CTRL-03 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b1 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0010)
            $display("CTRL-03 PASS");
        else $display("CTRL-03 FAIL");

        // or (op=0110011 f3=110 f7=0000000).
        Instr = 32'h0020E333;
        #10;
        $display("CTRL-04 esperado=RegWrite=1 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0011");
        $display("CTRL-04 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b1 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0011)
            $display("CTRL-04 PASS");
        else $display("CTRL-04 FAIL");

        // addi (op=0010011 f3=000).
        Instr = 32'h00A00093;
        #10;
        $display("CTRL-05 esperado=RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-05 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b1 && ALUSrc === 1'b1 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-05 PASS");
        else $display("CTRL-05 FAIL");

        // lw (op=0000011 f3=010).
        Instr = 32'h00002283;
        #10;
        $display("CTRL-06 esperado=RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=1 ImmSrc=00 ALUControl=0000");
        $display("CTRL-06 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b1 && ALUSrc === 1'b1 && MemWrite === 1'b0 &&
            ResultSrc === 1'b1 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-06 PASS");
        else $display("CTRL-06 FAIL");

        // sw (op=0100011 f3=010).
        Instr = 32'h00402023;
        #10;
        $display("CTRL-07 esperado=RegWrite=0 ALUSrc=1 MemWrite=1 ResultSrc=0 ImmSrc=01 ALUControl=0000");
        $display("CTRL-07 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b0 && ALUSrc === 1'b1 && MemWrite === 1'b1 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b01 && ALUControl === 4'b0000)
            $display("CTRL-07 PASS");
        else $display("CTRL-07 FAIL");

        // ================= addi contra sub =================
        // CTRL-08: addi x1, x0, -1 (bits 31:25 = 1111111, bit 30 = 1). Debe dar ADD.
        Instr = 32'hFFF00093;
        #10;
        $display("CTRL-08 esperado=RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-08 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b1 && ALUSrc === 1'b1 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-08 PASS");
        else $display("CTRL-08 FAIL");

        // CTRL-09: addi x1, x0, 1024 (bits 31:25 = 0100000, igual al funct7 de sub). Debe dar ADD.
        Instr = 32'h40000093;
        #10;
        $display("CTRL-09 esperado=RegWrite=1 ALUSrc=1 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-09 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b1 && ALUSrc === 1'b1 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-09 PASS");
        else $display("CTRL-09 FAIL");

        // ================= No soportadas: todas las salidas en 0 =================
        // CTRL-10: xor x7, x1, x2 (mismo opcode que add, f3=100).
        Instr = 32'h0020C3B3;
        #10;
        $display("CTRL-10 esperado=RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-10 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b0 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-10 PASS");
        else $display("CTRL-10 FAIL");

        // mul (mismo op y f3 que add, f7=0000001).
        Instr = 32'h022081B3;
        #10;
        $display("CTRL-11 esperado=RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-11 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b0 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-11 PASS");
        else $display("CTRL-11 FAIL");

        // xori (mismo opcode que addi, f3=100).
        Instr = 32'h0050C393;
        #10;
        $display("CTRL-12 esperado=RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-12 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b0 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-12 PASS");
        else $display("CTRL-12 FAIL");

        // lb (mismo opcode que lw, f3=000).
        Instr = 32'h00000283;
        #10;
        $display("CTRL-13 esperado=RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-13 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b0 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-13 PASS");
        else $display("CTRL-13 FAIL");

        // sb (mismo opcode que sw, f3=000).
        Instr = 32'h00400023;
        #10;
        $display("CTRL-14 esperado=RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-14 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b0 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-14 PASS");
        else $display("CTRL-14 FAIL");

        //  0x00000000 opcode invalido.
        Instr = 32'h00000000;
        #10;
        $display("CTRL-15 esperado=RegWrite=0 ALUSrc=0 MemWrite=0 ResultSrc=0 ImmSrc=00 ALUControl=0000");
        $display("CTRL-15 obtenido=RegWrite=%b ALUSrc=%b MemWrite=%b ResultSrc=%b ImmSrc=%b ALUControl=%b",
                 RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
        if (RegWrite === 1'b0 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("CTRL-15 PASS");
        else $display("CTRL-15 FAIL");

        $finish;
    end
endmodule
