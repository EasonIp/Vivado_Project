
`timescale 1ns/1ps

module tb_top (); /* this is automatically generated */

    reg clk;
    reg rst_n;
    
    wire [3:0] top_led_flow;  //reg?  写reg会报错

    top top1 (
    	.clk(clk), 
    	.rst_n(rst_n), 
    	.top_led_flow(top_led_flow)
    	);

    // clock
    initial begin
        clk = 1'b0;
       // clk_1hz_out <= 1'b0;
        forever #10 clk = ~clk;
    end

    // reset
    initial begin
        rst_n = 0;
        #20
        rst_n = 1;
        // # 200000000  //>50000000*20 ns
        // $stop;
    end

    // (*NOTE*) replace reset, clock

endmodule
