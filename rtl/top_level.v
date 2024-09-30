/* 
** Top level module
** in this module we instatiate datapath, control unit and instruction and data memory
*/
module top_level(
    input clk,
    input rst
);
    // control unit in signals 
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [6:0] opcode;

    // control unit out signals
    wire wr_en_reg, wr_en_mem;
    wire alu_src_b_sel;
    wire alu_zero; 
    wire [1:0] reg_wd_sel;
    wire jump;
    wire [3:0] aluCTRL;
    wire [2:0] immFormat;

    // instruction address 
    wire [31:0] iaddr;
    wire [31:0] instr;

    // address to data memory
    wire [31:0] dmemAddr;
    // data to write to memory (coming from rd2 port of regfile)
    wire [31:0] dmemDataWr;
    // data read from memory on a load instruction
    wire [31:0] dmemDataRd;

    /*
        The datapath receives the signals from the cu
    */
    datapath datapath(
        .clk(clk),
        .rst(rst),
        .wr_en_reg(wr_en_reg),
        .jmp(jump),
        .alu_src_b_sel(alu_src_b_sel),
        .reg_wd_sel(reg_wd_sel),
        .immFormat(immFormat),
        .aluCTRL(aluCTRL),
        .instr(instr),
        .dmemOut(dmemDataRd),
        
        .iaddr(iaddr),
        .alu_res(dmemAddr),
        .alu_zero(alu_zero),
        .wr_data_mem(dmemDataWr),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode)
    );

    cu control_unit(
        .zero(alu_zero),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),

        .wr_en_reg(wr_en_reg),
        .wr_en_mem(wr_en_mem),
        .jump_en(jump),
        .aluCTRL(aluCTRL),
        .immFormat(immFormat),
        .alu_src_b_sel(alu_src_b_sel),
        .reg_wd_sel(reg_wd_sel)
    );

    /*
        Instruction memory, piloted by the address stored in the program counter
    */
    imem instruction_memory(
        .addr(iaddr),

        .instr(instr)
    );

    /*
        The data memory is piloted by the address coming from the alu
    */
    dmem data_memory(
        .clk(clk),
        .wr_en_mem(wr_en_mem),
        .A(dmemAddr),
        .WD(dmemDataWr),
        
        .RD(dmemDataRd)
    );
endmodule