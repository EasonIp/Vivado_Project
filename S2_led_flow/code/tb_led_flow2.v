
`timescale 1ns/1ps

module tb_led_flow2 (); /* this is automatically generated */

    reg rst_n;
    reg clk;
    // clock
    wire [3:0] led_out;
led_flow2 led_flow2_1(
		.clk(clk), 
		.rst_n(rst_n), 
		.led_out(led_out));

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // reset
    initial begin
        rst_n = 0;
        #20
        rst_n = 1;
        #2000
        $stop;
    end

endmodule
