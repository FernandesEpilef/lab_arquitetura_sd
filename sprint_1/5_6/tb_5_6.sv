module musk_tb;

    logic [3:0] i1, i0;
    logic       sel;
    logic [3:0] saida;

    musk dut (.i0(i0), .i1(i1), .sel(sel), .saida(saida));

    initial begin
        //$dumpfile("dump.vcd"); 
	//$dumpvars(1);
        $monitor("Tempo = %3d | Sel = %b | In0 = %d | In1 = %d | Out = %d", $time, sel, i0, i1, saida);
	
	i0 = 4'd7;
	i1 = 4'd3;	
        
	#10
        sel = 1'b0;  // 0 para i0

        #10
	sel = 1'b1;  // 1 para i1
        i0 = 4'd7; 
	i1 = 4'd3;
    
    	#10    
        $display("cabousse");
        $finish;
    end
endmodule
