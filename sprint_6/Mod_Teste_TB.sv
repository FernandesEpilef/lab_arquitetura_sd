`timescale 1ns/1ps

module Mod_Teste_TB;
    logic CLOCK_27 = 1'b0;
    logic CLOCK_50 = 1'b0;
    logic [3:0] KEY = 4'b1111;
    logic [17:0] SW = 18'b0;

    wire [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
    wire [8:0] LEDG;
    wire [17:0] LEDR;
    wire UART_TXD;
    logic UART_RXD = 1'b1;
    wire [7:0] LCD_DATA;
    wire LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS;
    wire [35:0] GPIO_0, GPIO_1;

    always #10 CLOCK_27 = ~CLOCK_27;
    always #5  CLOCK_50 = ~CLOCK_50;

    Mod_Teste dut (.*);

    // Simula um clique no KEY[1]. A borda de subida acontece ao soltar.
    task automatic passo_clock;
        begin
            KEY[1] = 1'b0;
            #20;
            KEY[1] = 1'b1;
            #20;
        end
    endtask

    initial begin
        // Reset do processador.
        #2  KEY[2] = 1'b0;
        #20 KEY[2] = 1'b1;

        // Executa as sete instrucoes da memoria.
        repeat (7) passo_clock();

        if (dut.w_x0 !== 32'h00000000) $fatal(1, "x0 incorreto");
        if (dut.w_x1 !== 32'h000000f3) $fatal(1, "x1 incorreto");
        if (dut.w_x2 !== 32'h000000fc) $fatal(1, "x2 incorreto");
        if (dut.w_x3 !== 32'h000000f0) $fatal(1, "x3 incorreto");
        if (dut.w_x4 !== 32'h000000ff) $fatal(1, "x4 incorreto");
        if (dut.w_x5 !== 32'h00000000) $fatal(1, "x5 incorreto");
        if (dut.w_x6 !== 32'h00000001) $fatal(1, "x6 incorreto");
        if (dut.w_x7 !== 32'h000000fe) $fatal(1, "x7 incorreto");
        if (dut.w_PC !== 32'h0000001c) $fatal(1, "PC incorreto");

        $display("PASSOU: Mod_Teste executou as sete instrucoes.");
        $display("x0=%h x1=%h x2=%h x3=%h", dut.w_x0, dut.w_x1,
                 dut.w_x2, dut.w_x3);
        $display("x4=%h x5=%h x6=%h x7=%h", dut.w_x4, dut.w_x5,
                 dut.w_x6, dut.w_x7);
        $finish;
    end
endmodule
