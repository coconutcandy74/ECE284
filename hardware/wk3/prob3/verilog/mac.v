// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input [bw-1:0] a;
input [bw-1:0] b;
input [psum_bw-1:0] c;

wire signed [psum_bw-1:0] signed_b;
wire signed [psum_bw-1:0] signed_a;
wire signed [psum_bw-1:0] signed_c;
wire signed [psum_bw-1:0] product;

assign signed_b = {{(psum_bw-bw){b[bw-1]}}, b};
assign signed_a = {{(psum_bw-bw){1'b0}}, a};
assign signed_c = c;

assign product = signed_b * signed_a;
assign out = product + signed_c;

endmodule
