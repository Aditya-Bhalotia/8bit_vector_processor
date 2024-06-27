`timescale 1ns / 1ps

module control_unit(
    input [31:0] instruction,
    output reg 	     TypeDetect, // Flag to decide whether its vector or word
    output reg       ALUSrc,    // Decides between Register input to ALU and I Type add immediate
    output reg       MemToReg,  // Decides between SW and ALU output
    output reg       MemToVecReg, // Decides between SV and VPU output
    output reg       RegWriteEnable,  // Write enable for Register File
    output reg       VecRegWriteEnable, // Write Enable for Vector Register File
    output reg       VecWrite,   // Read from data memory
    output reg       MemWrite,  // Write to data memory
    output reg       Branch,    // 1 if instruction is beq and thus decides Program Counter
    output reg [5:0] ALUOp,     // ALU Opcode
    output reg       Jump       // 1 if insturction is J type

);

wire [5:0] opcode;
assign opcode = instruction [31:26];
reg [15:0]  controlSignals[63:0];

initial
begin
    controlSignals[6'b000000] = 16'b0010010000000000; // rtypeadd
    controlSignals[6'b000001] = 16'b0010010000000010; // rtypesub
    controlSignals[6'b000010] = 16'b0010010000000100; // rtypemult

    controlSignals[6'b000100] = 16'b0010010000001000; // rtypeand
    controlSignals[6'b000101] = 16'b0010010000001010; // rtypeor
    controlSignals[6'b000110] = 16'b0010010000001100; // rtypexor

    controlSignals[6'b001000] = 16'b0010010000010000; // rtypesl
    controlSignals[6'b001001] = 16'b0010010000010010; // rtypesr
    controlSignals[6'b001010] = 16'b0010010000010100; // rtypeslt
    controlSignals[6'b001011] = 16'b0010010000010110; // rtypeseq

    controlSignals[6'b010000] = 16'b0100000000100000; // rtypevadd
    controlSignals[6'b010001] = 16'b0100000000100010; // rtypevsub
    controlSignals[6'b010010] = 16'b0100000000100100; // rtypevdot
	
    controlSignals[6'b001101] = 16'b0011010000000000; // addi
    controlSignals[6'b001110] = 16'b0011010000001000; // andi
    controlSignals[6'b001111] = 16'b0011010000001100; // xori

    controlSignals[6'b100011] = 16'b0011000010010110; // beq
    controlSignals[6'b011111] = 16'b0011000010010100; // bgt
    //controlSignals[6'b010100]1	 = 11'b; //bne
    controlSignals[6'b101101] = 16'b1001000000000000; // lv
    controlSignals[6'b101110] = 16'b0001000100000000; // sv

    controlSignals[6'b100101] = 16'b0001100000000000; // lw
    controlSignals[6'b100110] = 16'b0001001000000000; // sw
    controlSignals[6'b101000] = 16'b0011010000010100; // slti
    controlSignals[6'b110000] = 16'b0000000011100001; // jump
    controlSignals[6'b101100] = 16'b0000001100000000; // reg address write
    controlSignals[6'b101111] = 16'b1000100000000000; //reg address read
end

always @(instruction)
    begin
	MemToVecReg = controlSignals[opcode][15];
	VecRegWriteEnable = controlSignals[opcode][14];
	TypeDetect = controlSignals[opcode][13];
        ALUSrc   = controlSignals[opcode][12];
        MemToReg = controlSignals[opcode][11];
        RegWriteEnable = controlSignals[opcode][10];
        MemWrite = controlSignals[opcode][9];
        VecWrite  = controlSignals[opcode][8];
        Branch   = controlSignals[opcode][7];
        ALUOp    = controlSignals[opcode][6:1];
        Jump     = controlSignals[opcode][0];

    end
endmodule
