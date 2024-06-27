`timescale 1ns / 1ps

module MainMemory(
    input wire clk,
    input wire [11:0] address,
    input wire vectorWriteEnable,
    input wire vectorReadEnable,
    input wire readEnable,
    input wire writeEnable,
    input wire [63:0] dataIn,
    output reg [63:0] dataOut
    );
reg [7:0] memory[((1024*4)-1):0];


initial begin
	memory[0] = 8'b00010111;
	memory[1] = 8'b00101011;
	memory[2] = 8'b01100100;
	memory[3] = 8'b00011110;
	memory[4] = 8'b01000100;
	memory[5] = 8'b00110110;
	memory[6] = 8'b01001011;
	memory[7] = 8'b11001001;

	memory[10] = 8'b00011000;
	memory[11] = 8'b00101101;
	memory[12] = 8'b01111000;
	memory[13] = 8'b01010000;
	memory[14] = 8'b01000101;
	memory[15] = 8'b00110011;
	memory[16] = 8'b01000111;
	memory[17] = 8'b00000001;

	memory[31] = 8'b00000000;
	memory[35] = 8'b00001010; 
	memory[40] = 8'b01100100;

end

always @(*) begin
	if (readEnable & !writeEnable & !vectorReadEnable & !vectorWriteEnable) begin
	dataOut[63:8] = 56'h00000000000000;
	dataOut[7:0] = memory[address];
	end
	else if (!readEnable & !writeEnable & vectorReadEnable & !vectorWriteEnable) begin
		dataOut[63:56] = memory[address+7];
		dataOut[55:48] = memory[address+6];
		dataOut[47:40] = memory[address+5];
		dataOut[39:32] = memory[address+4];
		dataOut[31:24] = memory[address+3];
		dataOut[23:16] = memory[address+2];
		dataOut[15:8] = memory[address+1];
		dataOut[7:0] = memory[address];
	end
	else if(readEnable & !writeEnable & vectorReadEnable & !vectorWriteEnable) begin
		dataOut[63:32] = 32'b00000000;
		dataOut[31:24] = memory[address+3];
		dataOut[23:16] = memory[address+2];
		dataOut[15:8] = memory[address+1];
		dataOut[7:0] = memory[address];
		end
end

always @(*) 
    begin
    if(!readEnable & writeEnable & !vectorReadEnable & !vectorWriteEnable) begin
        memory[address] = dataIn[7:0];
    end 
    else if (!readEnable & !writeEnable & !vectorReadEnable & vectorWriteEnable) begin
	memory[address+7] = dataIn[63:56];
	memory[address+6] = dataIn[55:48];
	memory[address+5] = dataIn[47:40];
	memory[address+4] = dataIn[39:32];
	memory[address+3] = dataIn[31:24];
	memory[address+2] = dataIn[23:16];
	memory[address+1] = dataIn[15:8];
	memory[address] = dataIn[7:0];
    end
    else if ((!readEnable & writeEnable & !vectorReadEnable & vectorWriteEnable)) begin
	memory[address+3] = dataIn[31:24];
	memory[address+2] = dataIn[23:16];
	memory[address+1] = dataIn[15:8];
	memory[address] = dataIn[7:0];
	end
end

endmodule
