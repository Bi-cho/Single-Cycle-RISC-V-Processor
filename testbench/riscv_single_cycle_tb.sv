// ============================================================
// Proyecto: Procesador RISC-V Uniciclo - Capitulo 2
// Curso: Diseno de Sistemas Digitales EL-3310
// Grupo: Samara
// Testbench: Integracion del procesador
// Descripcion: Se ejecuta un programa propio y se comprueban el reset,
// el avance del PC y los resultados de las siete instrucciones.
// Responsable / Verification Engineer: Andres Rojas Viquez
// Fecha de primera version: 14/11/2026
// Historial de modificaciones:
// Fecha       | Autor                           | Descripcion
// 14/11/2026  | Andres Rojas Viquez | Primera version
// 14/11/2026  | Andres Rojas Viquez | Reducir al alcance minimo
// ENTRADAS: No se reciben entradas externas. Las señales se generan aqui.
// SALIDAS: Se muestran los valores esperados y obtenidos, y PASS/FAIL por caso.
// Se usan los nombres de instancia acordados por el equipo.
// ============================================================
`timescale 1ns/1ps

module riscv_single_cycle_tb;
    logic clk, reset;
    logic secuencia_correcta;
    integer i;

    riscv_single_cycle dut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    task automatic comprobar(input string id,
                              input logic [31:0] obtenido,
                              input logic [31:0] esperado);
        begin
            $display("%s esperado=%08h obtenido=%08h", id, esperado, obtenido);
            if (obtenido === esperado) $display("%s PASS", id);
            else $display("%s FAIL", id);
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        // El reset solo reinicia el PC. Durante ese primer ciclo se dejan
        // instrucciones en cero para evitar cambios en registros y memoria.
        #1;
        for (i = 0; i < 64; i = i + 1)
            dut.u_imem.mem[i] = 32'h00000000;
        @(posedge clk);
        #1;
        comprobar("INT-01", dut.u_pc.PC, 32'd0);

        // El programa se carga y el reset se desactiva con el reloj en cero.
        @(negedge clk);
        $readmemh("program.hex", dut.u_imem.mem, 0, 7);
        reset = 1'b0;
        secuencia_correcta = 1'b1;
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            // Se espera a que terminen las escrituras antes de revisar los valores.
            #1;
            $display("INT-02 esperado=PC=%08h obtenido=PC=%08h",
                     32'd4 * (i + 1), dut.u_pc.PC);
            if (!(dut.u_pc.PC === (32'd4 * (i + 1))))
                secuencia_correcta = 1'b0;
        end
        if (secuencia_correcta === 1'b1) $display("INT-02 PASS");
        else $display("INT-02 FAIL");

        $display("INT-03 esperado=x1=0000000c x2=fffffffb obtenido=x1=%08h x2=%08h",
                 dut.u_rf.rf[1], dut.u_rf.rf[2]);
        if ((dut.u_rf.rf[1] === 32'd12) &&
            (dut.u_rf.rf[2] === 32'hfffffffb)) $display("INT-03 PASS");
        else $display("INT-03 FAIL");

        comprobar("INT-04", dut.u_rf.rf[3], 32'd7);          // add
        comprobar("INT-05", dut.u_rf.rf[4], 32'd17);         // sub
        comprobar("INT-06", dut.u_rf.rf[5], 32'd8);          // and
        comprobar("INT-07", dut.u_rf.rf[6], 32'hffffffff);   // or
        comprobar("INT-08", dut.u_dmem.mem[56], 32'd8);      // sw: 224/4=56
        comprobar("INT-09", dut.u_rf.rf[7], 32'd8);          // lw
        $finish;
    end
endmodule
