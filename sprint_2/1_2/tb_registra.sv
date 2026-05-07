module tb_registra_dor;

    // Sinais do testbench
    logic clk;
    logic rst_n;
    logic enable;
    logic [3:0] entra;
    logic [3:0] sai;

    // Instância do DUT (Device Under Test)
    registra_dor dut (
        .clk   (clk),
        .rst_n (rst_n),
        .enable(enable),
        .entra (entra),
        .sai   (sai)
    );

    // Geração do clock
    always #5 clk = ~clk;

    initial begin

        // Valores iniciais
        clk    = 0;
        rst_n  = 1;
        enable = 0;
        entra  = 4'b0000;

        $display("=== INICIO DA SIMULACAO ===");
        // caso 1 - reset assíncrono
        rst_n = 0;
        #2;
        $display("reset; sai = %b (esperado: 0000)", sai);

        rst_n = 1;

        // caso 2 - enable = 1, copia
        @(posedge clk);
        enable = 1;
        entra  = 4'b1010;
        @(posedge clk);
        #1;
        $display("enable=1 | entra=%b | sai=%b", entra, sai);

        // caso 3 - enable = 1; copia novo valor
        entra = 4'b1101;
        @(posedge clk);
        #1;
        $display("enable=1 | entra=%b | sai=%b", entra, sai);

        // caso 4 - enable = 0; mantem
        enable = 0;
        entra  = 4'b0011;
        @(posedge clk);
        #1;
        $display("enable=0 | entra=%b | sai=%b", entra, sai);

        // caso 5 - reset no meio do muido
        rst_n = 0;
        #1;
        $display("sai = %b (esperado: 0000)", sai);
        rst_n = 1;
        
        // caso 6 - enable = 1; apos reset
        enable = 1;
        entra  = 4'b1111;
        @(posedge clk);
        #1;
        $display("enable=1 | entra=%b | sai=%b", entra, sai);
        $display("finishi");
        $finish;
    end

endmodule