module musk (
    input  logic [3:0] i0,
    input  logic [3:0] i1,
    input  logic       sel,
    
    output logic [3:0] saida
);

assign saida = sel ? i1 : i0;

endmodule