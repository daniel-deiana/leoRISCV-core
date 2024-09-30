module cu(
    input      zero,
    input [2:0]funct3,
    input [6:0]funct7,
    input [6:0]opcode,

    output wr_en_reg,
    output wr_en_mem,
    output jump_en,
    output reg [3:0] aluCTRL,
    output [2:0] immFormat,
    output alu_src_b_sel,
    output [1:0] reg_wd_sel
);


reg [7:0]controls;
wire jump;
/*
// IMPLEMENTED ADDI, ADD, SUB
Arithmetics: ADD, ADDI, SUB

// ALL IMPLEMENTED
Logical: AND,ANDI,OR,ORI, XOR,XORI

// ALL IMPLEMENTED 
Sets: SLT, SLTI, SLTU, SLTIU

// ALL IMPLEMENTED  
Shifts: SRA, SRAI, SRL, SRLISLL, SLLI

// IMPLEMENTED LW, SW
Memory: LW, SW, LB, SB

// IMPLEMENTED 
PC: LUI, AUIPC

// NOT IMPLEMENTED
Jumps: JAL, JALR

// IMPLEMENTED BEQ
Branches: BEQ, BNE,BLT, BGE, BLTU, BGEU
*/ 

// control signals to datapath  
assign      {jump,
            wr_en_reg,
            wr_en_mem,
            immFormat, 
            alu_src_b_sel, 
            reg_wd_sel} = controls;


// control signal selection logic
always @(*) begin
    // the lowest 2 bits of opcodes are always 1 in RV23I instructions.
    case(opcode[6:2])

        // LOAD 
        7'b00000: controls =  9'b0_1_0_000_1_01;
        // STORE 
        7'b01000: controls =  9'b0_0_1_001_1_xx;
        // BRANCH 
        7'b11000: controls =  9'b1_0_0_010_0_xx; 
        // REGISTER IMMEDIATE
        7'b00100: controls =  9'b0_1_0_000_1_00;
        // REGISTER REGISTER 
        7'b01100: controls =  9'b0_1_0_xxx_0_01;
        // LUI
        7'b01101: controls =  9'b0_1_0_011_x_10;
        // AUIPC
        7'b00101: controls =  9'b1_1_0_011_x_11;

        default:  controls =  9'b0_0_0_000_0_00;

    endcase
end

always @(*) begin
    // the lowest 2 bits of opcodes are always 1 in RV32I instructions.
    case(opcode[6:2])
        // Integer register immediate instruction
        7'b00100: aluCTRL = (funct3 == 3'b000) ? 4'b0000:   // addi
                            (funct3 == 3'b010) ? 4'b0001:   // slti
                            (funct3 == 3'b011) ? 4'b0010:   // sltiu
                            (funct3 == 3'b100) ? 4'b0011:   // xori
                            (funct3 == 3'b110) ? 4'b0100:   // ori
                            (funct3 == 3'b111) ? 4'b0101:   // andi
                            (funct3 == 3'b001) ? 4'b0110:   // slli
                                                 4'b0111;   // srli/srai

        7'b01100: aluCTRL = (funct3 == 3'b001) ? 4'b0110:   // sll
                            (funct3 == 3'b010) ? 4'b0001:   // slt
                            (funct3 == 3'b011) ? 4'b0010:   // sltu
                            (funct3 == 3'b100) ? 4'b0011:   // xor
                            (funct3 == 3'b101) ? 4'b0111:   // srl/sra
                            (funct3 == 3'b110) ? 4'b0100:   // or
                            (funct3 == 3'b111) ? 4'b0101:   // and 
                            (funct7[5]) ?
                                                 4'b1000 : 
                                                 4'b0000;
        
        default:  aluCTRL = 4'b0000;
    endcase
end

// Conditional jumps 
assign jump_en = (jump && zero) ? 1'b1 : 1'b0;


endmodule