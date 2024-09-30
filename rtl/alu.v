module alu(
    input [31:0]srcA,
    input [31:0]srcB,
    input [3:0]aluCTRL,

    output reg[31:0]res,
    output reg zero
);

wire [4:0]shamt, is_logic_shift;

reg signed [31:0] imm_sign;

// signals used for shift operations 
assign shamt = srcB[4:0];
assign is_arith_shift = srcB[10];

always @(*) begin

    // used to implement instructions that require comparision with signed value
    imm_sign <= srcB;
    zero <= (srcA - srcB == 0) ? 1 : 0;

    case(aluCTRL)
        // add
        4'b0000: res = srcA + srcB;
        // slti instruction 
        4'b0001: res = (srcA < imm_sign) ? 1'b1: 1'b0;
        // sltiu
        4'b0010: res = (srcA < srcB) ? 1'b1: 1'b0;
        // xor 
        4'b0011: res = srcA ^ srcB; 
        // or
        4'b0100: res = srcA | srcB;
        // and
        4'b0101: res = srcA & srcB;
        /* slli is shift left unsigned immediate (srcB[4:0]) 
           is the shift amount part of the instruction */
        4'b0110: res = srcA << shamt;
        // srli/srai shift right 
        4'b0111: res = (is_arith_shift) ?   srcA >>> shamt :
                                            srcA >> shamt;
        // sub
        4'b1000: res = srcA - srcB; 
  
        default: res = 0;
    endcase
end
endmodule