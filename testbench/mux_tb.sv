// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Testbench: Multiplexor 2 a 1
//
// Descripción:
// Verifica que el multiplexor seleccione correctamente cada
// una de sus entradas según la señal Select.
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

module mux_tb;
    logic [31:0] A, B, Y;
    logic Select;

    mux2to1 #(.WIDTH(32)) dut (.A(A), .B(B), .Select(Select), .Y(Y));

    initial begin
        A = 32'h12345678;
        B = 32'hABCDEF00;

        // MUX-01: Select=0 selecciona A.
        Select = 0;
        #10;
        $display("MUX-01 esperado=Y=12345678 obtenido=Y=%h", Y);
        if (Y === 32'h12345678) $display("MUX-01 PASS");
        else $display("MUX-01 FAIL");

        // MUX-02: Select=1 selecciona B.
        Select = 1;
        #10;
        $display("MUX-02 esperado=Y=abcdef00 obtenido=Y=%h", Y);
        if (Y === 32'hABCDEF00) $display("MUX-02 PASS");
        else $display("MUX-02 FAIL");

        $finish;
    end
endmodule
