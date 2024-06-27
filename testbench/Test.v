module Test(input clk,
	input rst);

	wire [31:0] 	tb_inst;
	wire [63:0]	tb_main_memory_input_data_path;
	wire [63:0] 	tb_main_memory_output_data_path;
	wire[31:0] 	tb_pc_inst_addr;
	wire		tb_Vector_Write_Access; 
	wire		tb_Memory_Write_Access;
	wire		tb_Load_Vector_Flag;
	wire 		tb_Load_Word_Flag;
	wire[11:0]	tb_Main_Memory_Address;
CPU cpu(.clk(clk),
	.rst(rst),
	.inst(tb_inst),
	.main_memory_input_data_path(tb_main_memory_input_data_path),
	.main_memory_output_data_path(tb_main_memory_output_data_path),
	.pc_inst_addr(tb_pc_inst_addr),
	.Vector_Write_Access(tb_Vector_Write_Access),
	.Memory_Write_Access(tb_Memory_Write_Access),
	.Load_Vector_Flag(tb_Load_Vector_Flag),
	.Load_Word_Flag(tb_Load_Word_Flag),
	.Main_Memory_Address(tb_Main_Memory_Address)
);

MainMemory tb_main(.clk(clk),
    		   .address(tb_Main_Memory_Address),
     		   .vectorWriteEnable(tb_Vector_Write_Access),
    		   .vectorReadEnable(tb_Load_Vector_Flag),
    		   .readEnable(tb_Load_Word_Flag),
    	 	   .writeEnable(tb_Memory_Write_Access),
    		   .dataOut(tb_main_memory_input_data_path),
		   .dataIn(tb_main_memory_output_data_path)
);

InstructionMemoryModule tb_inst_memory(.clk(clk),
    					.address(tb_pc_inst_addr),
    					.readEnable(1'b1),
    					.writeEnable(1'b0),
    					.dataIn(32'h00000000),
    					.dataOut(tb_inst)
);
endmodule