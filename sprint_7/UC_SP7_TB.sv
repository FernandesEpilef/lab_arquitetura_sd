// Testbench para a UC Sprint6
module UC_SP6_TB;
  
  parameter num_col_vetor_teste = 25;
  parameter num_linhas_vetor_teste = 12;
  parameter num_saidas_esperadas = 8;
 
  //Definição das variáveis
  logic [num_col_vetor_teste - 1:0] Vetor_teste [num_linhas_vetor_teste - 1:0];
  logic [num_saidas_esperadas-1:0] 	Saida_esperada;
  logic [$clog2(num_linhas_vetor_teste)-1:0] 	Cont_linhas_VT, Cont_PASSOU, Cont_FALHOU; //atualizar pra log
  logic [6:0] 	OP, Funct7;
  logic [2:0] 	Funct3, ULAControl;
  logic 		RegWrite, ImmSrc, ULASrc, MemWrite, ResultSrc;
  

  //Instância da UC
  ControlUnit UC_rv(.OP(OP), .Funct7(Funct7),.Funct3(Funct3), .RegWrite(RegWrite), .ULASrc(ULASrc), .ImmSrc(ImmSrc), .MemWrite(MemWrite), .ResultSrc(ResultSrc), .ULAControl(ULAControl));
  
  initial
    begin
      $dumpfile("test.vcd"); $dumpvars(1);
      $readmemb("test_vector.txt", Vetor_teste);
      Cont_linhas_VT = 0;
      Cont_PASSOU = 0;
      Cont_FALHOU = 0;
    end
  
  always
    begin
      {OP, Funct3, Funct7, Saida_esperada} = Vetor_teste[Cont_linhas_VT]; #10;
      if (compara_vetores ({RegWrite, ImmSrc, ULASrc, ULAControl, MemWrite, ResultSrc}, Saida_esperada))
        begin
          $display("PASSOU");
          Cont_PASSOU = Cont_PASSOU +1;
        end
      else
        begin
          $display("FALHOU");
          Cont_FALHOU = Cont_FALHOU +1;
        end
      $display("Simulado:%b_%b_%b_%b_%b_%b <> Esperado:%b <> linha: %d",RegWrite, ImmSrc, ULASrc, ULAControl, MemWrite, ResultSrc,Saida_esperada, Cont_linhas_VT);
      if (Cont_linhas_VT < num_linhas_vetor_teste - 1) 
      	Cont_linhas_VT = Cont_linhas_VT + 1'b1;
      else
        begin
          $display("********************************************************************");
          $display("**************** RESUMO >>> PASSOU: %d,  FALHOU: %d ****************", Cont_PASSOU, Cont_FALHOU);
          $display("********************************************************************");
          $finish();
        end
    end
  
  function [0:0] compara_vetores (input[num_saidas_esperadas-1:0] vetorA, vetorB);
    begin
      integer Cont_bits;
      compara_vetores = 1;
        for (Cont_bits = 0; Cont_bits < num_saidas_esperadas; Cont_bits = Cont_bits +1)
          if((vetorA[Cont_bits] === 0 && vetorB[Cont_bits] === 1) || (vetorA[Cont_bits] === 1 && vetorB[Cont_bits] === 0))
            compara_vetores = 0; //Caso algum bit seja diferente, compara_vetores = 0; c.c. compara_vetores = 1;
    end
  endfunction
  
endmodule 
