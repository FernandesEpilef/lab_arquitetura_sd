//
//
//
// 


module soma_mux (
	input  logic [3:0] A,
	input  logic [3:0] B,
	input  logic [3:0] C,
	input  logic	   S, // seletor

	output logic [3:0] R // para resultado

);

	logic [3:0] mux_p_somador;

	musk musk_inst (.i0(B), .i1(C), .sel(S), .saida(mux_p_somador));

	somador_dor somaa (.A(A), .B(mux_p_somador), .C(R));

endmodule
