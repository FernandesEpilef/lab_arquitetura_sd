`default_nettype none

module ProgramCounter (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] PCin,
    output logic [31:0] PC
);

    // Reset ativo em nivel baixo, como especificado no enunciado.
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            PC <= 32'b0;
        else
            PC <= PCin;
    end

endmodule

`default_nettype wire
