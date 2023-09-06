module FIFO(din_a,wen_a,ren_b,clk_a,clk_b,rst,dout_b,full,empty);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 512;
parameter ADDR_SIZE = 9;
input [FIFO_WIDTH-1:0] din_a;
input wen_a,ren_b,clk_a,clk_b,rst;
output reg [FIFO_WIDTH-1:0] dout_b;
output full,empty;
reg [ADDR_SIZE:0] rd_ptr,wr_ptr;
reg [FIFO_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];

assign full =((rd_ptr[ADDR_SIZE-1:0] == wr_ptr[ADDR_SIZE-1:0]) && (rd_ptr[ADDR_SIZE] != wr_ptr[ADDR_SIZE]))? 1'b1:1'b0 ;
assign empty = (rd_ptr == wr_ptr)? 1'b1:1'b0;

always @(posedge clk_a) begin
	if (rst)
		wr_ptr <= 1'b0;
	else if (~full && wen_a) begin
		fifo[wr_ptr[ADDR_SIZE-1:0]] <= din_a;
		wr_ptr <= wr_ptr + 1;
	end
end
always @(posedge clk_b)begin
	if (rst) begin
		dout_b <= 'b0;
		rd_ptr <= 1'b0;
	end
	else if (~empty && ren_b) begin
		dout_b <= fifo[rd_ptr[ADDR_SIZE-1:0]];
		rd_ptr <= rd_ptr + 1; 
	end
end
endmodule