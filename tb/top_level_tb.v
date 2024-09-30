module top_level_tb;

reg tb_clk, tb_rst; 

reg [31:0]iaddr_tb;
wire [31:0]instr;

top_level DUT(
    .clk(tb_clk),
    .rst(tb_rst)
);

initial begin
    $dumpfile("leoRV.vcd");
    $dumpvars(0,top_level_tb);
    $display("Starting leoRV simulation");
end 

initial begin
    tb_clk <= 0;
    iaddr_tb <= 0;
    #70
    $finish(2);
end
always #10 tb_clk <= ~tb_clk;
endmodule