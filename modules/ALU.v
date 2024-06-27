`timescale 1ns / 1ps

module ALU(clk,a, b, alufn, enable, otp, zero, overflow);
    input wire clk;
    input wire [7:0] a;
    input wire [7:0] b;
    input wire [5:0] alufn; // choosing 6 bit op code
    input wire 	     enable;
    output reg [7:0] otp;
    output reg zero; // set if the output of the alu is 0
    output reg overflow;
    
    always @(*)
    begin
	if(enable) begin
        casex(alufn)
            6'b0000xx: begin
        if(alufn[1:0] == 2'b00)
            begin //ADD
                otp = a + b;
                zero = (otp==0)?1:0;
                if ((a >= 0 && b >= 0 && otp < 0) || (a < 0 && b < 0 && otp >= 0))
                    overflow = 1;
                else
                    overflow = 0;
            end
        else if(alufn[1:0] == 2'b01) //SUB
            begin
                otp = a-b;
                zero = (otp==0)?1:0;
                if ((a >= 0 && b < 0 && otp < 0) || (a < 0 && b >= 0 && otp > 0))
                    overflow = 1;
                else
                    overflow = 0;
            end
        else if (alufn[1:0] == 2'b10) //MUL
            begin
                otp = a*b;
                zero = (otp==0)?1:0;
                overflow = 0;
            end
    end
            6'b0001xx: begin
        case (alufn[1:0])
        2'b00: //AND
            begin
                otp = a & b;
                overflow = 0;
                zero = (otp==0)?1:0;
            end
        2'b01: //OR
            begin
                otp = a | b;
                overflow = 0;
                zero = (otp==0)?1:0;
            end
        2'b10:  //XOR
                begin
                    otp = a ^ b;
                    overflow = 0;
                    zero = (otp==0)?1:0;
                end
        endcase
    end
            6'b0010xx: begin
        case(alufn[1:0])
        2'b00: //SHIFTLEFT
            begin
                otp = a<<b;
                zero = (otp == 0)?1:0;
                overflow = 0;
            end
        2'b01: //shiftright
            begin
                otp = a>>b;
                zero = (otp == 0)?1:0;
                overflow = 0;
            end
        2'b10: //slt
            begin
                otp = (a<b)? 1:0;
                zero = (otp == 0 && a!=b)?1:0;
                overflow = 0;
            end
	2'b11: //seq
	    begin
		otp = (a==b)?1:0;
		zero = (otp==0)?1:0;
		overflow = 0;
	    end
        endcase
    end
            default:
            begin 
                otp = {8{1'b0}};
            end
        endcase
    end
    else begin
	otp = {8{1'b0}};
	end
end

endmodule 