module imem(
    input [31:0] addr,
    
    output [31:0] instr  
);

    reg [31:0] mem[0:3];
        
    // readmemh is used to put inside mem array the content of code.txt file
    initial begin 
        $readmemh("./rtl/code.txt", mem);
    end

    assign instr = mem[addr >> 2];

endmodule