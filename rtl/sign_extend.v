module sign_extend(
    // inputs 
    input [31:0]instr,
    input [2:0]format,
    // outputs 
    output reg [31:0] imm
);

/* the immediate value is chosen based on the format of the instruction */ 
always @(*) begin
    case(format)
    // I-immediate
    3'b000: imm <= {{20{instr[31]}},instr[30:25],instr[24:21],instr[20]};
    // S-immediate
    3'b001: imm <= {{20{instr[31]}},instr[30:25],instr[11:8],instr[7]};
    // B-immediate
    3'b010: imm <= {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
    // U-immediate
    3'b011: imm <= {instr[31],instr[30:20],instr[19:12],{12{1'b0}}};
    // J-immediate
    3'b100: imm <= {{12{instr[31]}},instr[19:12],instr[20],instr[30:25],instr[24:21],1'b0};
    default: imm <= 32'b0; // Handle unexpected format values
    endcase
end
endmodule