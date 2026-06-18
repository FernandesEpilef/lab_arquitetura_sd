`default_nettype none

module RegisterFile (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] wd3,
    input  logic [4:0]  wa3,
    input  logic        we3,
    input  logic [4:0]  ra1,
    input  logic [4:0]  ra2,
    output logic [31:0] rd1,
    output logic [31:0] rd2,
    output logic [31:0] x0,
    output logic [31:0] x1,
    output logic [31:0] x2,
    output logic [31:0] x3,
    output logic [31:0] x4,
    output logic [31:0] x5,
    output logic [31:0] x6,
    output logic [31:0] x7
);
    logic [31:0] reg_bank [31:0];
    integer i;

    // Duas portas de leitura assincronas.
    assign rd1 = (ra1 != 5'd0) ? reg_bank[ra1] : 32'b0;
    assign rd2 = (ra2 != 5'd0) ? reg_bank[ra2] : 32'b0;

    // Saidas exclusivas para depuracao no LCD.
    assign x0 = 32'b0;
    assign x1 = reg_bank[1];
    assign x2 = reg_bank[2];
    assign x3 = reg_bank[3];
    assign x4 = reg_bank[4];
    assign x5 = reg_bank[5];
    assign x6 = reg_bank[6];
    assign x7 = reg_bank[7];

    // Escrita sincrona e reset assincrono ativo em zero.
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1)
                reg_bank[i] <= 32'b0;
        end else if (we3 && (wa3 != 5'd0)) begin
            reg_bank[wa3] <= wd3;
        end
    end

endmodule

`default_nettype wire
