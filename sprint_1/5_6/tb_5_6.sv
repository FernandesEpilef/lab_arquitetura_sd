module musk_tb;

    logic [3:0] i1, i0;
    logic       sel;
    logic [3:0] saida;

    musk dut (.i0(i0), .i1(i1), .sel(sel), .saida(saida));

    initial begin
        //$dumpfile("dump.vcd"); 
	//$dumpvars(1);
        $monitor("Tempo = %3d | Sel = %b | In0 = %d | In1 = %d | Out = %d", $time, sel, i0, i1, saida);
		

        i0 = 4'd10; 
	i1 = 4'd5;
        
	#10
        sel = 1'b0;  // Deve sair In0 (10)

        #10
	sel = 1'b1;  // Deve sair In1 (5)
        
        i0 = 4'd3; i1 = 4'd7;

	#10
        sel = 1'b0; // Deve sair In0 (3)
        sel = 1'b1; // Deve sair In1 (7)
        
        $display("Testes do MUX Concluídos");
        $finish;
    end
endmodule
