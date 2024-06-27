`timescale 1ns / 1ps

module VectorRegisterFile(
        clk,
        read_data1,
        read_data2,
	read_addr1,
	read_addr2,
        write_data,
	write_addr,
        write_enable
    );

/***************************
******** PARAMETERS ********
***************************/

input wire clk;

input wire [63:0] write_data;
input wire        write_enable;
input wire [4:0] write_addr;
input wire [4:0] read_addr1;
input wire [4:0] read_addr2;

output reg [63:0] read_data1;
output reg [63:0] read_data2;


// REGISTER FILE

reg [63:0] Register_File [2:0]; // 32 - 32 Bit Registers


/*************************
********* LOGIC **********
**************************/

always @(posedge(clk))
    begin
     if (read_addr1 != 5'b11111) begin
	    read_data1 = Register_File[read_addr1];
    	end	
     if (read_addr2 != 5'b11111) begin
    	read_data2 = Register_File[read_addr2];	
    	end

end
always @(negedge(clk))
    begin
        if (write_enable) begin
    	    if (write_addr != 5'b11111) begin
    	        Register_File[write_addr] = write_data;  
    	    end 
        end
    end
endmodule 