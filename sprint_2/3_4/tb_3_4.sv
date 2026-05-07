`timescale 1ns/1ps

module tb_soma_mux_reg;

    logic clk;
    logic rst_n;
    logic enable;
    logic S;
    logic [3:0] A, B, C;
    logic [3:0] R;

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

    always #5 clk = ~clk;

    task check(input [3:0] esperado, input string msg);
        if (R !== esperado)
            $display("[ERRO] %s | esperado=%0h obtido=%0h", msg, esperado, R);
        else
            $display("[OK]   %s | R=%0h", msg, R);
    endtask

    initial begin
        //$dumpfile("tb_soma_mux_reg.vcd");
        //$dumpvars(0, tb_soma_mux_reg);

        clk = 0;
        rst_n = 0;
        enable = 0;
        S = 0;
        A = 0;
        B = 0;
        C = 0;

        #3 check(4'h0, "reset inicial");
        #7 rst_n = 1;

        // S=0: MUX escolhe B. Resultado registrado deve ser A+B.
        A = 4'h3;
        B = 4'h2;
        C = 4'h9;
        S = 0;
        enable = 1;
        @(posedge clk); #1;
        check(4'h5, "S=0 seleciona B: 3+2=5");

        // S=1: MUX escolhe C. Resultado registrado deve ser A+C.
        A = 4'h4;
        B = 4'h1;
        C = 4'h6;
        S = 1;
        @(posedge clk); #1;
        check(4'hA, "S=1 seleciona C: 4+6=A");

        // Overflow natural de 4 bits: F + 1 = 0, pois o somador tem saída de 4 bits.
        A = 4'hF;
        B = 4'h1;
        C = 4'h0;
        S = 0;
        @(posedge clk); #1;
        check(4'h0, "soma em 4 bits: F+1=0");

        // enable=0: mantém valor anterior.
        enable = 0;
        A = 4'h1;
        B = 4'h1;
        S = 0;
        @(posedge clk); #1;
        check(4'h0, "enable=0 mantém resultado anterior");

        $display("finish");
        $finish;
    end

endmodule
