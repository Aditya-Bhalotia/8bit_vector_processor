`timescale 1ns / 1ps
// A mux to work with 64-bit inputs
module mux64bit(in0, in1, select, out);
    input wire select; 
    input wire [63:0] in0;
    input wire [63:0] in1;
    output reg[63:0] out;

    always @(*)
    begin
        if(select == 0)
        begin
            out <= in0;
        end
        else begin
            out <= in1;
        end
    end

endmodule 