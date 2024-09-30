module if(
    input clk,
    input rst,
    // signal coming from cu that tells us if we need to jump or not
    input jmp,
    // if executing branch instr. need to pass the target to the fetch module
    input [31:0] target_branch,

    // addr of next instruction to fetch from memory
    output [31:0] iaddr,
); 

reg [31:0] pc; 

always @(posedge clk) begin
    if(jmp) begin
        pc <= target_branch else pc <= pc + 4;
    end 
end

assign iaddr = pc; 

endmodule

