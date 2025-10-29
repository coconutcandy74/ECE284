// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

output signed [psum_bw-1:0] out;
input [bw-1:0] a;
input signed [bw-1:0] b;
input signed [psum_bw-1:0] c;

wire signed [bw*2-1:0] product;
assign product = a * b;

wire signed [psum_bw-1:0] product_extended;
assign product_extended = product;

assign out = product_extended + c;

endmodule
