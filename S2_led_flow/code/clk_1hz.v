
module clk_1hz (clk, rst_n, clk_1hz_out	);

	input clk; 
	input rst_n; 
	output reg clk_1hz_out;
	reg [25:0] counter;
	//parameter  counter_num=25_000_000-1;//50_000_000/1/2-1   
    parameter  counter_num=24_999_999;//50_000_000/1/2-1   
	always @(posedge clk or negedge rst_n) 
	begin : proc_1
		if(~rst_n) begin
			 counter <= 26'd0;
			 clk_1hz_out <= 0;
		end else begin
			 if(counter == counter_num) begin

			 	clk_1hz_out <= ~clk_1hz_out;
			 	counter <= 6'd1;
			 end
			 else
			 	counter = counter +1;
		end
	end
endmodule