module regsfile(
    input clk,
    input wr_en,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,

    output [31:0] RD1,
    output [31:0] RD2
);

// registers array 
reg [31:0] regs[0:31];

initial begin
    // set all register values to zero
    regs[1] <= 0;
    regs[2] <= 200;
    regs[3] <= 8;
end

// values are written synchronously 
always @(posedge clk) begin
    if (wr_en) begin
        $display("DEBUG: LOAD INSTRUCTION, wrote into register value: %i",WD3);
        regs[A3] <= WD3;
        regs[0] <= 0;
    end
end

// values are read combinationally
assign RD1 = regs[A1];
assign RD2 = regs[A2];

endmodule