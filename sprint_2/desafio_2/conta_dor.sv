module conta_dor(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enable,
    input  logic       dir,     // 0: crescente, 1: decrescente
    output logic [3:0] count
);

    logic [3:0] constante;
    logic [3:0] proximo_valor;

    // Se dir=0, soma +1. Se dir=1, soma 4'b1111, que equivale a -1 em 4 bits.
    musk u_mux_dir (
        .i0   (4'b0001),
        .i1   (4'b1111),
        .sel  (dir),
        .saida(constante)
    );

    somador_dor u_somador (
        .A(count),
        .B(constante),
        .C(proximo_valor)
    );

    registra_dor u_reg (
        .clk   (clk),
        .rst_n (rst_n),
        .enable(enable),
        .entra   (proximo_valor),
        .sai   (count)
    );

endmodule
