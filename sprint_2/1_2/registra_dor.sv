`timescale 1ns/1ps

module registra_dor (
    input  logic       clk,
    input  logic       rst_n,   // reset assíncrono ativo em 0
    input  logic       enable,
    input  logic [3:0] entra,   // 1 ele copia
    output logic [3:0] sai
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sai <= 4'b0000;
        else if (enable)
            sai <= entra;
        else
            sai <= sai;
    end

endmodule