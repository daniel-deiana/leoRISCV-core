module datapath(
    // inputs 
    input clk, rst,
    input wr_en_reg, wr_en_mem,
    input jmp,
    input alu_op_b_src,
    input [2:0] immFormat,
    input [2:0] aluCTRL,
    input [31:0] instr,
    // outputs 
    output [31:0]iaddr,
    output [31:0]alu_res,
    output [31:0]wr_data_mem
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

    // values that are input to the alu
    wire [31:0] alu_src_a, alu_src_b;

    // sign-extended immediate value 
    wire [31:0] immExt; 

    /* funct3/funct7 */
    wire [2:0] funct3;
    wire [6:0] funct7;

    // result of alu operation
    wire [31:0] aluRes;

    // output of data memory 
    wire [31:0] dmem_out 
 
    // ----------------------------
    // fetch
    // ----------------------------
    if fetch(
        .clk(clk), 
        .rst(rst),
        .jmp(jmp),
        .target_branch(),

        .iaddr(iaddr)
    );
    
    sign_extend sign_extension(
        .instr(f_instr),
        .format(immFormat)
    );

    regsfile register_file(
        .clk(clk),
        .wr_en(wr_en_reg),
        .A1(rs1), .A2(rs2), .A3(rd),
        .WD3(wd3),
        .RD1(rd1), .RD2(rd2)
    );

    alu alu(
    
    );


    // instr decoding
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd = instr[11:7];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    // alu wires
    assign alu_src_a = rd1;
    assign alu_src_b = (alu_op_b_src == 1'b0) ? rd2 : immExt;
    
    // register file write input data 
    assign wd3 = (reg_wd_sel = 1'b0) ? aluRes : dmem_out; 


endmodule 




