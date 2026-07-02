
`timescale 1ns/1ps

module ProcessorRV32_v02_TB;

    // =========================================
    // Sinais
    // =========================================

    logic clk;
    logic rst;

    logic [31:0] w_PC;
    logic [31:0] w_Inst;

    logic        w_RegWrite;
    logic        w_ULASrc;
    logic [2:0]  w_ULAControl;

    logic [31:0] x0;
    logic [31:0] x1;
    logic [31:0] x2;
    logic [31:0] x3;
    logic [31:0] x4;
    logic [31:0] x5;
    logic [31:0] x6;
    logic [31:0] x7;


    // =========================================
    // Clock
    // =========================================

    initial
        clk = 1'b0;

    always #5 clk = ~clk;


    // =========================================
    // DUT
    // =========================================

    ProcessorRV32_v02 dut (

        .clk(clk),
        .rst(rst),

        .w_PC(w_PC),
        .w_Inst(w_Inst),

        .w_RegWrite(w_RegWrite),
        .w_ULASrc(w_ULASrc),
        .w_ULAControl(w_ULAControl),

        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .x6(x6),
        .x7(x7)

    );


    // =========================================
    // Debug
    // =========================================

    always @(posedge clk) begin

        $display("========================================");

        $display("TIME       = %0t", $time);

        $display("PC         = %h", w_PC);
        $display("INST       = %h", w_Inst);

        $display("RegWrite   = %b", w_RegWrite);
        $display("ULASrc     = %b", w_ULASrc);
        $display("ULAControl = %b", w_ULAControl);

        $display("Imm        = %h", dut.w_Imm);

        $display("rd1        = %h", dut.w_rd1);
        $display("rd2        = %h", dut.w_rd2);

        $display("SrcB       = %h", dut.w_SrcB);

        $display("ULAResult  = %h", dut.w_ULAResult);

        $display("wd3        = %h", dut.w_wd3);

        $display("x1         = %h", x1);
        $display("x2         = %h", x2);
        $display("x3         = %h", x3);
        $display("x4         = %h", x4);

    end


    // =========================================
    // Simulação principal
    // =========================================

    initial begin

        // -------------------------------------
        // Dump de waveform
        // -------------------------------------

        $dumpfile("processor_rv32_v02_tb.vcd");
        $dumpvars(0, ProcessorRV32_v02_TB);


        // -------------------------------------
        // Reset
        // -------------------------------------

        rst = 1'b0;

        repeat (2) @(posedge clk);

        rst = 1'b1;

        $display("");
        $display("=====================================");
        $display("RESET LIBERADO");
        $display("=====================================");
        $display("");


        // -------------------------------------
        // Espera execução completa
        // -------------------------------------

        wait (x4 == 32'h000000AB);

        @(posedge clk);

        #1;


        // =====================================
        // Verificação dos registradores
        // =====================================

        if (x0 !== 32'h00000000)
            $fatal(1, "x0 incorreto: %h", x0);

        if (x1 !== 32'h000000AB)
            $fatal(1, "x1 incorreto: %h", x1);

        if (x2 !== 32'h000000AB)
            $fatal(1, "x2 incorreto: %h", x2);

        if (x3 !== 32'h000000AB)
            $fatal(1, "x3 incorreto: %h", x3);

        if (x4 !== 32'h000000AB)
            $fatal(1, "x4 incorreto: %h", x4);


        // =====================================
        // Verificação da memória
        // =====================================

        if (dut.DM.mem[10] !== 32'h000000AB)
            $fatal(
                1,
                "mem[10] incorreta: %h",
                dut.DM.mem[10]
            );

        if (dut.DM.mem[11] !== 32'h000000AB)
            $fatal(
                1,
                "mem[11] incorreta: %h",
                dut.DM.mem[11]
            );

        if (dut.DM.mem[12] !== 32'h000000AB)
            $fatal(
                1,
                "mem[12] incorreta: %h",
                dut.DM.mem[12]
            );


        // =====================================
        // Resultado final
        // =====================================

        $display("");
        $display("=====================================");
        $display("PASSOU: Sprint 7 funcionando.");
        $display("=====================================");
        $display("");

        $display("REGISTRADORES:");
        $display("x0 = %h", x0);
        $display("x1 = %h", x1);
        $display("x2 = %h", x2);
        $display("x3 = %h", x3);
        $display("x4 = %h", x4);

        $display("");

        $display("MEMORIA:");
        $display("mem[10] = %h", dut.DM.mem[10]);
        $display("mem[11] = %h", dut.DM.mem[11]);
        $display("mem[12] = %h", dut.DM.mem[12]);

        $display("");

        $finish;

    end

endmodule
