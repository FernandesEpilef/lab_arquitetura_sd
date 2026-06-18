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

// Fios principais do processador
logic [31:0] w_PC;
logic [31:0] w_Inst;
logic        w_RegWrite;
logic        w_ULASrc;
logic [2:0]  w_ULAControl;

// Saidas de depuracao do banco de registradores
logic [31:0] w_x0, w_x1, w_x2, w_x3;
logic [31:0] w_x4, w_x5, w_x6, w_x7;

// Instancia do processador completo.
// KEY[1] funciona como clock manual.
// KEY[0] funciona como reset ativo em nivel baixo.
ProcessorRV32_v01 CPU (
    .clk          (KEY[1]),
    .rst          (KEY[0]),
    .w_PC         (w_PC),
    .w_Inst       (w_Inst),
    .w_RegWrite   (w_RegWrite),
    .w_ULASrc     (w_ULASrc),
    .w_ULAControl (w_ULAControl),
    .x0           (w_x0),
    .x1           (w_x1),
    .x2           (w_x2),
    .x3           (w_x3),
    .x4           (w_x4),
    .x5           (w_x5),
    .x6           (w_x6),
    .x7           (w_x7)
);

// ---------------------------------------------------------------------
// LCD
// Linha superior: x0, x1, x2, x3 e PC.
// Linha inferior: x4, x5, x6 e x7.
// O LCD mostra os 8 bits menos significativos de cada valor.
// ---------------------------------------------------------------------
assign w_d0x0 = w_x0[7:0];
assign w_d0x1 = w_x1[7:0];
assign w_d0x2 = w_x2[7:0];
assign w_d0x3 = w_x3[7:0];
assign w_d0x4 = w_PC[7:0];
assign w_d0x5 = 8'h00;

assign w_d1x0 = w_x4[7:0];
assign w_d1x1 = w_x5[7:0];
assign w_d1x2 = w_x6[7:0];
assign w_d1x3 = w_x7[7:0];
assign w_d1x4 = 8'h00;
assign w_d1x5 = 8'h00;

// ---------------------------------------------------------------------
// LEDs vermelhos: sinais gerados pela Unidade de Controle.
// ---------------------------------------------------------------------
assign LEDR[4]   = w_RegWrite;
assign LEDR[3]   = w_ULASrc;
assign LEDR[2:0] = w_ULAControl;
assign LEDR[17:5] = 13'b0;

// LEDs verdes nao utilizados nesta sprint.
assign LEDG = 9'b0;

// ---------------------------------------------------------------------
// Displays de sete segmentos: codigo da instrucao atual.
// HEX7 = nibble mais significativo; HEX0 = menos significativo.
// ---------------------------------------------------------------------
Hex7Seg H0 (.hex(w_Inst[ 3: 0]), .seg(HEX0));
Hex7Seg H1 (.hex(w_Inst[ 7: 4]), .seg(HEX1));
Hex7Seg H2 (.hex(w_Inst[11: 8]), .seg(HEX2));
Hex7Seg H3 (.hex(w_Inst[15:12]), .seg(HEX3));
Hex7Seg H4 (.hex(w_Inst[19:16]), .seg(HEX4));
Hex7Seg H5 (.hex(w_Inst[23:20]), .seg(HEX5));
Hex7Seg H6 (.hex(w_Inst[27:24]), .seg(HEX6));
Hex7Seg H7 (.hex(w_Inst[31:28]), .seg(HEX7));

// Interfaces que nao sao utilizadas nesta sprint.
assign UART_TXD = 1'b1;

endmodule

`default_nettype wire
