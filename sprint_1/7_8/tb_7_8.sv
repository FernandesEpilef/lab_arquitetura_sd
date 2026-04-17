

//
//
//


module jucao_tb;

	logic [3:0] A, B, C;
	logic       S;
	logic [3:0] R;


	soma_mux dut (.A(A), .B(B), .C(C), .S(S), .R(R));

	initial begin
		$monitor("Tempo = %d; S = %d; A = %d; B = %d; C = %d; R = %d", $time, S, A, B, C, R);

		A = 0;
		B = 0;
		C = 0;
		S = 1'b0;

		#10
		A = 0;
		B = 0;
		C = 0;
		S = 1'b1;


		// caso 1
		#10
		A = 4'd2;
		B = 4'd3;
		C = 4'd10;
		S = 1'b0;

		// caso 2
		#10
		A = 4'd2;
		B = 4'd3;
		C = 4'd10;
		S = 1'b1;

		// caso 3
		#10
		A = 4'd2;
		B = 4'd5;
		C = 4'd1;
		S = 1'b0;

		#10
		$display("finishi");
		$finish;
	end
endmodule
