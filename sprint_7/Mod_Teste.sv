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

/// =========================================
// Sinais internos
// =========================================

logic [31:0] w_PC;
logic [31:0] w_Inst;

logic        w_RegWrite;
logic        w_ULASrc;
logic [2:0]  w_ULAControl;

logic [31:0] x0, x1, x2, x3;
logic [31:0] x4, x5, x6, x7;


// =========================================
// Processador
// =========================================

ProcessorRV32_v02 CPU (
    .clk          (CLOCK_50),
    .rst          (KEY[0]),

    .w_PC         (w_PC),
    .w_Inst       (w_Inst),

    .w_RegWrite   (w_RegWrite),
    .w_ULASrc     (w_ULASrc),
    .w_ULAControl (w_ULAControl),

    .x0 (x0),
    .x1 (x1),
    .x2 (x2),
    .x3 (x3),
    .x4 (x4),
    .x5 (x5),
    .x6 (x6),
    .x7 (x7)
);


// =========================================
// LEDs -> instrução atual
// =========================================

assign LEDR[17:0] = w_Inst[17:0];

assign LEDG[0] = w_RegWrite;
assign LEDG[1] = w_ULASrc;
assign LEDG[4:2] = w_ULAControl;
assign LEDG[8:5] = 4'b0000;


// =========================================
// HEX displays -> x0 até x7
// mostra apenas os 4 bits menos significativos
// =========================================

Hex7Seg H0 (.hex(x0[3:0]), .display(HEX0));
Hex7Seg H1 (.hex(x1[3:0]), .display(HEX1));
Hex7Seg H2 (.hex(x2[3:0]), .display(HEX2));
Hex7Seg H3 (.hex(x3[3:0]), .display(HEX3));
Hex7Seg H4 (.hex(x4[3:0]), .display(HEX4));
Hex7Seg H5 (.hex(x5[3:0]), .display(HEX5));
Hex7Seg H6 (.hex(x6[3:0]), .display(HEX6));
Hex7Seg H7 (.hex(x7[3:0]), .display(HEX7));


// =========================================
// LCD -> PC
// =========================================

assign w_d0x0 = w_PC[31:24];
assign w_d0x1 = w_PC[23:16];
assign w_d0x2 = w_PC[15:8];
assign w_d0x3 = w_PC[7:0];

assign w_d0x4 = 8'h50; // P
assign w_d0x5 = 8'h43; // C

// linha 2 vazia
assign w_d1x0 = 8'h20;
assign w_d1x1 = 8'h20;
assign w_d1x2 = 8'h20;
assign w_d1x3 = 8'h20;
assign w_d1x4 = 8'h20;
assign w_d1x5 = 8'h20;

endmodule
