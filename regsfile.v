module regsfile(
    input clk,
    input wr_en,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,

    output [31:0] RD1,
    output [31:0] RD2,
);

reg [4:0] regs[0:31];


// values are written synchronously 
always @(posedge clk) begin
    if (wr_en) begin
        regs[A3] <= WD3;
    end
end

// values are read combinationally
assign RD1 = regs[A1];
assign RD2 = regs[A2];

endmodule