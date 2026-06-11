module musk (
    input  logic [31:0] i0,
    input  logic [31:0] i1,
    input  logic       sel,
    
    output logic [31:0] saida
);

assign saida = (sel == 1'b0) ? i1 : i0;

endmodule