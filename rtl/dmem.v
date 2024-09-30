module dmem(
    input clk,
    input wr_en_mem,
    input [31:0] A,
    input [31:0] WD,
    
    output reg [31:0] RD
);

reg [31:0] mem[0:1024];

always @(posedge clk) begin
    if (wr_en_mem) begin
        mem[A] <= WD;
        $display("DEBUG: STORE INSTUCTION, wrote value: %i", WD );
    end else begin
        $display("DEBUG: load INSTUCTION, read value: %i", mem[A] );
        RD <= mem[A];
    end
end
endmodule



