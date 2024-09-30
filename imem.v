module imem(
    input [31:0] addr,
    
    output [31:0] instr  
);

    reg [31:0] mem[0:1024];
        
    // readmemh is used to put inside mem array the content of code.txt file
    initial begin 
        $readmemh("code.txt", mem)
    end

endmodule