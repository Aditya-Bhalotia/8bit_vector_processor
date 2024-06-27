`timescale 1ns / 1ps

module CPU( input clk,
	input rst,
	input reg [31:0] inst,
	input reg[63:0]	main_memory_input_data_path,
	output reg[63:0] main_memory_output_data_path,
	output wire[31:0] pc_inst_addr,
	output wire		Vector_Write_Access, 
	output wire		Memory_Write_Access,
	output wire		Load_Vector_Flag,
	output wire 		Load_Word_Flag,
	output wire[11:0]	Main_Memory_Address
	);

	reg[31:0]	instruction;
    	wire[31:0]	reg_data1;
	reg[31:0]	temp_reg_data1;
	wire[5:0]		Opcode;
	wire		Branch_Control;
	wire		Jump_Control;
	wire		Word_Reg_Write_Enable;
	wire		Vect_Reg_Write_Enable;
	wire		Vector_vs_Word;
	wire		Reg_Imm_Flag;
	wire[4:0]	destination_reg;
	wire[4:0] 	source_reg1;
	wire[4:0] 	source_reg2;
	wire[7:0] 	operand1;
	wire[7:0]	temp_operand2;
	wire[7:0] 	operand2;
	wire[7:0] 	alu_output_word;
	wire[7:0]	data_to_wordreg;
	wire[63:0] 	vect_operand1;
	wire[63:0]	vect_operand2;
	wire[63:0]	vpu_vec_output;
	wire[63:0]	data_to_vec_reg;
	wire 		zero;
	wire		overflow;
	reg[63:0] 	vector_output_memory;
	reg[7:0]	word_output_memory;
	wire[63:0]	vector_input_memory;
	wire[7:0]	word_input_memory;

ProgramCounter prc(.clk(clk),
	.reset(rst),
	.zero(zero),
	.branch(Branch_Control),
	.jump(Jump_Control),
	.regAddress(reg_data1),
	.pc(pc_inst_addr)
);

always @(*) 
    begin
	if (pc_inst_addr != 32'hFFFFFFFF) begin
    		instruction = inst;
		end

end

control_unit control_signal(.instruction(instruction),
	.ALUOp(Opcode),
	.VecWrite(Vector_Write_Access),
	.MemWrite(Memory_Write_Access),
	.Branch(Branch_Control),
	.Jump(Jump_Control),
	.RegWriteEnable(Word_Reg_Write_Enable),
	.VecRegWriteEnable(Vect_Reg_Write_Enable),
	.MemToVecReg(Load_Vector_Flag),
	.MemToReg(Load_Word_Flag),
	.TypeDetect(Vector_vs_Word),
	.ALUSrc(Reg_Imm_Flag)
);

mux32bit RegAddselect(.select(Jump_Control),
	.in0(temp_reg_data1),
	.in1(instruction[25:0]),
	.out(reg_data1)
);
assign destination_reg = instruction[25:21];
assign source_reg1 = instruction[20:16];
assign source_reg2 = instruction[15:11];

mux DataToReg(.select(Load_Word_Flag),
	.in0(alu_output_word),
	.in1(word_output_memory),
	.out(data_to_wordreg)
);

mux64bit VectToReg(.select(Load_Vector_Flag),
	.in0(vpu_vec_output),
	.in1(vector_output_memory),
	.out(data_to_vec_reg)
);

Register_File reg_value_retrival_And_Update(.clk(clk),
		.read_addr1(source_reg1),
		.read_addr2(source_reg2),
		.read_data1(operand1),
		.read_data2(temp_operand2),
		.write_addr(destination_reg),
		.write_data(data_to_wordreg),
		.write_enable((Word_Reg_Write_Enable & !Vect_Reg_Write_Enable) | Load_Word_Flag)
);

mux decision_between_immediate_reg(.select(Reg_Imm_Flag),
	.in0(temp_operand2),
	.in1(instruction[15:8]),
	.out(operand2)
);

VectorRegisterFile vect_value_retrival_And_Update(.clk(clk),
		.read_addr1(source_reg1),
		.read_addr2(source_reg2),
		.read_data1(vect_operand1),
		.read_data2(vect_operand2),
		.write_addr(destination_reg),
		.write_data(data_to_vec_reg),
		.write_enable((Vect_Reg_Write_Enable & !Word_Reg_Write_Enable) | Load_Vector_Flag)
);

ALU alu(.clk(clk),
	.a(operand1), 
	.b(operand2), 	
	.alufn(Opcode), 
	.enable(Vector_vs_Word), 
	.otp(alu_output_word), 
	.zero(zero), 
	.overflow(overflow)
);

VPU vpu(.clk(clk),
	.a(vect_operand1),
	.b(vect_operand2),
	.enable((!Vector_vs_Word) & (Vect_Reg_Write_Enable)),
	.opCode(Opcode),
	.out(vpu_vec_output)
);


assign vector_input_memory = vect_operand1;
assign word_input_memory = operand1;

always @(posedge clk) begin
	if (Load_Word_Flag & !Memory_Write_Access & !Load_Vector_Flag & !Vector_Write_Access) begin
		word_output_memory = main_memory_input_data_path[7:0];
	end
	else if (!Load_Word_Flag & !Memory_Write_Access & Load_Vector_Flag & !Vector_Write_Access) begin
		vector_output_memory = main_memory_input_data_path;
	end
	else if(Load_Word_Flag & !Memory_Write_Access & Load_Vector_Flag & !Vector_Write_Access) begin
		temp_reg_data1 = main_memory_input_data_path[31:0];
		end
end

always @(negedge clk) 
    begin
    if(!Load_Word_Flag & Memory_Write_Access & !Load_Vector_Flag & !Vector_Write_Access) begin
	main_memory_output_data_path[63:8] = 56'h00000000000000;
        main_memory_output_data_path[7:0] = word_input_memory;
    end 
    else if (!Load_Word_Flag & !Memory_Write_Access & !Load_Vector_Flag & Vector_Write_Access) begin
	main_memory_output_data_path = vector_input_memory;
    end
    else if ((!Load_Word_Flag & Memory_Write_Access & !Load_Vector_Flag & Vector_Write_Access)) begin
	main_memory_output_data_path[63:32] = 32'h00000000;
	main_memory_output_data_path[31:0] = pc_inst_addr;
	end
end

assign Main_Memory_Address = instruction[11:0];

endmodule
