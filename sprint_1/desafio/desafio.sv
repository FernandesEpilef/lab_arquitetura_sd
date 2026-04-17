
///
//
//
//

module ula_la (
	input  logic [3:0] A,
	input  logic [3:0] B,
	input  logic [1:0] S, // seletor

	output logic [3:0] R, // resultado
	output logic	   overflow_
);

	logic [4:0] temp_calc; //capturar o carry-out da soma

	always_comb begin
		R = 4'b0000;
		overflow_ = 1'b0;

		case (S)
			2'b00: begin
				temp_calc = A + B;
				R = temp_calc[3:0];
				overflow_ = temp_calc[4];
			end
			
			2'b01: begin
				R = A - B;
				overflow_ = (A < B);
			end

			2'b10: begin
				R = A >> B;
			end

			2'b11: begin
				R = A << B;
			end
		endcase
	end
endmodule
