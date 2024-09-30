module instr_fetch(
    input clk,
    input rst,
    // signal coming from cu that tells us if we need to jump or not
    input jmp,
    // if executing branch instr. need to pass the target to the fetch module
    input [31:0] branchOffset,

    // addr of next instruction to fetch from memory
    output [31:0] iaddr
); 

reg [31:0] pc;

wire [31:0]offset;
assign offset = branchOffset;

initial begin
    // reset value (in reality this should be an always block with rst in sensitivity)
    pc <= 0;
end

always @(posedge clk) begin
    pc <= (jmp) ? pc + offset 
                : pc + 4; 
end

assign iaddr = pc; 

endmodule

