`timescale 1ns/1ps

module UC_SP6_TB;
    logic [21:0] Vetor_teste [7:0];
    logic [6:0]  OP, Funct7;
    logic [4:0]  Out_esperado;
    logic [3:0]  Cont;
    logic [2:0]  Funct3, ULAControl;
    logic        RegWrite, ULASrc;

    ControlUnit UC_rv (
        .OP(OP), .Funct7(Funct7), .Funct3(Funct3),
        .RegWrite(RegWrite), .ULASrc(ULASrc), .ULAControl(ULAControl)
    );

    initial begin
        $readmemb("test_vector.txt", Vetor_teste);
        for (Cont = 0; Cont < 8; Cont = Cont + 1'b1) begin
            {OP, Funct3, Funct7, Out_esperado} = Vetor_teste[Cont];
            #10;
            if ({RegWrite, ULASrc, ULAControl} === Out_esperado)
                $display("PASSOU Cont=%0d", Cont);
            else begin
                $display("FALHOU Cont=%0d esperado=%b obtido=%b", Cont,
                         Out_esperado, {RegWrite, ULASrc, ULAControl});
                $fatal(1);
            end
        end
        $finish;
    end
endmodule
