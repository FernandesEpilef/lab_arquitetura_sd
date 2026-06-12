module musk (
    input  logic [31:0] i0,
    input  logic [31:0] i1,
    input  logic       sel,
    output logic [31:0] saida
);

always_comb begin
   if (sel == 1'b0) begin
      saida = i0;
   end else begin
      saida = i1;
   end
end

endmodule
