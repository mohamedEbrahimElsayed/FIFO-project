module FIFO_tb();
reg [15:0] din_a;
reg wen_a,ren_b,clk_a,clk_b,rst;
wire [15:0] dout_b;
wire full,empty;

FIFO dut(din_a,wen_a,ren_b,clk_a,clk_b,rst,dout_b,full,empty);

integer i=0;
initial begin
	clk_a=0;
	clk_b=0;
	forever begin
	#1 clk_a=~clk_a;
	#1 clk_b=~clk_b;
	end
end
initial begin
rst = 1;
wen_a=0;
ren_b=0;
din_a=0;
#50;
rst=0;
wen_a=1;
ren_b=0;
for(i=0;i<1000;i=i+1)begin
#2
din_a=$random;
end
wen_a=0;
ren_b=1;
#100;
for(i=0;i<1000;i=i+1)begin
#2
wen_a=$random;
ren_b=$random;
din_a=$random;
end
#1 $stop;
end
endmodule

