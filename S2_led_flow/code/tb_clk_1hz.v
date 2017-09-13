
`timescale 1ns/1ps

module tb_clk_1hz (); /* this is automatically generated */

    reg rst_n;
    reg clk;

    wire clk_1hz_out;

    clk_1hz clk_1hz1 (
    	.clk(clk), 
    	.rst_n(rst_n), 
    	.clk_1hz_out(clk_1hz_out)
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
