module soma_mux_reg (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enable,
    input  logic       S,
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic [3:0] C,
    output logic [3:0] R
);

    logic [3:0] mux_p_somador;
    logic [3:0] soma_resultado;

    musk u_mux (
        .i0   (B),
        .i1   (C),
        .sel  (S),
        .saida(mux_p_somador)
    );

    somador_dor u_somador (
        .A(A),
        .B(mux_p_somador),
        .C(soma_resultado)
    );

    registrador_dor u_reg (
        .clk   (clk),
        .rst_n (rst_n),
        .enable(enable),
        .entra    (soma_resultado),
        .sai   (R)
    );

endmodule
