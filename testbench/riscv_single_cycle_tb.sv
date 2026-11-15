// ============================================================
// Proyecto: Procesador RISC-V Uniciclo - Capitulo 2
// Curso: Diseno de Sistemas Digitales EL-3310
// Grupo: Samara
// Testbench: Integracion del procesador
// Descripcion: ejecuta dos programas y verifica PC, registros,
// memoria, x0 e instrucciones no soportadas con PASS/FAIL.
// Responsable / Verification Engineer: Andres Rojas Viquez
// Elaborado con apoyo de IA; pendiente de revision por el estudiante.
// Fecha de primera version: 14/11/2026
// Historial de modificaciones:
// Fecha       | Autor                           | Descripcion
// 14/11/2026  | Andres Rojas Viquez / apoyo IA   | Primera version
// ENTRADAS: ninguna; los estimulos se generan en este testbench.
// SALIDAS: esperado, obtenido, PASS/FAIL y resumen en consola.
// Requiere los nombres de instancia del contrato del equipo.
// ============================================================
`timescale 1ns/1ps

module riscv_single_cycle_tb;
    logic clk, reset;
    integer pruebas = 0;
    integer fallos = 0;
    integer i;
    integer siguiente_pc;
    logic secuencia_correcta;
    logic control_seguro, registros_intactos, memoria_intacta;
    logic [31:0] registros_antes [1:31];
    logic [31:0] memoria_antes [0:63];

    riscv_single_cycle dut (.clk(clk), .reset(reset));

    // El reloj se controla aqui: cada llamada genera exactamente un
    // flanco positivo. #1 deja terminar las asignaciones no bloqueantes
    // antes de observar el estado. Los programas se cambian con clk=0.
    task automatic ciclo;
        begin
            #5; clk = 1'b1;
            #1;
            #4; clk = 1'b0;
        end
    endtask

    task automatic comprobar(input string id,
                              input logic [31:0] obtenido,
                              input logic [31:0] esperado);
        begin
            pruebas = pruebas + 1;
            $display("%s esperado=%08h obtenido=%08h", id, esperado, obtenido);
            if (obtenido === esperado) $display("%s PASS", id);
            else begin
                $display("%s FAIL", id);
                fallos = fallos + 1;
            end
        end
    endtask

    task automatic vaciar_imem;
        integer posicion;
        begin
            for (posicion = 0; posicion < 64; posicion = posicion + 1)
                dut.u_imem.mem[posicion] = 32'h00000000;
            #1;
        end
    endtask

    task automatic ejecutar(input integer cantidad);
        integer paso;
        begin
            for (paso = 0; paso < cantidad; paso = paso + 1) begin
                $display("TRAZA PC=%08h Instr=%08h", dut.u_pc.PC, dut.u_imem.RD);
                if (!(dut.u_pc.PC === siguiente_pc)) secuencia_correcta = 1'b0;
                ciclo();
                siguiente_pc = siguiente_pc + 4;
                if (!(dut.u_pc.PC === siguiente_pc)) secuencia_correcta = 1'b0;
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        // Esperar los initial de las memorias antes de escribir IMEM.
        #1;
        // El reset SOLO afecta al PC. Instrucciones cero durante reset
        // evitan escrituras accidentales del datapath en ese flanco.
        vaciar_imem();
        ciclo();
        comprobar("INT-01", dut.u_pc.PC, 32'd0);
        reset = 1'b0;

        // Programa ilustrativo: seis flancos, sin ciclos extra.
        $readmemh("program.hex", dut.u_imem.mem, 0, 5);
        #1;
        siguiente_pc = 0;
        secuencia_correcta = 1'b1;
        ejecutar(6);
        comprobar("INT-02", {31'd0, secuencia_correcta}, 32'd1);
        comprobar("INT-03", dut.u_rf.rf[1], 32'd10);
        comprobar("INT-04", dut.u_rf.rf[2], 32'd20);
        comprobar("INT-05", dut.u_rf.rf[3], 32'd30);
        comprobar("INT-06", dut.u_rf.rf[4], 32'd20);
        comprobar("INT-07", dut.u_rf.rf[5], 32'd20);
        comprobar("INT-08", dut.u_dmem.mem[0], 32'd20);

        // Reiniciar desde PC=24: no debe cambiar antes del flanco.
        // No se borran RF ni DMEM entre programas.
        vaciar_imem();
        reset = 1'b1;
        #2;
        comprobar("INT-09", dut.u_pc.PC, 32'd24);
        ciclo();
        comprobar("INT-10", dut.u_pc.PC, 32'd0);
        reset = 1'b0;
        $readmemh("prog2.hex", dut.u_imem.mem, 0, 22);
        #1;
        siguiente_pc = 0;
        secuencia_correcta = 1'b1;
        ejecutar(11);
        // Esta palabra se sobrescribe despues: comprobarla ahora
        // demuestra que el primer sw a 0xe4 tambien se ejecuto.
        comprobar("INT-12", dut.u_dmem.mem[57], 32'd14);
        ejecutar(12);
        comprobar("INT-11", {31'd0, secuencia_correcta}, 32'd1);
        comprobar("INT-13", dut.u_rf.rf[1], 32'd12);
        comprobar("INT-14", dut.u_rf.rf[2], 32'd10);
        comprobar("INT-15", dut.u_rf.rf[3], 32'd22);
        comprobar("INT-16", dut.u_rf.rf[4], 32'd2);
        comprobar("INT-17", dut.u_rf.rf[5], 32'd8);
        comprobar("INT-18", dut.u_rf.rf[6], 32'd14);
        comprobar("INT-19", dut.u_rf.rf[7], 32'hfffffffb);
        comprobar("INT-20", dut.u_rf.rf[8], 32'd4);
        comprobar("INT-21", dut.u_rf.rf[9], 32'd8);
        comprobar("INT-22", dut.u_rf.rf[10], 32'd224);
        comprobar("INT-23", dut.u_rf.rf[11], 32'd232);
        comprobar("INT-24", dut.u_rf.rf[12], 32'd22);
        comprobar("INT-25", dut.u_rf.rf[13], 32'hfffffffb);
        comprobar("INT-26", dut.u_rf.rf[14], 32'd17);
        comprobar("INT-27", dut.u_rf.rf[15], 32'hfffffffe);
        comprobar("INT-28", dut.u_rf.rf[16], 32'd10);
        comprobar("INT-29", dut.u_rf.rf[17], 32'hffffffff);
        comprobar("INT-30", dut.u_rf.rf[18], 32'd4);
        comprobar("INT-31", dut.u_dmem.mem[56], 32'd8);
        comprobar("INT-32", dut.u_dmem.mem[57], 32'd22);
        comprobar("INT-33", dut.u_dmem.mem[63], 32'hfffffffb);
        // En PC=92 la instruccion es cero: A1=0. Se observa x0 por
        // el puerto de lectura; rf[0] puede permanecer sin inicializar.
        comprobar("INT-34", dut.u_rf.RD1, 32'd0);

        // Prueba negativa separada de los programas RV32I soportados.
        // PC=92 apunta a mem[23]. No alterar los registros ni DMEM.
        dut.u_imem.mem[23] = 32'h0020c3b3; // xor x7,x1,x2
        dut.u_imem.mem[24] = 32'h022081b3; // mul x3,x1,x2
        dut.u_imem.mem[25] = 32'h0050c393; // xori x7,x1,5
        dut.u_imem.mem[26] = 32'h00000283; // lb x5,0(x0)
        dut.u_imem.mem[27] = 32'h00400023; // sb x4,0(x0)
        dut.u_imem.mem[28] = 32'h00000000; // opcode no soportado
        #1;
        for (i = 1; i < 32; i = i + 1) registros_antes[i] = dut.u_rf.rf[i];
        for (i = 0; i < 64; i = i + 1) memoria_antes[i] = dut.u_dmem.mem[i];
        control_seguro = 1'b1;
        registros_intactos = 1'b1;
        memoria_intacta = 1'b1;
        secuencia_correcta = 1'b1;
        // Comparar tras CADA instruccion, para detectar tambien un
        // cambio transitorio que otra instruccion pudiera deshacer.
        repeat (6) begin
            if (!({dut.u_ctrl.RegWrite, dut.u_ctrl.MemWrite} === 2'b00))
                control_seguro = 1'b0;
            ejecutar(1);
            for (i = 1; i < 32; i = i + 1)
                if (!(dut.u_rf.rf[i] === registros_antes[i])) registros_intactos = 1'b0;
            for (i = 0; i < 64; i = i + 1)
                if (!(dut.u_dmem.mem[i] === memoria_antes[i])) memoria_intacta = 1'b0;
        end
        comprobar("INT-35", {31'd0, control_seguro}, 32'd1);
        comprobar("INT-36", {31'd0, registros_intactos}, 32'd1);
        comprobar("INT-37", {31'd0, memoria_intacta}, 32'd1);
        comprobar("INT-38", {31'd0, secuencia_correcta}, 32'd1);

        $display("RESUMEN: %0d pruebas, %0d PASS, %0d FAIL", pruebas, pruebas-fallos, fallos);
        if (fallos != 0) $fatal(1, "La integracion tiene fallos");
        $finish;
    end

    initial begin
        #10000;
        $fatal(1, "Tiempo limite: el testbench no termino");
    end
endmodule
