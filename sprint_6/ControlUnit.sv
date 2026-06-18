`default_nettype none

module ControlUnit (
    input  wire [6:0] OP,
    input  wire [2:0] Funct3,
    input  wire [6:0] Funct7,
    output logic       RegWrite,
    output logic       ULASrc,
    output logic [2:0] ULAControl
);

    always_comb begin
        // Valores seguros para instrucoes desconhecidas.
        RegWrite   = 1'b0;
        ULASrc     = 1'b0;
        ULAControl = 3'b000;

        case (OP)
            7'b0110011: begin // Instrucoes do tipo R
                ULASrc = 1'b0;

                case (Funct3)
                    3'b000: begin
                        if (Funct7 == 7'b0000000) begin      // ADD
                            RegWrite   = 1'b1;
                            ULAControl = 3'b000;
                        end else if (Funct7 == 7'b0100000) begin // SUB
                            RegWrite   = 1'b1;
                            ULAControl = 3'b001;
                        end
                    end

                    3'b111: begin // AND
                        if (Funct7 == 7'b0000000) begin
                            RegWrite   = 1'b1;
                            ULAControl = 3'b010;
                        end
                    end

                    3'b110: begin // OR
                        if (Funct7 == 7'b0000000) begin
                            RegWrite   = 1'b1;
                            ULAControl = 3'b011;
                        end
                    end

                    3'b010: begin // SLT
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

            7'b0010011: begin // ADDI: Funct7 pertence ao imediato e e ignorado
                if (Funct3 == 3'b000) begin
                    RegWrite   = 1'b1;
                    ULASrc     = 1'b1;
                    ULAControl = 3'b000;
                end
            end

            default: begin
                RegWrite   = 1'b0;
                ULASrc     = 1'b0;
                ULAControl = 3'b000;
            end
        endcase
    end

endmodule

`default_nettype wire
