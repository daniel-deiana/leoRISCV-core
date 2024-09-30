module alu(
    input srcA[31:0],
    input srcB[31:0],
    input aluCTRL[2:0],

    output res[31:0]
);

always @(*) begin
    case(aluCTRL)
        3'b000: res = srcA + srcB;
        default: res = 0;
    endcase
end
endmodule