`timescale 1ns / 1ps

module ProgramCounter(
    input clk,
    input reset,
    input zero,
    input branch,
    input jump,
    input [31:0] regAddress,
    output reg [31:0] pc 
);
    wire [31:0] pcPlus4;
    reg [1:0] pcControl;

    initial
    begin
        pc = 32'h00000000;
	pcControl <= 2'b00;
    end
    
    assign pcPlus4 = pc + 4;
    
    always @(negedge clk)
    begin
        if(reset == 1)
            pc <= 32'h00000000;
        else
        begin
        pcControl = ( branch==1 & zero == 1)? 2'b01: 2'b00;
        pcControl = (jump)?2'b01:pcControl;
        
            case(pcControl)
                2'b00: pc <= pcPlus4;                                                       //Increment of program counter by 4
                2'b01: pc <= regAddress;                                                    //Initial address
                //default: pc<= pcPlus4;
            endcase
        end
        // $display("pc - %d clk -%d  reset- %d pcControl- %b",pc,clk,reset,pcControl);
    end
endmodule
