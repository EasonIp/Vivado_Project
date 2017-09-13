
`timescale 1ns/1ps

module tb_led_flow (); /* this is automatically generated */

    reg rst_n;
    reg clk;
    // clock
led_flow led_flow1(
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
