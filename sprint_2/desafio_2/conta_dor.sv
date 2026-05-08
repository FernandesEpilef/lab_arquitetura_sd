module conta_dor(
    input  logic       clk,
    input  logic       rst_n, // ativo em 0
    input  logic       enable, // 1 -> copia o novo valor
    input  logic       dir, // 0 -> crescente 
    output logic [3:0] count
);

    logic [3:0] passo; // passo do musk
    logic [3:0] proximo_valor; // prox_valor do contador

    musk u_mux_dir (

        // Entrada para contagem crescente (+1)
        .i0    (4'b0001),
        // Entrada para contagem decrescente (-1)
        // 1111 equivale a -1 em complemento de 2
        .i1    (4'b1111),
        // Seleção do MUX
        .sel   (dir),
        // Saída escolhida
        .saida (passo)
    );
    somador_dor u_somador (

        // Valor atual do contador
        .A (count),

        // Valor escolhido pelo MUX
        .B (passo),

        // Próximo valor do contador
        .C (proximo_valor)
    );

    registra_dor u_reg (

        // Clock
        .clk    (clk),

        // Reset
        .rst_n  (rst_n),

        // Habilitação
        .enable (enable),

        // Entrada do registrador
        .entra  (proximo_valor),

        // Saída do registrador
        .sai    (count)
    );

endmodule
