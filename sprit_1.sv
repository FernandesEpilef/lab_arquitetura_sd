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


// questoes  5 e 6

module musx (
    input  logic [3:0] In0,
    input  logic [3:0] In1,
    input  logic       Sel,
    output logic [3:0] Out
);
    assign Out = Sel ? In1 : In0;
endmodule


module top_module (
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic [3:0] C,
    input  logic       S,
    output logic [3:0] RES
);
    // Fio interno conectando a saída do MUX à entrada InB do Somador
    logic [3:0] mux_to_adder;

    // Instanciando o MUX
    // In0 recebe B, In1 recebe C. A seleção é S.
    mux2x1_4bit mux_inst (
        .In0(B),
        .In1(C),
        .Sel(S),
        .Out(mux_to_adder)
    );

    // Instanciando o Somador
    // InA recebe A, InB recebe a saída do MUX.
    adder_4bit adder_inst (
        .InA(A),
        .InB(mux_to_adder),
        .Out(RES)
    );
endmodule


module ula_4bit (
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic [1:0] Sel,
    output logic [3:0] Res,
    output logic       Flag_Overflow
);
    logic [4:0] calc_temp; // 5 bits para capturar o carry-out da soma

    always_comb begin
        // Valores padrão
        Res = 4'b0000;
        Flag_Overflow = 1'b0;

        case (Sel)
            2'b00: begin // Soma
                calc_temp = A + B;
                Res = calc_temp[3:0];
                Flag_Overflow = calc_temp[4]; // Bit mais significativo indica overflow
            end
            2'b01: begin // Subtração
                Res = A - B;
                Flag_Overflow = (A < B); // Se A < B, a subtração unsigned resulta em erro (borrow out)
            end
            2'b10: begin // Deslocamento para a direita
                Res = A >> B;
            end
            2'b11: begin // Deslocamento para a esquerda
                Res = A << B;
            end
        endcase
    end
endmodule

