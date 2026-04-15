// testbench da primeira sprint
// segue-se na ordem da lista


// porta xor2x1

$display("-------------- PORTA XOR ----------------");

module xor_tb;

logic sa;
logic sb;
logic saida;

inital
    begin
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
        $display("finish";
    end
    
endmodule


$display("-------------------- SOMADOR 4 BITS -------------------");


module somador_tb;

