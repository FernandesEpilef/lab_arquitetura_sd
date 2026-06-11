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

    logic [31:0] rd1;
    logic [31:0] rd2;

    logic [31:0] wd3;
    logic [4:0]  wa3;
    logic [4:0]  ra1;
    logic [4:0]  ra2;
    logic        we3;
    logic        clk;
    logic        rst;

    // Entradas do banco de registradores vindas da FPGA
    assign clk = KEY[1];
    assign rst = KEY[2];
    assign we3 = SW[17];

    // Como o enunciado usa apenas 3 bits de endereço,
    // completamos os 5 bits com zeros.
    assign wa3 = {2'b00, SW[16:14]};
    assign ra1 = {2'b00, SW[13:11]};
    assign ra2 = {2'b00, SW[10:8]};

    // Como só temos 8 switches para dado,
    // completamos os 32 bits com zeros.
    assign wd3 = {24'b0, SW[7:0]};

    // Instância do banco de registradores
    RegisterFile RF (
        .clk(clk),
        .rst(rst),
        .wd3(wd3),
        .wa3(wa3),
        .we3(we3),
        .ra1(ra1),
        .ra2(ra2),
        .rd1(rd1),
        .rd2(rd2)
    );

    // LCD:
    // posição d0x0 recebe os 8 bits menos significativos de rd1
    // posição d0x1 recebe os 8 bits menos significativos de rd2
    assign w_d0x0 = rd1[7:0];
    assign w_d0x1 = rd2[7:0];

    // Demais posições do LCD em branco
    assign w_d0x2 = 8'h20;
    assign w_d0x3 = 8'h20;
    assign w_d0x4 = 8'h20;
    assign w_d0x5 = 8'h20;

    assign w_d1x0 = 8'h20;
    assign w_d1x1 = 8'h20;
    assign w_d1x2 = 8'h20;
    assign w_d1x3 = 8'h20;
    assign w_d1x4 = 8'h20;
    assign w_d1x5 = 8'h20;

    // HEX0 e HEX1 mostram o valor de entrada SW[7:0]
    // Exemplo: se SW[7:0] = CA, aparece C A.
    Hex7Seg H0 (.hex(SW[3:0]), .seg(HEX0));
    Hex7Seg H1 (.hex(SW[7:4]), .seg(HEX1));

    // Extras para facilitar seu teste:
    // HEX2 e HEX3 mostram rd1[7:0]
    // HEX4 e HEX5 mostram rd2[7:0]
    Hex7Seg H2 (.hex(rd1[3:0]), .seg(HEX2));
    Hex7Seg H3 (.hex(rd1[7:4]), .seg(HEX3));

    Hex7Seg H4 (.hex(rd2[3:0]), .seg(HEX4));
    Hex7Seg H5 (.hex(rd2[7:4]), .seg(HEX5));

    // HEX6 e HEX7 apagados
    assign HEX6 = 7'b1111111;
    assign HEX7 = 7'b1111111;

    // LEDs para facilitar a visualização
    // LEDR[7:0] mostra rd1[7:0]
    // LEDR[15:8] mostra rd2[7:0]
    assign LEDR[7:0]   = rd1[7:0];
    assign LEDR[15:8]  = rd2[7:0];
    assign LEDR[16]    = ~KEY[2];  // acende quando reset está pressionado
    assign LEDR[17]    = SW[17];   // mostra we3

    // LEDG[8] mostra o botão de clock pressionado
    assign LEDG[8]   = ~KEY[1];
    assign LEDG[7:1] = 7'b0;
    assign LEDG[0]   = SW[17];

endmodule


// Conversor hexadecimal para display de 7 segmentos
// Saída ativa em nível baixo, padrão comum da placa DE2.
module Hex7Seg (
    input  logic [3:0] hex,
    output logic [0:6] seg
);

    always_comb begin
        case (hex)
            4'h0: seg = 7'b0000001;
            4'h1: seg = 7'b1001111;
            4'h2: seg = 7'b0010010;
            4'h3: seg = 7'b0000110;
            4'h4: seg = 7'b1001100;
            4'h5: seg = 7'b0100100;
            4'h6: seg = 7'b0100000;
            4'h7: seg = 7'b0001111;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0000100;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b1100000;
            4'hC: seg = 7'b0110001;
            4'hD: seg = 7'b1000010;
            4'hE: seg = 7'b0110000;
            4'hF: seg = 7'b0111000;
            default: seg = 7'b1111111;
        endcase
    end

endmodule
