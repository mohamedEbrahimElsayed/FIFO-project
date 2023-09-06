module RAM(din,addr,wr_en,rd_en,addr_en,dout_en,blk_select,clk,rst,dout,parity_out);
parameter MEM_WIDTH = 16;
parameter MEM_DEPTH = 1024;
parameter ADDR_SIZE = 10;
parameter ADDR_PIPLINE = "FALSE";
parameter DOUT_PIPLINE = "TRUE";
parameter PARITY_ENABLE = 1;
input [MEM_WIDTH-1:0] din;
input [ADDR_SIZE-1:0] addr;
input addr_en,wr_en,rd_en,dout_en,blk_select,clk,rst;
output [MEM_WIDTH-1:0] dout;
output parity_out;
wire [ADDR_SIZE-1:0] addr_in;
reg [MEM_WIDTH-1:0] dout_reg1,dout_reg2;
reg [ADDR_SIZE-1:0] addr_reg;
reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];
assign addr_in =(ADDR_PIPLINE == "TRUE")? addr_reg:(ADDR_PIPLINE == "FALSE")? addr : 0 ;
assign dout = (DOUT_PIPLINE == "TRUE")? dout_reg2:(DOUT_PIPLINE == "FALSE")? dout_reg1: 0 ;
always @(posedge clk) begin
 	if (rst)begin
 		addr_reg <= 0;
 		dout_reg1 <= 0;
 		dout_reg2 <= 0;

 	end
 	else begin
 		if (addr_en)
 			addr_reg <= addr;
 		if (dout_en)
 			dout_reg2 <= dout_reg1;
 		if (blk_select)begin
 			if(wr_en)
 				mem[addr_in] <= din;
 			if(rd_en)
 				dout_reg1 <= mem[addr_in];
 		end
 	end
end
assign parity_out =(PARITY_ENABLE)? ^dout:1'b0;
endmodule