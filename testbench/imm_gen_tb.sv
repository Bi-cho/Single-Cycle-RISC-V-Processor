// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Sámara
//
// Testbench: Immediate Generator
//
// Descripción:
// Verifica la generación y extensión de los valores inmediatos
// requeridos durante el Capítulo 1 del proyecto.
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

module imm_gen_tb;
    logic [31:0] Instr, ImmExt;
    logic [1:0] ImmSrc;

    imm_gen dut (.Instr(Instr), .ImmSrc(ImmSrc), .ImmExt(ImmExt));

    initial begin
        // IMM-01: I-type positivo, addi x2, x1, 5.
        Instr = 32'h00508113; ImmSrc = 2'b00;
        #10;
        $display("IMM-01 esperado=ImmExt=00000005 obtenido=ImmExt=%h", ImmExt);
        if (ImmExt === 32'd5) $display("IMM-01 PASS");
        else $display("IMM-01 FAIL");

        // IMM-02: I-type negativo, addi x2, x1, -1.
        Instr = 32'hFFF08113; ImmSrc = 2'b00;
        #10;
        $display("IMM-02 esperado=ImmExt=ffffffff obtenido=ImmExt=%h", ImmExt);
        if (ImmExt === 32'hFFFFFFFF) $display("IMM-02 PASS");
        else $display("IMM-02 FAIL");

        // IMM-03: S-type positivo, sw x2, 37(x1).
        Instr = 32'h0220A2A3; ImmSrc = 2'b01;
        #10;
        $display("IMM-03 esperado=ImmExt=00000025 obtenido=ImmExt=%h", ImmExt);
        if (ImmExt === 32'd37) $display("IMM-03 PASS");
        else $display("IMM-03 FAIL");

        // IMM-04: S-type negativo, sw x2, -16(x1).
        Instr = 32'hFE20A823; ImmSrc = 2'b01;
        #10;
        $display("IMM-04 esperado=ImmExt=fffffff0 obtenido=ImmExt=%h", ImmExt);
        if (ImmExt === 32'hFFFFFFF0) $display("IMM-04 PASS");
        else $display("IMM-04 FAIL");

        $finish;
    end
endmodule
