//
module ULA(

    input  logic [31:0] SrcA, SrcB,
    input  logic [2:0]  ULAControl,
    output logic [31:0] ULAResult,
    output logic        Z
);
    
    always_comb
        case (ULAControl)
            3'b000: begin
                ULAResult = SrcA + SrcB; // suma
            end
            3'b001: begin
                ULAResult = SrcA - SrcB; // Subtração
            end
            3'b010: begin
                ULAResult = SrcA & SrcB; // AND
            end
            3'b011: begin
                ULAResult = SrcA | SrcB; // OR
            end
            3'b101: begin
                ULAResult = (SrcA < SrcB) ? 32'd1 : 32'd0; // SLT (set less than)
            end
            default: begin
                ULAResult = 32'd0;
            end
        endcase
    
    assign Z = (ULAResult == 32'd0) ? 1 : 0;
endmodule
