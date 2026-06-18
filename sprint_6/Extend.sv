`default_nettype none

module Extend (
    input  logic [11:0] ImmIn,
    output logic [31:0] ImmOut
);

    // Repete o bit de sinal ImmIn[11] nas 20 posicoes superiores.
    always_comb begin
        ImmOut = {{20{ImmIn[11]}}, ImmIn};
    end

endmodule

`default_nettype wire
