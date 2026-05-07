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

    initial begin
        //$dumpfile("tb_contador16.vcd");
        //$dumpvars(0, tb_contador16);

        $monitor(
            "Tempo=%0t | rst_n=%b | enable=%b | dir=%b | count=%0h",
            $time, rst_n, enable, dir, count
        );

        clk = 0;
        rst_n = 0;
        enable = 0;
        dir = 0;

        // Reset inicial
        #10;
        rst_n = 1;

        // Conta crescente: 0 -> 1 -> 2 -> 3
        enable = 1;
        dir = 0;

        #40;

        // Pausa: deve manter o valor
        enable = 0;

        #20;

        // Conta decrescente
        enable = 1;
        dir = 1;

        #40;

        // Reset novamente
        rst_n = 0;

        #10;
        rst_n = 1;

        // Wrap decrescente: 0 -> F
        enable = 1;
        dir = 1;

        #20;

        // Wrap crescente: F -> 0
        dir = 0;

        #20;

        $display("cabousse");
        $finish;
    end

endmodule