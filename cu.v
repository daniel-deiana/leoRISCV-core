module cu(
    input [2:0]funct3,
    input [6:0]funct7,
    input [6:0]opcode,

    output wr_en_reg,
    output wr_en_mem,
    output jump,
    output [2:0]aluCTRL,
    output [2:0]immFormat
);

wire [2:0] control;

// control signals to datapath  
{   jump,
    wr_en_reg,
    wr_en_mem,
    aluCTRL,
    immFormat
} = controls; 

always @(*) begin
    case(opcode[6:2])
        // SW
         instruction 
        7'b01000: controls = 9'b0_0_0_000_001;
        // BEQ instruction
        7'b11000: controls = 9'b1_1_1_xxx_010;
    endcase
end
endmodule