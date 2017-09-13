module led_flow (clk,rst_n,led_out);
	input clk;   // Clock
	input rst_n;  // Asynchronous reset active low
	output reg [3:0] led_out;
	
	reg [1:0] current_state;
	parameter [1:0]
			S0 = 2'b00,
			S1 = 2'b01,
			S2 = 2'b10,
			S3 = 2'b11;

	always @(posedge clk or negedge rst_n) 
	begin : proc_
		if(~rst_n) begin
			 current_state <= S0;
			 led_out <= 4'b0111;
		end else begin
			case (current_state)
				S0 :	begin
							current_state <= S1;
							led_out <= 4'b1011;
						end
				S1 :	begin
							current_state <= S2;
							led_out <= 4'b1011;
						end
				S2 :	begin
							current_state <= S3;
							led_out <= 4'b1101;
						end
				S3 :	begin
							current_state <= S0;
							led_out <= 4'b1110;
						end
				default :	begin
							current_state <= S0;
							led_out <= 4'b0111;
							end 
			endcase
		end
	end
endmodule