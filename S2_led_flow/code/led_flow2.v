module led_flow2 (clk,rst_n,led_out);
	input clk;   // Clock
	input rst_n;  // Asynchronous reset active low
	output reg [3:0] led_out;

	always @(posedge clk or negedge rst_n) begin : proc_
		if(~rst_n) begin
			 led_out <= 4'b0111;
		end else begin
			// led_out = 0111;
			led_out <= {led_out[0], led_out[3:1]};

		end
	end

endmodule