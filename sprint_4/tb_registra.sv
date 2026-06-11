//
// `timescale 1ns/1ps

module tb_Register;

	logic		 clk;
	logic		 rst;
	logic [31:0] wd3;
	logic [4:0]	 wa3;
	logic		 we3;
	logic [4:0]	 ra1;
	logic [4:0]	 ra2;
	logic [31:0] rd1;
	logic [31:0] rd2;

	// invocacao
	RegisterFile reg_file (
		.clk(clk),
		.rst(rst),
		.wd3(wd3),
		.wa3(wa3),
		.we3(we3),
		.ra1(ra1),
		.ra2(ra2),
		.rd1(rd1),
		.rd2(rd2)
	);

	// clock
	initial begin
		clk = 0;
		forever #5 clk = ~clk; // Clock de 10ns (100MHz)
	end

	// testando
	initial begin
		$display("Iniciando testes");

		// valores iniciais
		rst = 1;
		wd3 = 0;
		wa3 = 0;
		we3 = 0;
		ra1 = 0;
		ra2 = 0;

		// reset
		rst = 0;
		#10;
		rst = 1;
		#10;

		// verifica se x0
		ra1 = 5'd0;
		#1;

		if (rd1 == 32'h00000000) begin
			$display("Teste 1: $zero correto");
		end else begin
			$display("Teste 1: $zero incorreto, rd1 = %h", rd1);
		end

		// escreve 000000CA em x1
		we3 = 1;
		wa3 = 5'd1;
		wd3 = 32'h000000CA;
		#10;
		we3 = 0;

		// lê x1
		ra1 = 5'd1;
		#1;

		if (rd1 == 32'h000000CA) begin
			$display("x1 recebeu!");
		end else begin
			$display("lascou, mas deu, rd1 = %h", rd1);
		end

		// escreve 000000FE em x7
		we3 = 1;
		wa3 = 5'd7;;
		wd3 = 32'h000000FE;
		#10;
		we3 = 0;

		// lê x7
		ra1 = 5'd7;
		#1

		if (rd1 == 32'h000000FE) begin
			$display("x7 recebeu!");
		end else begin
			$display("lascou, mas deu, rd1 = %h", rd1);
		end

		// escreve 000000DB em x0

		we3 = 1;
		wa3 = 5'd
		wd3 = 32'h000000DB;
		#10;
		we3 = 0;

		// le x0
		ra1 = 5'd0;
		#1;

		if (rd1 == 32'h00000000) begin
			$display("x0 não recebeu, correto!");
		end else begin
			$display("x0 recebeu, incorreto, rd1 = %h", rd1);
		end
	
	// rd1 ler x1 e rd2 ler x7
		ra1 = 5'd1;
		ra2 = 5'd7;
		#1;

		if (rd1 == 32'h000000CA && rd2 == 32'h000000FE) begin
			$display("rd1 e rd2 leram certo!");
		end else begin
			$display("error, rd1 = %h, rd2 = %h", rd1, rd2);
		end
	end

	// reset
	rst = 0;
	#10;
	rst = 1;
	#10;

	ra1 = 5'd1;
	ra2 = 5'd7;
	#1;

	if (rd1 == 32'h00000000 && rd2 == 32'h00000000) begin
		$display("resetou tudo, correto!");
	end else begin
		$display("resetou nada, incorreto, rd1 = %h, rd2 = %h", rd1, rd2);
	end

	$finish;

endmodule
