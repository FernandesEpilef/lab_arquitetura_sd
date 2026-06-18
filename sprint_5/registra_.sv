//
module RegisterFile (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] wd3,
    input  logic [4:0]  wa3,
    input  logic        we3,
    input  logic [4:0]  ra1,
    input  logic [4:0]  ra2,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);
    logic [31:0] reg_bank [31:0];

    // Leitura assíncrona
    assign rd1 = (ra1 != 5'd0) ? reg_bank[ra1] : 32'b0; // Reg. $zero sempre retorna 0
    assign rd2 = (ra2 != 5'd0) ? reg_bank[ra2] : 32'b0; // Reg. $zero sempre retorna 0

    // Escrita síncrona
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Resetar todos os registradores para 0
            for (int i = 0; i < 32; i++) begin
                reg_bank[i] <= 32'b0;
            end
        end else if (we3 && wa3 != 5'd0) begin
            reg_bank[wa3] <= wd3; // Escrever no registrador, exceto $zero
        end
    end

endmodule
