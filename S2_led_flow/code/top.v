module top (clk,rst_n,top_led_flow);
input clk;
input rst_n;
output [3:0] top_led_flow;  //reg? 顶层不用赋值，只用来连线；不用reg  看他的错误信息

wire  clk_1hz1_out;
// 
// reg rst_n;

clk_1hz clk_1hz1(
	.clk(clk), 
    .rst_n(rst_n), 
    .clk_1hz_out(clk_1hz1_out)
	);

led_flow2 led_flow2 (
	.clk(clk_1hz1_out),
	.rst_n(rst_n),
	.led_out(top_led_flow)
	);

endmodule