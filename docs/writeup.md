### RISC-V and Verilog refresher
I decided to pick up verilog which i hadn't been using since 2021 to write a risc-v processor. The idea is to follow the Harris and Harris book to build the pipeline + Hazard unit version and then add something personal (maybe a branch predictor??).


Today we implement some new instructions, the one that i implemented before are the LW and SW ones. 

##### Implementation of BEQ instr
The BEQ instruction stands for "branch if equal". The specs tells us that the branch instruction follow the B-Type instr format. so the structure is like 

| imm(high) | src2 | src1 | funct3 | imm(low) | opcode|.

the source registers are compared, then if the result of the subtraction between the two is zero, the program counter gets added the immediate value encoded in the branch instruction. the immediate value is computed using the B format encoding for immediates. (i can jump -+ 4Kib in memory from the current instruction) does this pose some limitation on the code execution ( i think no, you can always put in the branch a unconditional jump like a JAL instr. that has 1Mb offset).

we tested if the new instruction worked as espected adding the following risv assembly instruction to the instr. memory (beq x3, x3, -4). Observing the vcd with gtkwave the pc is actually assigned pc - 4.

#### Implementing Integer register immediate instruction
This morning i wanted to implement the ADDI instruction, this instr simply sums the sign extended immediate value to the value of register rs1 and puts it inside the rd register, inside this kind of instruction there are also SLTI, ANDI, ORI, XORI. the format is the I type.
the funct3 field of the instruction encodes the type of operation (wether an add or a shift operation etc..)

So the first thing to do is to add a case statement to drive the control signals, what we have to do in this case is, after the instr fetch, we pilot the src_b_sel to input the immediate value to the alu, so we can compute rs1 + sign_extend(imm) and then we forward the value computed to the rd register so we need to pilot the reg_wd_sel to select the output of the alu.
That's it, and this is the same flow for the addi but also for the ori etc.. the only thing we have to change in all those cases is the result chosen from the alu.

since the b type instructions require to use the same control signaling, i implemented all by adding alu functions.


#### Implementing the LUI instruction 
The LUI (Load upper immediate) is an instruction that extend a 20 bit immmediate constant to 32 bits and then load the rd register with that value. In the Harris book this instruction is implemented by simply passing the value coming from the sign extender.
we extend the multiplexer of the writeback stage to get data from 3 inputs, (the new input is the result of the sign extension to be put inside rd register)

#### Implementing the AUIPC instruction
the auipc instruction sums the u-immediate value to pc and then puts the result of this operation into rd register, i added another input to the multiplexer of wb stage this time with an adder that passes the address of the new pc (old_pc + u type immediate offset)


#### Next step: setup an environment for testing the current instruction that are implemented

resources:
    - RISCV specs: https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf.
    - RISCV online encoder/decoder https://luplab.gitlab.io/rvcodecjs/#q=addi+x4,+x2,+8&abi=true&isa=RV32I
    - Harris and Harris digital design and computer arch. book (RISCV Edition)