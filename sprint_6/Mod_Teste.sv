`default_nettype none //Comando para desabilitar declaração automática de wires
module Mod_Teste (
//Clocks
input CLOCK_27, CLOCK_50,
//Chaves e Botoes
input [3:0] KEY,
input [17:0] SW,
//Displays de 7 seg e LEDs
output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
output [8:0] LEDG,
output [17:0] LEDR,
//Serial
output UART_TXD,
input UART_RXD,
inout [7:0] LCD_DATA,
output LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
//GPIO
inout [35:0] GPIO_0, GPIO_1
);
assign GPIO_1 = 36'hzzzzzzzzz;
assign GPIO_0 = 36'hzzzzzzzzz;
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;
logic [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5,
w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;
LCD_TEST MyLCD (
.iCLK ( CLOCK_50 ),
.iRST_N ( KEY[0] ),
.d0x0(w_d0x0),.d0x1(w_d0x1),.d0x2(w_d0x2),.d0x3(w_d0x3),.d0x4(w_d0x4),.d0x5(w_d0x5),
.d1x0(w_d1x0),.d1x1(w_d1x1),.d1x2(w_d1x2),.d1x3(w_d1x3),.d1x4(w_d1x4),.d1x5(w_d1x5),
.LCD_DATA( LCD_DATA ),
.LCD_RW ( LCD_RW ),
.LCD_EN ( LCD_EN ),
.LCD_RS ( LCD_RS )
);
//---------- modifique a partir daqui --------

// =====================================================================
// 1. FIOS INTERNOS DO PROCESSADOR
// =====================================================================

// Sinais produzidos pela Unidade de Controle.
logic        w_ULASrc;
logic        w_RegWrite;
logic [2:0]  w_ULAControl;

// Sinais relacionados ao Program Counter e a instrucao.
logic [31:0] w_PC;
logic [31:0] w_PCp4;
logic [31:0] w_Inst;

// Sinais do banco de registradores, imediato, MUX e ULA.
logic [31:0] w_rd1SrcA;
logic [31:0] w_rd2;
logic [31:0] w_Imm;
logic [31:0] w_SrcB;
logic [31:0] w_ULAResult;
logic        w_Zero;

// Saidas auxiliares do banco de registradores para o LCD.
logic [31:0] w_x0, w_x1, w_x2, w_x3;
logic [31:0] w_x4, w_x5, w_x6, w_x7;

// =====================================================================
// 2. PROGRAM COUNTER E SOMADOR PC + 4
// =====================================================================

// Como cada instrucao ocupa 4 bytes, o endereco seguinte e PC + 4.
assign w_PCp4 = w_PC + 32'd4;

// KEY[1] funciona como clock manual.
// KEY[2] funciona como reset ativo em nivel baixo.
ProgramCounter PC_rv (
    .clk  (KEY[1]),
    .rst  (KEY[2]),
    .PCin (w_PCp4),
    .PC   (w_PC)
);

// =====================================================================
// 3. MEMORIA DE INSTRUCOES
// =====================================================================

// O PC fornece o endereco e a memoria entrega a instrucao de 32 bits.
// Sao usados os 10 bits menos significativos porque a memoria foi
// configurada com largura de endereco igual a 10.
InstructionMemory #(.ADDR_WIDTH(10)) Memoria_Instrucoes (
    .A  (w_PC[9:0]),
    .RD (w_Inst)
);

// =====================================================================
// 4. UNIDADE DE CONTROLE
// =====================================================================

// A Unidade de Controle separa os campos da instrucao e gera os sinais
// que controlam a escrita no banco, o MUX e a operacao da ULA.
ControlUnit Unidade_Controle (
    .OP         (w_Inst[6:0]),
    .Funct3     (w_Inst[14:12]),
    .Funct7     (w_Inst[31:25]),
    .RegWrite   (w_RegWrite),
    .ULASrc     (w_ULASrc),
    .ULAControl (w_ULAControl)
);

// =====================================================================
// 5. EXTENSOR DE SINAL
// =====================================================================

// Nas instrucoes do tipo I, w_Inst[31:20] contem o imediato de 12 bits.
// O extensor transforma esse valor em uma palavra de 32 bits.
Extend Extensor_de_Sinal (
    .ImmIn  (w_Inst[31:20]),
    .ImmOut (w_Imm)
);

// =====================================================================
// 6. BANCO DE REGISTRADORES
// =====================================================================

RegisterFile Banco_de_Registradores (
    .clk (KEY[1]),
    .rst (KEY[2]),

    // Porta de escrita: rd recebe o resultado calculado pela ULA.
    .wd3 (w_ULAResult),
    .wa3 (w_Inst[11:7]),
    .we3 (w_RegWrite),

    // Portas de leitura: rs1 e rs2 vem da instrucao atual.
    .ra1 (w_Inst[19:15]),
    .ra2 (w_Inst[24:20]),
    .rd1 (w_rd1SrcA),
    .rd2 (w_rd2),

    // Saidas exclusivas para depuracao no LCD.
    .x0(w_x0), .x1(w_x1), .x2(w_x2), .x3(w_x3),
    .x4(w_x4), .x5(w_x5), .x6(w_x6), .x7(w_x7)
);

// =====================================================================
// 7. MULTIPLEXADOR DA ENTRADA B DA ULA
// =====================================================================

// Para instrucoes do tipo R, ULASrc=0 e a ULA recebe o valor de rs2.
// Para ADDI, ULASrc=1 e a ULA recebe o imediato estendido.
assign w_SrcB = (w_ULASrc == 1'b0) ? w_rd2 : w_Imm;

// =====================================================================
// 8. ULA
// =====================================================================

ULA ULA_rv (
    .SrcA       (w_rd1SrcA),
    .SrcB       (w_SrcB),
    .ULAControl (w_ULAControl),
    .ULAResult  (w_ULAResult),
    .Z          (w_Zero)
);

// =====================================================================
// 9. INFORMACOES MOSTRADAS NO LCD
// =====================================================================

// O LCD fornecido mostra somente dois digitos hexadecimais por posicao.
// Por isso sao usados os 8 bits menos significativos dos registradores.
//
// Primeira linha: x0, x1, x2, x3 e PC.
assign w_d0x0 = w_x0[7:0];
assign w_d0x1 = w_x1[7:0];
assign w_d0x2 = w_x2[7:0];
assign w_d0x3 = w_x3[7:0];
assign w_d0x4 = w_PC[7:0];
assign w_d0x5 = 8'h00;

// Segunda linha: x4, x5, x6 e x7.
assign w_d1x0 = w_x4[7:0];
assign w_d1x1 = w_x5[7:0];
assign w_d1x2 = w_x6[7:0];
assign w_d1x3 = w_x7[7:0];
assign w_d1x4 = 8'h00;
assign w_d1x5 = 8'h00;

// =====================================================================
// 10. INSTRUCAO ATUAL NOS DISPLAYS HEX0 A HEX7
// =====================================================================

// HEX0 mostra os 4 bits menos significativos da instrucao.
// HEX7 mostra os 4 bits mais significativos da instrucao.
Hex7Seg Display0 (.hex(w_Inst[ 3: 0]), .seg(HEX0));
Hex7Seg Display1 (.hex(w_Inst[ 7: 4]), .seg(HEX1));
Hex7Seg Display2 (.hex(w_Inst[11: 8]), .seg(HEX2));
Hex7Seg Display3 (.hex(w_Inst[15:12]), .seg(HEX3));
Hex7Seg Display4 (.hex(w_Inst[19:16]), .seg(HEX4));
Hex7Seg Display5 (.hex(w_Inst[23:20]), .seg(HEX5));
Hex7Seg Display6 (.hex(w_Inst[27:24]), .seg(HEX6));
Hex7Seg Display7 (.hex(w_Inst[31:28]), .seg(HEX7));

// =====================================================================
// 11. SINAIS DE CONTROLE NOS LEDS VERMELHOS
// =====================================================================

// LEDR[4]   = RegWrite
// LEDR[3]   = ULASrc
// LEDR[2:0] = ULAControl
assign LEDR[4:0]  = {w_RegWrite, w_ULASrc, w_ULAControl};
assign LEDR[17:5] = 13'b0;

// Saidas que nao sao utilizadas nesta sprint recebem valores definidos.
assign LEDG     = 9'b0;
assign UART_TXD = 1'b1;

endmodule

`default_nettype wire
