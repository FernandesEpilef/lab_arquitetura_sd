`default_nettype none

module Mod_Teste (
    // Clocks
    input  logic        CLOCK_27,
    input  logic        CLOCK_50,

    // Chaves e Botoes
    input  logic [3:0]  KEY,
    input  logic [17:0] SW,

    // Displays de 7 seg e LEDs
    output logic [0:6]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic [8:0]  LEDG,
    output logic [17:0] LEDR,

    // Serial
    output logic        UART_TXD,
    input  logic        UART_RXD,

    // LCD
    inout  wire  [7:0]  LCD_DATA,
    output logic        LCD_ON,
    output logic        LCD_BLON,
    output wire         LCD_RW,
    output wire         LCD_EN,
    output wire         LCD_RS,

    // GPIO
    inout  wire [35:0]  GPIO_0,
    inout  wire [35:0]  GPIO_1
);

    // ------------------------------------------------------------
    // Sinais não utilizados
    // ------------------------------------------------------------

    assign GPIO_0 = 36'hzzzzzzzzz;
    assign GPIO_1 = 36'hzzzzzzzzz;

    assign LCD_ON   = 1'b1;
    assign LCD_BLON = 1'b1;

    assign UART_TXD = 1'b1;

    assign HEX0 = 7'b1111111;
    assign HEX1 = 7'b1111111;
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;
    assign HEX6 = 7'b1111111;
    assign HEX7 = 7'b1111111;

    // ------------------------------------------------------------
    // Sinais internos do datapath
    // ------------------------------------------------------------

    logic        w_clk;
    logic        w_rst;

    logic [31:0] w_wd3;
    logic [4:0]  w_wa3;
    logic        w_we3;

    logic [4:0]  w_ra1;
    logic [4:0]  w_ra2;

    logic [31:0] w_rd1SrcA;
    logic [31:0] w_rd2;

    logic [31:0] w_SrcB;
    logic [31:0] w_ULAResultWd3;

    logic [2:0]  w_ULAControl;
    logic        w_Z;

    // ------------------------------------------------------------
    // Mapeamento das chaves e botões
    // ------------------------------------------------------------

    assign w_clk = KEY[1];

    /*
        Seu RegisterFile usa reset ativo baixo:
        always_ff @(posedge clk or negedge rst)

        Na DE2, KEY normalmente também é ativo baixo.
        Então:
        KEY[2] pressionado -> rst = 0 -> reset
        KEY[2] solto       -> rst = 1 -> funcionamento normal
    */
    assign w_rst = KEY[2];

    /*
        O seu RegisterFile usa endereços de 5 bits.
        Mas a Sprint usa apenas 3 chaves.

        Portanto:
        SW[13:11] = 101 vira 5'b00101 = $5
        SW[16:14] = 010 vira 5'b00010 = $2
    */
    assign w_ra1 = {2'b00, SW[13:11]};
    assign w_ra2 = 5'd2;

    assign w_wa3 = {2'b00, SW[16:14]};
    assign w_wd3 = {24'd0, SW[7:0]};
    assign w_we3 = 1'b1;

    assign w_ULAControl = SW[10:8];

    // ------------------------------------------------------------
    // Banco de registradores
    // ------------------------------------------------------------

    RegisterFile REG_FILE (
        .clk (w_clk),
        .rst (w_rst),

        .wd3 (w_wd3),
        .wa3 (w_wa3),
        .we3 (w_we3),

        .ra1 (w_ra1),
        .ra2 (w_ra2),

        .rd1 (w_rd1SrcA),
        .rd2 (w_rd2)
    );

    // ------------------------------------------------------------
    // MUX da entrada SrcB da ULA
    // ------------------------------------------------------------

    Mux2x1_32 MUX_ULASRC (
        .i0  (w_rd2),
        .i1  (32'h0000_0007),
        .sel (SW[17]),
        .y   (w_SrcB)
    );

    // ------------------------------------------------------------
    // ULA
    // ------------------------------------------------------------

    ULA ULA_INST (
        .SrcA       (w_rd1SrcA),
        .SrcB       (w_SrcB),
        .ULAControl (w_ULAControl),

        .ULAResult  (w_ULAResultWd3),
        .Z          (w_Z)
    );

    // ------------------------------------------------------------
    // LEDs
    // ------------------------------------------------------------

    assign LEDG[0]   = w_Z;
    assign LEDG[8:1] = 8'd0;

    assign LEDR = SW;

    // ------------------------------------------------------------
    // LCD
    // ------------------------------------------------------------

    logic [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5;
    logic [7:0] w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;

    /*
        O LCD_TEST mostra os valores em hexadecimal.
        Então, se w_rd1SrcA[7:0] = 8'h06, aparece "06".
    */

    assign w_d0x0 = w_rd1SrcA[7:0];       // rd1 / SrcA
    assign w_d0x1 = 8'h00;
    assign w_d0x2 = 8'h00;
    assign w_d0x3 = 8'h00;
    assign w_d0x4 = w_ULAResultWd3[7:0];  // ULAResult
    assign w_d0x5 = 8'h00;

    assign w_d1x0 = w_rd2[7:0];           // rd2
    assign w_d1x1 = w_SrcB[7:0];          // SrcB real da ULA
    assign w_d1x2 = 8'h00;
    assign w_d1x3 = 8'h00;
    assign w_d1x4 = 8'h00;
    assign w_d1x5 = 8'h00;

    LCD_TEST LCD0 (
        .iCLK   (CLOCK_50),
        .iRST_N (w_rst),

        .d0x0   (w_d0x0),
        .d0x1   (w_d0x1),
        .d0x2   (w_d0x2),
        .d0x3   (w_d0x3),
        .d0x4   (w_d0x4),
        .d0x5   (w_d0x5),

        .d1x0   (w_d1x0),
        .d1x1   (w_d1x1),
        .d1x2   (w_d1x2),
        .d1x3   (w_d1x3),
        .d1x4   (w_d1x4),
        .d1x5   (w_d1x5),

        .LCD_DATA (LCD_DATA),
        .LCD_RW   (LCD_RW),
        .LCD_EN   (LCD_EN),
        .LCD_RS   (LCD_RS)
    );

endmodule

`default_nettype wire