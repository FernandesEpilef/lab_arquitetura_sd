module DataMemory(
    input  logic        clk,
    input  logic        rst,
    input  logic        we,
    input  logic [9:0]  A,
    input  logic [31:0] WD,
    output logic [31:0] RD
);

    logic [31:0] mem [0:1023];

    integer i;

    // leitura combinacional
    assign RD = mem[A];

    // escrita + reset
    always_ff @(posedge clk or negedge rst) begin

        if (!rst) begin
            for (i = 0; i < 1024; i = i + 1)
                mem[i] <= 32'b0;
        end

        else if (we) begin
            mem[A] <= WD;
        end

    end

endmodule
