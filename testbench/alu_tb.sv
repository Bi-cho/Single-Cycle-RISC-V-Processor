// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Testbench: ALU
//
// Descripción:
// Verifica el funcionamiento de la ALU para las operaciones
// aritméticas y lógicas definidas en la especificación.
//
// Autor / Verification Engineer:
// Nombre: Andrés Rojas Viquez
// Fecha de primera versión: 21/10/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// ____/____/  | _________________  | Primera versión
// 21/10/2026 | Codex (apoyo IA)    | Borrador de pruebas automaticas; revisar por el verificador
// 21/10/2026 | Codex (apoyo IA)    | Simplificacion a las pruebas minimas del enunciado
//
// ============================================================

`timescale 1ns/1ps

module alu_tb;
    logic [31:0] A, B, Result;
    logic [3:0] ALUControl;
    logic Zero;

    alu dut (.A(A), .B(B), .ALUControl(ALUControl), .Result(Result), .Zero(Zero));

    initial begin
        // ALU-01: ADD, 5 + 3 = 8.
        A = 5; B = 3; ALUControl = 4'b0000;
        #10;
        $display("ALU-01 esperado=Result=00000008; Zero=0 obtenido=Result=%h; Zero=%b", Result, Zero);
        if ((Result === 32'd8) && (Zero === 1'b0)) $display("ALU-01 PASS");
        else $display("ALU-01 FAIL");

        // ALU-02: SUB con resultado negativo, 3 - 5 = -2.
        A = 3; B = 5; ALUControl = 4'b0001;
        #10;
        $display("ALU-02 esperado=Result=fffffffe; Zero=0 obtenido=Result=%h; Zero=%b", Result, Zero);
        if ((Result === 32'hFFFFFFFE) && (Zero === 1'b0)) $display("ALU-02 PASS");
        else $display("ALU-02 FAIL");

        // ALU-03: AND con resultado cero, 0101 & 0010 = 0000.
        A = 5; B = 2; ALUControl = 4'b0010;
        #10;
        $display("ALU-03 esperado=Result=00000000; Zero=1 obtenido=Result=%h; Zero=%b", Result, Zero);
        if ((Result === 32'd0) && (Zero === 1'b1)) $display("ALU-03 PASS");
        else $display("ALU-03 FAIL");

        // ALU-04: OR, 0101 OR 0011 = 0111.
        A = 5; B = 3; ALUControl = 4'b0011;
        #10;
        $display("ALU-04 esperado=Result=00000007; Zero=0 obtenido=Result=%h; Zero=%b", Result, Zero);
        if ((Result === 32'd7) && (Zero === 1'b0)) $display("ALU-04 PASS");
        else $display("ALU-04 FAIL");

        $finish;
    end
endmodule
