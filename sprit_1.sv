// aluno:
// matricula:

// --------------------------------------------
// --------------------------------------------

// questao_1: porta xor2x1

module xor_xor (
    input A,
    input B,
    
    output C
    
);

    assign C = A ^ B;
 
endmodule


// questao_3: somador 4bits

module somador_dor (
    input  [3:0] inA,
    input  [3:0] inB,
    
    output [3:0]  C
);

    assign C = inA + inB;
endmodule
