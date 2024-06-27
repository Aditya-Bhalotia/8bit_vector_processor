`timescale 1ns / 1ps

module InstructionMemoryModule(
    input wire clk,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] dataIn,
    output reg [31:0] dataOut
    );
reg [31:0] memory[8191:0];


initial begin
	memory[0]  = 32'b00000000000000000000000000000000;
	memory[1]  = 32'b10010100001000000000000000011111;
	memory[2]  = 32'b10010100010000000000000000100011;
	memory[3]  = 32'b11000000000000000000000000001010;

	memory[4]  = 32'b10110000000000000000000000101010;
	memory[5]  = 32'b00000000001000010001000000000000;
	memory[6]  = 32'b00110100010000101111111100000000;

	memory[7]  = 32'b10111100000000000000000000101010;
	memory[8]  = 32'b01111100000000100000000000000000;
	memory[9]  = 32'b11000000000000000000000000001100;
	
	memory[10] = 32'b00110100010000100000101000000000;
	memory[11] = 32'b11000000000000000000000000000100;
//	memory[1]  = 32'b10010100010000000000000000011111;
//	memory[2]  = 32'b10010100101000000000000000100011;
//	memory[3]  = 32'b10010110100000000000000000101000;
//	memory[4]  = 32'b10110100000000000000000000000000;
//	memory[5]  = 32'b10110100001000000000000000001010;
//	memory[6]  = 32'b01000000010000000000100000000000;
//	memory[7]  = 32'b10111000010000000000001010110010;
//	memory[8]  = 32'b01000100010000000000100000000000;
//	memory[9]  = 32'b10111000010000000000001010110010;
//	memory[10]  = 32'b01001000010000000000100000000000;
//	memory[11]  = 32'b10111000010000000000001010110010;
//	memory[12]  = 32'b00000000100000100010100000000000;
//	memory[13]  = 32'b10011000100000000000000000110001;
//	memory[14]  = 32'b00000000100000101010000000000000;
//	memory[15]  = 32'b10011000100000000000000000110001;
//	memory[16]  = 32'b00000100100000100010100000000000;
//	memory[17]  = 32'b10011000100000000000000000110001;
//	memory[18]  = 32'b00001000100000100010100000000000;
//	memory[19]  = 32'b10011000100000000000000000110001;
//	memory[20]  = 32'b00010000100000100010100000000000;
//	memory[21]  = 32'b10011000100000000000000000110001;
//	memory[22]  = 32'b00010100100000100010100000000000;
//	memory[23]  = 32'b10011000100000000000000000110001;
//	memory[24]  = 32'b00100000100000100010100000000000;
//	memory[25]  = 32'b10011000100000000000000000110001;
//	memory[26]  = 32'b00100100100000100010100000000000;
//	memory[27]  = 32'b10011000100000000000000000110001;
//	memory[28]  = 32'b00101000100000100010100000000000;
//	memory[29]  = 32'b10011000100000000000000000110001;
//	memory[30]  = 32'b00101100100000100010100000000000;
//	memory[31]  = 32'b10011000100000000000000000110001;
end

always @(address) 
    begin
	if (address != 32'hFFFFFFFF) begin
    		dataOut = memory[address];
		end

end


endmodule