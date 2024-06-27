`timescale 1ns / 1ps
// A mux to work with 64-bit inputs
module mux32bit(in0, in1, select, out);
    input wire select; 
    input wire [31:0] in0;
    input wire [25:0] in1;
    output reg[31:0] out;

    always @(*)
    begin
        if(select == 0)
        begin
            out <= in0;
        end
        else begin
            out <= {{6{1'b0}},in1};
        end
    end

endmodule 