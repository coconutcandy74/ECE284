// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a0, a1, a2, a3, b0, b1, b2, b3, c);

parameter bw = 4;
parameter psum_bw = 16;

output signed [psum_bw-1:0] out;
input [bw-1:0] a0, a1, a2, a3;
input signed [bw-1:0] b0, b1, b2, b3;
input signed [psum_bw-1:0] c;

wire signed [bw*2-1:0] prod0, prod1, prod2, prod3;
assign prod0 = a0 * b0;
assign prod1 = a1 * b1;
assign prod2 = a2 * b2;
assign prod3 = a3 * b3;

wire signed [bw*2:0] sum01, sum23;
assign sum01 = prod0 + prod1;
assign sum23 = prod2 + prod3;

wire signed [bw*2+1:0] sum_all_prods;
assign sum_all_prods = sum01 + sum23;

assign out = sum_all_prods + c;

endmodule
