module somador;

    logic [3:0] A;
    logic [3:0] B;
    logic [3:0] C;
    
    somador_dor dut (.A(A), .B(B), .C(C));
    
    initial begin
       // $dumpfile("dump.vcd");
       // $dumpvars(1);
        
        $monitor("tempo = 3%d \ A = %d \ B = %d \ saida = %d", $time, A, B, C);
        
	A = 0;
	B = 0;

        #10
        A = 4'd2;
        B = 4'd3;
        
        #10
        A = 4'd5;
        B = 4'd5;
        
        #10
        A = 4'd15;
        B = 4'd1;
        
        $display("finichi");
        $finish;
    end
endmodule
        
        
