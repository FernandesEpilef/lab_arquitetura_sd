
module ControlUnit (
    input  wire [6:0] OP,
    input  wire [2:0] Funct3,
    input  wire [6:0] Funct7,

    output logic       RegWrite,
    output logic       ImmSrc,
    output logic       ULASrc,
    output logic [2:0] ULAControl,
    output logic       MemWrite,
    output logic       ResultSrc
);

    always_comb begin

        // valores padrao
        RegWrite   = 1'b0;
        ImmSrc     = 1'b0;
        ULASrc     = 1'b0;
        ULAControl = 3'b000;
        MemWrite   = 1'b0;
        ResultSrc  = 1'b0;

        case (OP)

            // =========================================
            // Tipo R
            // =========================================
            7'b0110011: begin

                ULASrc = 1'b0;

                case (Funct3)

                    // ADD / SUB
                    3'b000: begin

                        if (Funct7 == 7'b0000000) begin
                            // ADD
                            RegWrite   = 1'b1;
                            ULAControl = 3'b000;
                        end

                        else if (Funct7 == 7'b0100000) begin
                            // SUB
                            RegWrite   = 1'b1;
                            ULAControl = 3'b001;
                        end

                    end

                    // AND
                    3'b111: begin

                        if (Funct7 == 7'b0000000) begin
                            RegWrite   = 1'b1;
                            ULAControl = 3'b010;
                        end

                    end

                    // OR
                    3'b110: begin

                        if (Funct7 == 7'b0000000) begin
                            RegWrite   = 1'b1;
                            ULAControl = 3'b011;
                        end

                    end

                    // SLT
                    3'b010: begin

                        if (Funct7 == 7'b0000000) begin
                            RegWrite   = 1'b1;
                            ULAControl = 3'b101;
                        end

                    end

                    default: begin
                        RegWrite   = 1'b0;
                        ULAControl = 3'b000;
                    end

                endcase

            end

            // =========================================
            // ADDI
            // =========================================
            7'b0010011: begin

                if (Funct3 == 3'b000) begin

                    RegWrite   = 1'b1;
                    ImmSrc     = 1'b0;
                    ULASrc     = 1'b1;
                    ULAControl = 3'b000;

                end

            end

            // =========================================
            // LW
            // =========================================
            7'b0000011: begin

                if (Funct3 == 3'b010) begin

                    RegWrite   = 1'b1;
                    ImmSrc     = 1'b0;
                    ULASrc     = 1'b1;
                    ULAControl = 3'b000;
                    MemWrite   = 1'b0;
                    ResultSrc  = 1'b1;

                end

            end

            // =========================================
            // SW
            // =========================================
            7'b0100011: begin

                if (Funct3 == 3'b010) begin

                    RegWrite   = 1'b0;
                    ImmSrc     = 1'b1;
                    ULASrc     = 1'b1;
                    ULAControl = 3'b000;
                    MemWrite   = 1'b1;
                    ResultSrc  = 1'b0;

                end

            end

            default: begin

                RegWrite   = 1'b0;
                ImmSrc     = 1'b0;
                ULASrc     = 1'b0;
                ULAControl = 3'b000;
                MemWrite   = 1'b0;
                ResultSrc  = 1'b0;

            end

        endcase

    end

endmodule
