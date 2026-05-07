`timescale 1ns/1ps

module tb_contador16;

    logic clk;
    logic rst_n;
    logic enable;
    logic dir;
    logic [3:0] count;

    conta_dor dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .dir(dir),
        .count(count)
    );

    always #5 clk = ~clk;

    task check(input [3:0] esperado, input string msg);
        if (count !== esperado)
            $display("[ERRO] %s | esperado=%0h obtido=%0h", msg, esperado, count);
        else
            $display("[OK]   %s | count=%0h", msg, count);
    endtask

    initial begin
        $dumpfile("tb_contador16.vcd");
        $dumpvars(0, tb_contador16);

        clk = 0;
        rst_n = 0;
        enable = 0;
        dir = 0;

        #2 check(4'h0, "reset inicial");
        #8 rst_n = 1;

        enable = 1;
        dir = 0;
        repeat (3) @(posedge clk);
        #1 check(4'h3, "contagem crescente após 3 clocks");

        enable = 0;
        repeat (2) @(posedge clk);
        #1 check(4'h3, "enable=0 mantém contagem");

        enable = 1;
        dir = 1;
        @(posedge clk); #1;
        check(4'h2, "contagem decrescente: 3 -> 2");

        // Testa wrap-around decrescente: 0 - 1 = F em 4 bits.
        rst_n = 0;
        #1 check(4'h0, "reset antes do wrap decrescente");
        #4 rst_n = 1;
        dir = 1;
        enable = 1;
        @(posedge clk); #1;
        check(4'hF, "wrap decrescente: 0 -> F");

        // Testa wrap-around crescente: F + 1 = 0 em 4 bits.
        dir = 0;
        @(posedge clk); #1;
        check(4'h0, "wrap crescente: F -> 0");

        $display("Fim do teste do contador de 16 estados.");
        $finish;
    end

endmodule
