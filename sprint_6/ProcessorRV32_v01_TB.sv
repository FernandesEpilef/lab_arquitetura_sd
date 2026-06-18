`timescale 1ns/1ps

module ProcessorRV32_v01_TB;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic [31:0] w_PC, w_Inst;
    logic w_RegWrite, w_ULASrc;
    logic [2:0] w_ULAControl;
    logic [31:0] x0, x1, x2, x3, x4, x5, x6, x7;

    always #5 clk = ~clk;

    ProcessorRV32_v01 dut (.*);

    initial begin
        // Gera um pulso de reset ativo em zero.
        #1 rst = 1'b0;
        #2;
        rst = 1'b1;

        // Sete bordas executam as sete instrucoes da ROM.
        repeat (7) @(posedge clk);
        #1;

        if (x0 !== 32'h00000000) $fatal(1, "x0 incorreto: %h", x0);
        if (x1 !== 32'h000000f3) $fatal(1, "x1 incorreto: %h", x1);
        if (x2 !== 32'h000000fc) $fatal(1, "x2 incorreto: %h", x2);
        if (x3 !== 32'h000000f0) $fatal(1, "x3 incorreto: %h", x3);
        if (x4 !== 32'h000000ff) $fatal(1, "x4 incorreto: %h", x4);
        if (x5 !== 32'h00000000) $fatal(1, "x5 incorreto: %h", x5);
        if (x6 !== 32'h00000001) $fatal(1, "x6 incorreto: %h", x6);
        if (x7 !== 32'h000000fe) $fatal(1, "x7 incorreto: %h", x7);

        $display("PASSOU: programa completo executado corretamente.");
        $display("x0=%h x1=%h x2=%h x3=%h", x0, x1, x2, x3);
        $display("x4=%h x5=%h x6=%h x7=%h", x4, x5, x6, x7);
        $finish;
    end
endmodule
