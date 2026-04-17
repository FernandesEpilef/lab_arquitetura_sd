
//
//
//


module ulalaa;
	logic [3:0] A, B, R;
	logic [1:0] S;
	logic	    overflor;


	ula_la dut (.A(A), .B(B), .S(S), .R(R), .overflow_(overflor));

	initial begin
		$monitor("Tempo = %d; S = %b; A = %d; B = %d; R = %d; OVER = %b", $time, S, A, B, R, overflor);


		// caso 1
		#10
		S = 2'b00;
		A = 4'd5;
		B = 4'd5;

		#10
		S = 2'b00;
		A = 4'd15;
		B = 4'd1;

		// caso 2
		#10
		S = 2'b01;
		A = 4'd8;
		B = 4'd3;

		#10
		S = 2'b01;
		A = 4'd2;
		B = 4'd5;
		
		// caso 3
		#10
		S = 2'b10;
		A = 4'b1100;
		B = 4'd1;

		#10
		S = 2'b10;
		A = 4'b1100;
		B = 4'd2;

		// caso 4
		#10
		S = 2'b11;
		A = 4'b0011;
		B = 4'd1;

		#10
		$display("finishi");
		$finish;
	end
endmodule
