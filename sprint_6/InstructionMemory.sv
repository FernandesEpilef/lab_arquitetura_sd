`default_nettype none

module InstructionMemory #(
    parameter int ADDR_WIDTH = 10
) (
    input  logic [ADDR_WIDTH-1:0] A,
    output logic [31:0]           RD
);

    // A e um endereco em bytes. Por isso as instrucoes aparecem de 4 em 4.
    always_comb begin
        case (A)
            10'h000: RD = 32'h0f300093; // addi x1, x0, 0x0F3
            10'h004: RD = 32'h00900113; // addi x2, x0, 9
            10'h008: RD = 32'h00208133; // add  x2, x1, x2
            10'h00C: RD = 32'h0020f1b3; // and  x3, x1, x2
            10'h010: RD = 32'h0020e233; // or   x4, x1, x2
            10'h014: RD = 32'h0041a333; // slt  x6, x3, x4
            10'h018: RD = 32'h406203b3; // sub  x7, x4, x6
            default: RD = 32'h00000013; // nop = addi x0, x0, 0
        endcase
    end

endmodule

`default_nettype wire
