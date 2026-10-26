// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Testbench: Register File
//
// Descripción:
// Verifica las operaciones de lectura y escritura del banco de
// registros, incluyendo el comportamiento especial de x0.
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

module register_file_tb;
    logic clk, RegWrite;
    logic [4:0] A1, A2, A3;
    logic [31:0] WD3, RD1, RD2;

    register_file dut (.clk(clk), .A1(A1), .A2(A2), .A3(A3), .WD3(WD3),
                       .RegWrite(RegWrite), .RD1(RD1), .RD2(RD2));

    initial begin
        clk = 0; RegWrite = 0;
        A1 = 0; A2 = 0; A3 = 0; WD3 = 0;

        // RF-01: escribir x5=25 y leerlo.
        A3 = 5; WD3 = 25; RegWrite = 1;
        // Datos estables durante ambos flancos; observar despues del ciclo.
        #5; clk = 1;
        #5; clk = 0;
        #1; RegWrite = 0; A1 = 5;
        #1;
        $display("RF-01 esperado=RD1=00000019 obtenido=RD1=%h", RD1);
        if (RD1 === 32'd25) $display("RF-01 PASS");
        else $display("RF-01 FAIL");

        // RF-02: escribir x6=50 y leer x5 y x6 simultaneamente.
        A3 = 6; WD3 = 50; RegWrite = 1;
        #5; clk = 1;
        #5; clk = 0;
        #1; RegWrite = 0; A1 = 5; A2 = 6;
        #1;
        $display("RF-02 esperado=RD1=00000019; RD2=00000032 obtenido=RD1=%h; RD2=%h", RD1, RD2);
        if ((RD1 === 32'd25) && (RD2 === 32'd50)) $display("RF-02 PASS");
        else $display("RF-02 FAIL");

        // RF-03: intentar escribir x0=100 y comprobar que siga en cero.
        A3 = 0; WD3 = 100; RegWrite = 1;
        #5; clk = 1;
        #5; clk = 0;
        #1; RegWrite = 0; A1 = 0; A2 = 0;
        #1;
        $display("RF-03 esperado=RD1=00000000; RD2=00000000 obtenido=RD1=%h; RD2=%h", RD1, RD2);
        if ((RD1 === 32'd0) && (RD2 === 32'd0)) $display("RF-03 PASS");
        else $display("RF-03 FAIL");

        $finish;
    end
endmodule
