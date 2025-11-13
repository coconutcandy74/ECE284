// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  input  [row*bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  output [col-1:0] valid;

  wire [psum_bw*col-1:0] psum [0:row];
  wire [col-1:0] valid_row [0:row-1];
  
  reg [1:0] inst_q [0:row-1];
  
  assign psum[0] = in_n;
  assign out_s = psum[row];

  assign valid = valid_row[row-1];

  genvar r;
  generate
    for (r = 0; r < row; r = r + 1) begin : row_num
      mac_row #(.bw(bw), .psum_bw(psum_bw), .col(col)) mac_row_instance (
        .clk (clk),
        .reset (reset),

        .in_w (in_w[bw*(r+1)-1 : bw*r]),

        .in_n (psum[r]),
        .out_s(psum[r+1]),

        .valid (valid_row[r]),

        .inst_w (inst_q[r])
      );

    end 
  endgenerate


  integer k;
  always @ (posedge clk) begin
    if (reset) begin
      for (k = 0; k < row; k = k+1) begin
        inst_q[k] <= 2'b00;
      end
    end else begin
      inst_q[0] <= inst_w;
      for (k = 1; k < row; k = k+1) begin
        inst_q[k] <= inst_q[k-1];
      end
    end
  end

endmodule
