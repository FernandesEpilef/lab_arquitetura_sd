`default_nettype none //Comando para desabilitar declaração automática de wires 
module Mod_Teste ( 
//Clocks 
input   CLOCK_27, CLOCK_50, 
//Chaves e Botoes 
input  [3:0]  KEY, 
input  [17:0]  SW, 
//Displays de 7 seg e LEDs 
output  [0:6]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, 
output  [8:0]  LEDG, 
output  [17:0]  LEDR, 
//Serial 
output   UART_TXD, 
input   UART_RXD, 
inout  [7:0]  LCD_DATA, 
output   LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS, 
//GPIO 
inout  [35:0]  GPIO_0, GPIO_1 
); 
assign GPIO_1  = 36'hzzzzzzzzz; 
assign GPIO_0  = 36'hzzzzzzzzz;  
assign LCD_ON  = 1'b1; 
assign LCD_BLON  = 1'b1; 
wire  [7:0]  w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5,  
         w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5; 
LCD_TEST MyLCD (  
 .iCLK  ( CLOCK_50 ), 
 .iRST_N ( KEY[0] ), 
.d0x0(w_d0x0),.d0x1(w_d0x1),.d0x2(w_d0x2),.d0x3(w_d0x3),.d0x4(w_d0x4),.d0x5(w_d0x5), 
.d1x0(w_d1x0),.d1x1(w_d1x1),.d1x2(w_d1x2),.d1x3(w_d1x3),.d1x4(w_d1x4),.d1x5(w_d1x5), 
 .LCD_DATA( LCD_DATA ), 
 .LCD_RW  ( LCD_RW ), 
 .LCD_EN  ( LCD_EN ), 
 .LCD_RS  ( LCD_RS )   
); 

//---------- modifique a partir daqui --------

// Fio interno para guardar a saída do registrador
wire [3:0] saida_reg;

// Item 3: teste manual dos segmentos do HEX0
assign HEX0 = SW[6:0];

// Item 5: decodificador direto usando SW[11:8] no HEX3
decod_hex7seg u_decod_direto (
    .in  (SW[11:8]),
    .out (HEX3)
);

// Item 6 e 7: registrador de 4 bits + decodificador
registra_dor u_reg4 (
    .clk    (KEY[1]),
    .rst_n  (KEY[0]),
    .enable (SW[17]),
    .entra  (SW[3:0]),
    .sai    (saida_reg)
);

// Mostra a saída do registrador no HEX2
hexa u_decod_reg (
    .in  (saida_reg),
    .out (HEX2)
);

// LEDs auxiliares
assign LEDR[17:0] = SW[17:0];
assign LEDG[0] = KEY[1];
assign LEDG[4:1] = saida_reg;
assign LEDG[8:5] = 4'b0000;

// Apaga displays não usados
assign HEX1 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
assign HEX6 = 7'b1111111;
assign HEX7 = 7'b1111111;

endmodule