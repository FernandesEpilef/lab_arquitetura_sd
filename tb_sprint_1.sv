// testbench da primeira sprint
// segue-se na ordem da lista


// porta xor2x1

//$display("-------------- PORTA XOR ----------------");

module xor_tb();

logic sa;
logic sb;
logic saida;

xor_xor tes(.A(sa), .B(sb), .C(saida));

initial  begin
        // para salvar em um arquivo .vdc
        $dumpfile("test_1.vdc");
        $dumpvars(1);
    
        // motinora sinais de entrada e saida
        $monitor("time=%3d, sa=%h, sb=%h, saida=%h", $time, sa,sb,saida);
    
        // gera sinais de entradas
        sa = 1'b0;
        sb = 1'b0;
    
        #10
        sa = 1'b0;
        sb = 1'b1;
    
        #10
        sa = 1'b1;
        sb = 1'b0;
    
        #10
        sa = 1'b1;
        sb = 1'b1;
    
        #10
        $display("finish");
    end
    
endmodule


//$display("-------------------- SOMADOR 4 BITS -------------------");



module somador;
    logic [3:0] InA, InB;
    logic [3:0] sainda;

    // Instância do módulo
    somador_dor dut (.InA(inA), .InB(inB), .Out(C));

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(1);
        $monitor("Tempo = %3d | InA = %d | InB = %d | Out = %d", $time, InA, InB, Out);

        // 5 cenários de soma distintos
        InA = 4'd2;  InB = 4'd3;  #10;
        InA = 4'd5;  InB = 4'd5;  #10;
        InA = 4'd10; InB = 4'd1;  #10;
        InA = 4'd15; InB = 4'd1;  #10; // Causa overflow, mas como não há Cout, resultará em 0
        InA = 4'd7;  InB = 4'd8;  #10;
        
        $display("Testes do Somador Concluídos");
        $finish;
    end
endmodule


module muxxx;
    logic [3:0] In0, In1;
    logic       Sel;
    logic [3:0] Out;

    musx dut (.In0(In0), .In1(In1), .Sel(Sel), .Out(Out));

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


module top_module_tb;
    logic [3:0] A, B, C;
    logic       S;
    logic [3:0] RES;

    top_module dut (.A(A), .B(B), .C(C), .S(S), .RES(RES));

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(1);
        $monitor("Tempo=%3d | S=%b | A=%d | B=%d | C=%d | RES=%d", $time, S, A, B, C, RES);

        // Cenário 1: A + B
        A = 4'd2; B = 4'd3; C = 4'd10; S = 1'b0; #10; 
        
        // Cenário 2: A + C
        A = 4'd2; B = 4'd3; C = 4'd10; S = 1'b1; #10; 
        
        // Cenário 3: A + B (Outros valores)
        A = 4'd5; B = 4'd5; C = 4'd1;  S = 1'b0; #10; 
        
        $display("Testes do Top Module Concluídos");
        $finish;
    end
endmodule


module ula_4bit_tb;
    logic [3:0] A, B;
    logic [1:0] Sel;
    logic [3:0] Res;
    logic       Flag_Overflow;

    ula_4bit dut (.A(A), .B(B), .Sel(Sel), .Res(Res), .Flag_Overflow(Flag_Overflow));

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(1);
        $monitor("Tempo=%3d | Sel=%b | A=%d | B=%d | Res=%d | OVF=%b", $time, Sel, A, B, Res, Flag_Overflow);

        // Teste de Soma com e sem Overflow
        Sel = 2'b00; A = 4'd5;  B = 4'd5;  #10; // 10 (Sem OVF)
        Sel = 2'b00; A = 4'd10; B = 4'd10; #10; // 20 > 15 (Com OVF)

        // Teste de Subtração com e sem Overflow
        Sel = 2'b01; A = 4'd8; B = 4'd3; #10; // 5 (Sem OVF)
        Sel = 2'b01; A = 4'd2; B = 4'd5; #10; // 2 - 5 (Com OVF)

        // Teste de Shift Right
        Sel = 2'b10; A = 4'b1100; B = 4'd1; #10; // Desloca 1 pra direita -> 0110 (6)
        Sel = 2'b10; A = 4'b1100; B = 4'd2; #10; // Desloca 2 pra direita -> 0011 (3)

        // Teste de Shift Left
        Sel = 2'b11; A = 4'b0011; B = 4'd1; #10; // Desloca 1 pra esquerda -> 0110 (6)
        Sel = 2'b11; A = 4'b0011; B = 4'd2; #10; // Desloca 2 pra esquerda -> 1100 (12)

        $display("Testes da ULA Concluídos");
        $finish;
    end
endmodule
