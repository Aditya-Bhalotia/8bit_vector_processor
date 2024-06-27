module VPU(
    input wire clk,
    input wire [63:0] a,
    input wire [63:0] b,
    input wire 	      enable,
    input wire [5:0] opCode, // choosing 6 bit op code
    output reg [63:0] out);

    reg [31:0] temp;
    initial begin
	out = {64{1'b0}};
    end
    always @(*) begin
	if (enable) begin
	case(opCode)
	
	6'b010000: begin
	out[7:0] = a[7:0] + b[7:0];
	out[15:8] = a[15:8] + b[15:8];
	out[23:16] = a[23:16] + b[23:16];
	out[31:24] = a[31:24] + b[31:24];
	out[39:32] = a[39:32] + b[39:32];
	out[47:40] = a[47:40] + b[47:40];
	out[55:48] = a[55:48] + b[55:48];
	out[63:56] = a[63:56] + b[63:56];
	end

	6'b010001: begin
	out[7:0] = a[7:0] - b[7:0];
	out[15:8] = a[15:8] - b[15:8];
	out[23:16] = a[23:16] - b[23:16];
	out[31:24] = a[31:24] - b[31:24];
	out[39:32] = a[39:32] - b[39:32];
	out[47:40] = a[47:40] - b[47:40];
	out[55:48] = a[55:48] - b[55:48];
	out[63:56] = a[63:56] - b[63:56];
	end

	6'b010010: begin
	
	temp[15:0] = a[7:0]*b[7:0];
	temp[31:16] = temp[15:0];
	temp[15:0] = a[15:8]*b[15:8];
	temp[31:16] = temp[31:16] + temp[15:0];
	temp[15:0] = a[23:16]*b[23:16];
	temp[31:16] = temp[31:16] + temp[15:0];
	temp[15:0] = a[31:24]*b[31:24];
	temp[31:16] = temp[31:16] + temp[15:0];
	temp[15:0] = a[39:32]*b[39:32];
	temp[31:16] = temp[31:16] + temp[15:0];
	temp[15:0] = a[47:40]*b[47:40];
	temp[31:16] = temp[31:16] + temp[15:0];
	temp[15:0] = a[55:48]*b[55:48];
	temp[31:16] = temp[31:16] + temp[15:0];
	temp[15:0] = a[63:56]*b[63:56];
	temp[31:16] = temp[31:16] + temp[15:0];
	
	out[7:0] = temp[23:16];
	end
endcase
end
else begin
out = {64{1'b0}};
end


end

endmodule
