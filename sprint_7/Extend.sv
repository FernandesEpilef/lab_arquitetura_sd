
module Extend (
    input  wire         ImmSrc,
    input  wire  [31:0] Inst,
    output logic [31:0] ImmOut
);

    logic [11:0] ImmIn;

    always_comb begin

        // =========================================
        // Seleciona tipo do imediato
        // =========================================

        case (ImmSrc)

            // Tipo I
            1'b0: begin
                ImmIn = Inst[31:20];
            end

            // Tipo S
            1'b1: begin
                ImmIn = {Inst[31:25], Inst[11:7]};
            end

            default: begin
                ImmIn = 12'b0;
            end

        endcase

        // =========================================
        // Extensão de sinal
        // =========================================

        ImmOut = {{20{ImmIn[11]}}, ImmIn};

    end

endmodule
