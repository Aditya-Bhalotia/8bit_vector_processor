`timescale 1ns / 1ps

module Register_File(
        clk,
        read_addr1,
        read_addr2,
        read_data1,
        read_data2,
        write_addr,
        write_data,
        write_enable
    );

/***************************
******** PARAMETERS ********
***************************/

input wire clk;

input wire [4:0]  read_addr1;
input wire [4:0]  read_addr2;
input wire [4:0]  write_addr;

input wire [7:0] write_data;
input wire        write_enable;

output reg [7:0] read_data1;
output reg [7:0] read_data2;


// REGISTER FILE

    reg [7:0] Register_File [31:0]; // 32 - 8 Bit Registers


/*************************
********* LOGIC **********
**************************/

initial begin
	
end
always @(posedge(clk))
    begin
    read_data1 = 8'b00000000;
    read_data2 = 8'b00000000;
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