
module InstructionMemory #(
    parameter int ADDR_WIDTH = 10
) (
    input  wire  [ADDR_WIDTH-1:0] A,
    output logic [31:0]           RD
);

    // A é endereço em bytes.
    // As instruções ficam espaçadas de 4 em 4.

    always_comb begin

        case (A)

            // =========================================
            // TESTES ANTIGOS (SPRINT 6)
            // =========================================

            10'h000: RD = 32'h0f300093; // addi x1, x0, 0x0F3
            10'h004: RD = 32'h00900113; // addi x2, x0, 9
            10'h008: RD = 32'h00208133; // add  x2, x1, x2
            10'h00C: RD = 32'h0020f1b3; // and  x3, x1, x2
            10'h010: RD = 32'h0020e233; // or   x4, x1, x2
            10'h014: RD = 32'h0041a333; // slt  x6, x3, x4
            10'h018: RD = 32'h406203b3; // sub  x7, x4, x6


            // =========================================
            // TESTES NOVOS (SPRINT 7)
            // =========================================

            // addi x1, x0, 0xAB
            10'h01C: RD = 32'h0AB00093;
            // sw x1, 0xA(x0)
            10'h020: RD = 32'h00102523;
            // lw x2, 0xA(x0)
            10'h024: RD = 32'h00A02103;
            // sw x2, 0xB(x0)
            10'h028: RD = 32'h002025A3;
            // lw x3, 0xB(x0)
            10'h02C: RD = 32'h00B02183;
            // sw x3, 0xC(x0)
            10'h030: RD = 32'h00302623;
            // lw x4, 0xC(x0)
            10'h034: RD = 32'h00C02203;
            
            default: RD = 32'h00000013; // nop

        endcase

    end

endmodule
