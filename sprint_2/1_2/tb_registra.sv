`timescale 1ns/1ps

module tb_registr_a_dor;

    logic clk;
    logic rst_n;
    logic enable;
    logic [3:0] entra;
    logic [3:0] sai;

    registra_dor dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .entra(entra),
        .sai(sai)
    );

    always #5 clk = ~clk;

    task check(input [3:0] esperado, input string msg);
        if (out !== esperado)
            $display("[ERRO] %s | esperado=%0h obtido=%0h", msg, esperado, out);
        else
            $display("[OK]   %s | out=%0h", msg, out);
    endtask

    initial begin
        //$dumpfile("tb_registrador4.vcd");
        //$dumpvars(0, tb_registrador4);

        clk = 0;
        rst_n = 1;
        enable = 0;
        entra = 4'h0;

        // Reset assíncrono: não precisa esperar borda de clock.
        #2 rst_n = 0;
        #1 check(4'h0, "reset assíncrono zera o registrador");
        #7 rst_n = 1;

        // enable=1: registra a entrada na borda de subida.
        entra = 4'hA;
        enable = 1;
        @(posedge clk); #1;
        check(4'hA, "enable=1 registra in=A");

        // enable=0: mantém valor antigo, mesmo mudando a entrada.
        entra = 0;
        in = 4'h5;
        @(posedge clk); #1;
        check(4'hA, "enable=0 mantém valor A, mesmo in=5");

        // enable volta para 1: agora registra o novo valor.
        enable = 1;
        @(posedge clk); #1;
        check(4'h5, "enable=1 registra in=5");

        // Reset no meio da simulação.
        #3 rst_n = 0;
        #1 check(4'h0, "reset no meio da simulação zera imediatamente");
        #6 rst_n = 1;

        $display("Finish");
        $finish;
    end

endmodule
