`default_nettype none

module ULA (
    input  logic [31:0] SrcA,
    input  logic [31:0] SrcB,
    input  logic [2:0]  ULAControl,
    output logic [31:0] ULAResult,
    output logic        Z
);

    always_comb begin
        case (ULAControl)
            3'b000: ULAResult = SrcA + SrcB;
            3'b001: ULAResult = SrcA - SrcB;
            3'b010: ULAResult = SrcA & SrcB;
            3'b011: ULAResult = SrcA | SrcB;
            3'b101: ULAResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
            default: ULAResult = 32'b0;
        endcase
    end

    assign Z = (ULAResult == 32'b0);

endmodule

`default_nettype wire
