`default_nettype none

module ProcessorRV32_v01 (
    input  logic        clk,
    input  logic        rst,
    output logic [31:0] w_PC,
    output logic [31:0] w_Inst,
    output logic        w_RegWrite,
    output logic        w_ULASrc,
    output logic [2:0]  w_ULAControl,
    output logic [31:0] x0,
    output logic [31:0] x1,
    output logic [31:0] x2,
    output logic [31:0] x3,
    output logic [31:0] x4,
    output logic [31:0] x5,
    output logic [31:0] x6,
    output logic [31:0] x7
);
    logic [31:0] w_PCp4;
    logic [31:0] w_rd1;
    logic [31:0] w_rd2;
    logic [31:0] w_Imm;
    logic [31:0] w_SrcB;
    logic [31:0] w_ULAResult;
    logic        w_Zero;

    assign w_PCp4 = w_PC + 32'd4;
    assign w_SrcB = w_ULASrc ? w_Imm : w_rd2;

    ProgramCounter PC_rv (
        .clk  (clk),
        .rst  (rst),
        .PCin (w_PCp4),
        .PC   (w_PC)
    );

    InstructionMemory #(.ADDR_WIDTH(10)) IM_rv (
        .A  (w_PC[9:0]),
        .RD (w_Inst)
    );

    ControlUnit UC_rv (
        .OP         (w_Inst[6:0]),
        .Funct3     (w_Inst[14:12]),
        .Funct7     (w_Inst[31:25]),
        .RegWrite   (w_RegWrite),
        .ULASrc     (w_ULASrc),
        .ULAControl (w_ULAControl)
    );

    Extend EXT_rv (
        .ImmIn  (w_Inst[31:20]),
        .ImmOut (w_Imm)
    );

    RegisterFile RF_rv (
        .clk (clk), .rst(rst),
        .wd3 (w_ULAResult),
        .wa3 (w_Inst[11:7]),
        .we3 (w_RegWrite),
        .ra1 (w_Inst[19:15]),
        .ra2 (w_Inst[24:20]),
        .rd1 (w_rd1),
        .rd2 (w_rd2),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7)
    );

    ULA ULA_rv (
        .SrcA       (w_rd1),
        .SrcB       (w_SrcB),
        .ULAControl (w_ULAControl),
        .ULAResult  (w_ULAResult),
        .Z          (w_Zero)
    );

endmodule

`default_nettype wire
