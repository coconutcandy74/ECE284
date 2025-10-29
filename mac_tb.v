// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] a0, a1, a2, a3;
reg  signed [bw-1:0] b0, b1, b2, b3;
reg  signed [psum_bw-1:0] c;
wire signed [psum_bw-1:0] out;
reg  signed [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec0, x_dec1, x_dec2, x_dec3;
integer w_dec0, w_dec1, w_dec2, w_dec3;
integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight > -1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end
    
    if (weight > 3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end 
    else
     w_bin[2] = 0;
      
    if (weight > 1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end 
    else
     w_bin[1] = 0;

    if (weight > 0)
     w_bin[0] = 1;
    else
     w_bin[0] = 0;

  end
endfunction

function [3:0] x_bin ;
  input integer activation;
  begin
    x_bin[3] = (activation >> 3) & 1'b1;
    x_bin[2] = (activation >> 2) & 1'b1;
    x_bin[1] = (activation >> 1) & 1'b1;
    x_bin[0] = (activation >> 0) & 1'b1;
  end
endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
  input [bw-1:0] a0, a1, a2, a3;
  input [bw-1:0] b0, b1, b2, b3;
  input [psum_bw-1:0] c;
    
  reg signed [psum_bw-1:0] predicted_val;
  reg signed [bw*2-1:0] prod0, prod1, prod2, prod3;
  reg signed [bw*2:0] sum01, sum23;
  reg signed [bw*2+1:0] sum_all_prods;
    
  begin
    prod0 = a0 * $signed(b0);
    prod1 = a1 * $signed(b1);
    prod2 = a2 * $signed(b2);
    prod3 = a3 * $signed(b3);

    sum01 = prod0 + prod1;
    sum23 = prod2 + prod3;

    sum_all_prods = sum01 + sum23;
  
    predicted_val = sum_all_prods + $signed(c);

    mac_predicted = predicted_val;
  end
endfunction

mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
        .a0(a0), .a1(a1), .a2(a2), .a3(a3), 
        .b0(b0), .b1(b1), .b2(b2), .b3(b3),
        .c(c),
	.out(out)
); 
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
    
  #1 clk = 1'b0;
  #1 clk = 1'b1;    
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  
  for (i=0; i<10; i=i+1) begin  // Data lenght is 10 in the data files
     #1 clk = 1'b1;     
     #1 clk = 1'b0;

     w_scan_file = $fscanf(w_file, "%d %d %d %d", w_dec0, w_dec1, w_dec2, w_dec3);
     x_scan_file = $fscanf(x_file, "%d %d %d %d", x_dec0, x_dec1, x_dec2, x_dec3);

     a0 = x_bin(x_dec0);
     a1 = x_bin(x_dec1);
     a2 = x_bin(x_dec2);
     a3 = x_bin(x_dec3);
 
     b0 = w_bin(w_dec0);
     b1 = w_bin(w_dec1);
     b2 = w_bin(w_dec2);
     b3 = w_bin(w_dec3);

     c = expected_out;

     expected_out = mac_predicted(a0, a1, a2, a3, b0, b1, b2, b3, c);
  end    
  
  #1 clk = 1'b1;
  #1 clk = 1'b0;


  $display("-------------------- Computation completed --------------------");

  #10 $finish;

end

endmodule




