

module tb_soma_mux_reg;

    logic clk;
    logic rst_n;
    logic enable;
    logic S;
    logic [3:0] A, B, C;
    logic [3:0] R;

    // Instância do DUT
    soma_mux_reg dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .S(S),
        .A(A),
        .B(B),
        .C(C),
        .R(R)
    );

    // Geração do clock
    always #5 clk = ~clk;

    initial begin

        //$dumpfile("tb_soma_mux_reg.vcd");
        //$dumpvars(0, tb_soma_mux_reg);

        $monitor(
            "Tempo=%0t | rst_n=%b | enable=%b | S=%b | A=%d | B=%d | C=%d | R=%d",
            $time, rst_n, enable, S, A, B, C, R
        );

        // Valores iniciais
        clk    = 0;
        rst_n  = 0;
        enable = 0;
        S      = 0;
        A      = 0;
        B      = 0;
        C      = 0;

        // =====================================================
        // RESET
        // =====================================================
        #10;
        rst_n = 1;

        // =====================================================
        // S = 0 -> escolhe B
        // R = A + B = 3 + 2 = 5
        // =====================================================
        #10;
        enable = 1;
        S = 0;

        A = 4'd3;
        B = 4'd2;
        C = 4'd9;

        // =====================================================
        // S = 1 -> escolhe C
        // R = A + C = 4 + 6 = 10
        // =====================================================
        #10;
        S = 1;

        A = 4'd4;
        B = 4'd1;
        C = 4'd6;

        // =====================================================
        // Overflow de 4 bits
        // F + 1 = 0
        // =====================================================
        #10;
        S = 0;

        A = 4'hF;
        B = 4'h1;
        C = 4'h0;

        // =====================================================
        // enable = 0 -> mantém valor anterior
        // =====================================================
        #10;
        enable = 0;

        A = 4'd1;
        B = 4'd1;
        C = 4'd1;

        // =====================================================
        // Finalização
        // =====================================================
        #10;
        $display("cabousse");
        $finish;

    end

endmodule