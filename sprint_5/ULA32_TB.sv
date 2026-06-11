// Testbench para a ULA
module ULA_TB;
  
  //Definição das variáveis
  logic [31:0] w_SrcA, w_SrcB, w_ULAResult, w_ULAResult_esperado;
  logic [2:0] w_ULAControl;
  logic w_Zero, w_Zero_esperado;
  
  //Instância da ULA
  ULA RiscvULA( .SrcA(w_SrcA), .SrcB(w_SrcB), .ULAControl(w_ULAControl), .ULAResult(w_ULAResult), .Zero(w_Zero));

  initial
    begin
      $dumpfile("test.vcd"); $dumpvars(1);
      // ********** Atribuição das entradas SrcA = 6 e SrcB = 3 **********
      w_SrcA = 32'h06; 			w_SrcB = 32'h03; 
      
      // Operação de SOMA
      w_ULAControl = 3'b000; 	w_ULAResult_esperado = 32'h09;	w_Zero_esperado = 0;
      mostrar;
      // Operação de SUBTRAÇÃO
      w_ULAControl = 3'b001; 	w_ULAResult_esperado = 32'h03;	w_Zero_esperado = 0;
      mostrar;
      // Operação AND
      w_ULAControl = 3'b010; 	w_ULAResult_esperado = 32'h02;	w_Zero_esperado = 0;
      mostrar;
      // Operação OR
      w_ULAControl = 3'b011; 	w_ULAResult_esperado = 32'h07;	w_Zero_esperado = 0;
      mostrar;
      // Operação SLT
      w_ULAControl = 3'b101; 	w_ULAResult_esperado = 32'h00;	w_Zero_esperado = 1;
      mostrar;
      
      // ********** Atribuição das entradas SrcA = 6 e SrcB = 7 **********
      w_SrcA = 32'h06; 			w_SrcB = 32'h07; 
      
      // Operação de SOMA
      w_ULAControl = 3'b000; 	w_ULAResult_esperado = 32'h0D;	w_Zero_esperado = 0;
      mostrar;
      // Operação de SUBTRAÇÃO
      w_ULAControl = 3'b001; 	w_ULAResult_esperado = 32'hFFFFFFFF; w_Zero_esperado = 0;
      mostrar;
      // Operação AND
      w_ULAControl = 3'b010; 	w_ULAResult_esperado = 32'h06;	w_Zero_esperado = 0;
      mostrar;
      // Operação OR
      w_ULAControl = 3'b011; 	w_ULAResult_esperado = 32'h07;	w_Zero_esperado = 0;
      mostrar;
      // Operação SLT
      w_ULAControl = 3'b101; 	w_ULAResult_esperado = 32'h01;	w_Zero_esperado = 0;
      mostrar;
      #10;
      
      $finish();
    end
  
  task mostrar;
    #10
    if (w_ULAResult == w_ULAResult_esperado)
        if (w_Zero == w_Zero_esperado)
          	$display("PASSOU, Res %h == %h, Z%h == %h", w_ULAResult, w_ULAResult_esperado, w_Zero, w_Zero_esperado);
        else
          	$display("FALHOU, Res %h == %h, Z%h != %h", w_ULAResult, w_ULAResult_esperado, w_Zero, w_Zero_esperado);
    else
        if (w_Zero == w_Zero_esperado)
            $display("FALHOU, Res %h != %h, Z%h == %h", w_ULAResult, w_ULAResult_esperado, w_Zero, w_Zero_esperado);
        else
          	$display("FALHOU, Res %h != %h, Z%h != %h", w_ULAResult, w_ULAResult_esperado, w_Zero, w_Zero_esperado);
  endtask

endmodule 