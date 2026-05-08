module tb_contador16;

    logic clk;
    logic rst_n;
    logic enable;
    logic dir;
    logic [3:0] count;

    conta_dor dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .enable (enable),
        .dir    (dir),
        .count  (count)
    );

    // Clock: troca a cada 5 ns
    // Período total = 10 ns
    always #5 clk = ~clk;

    initial begin

        $monitor(
            "Tempo=%0t | clk=%b | rst_n=%b | enable=%b | dir=%b | count=%0h",
            $time, clk, rst_n, enable, dir, count
        );

        // Valores iniciais
        clk    = 0;
        rst_n  = 0;
        enable = 0;
        dir    = 0;

        //====================================================
        // RESET INICIAL
        //====================================================
        #2;
        rst_n = 0;

        @(posedge clk);
        rst_n = 1;

        //====================================================
        // CASO 1: CONTAGEM CRESCENTE
        //====================================================
        enable = 1;
        dir    = 0;

        // Conta uma volta completa:
        // 0 -> 1 -> 2 -> ... -> E -> F -> 0
        repeat (16) begin
            @(posedge clk);
        end

        //====================================================
        // CASO 2: CONTAGEM DECRESCENTE
        //====================================================
        dir = 1;

        // Conta uma volta completa ao contrário:
        // 0 -> F -> E -> ... -> 1 -> 0
        repeat (16) begin
            @(posedge clk);
        end

        //====================================================
        // CASO 3: PAUSA COM ENABLE = 0
        //====================================================
        enable = 0;

        // Mesmo passando clocks, count deve ficar parado
        repeat (3) begin
            @(posedge clk);
        end

        //====================================================
        // CASO 4: VOLTA A CONTAR CRESCENTE
        //====================================================
        enable = 1;
        dir    = 0;

        repeat (4) begin
            @(posedge clk);
        end

        //====================================================
        // CASO 5: RESET DURANTE A SIMULAÇÃO
        //====================================================
        rst_n = 0;

        @(posedge clk);

        rst_n = 1;

        // Conta mais um pouco depois do reset
        repeat (4) begin
            @(posedge clk);
        end

        $display("fim da simulacao");
        $finish;
    end

endmodule