module registra_dor (
    input  logic       clk,
    input  logic       rst_n,   // reset assíncrono ativo em 0
    input  logic       enable,  // 1 ele copia
    input  logic [3:0] entra,
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