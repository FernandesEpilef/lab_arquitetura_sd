`timescale 1ps/1ns

module tb_contador_simple_man;

    // clk e rst
    reg clk = 0;
    reg rst = 0;

    always #5 clk = ~clk; // gogo inverte a cada 5ns


    //wb invocamentos
    reg [31:0] wb_adr_i;
    reg [31:0] wb_dat_i;
    reg [3:0]  wb_sel_i;  // select do wb. quais bytes valem? (1111 for 32 bits)
    reg        wb_we_i;   // 1 = iscreve, 0 = ler
    reg        wb_stb_i;  // strobe
    reg        wb_cyc_i;  // cycle

    wire [31:0] wb_dat_o; // datos lidos do timer
    wire        wb_ack_o; // acknowledge (valida o recebimento)

    // interupcion

  //  wire       irq;         // não sera usado agr mas existe
   // wire       pwm0, pwm1;  // """"""""""""""""""""""""""""' 

    //duts

    EF_TMR32 dut (
        .clk(clk),
        .rst(rst),

        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_we_i(wb_we_i),
        .wb_stb_i(wb_stb_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_sel_i(wb_sel_i),

        .wb_dat_o(wb_dat_o),
        .wb_ack_o(wb_ack_o)
        //.irq(irq)
        //.pwm0(pwm0),
        //.pwm1(pwm1),
        //.pwm_fault(1'b0)
    );

    initial begin

        // começando com zero tudo
        wb_cyc_i = 0;
        wb_stb_i = 0;
        wb_we_i  = 0;
        wb_sel_i = 0;
        wb_adr_i = 0;
        wb_dat_i = 0;

        rst = 1;
        #50; // ispeera 50ns
        rst = 0; // no reset
        #20; // ispera 20ns pra isperar um tico

        $display("alvo teto sendo inserido (RELOAD");

        @(posedge clk);
        wb_adr_i = 32'h0000_0004; // endereço do reload
        wb_dat_i = 32'd100; // valor do reload
        wb_sel_i = 4'b1111; // habilita todos os bitis inteiros
        wb_we_i = 1; // avisa que é iscrita
        wb_stb_i = 1; // aqui
        wb_cyc_i = 1; // aqui^2 é o handshake do wb. tem que os dois ser 1

        wait(wb_ack_o == 1); // espera valida que foi lido/recebido o solicitamento

        @(posedge clk);
        wb_cyc_i = 0; // desabilita o handshake
        wb_stb_i = 0; // desabilita o handshake
        wb_we_i  = 0; // so leia

        $display("papocando o timer via o registra_dor CTRL");

        @(posedge clk);
        wb_adr_i = 32'h0000_0014; // endereço do CTRL
        wb_dat_i = 32'h0000_0001; // habilita o timer
        wb_sel_i = 4'b1111; // habilita todos os bitis inteiros
        wb_we_i = 1; // avisa que é iscrita
        wb_stb_i = 1; // aqui
        wb_cyc_i = 1; // aqui^2 é o handshake do wb. tem que os dois ser 1

        wait(wb_ack_o == 1); // espera valida que foi lido/recebido o solicitamento

        @(posedge clk);
        wb_cyc_i = 0; // desabilita o handshake
        wb_stb_i = 0; // desabilita o handshake
        wb_we_i  = 0; // so leia

        #100; // ispere 100ns. the timer estar rodano

        $display("oia la o valor atual no cabra");

        wb_adr_i = 32'h0000_0000; // endereço do valor atual
        wb_sel_i = 4'b1111; // habilita todos os bitis inteiros
        wb_we_i = 0; // ser intelectual na leitura
        wb_stb_i = 1; // aqui
        wb_cyc_i = 1; // aqui^2 é o handshake do wb. tem que os dois ser 1

        wait(wb_ack_o == 1); // espera valida que foi lido/recebido o solicitamento

        @(posedge clk);
        $display("valor lido: %0d", wb_dat_o); // imprime resposta

        wb_cyc_i = 0; // desabilita o handshake
        wb_stb_i = 0; // desabilita o handshake

        $display("finishi");
        $finish;
    end

endmodule
