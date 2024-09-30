module datapath(
    // inputs 
    input clk, rst,
    input           wr_en_reg,
    input           jmp,
    input           alu_src_b_sel,
    input [1:0]     reg_wd_sel,
    input [2:0]     immFormat,
    input [3:0]     aluCTRL,
    input [31:0]    instr,
    input [31:0]    dmemOut,
    // outputs 
    output [31:0]   iaddr,
    output [31:0]   alu_res,
    output          alu_zero,
    output [31:0]   wr_data_mem,
    output [2:0]    funct3,
    output [6:0]    funct7,
    output [6:0]    opcode
);
    // ---------------------------
    // wire declaration
    // ---------------------------
    
    wire [31:0]f_iaddr;
    wire [31:0]f_instr;

    /* instruction operands decoding wires */
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    // values that are read from register file
    wire [31:0] rd1,rd2;
    wire [31:0] wd3;

    // values that are input to the alu
    wire [31:0] alu_src_a, alu_src_b;

    // sign-extended immediate value 
    wire [31:0] immExt; 

    // result of alu operations
    wire [31:0] aluRes;
    wire alu_zero;


    // instr decoding
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd = instr[11:7];

    // wires in output from the datapath and in input to the CU 
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    assign opcode = instr[6:0];

    // f_instr is the current instruction fetched from imem
    assign f_instr = instr;
    
    // alu wires
    assign alu_src_a = rd1; // src a 
    
    // src b can come from either from register file or from immediate extended
    assign alu_src_b = (alu_src_b_sel == 1'b0) ? rd2 : immExt; 
    
    // register file write input data 
    assign wd3 = (reg_wd_sel == 2'b00) ? aluRes  :          // rd instructions 
                 (reg_wd_sel == 2'b01) ? dmemOut :          // load instructions
                 (reg_wd_sel == 2'b10) ? immExt  :          // lui instruction
                                         immExt + iaddr;    // auipc instruction

    assign wr_data_mem = rd2;
    
    // ----------------------------
    // fetch
    // ----------------------------
    instr_fetch fetch(
        .clk(clk), 
        .rst(rst),
        .jmp(jmp),
        .branchOffset(immExt),

        .iaddr(iaddr)
    );
    
    // ----------------------------
    // Sign extension
    // ----------------------------
    sign_extend sign_extension(
        .instr(f_instr),
        .format(immFormat),
        .imm(immExt)
    );

    // ----------------------------
    // Register file 
    // ----------------------------
    regsfile register_file(
        .clk(clk),
        .wr_en(wr_en_reg),
        .A1(rs1), .A2(rs2), .A3(rd),
        .WD3(wd3),
        .RD1(rd1), .RD2(rd2)
    );

    // ----------------------------
    // Alu
    // ----------------------------
    alu alu(
        .srcA(alu_src_a),
        .srcB(alu_src_b),
        .aluCTRL(aluCTRL),

        .res(alu_res),
        .zero(alu_zero)
    );

endmodule 




