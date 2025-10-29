// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

output signed [psum_bw-1:0] out;
input  [bw-1:0] a;
input  signed [bw-1:0] b;
input  signed [psum_bw-1:0] c;
input  clk;

reg    [bw-1:0] a_q;
reg    signed [bw-1:0] b_q;
reg    signed [psum_bw-1:0] c_q;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .a(a_q), 
        .b(b_q),
        .c(c_q),
	.out(out)
); 

always @ (posedge clk) begin
        b_q  <= b;
        a_q  <= a;
        c_q  <= c;
end

endmodule
