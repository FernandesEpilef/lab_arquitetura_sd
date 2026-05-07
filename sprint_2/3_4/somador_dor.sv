module somador_dor(
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic [3:0] C
);

    assign C = A + B;

endmodule
