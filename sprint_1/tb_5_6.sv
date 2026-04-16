module musk;

    logic [3:0] i1, 10;
    logic       sel;
    logic [3:0] saida;

    musk dut (.i0(i0), .i1(i1), .sel(sel), .saida(saida));

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(1);
        $monitor("Tempo = %3d | Sel = %b | In0 = %d | In1 = %d | Out = %d", $time, Sel, In0, In1, Out);

        In0 = 4'd10; In1 = 4'd5;
        
        Sel = 1'b0; #10; // Deve sair In0 (10)
        Sel = 1'b1; #10; // Deve sair In1 (5)
        
        In0 = 4'd3; In1 = 4'd7;
        Sel = 1'b0; #10; // Deve sair In0 (3)
        Sel = 1'b1; #10; // Deve sair In1 (7)
        
        $display("Testes do MUX Concluídos");
        $finish;
    end
endmodule