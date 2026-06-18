`default_nettype none

module Mod_Teste (
    // Clocks da placa
    input  wire        CLOCK_27,
    input  wire        CLOCK_50,

    // Chaves e botoes
    input  wire [3:0]  KEY,
    input  wire [17:0] SW,

    // Displays de 7 segmentos e LEDs
    output wire [0:6]  HEX0,
    output wire [0:6]  HEX1,
    output wire [0:6]  HEX2,
    output wire [0:6]  HEX3,
    output wire [0:6]  HEX4,
    output wire [0:6]  HEX5,
    output wire [0:6]  HEX6,
    output wire [0:6]  HEX7,
    output wire [8:0]  LEDG,
    output wire [17:0] LEDR,

    // Serial
    output wire        UART_TXD,
    input  wire        UART_RXD,

    // LCD
    inout  wire [7:0]  LCD_DATA,
    output wire        LCD_ON,
    output wire        LCD_BLON,
    output wire        LCD_RW,
    output wire        LCD_EN,
    output wire        LCD_RS,

    // GPIO
    inout  wire [35:0] GPIO_0,
    inout  wire [35:0] GPIO_1
);

    // -----------------------------------------------------------------
    // Sinais internos do processador
    // -----------------------------------------------------------------
    logic [31:0] w_PC;
    logic [31:0] w_Inst;
    logic        w_RegWrite;
    logic        w_ULASrc;
    logic [2:0]  w_ULAControl;

    logic [31:0] w_x0, w_x1, w_x2, w_x3;
    logic [31:0] w_x4, w_x5, w_x6, w_x7;

    // Cada entrada do LCD representa um valor hexadecimal de 8 bits.
    logic [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5;
    logic [7:0] w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;

    // -----------------------------------------------------------------
    // Ligacoes fixas da placa
    // -----------------------------------------------------------------
    assign GPIO_0  = 36'hzzzzzzzzz;
    assign GPIO_1  = 36'hzzzzzzzzz;
    assign LCD_ON  = 1'b1;
    assign LCD_BLON = 1'b1;

    // UART nao utilizada: mantem a transmissao em repouso.
    assign UART_TXD = 1'b1;

    // LEDs verdes e LEDs vermelhos nao utilizados ficam apagados.
    assign LEDG       = 9'b0;
    assign LEDR[17:5] = 13'b0;

    // Ordem solicitada no enunciado:
    // LEDR[4]   = RegWrite
    // LEDR[3]   = ULASrc
    // LEDR[2:0] = ULAControl
    assign LEDR[4:0] = {w_RegWrite, w_ULASrc, w_ULAControl};

    // -----------------------------------------------------------------
    // Processador RISC-V v0.1
    // -----------------------------------------------------------------
    // Os botoes da DE2 sao ativos em zero.
    // KEY[2]: reset. Pressionado -> rst=0.
    // KEY[1]: clock manual. A instrucao e concluida ao soltar o botao,
    //         pois nesse momento ocorre a borda de subida 0 -> 1.
    ProcessorRV32_v01 CPU (
        .clk          (KEY[1]),
        .rst          (KEY[2]),
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

    // -----------------------------------------------------------------
    // LCD: primeira linha = x0, x1, x2, x3 e PC
    //      segunda linha  = x4, x5, x6 e x7
    // Apenas os 8 bits menos significativos cabem em cada campo.
    // -----------------------------------------------------------------
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

    LCD_TEST MyLCD (
        .iCLK     (CLOCK_50),
        .iRST_N   (KEY[0]),
        .d0x0(w_d0x0), .d0x1(w_d0x1), .d0x2(w_d0x2),
        .d0x3(w_d0x3), .d0x4(w_d0x4), .d0x5(w_d0x5),
        .d1x0(w_d1x0), .d1x1(w_d1x1), .d1x2(w_d1x2),
        .d1x3(w_d1x3), .d1x4(w_d1x4), .d1x5(w_d1x5),
        .LCD_DATA (LCD_DATA),
        .LCD_RW   (LCD_RW),
        .LCD_EN   (LCD_EN),
        .LCD_RS   (LCD_RS)
    );

    // -----------------------------------------------------------------
    // Displays HEX: mostram a instrucao atual completa em hexadecimal.
    // HEX7 mostra o nibble mais significativo; HEX0, o menos significativo.
    // -----------------------------------------------------------------
    Hex7Seg H0 (.hex(w_Inst[ 3: 0]), .seg(HEX0));
    Hex7Seg H1 (.hex(w_Inst[ 7: 4]), .seg(HEX1));
    Hex7Seg H2 (.hex(w_Inst[11: 8]), .seg(HEX2));
    Hex7Seg H3 (.hex(w_Inst[15:12]), .seg(HEX3));
    Hex7Seg H4 (.hex(w_Inst[19:16]), .seg(HEX4));
    Hex7Seg H5 (.hex(w_Inst[23:20]), .seg(HEX5));
    Hex7Seg H6 (.hex(w_Inst[27:24]), .seg(HEX6));
    Hex7Seg H7 (.hex(w_Inst[31:28]), .seg(HEX7));

    // CLOCK_27, SW e UART_RXD nao sao utilizados nesta sprint.

endmodule

`default_nettype wire
