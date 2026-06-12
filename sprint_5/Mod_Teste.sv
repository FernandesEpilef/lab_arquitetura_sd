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

    //---------- Sprint 5: Register File + MuxULASrc + ULA ----------

    logic [31:0] w_rd1SrcA;
    logic [31:0] w_rd2;
    logic [31:0] w_SrcB;
    logic [31:0] w_ULAResultWd3;
    logic        w_Z;

    // Extensões dos sinais da placa para os tamanhos usados nos módulos
    logic [4:0]  w_ra1;
    logic [4:0]  w_ra2;
    logic [4:0]  w_wa3;
    logic [31:0] w_wd3;
    logic [31:0] w_const_07;

    assign w_ra1      = {2'b00, SW[13:11]};   // seleciona registrador para SrcA
    assign w_ra2      = 5'd2;                 // ra2 fixo em $2, conforme o diagrama
    assign w_wa3      = {2'b00, SW[16:14]};   // seleciona registrador de escrita
    assign w_wd3      = {24'b0, SW[7:0]};     // dado escrito no banco de registradores
    assign w_const_07 = 32'h0000_0007;        // Constant in = 8'h07

    RegisterFile RF (
        .clk (KEY[1]),        // escreve na borda de subida; na prática, ao soltar o botão
        .rst (KEY[2]),        // reset ativo em 0
        .wd3 (w_wd3),
        .wa3 (w_wa3),
        .we3 (1'b1),
        .ra1 (w_ra1),
        .ra2 (w_ra2),
        .rd1 (w_rd1SrcA),
        .rd2 (w_rd2)
    );

    // MuxULASrc usando a forma padrão/didática:
    // sel=0 -> saida=i0 -> SrcB=rd2
    // sel=1 -> saida=i1 -> SrcB=8'h07
    musk MuxULASrc (
        .i0    (w_rd2),
        .i1    (w_const_07),
        .sel   (SW[17]),
        .saida (w_SrcB)
    );

    ULA ULA_inst (
        .SrcA       (w_rd1SrcA),
        .SrcB       (w_SrcB),
        .ULAControl (SW[10:8]),
        .ULAResult  (w_ULAResultWd3),
        .Z          (w_Z)
    );

    assign LEDG = {8'b0, w_Z};

    // LCD conforme o enunciado:
    // d0x0 = rd1/SrcA, d1x0 = rd2, d1x1 = SrcB, d0x4 = ULAResult.
    // Como o LCD_TEST mostra bytes, exibimos os 8 bits menos significativos.
    assign w_d0x0 = w_rd1SrcA[7:0];
    assign w_d0x1 = 8'h00;
    assign w_d0x2 = 8'h00;
    assign w_d0x3 = 8'h00;
    assign w_d0x4 = w_ULAResultWd3[7:0];
    assign w_d0x5 = 8'h00;

    assign w_d1x0 = w_rd2[7:0];
    assign w_d1x1 = w_SrcB[7:0];
    assign w_d1x2 = 8'h00;
    assign w_d1x3 = 8'h00;
    assign w_d1x4 = 8'h00;
    assign w_d1x5 = 8'h00;

endmodule

`default_nettype wire
