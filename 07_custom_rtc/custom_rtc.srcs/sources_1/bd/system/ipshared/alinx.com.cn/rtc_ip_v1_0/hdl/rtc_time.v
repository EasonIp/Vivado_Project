module rtc_time
(
     input          CLK,
	 input          RSTn,

     input       Time_set_en,
     
     input [7:0] Time_year_set,
     input [7:0] Time_month_set,
     input [7:0] Time_date_set,   
     input [7:0] Time_second_set,
     input [7:0] Time_munite_set,
     input [7:0] Time_hour_set,   
  
 	 output reg [7:0] Time_year,
     output reg [7:0] Time_month,
     output reg [7:0] Time_date,    
	 output reg [7:0] Time_second,
	 output reg [7:0] Time_munite,
	 output reg [7:0] Time_hour,
	
	 output         RST,                 //ds1302 CE/RST
	 output         SCLK,                //ds1302 SCLK
	 inout          SIO                  //ds1302 SIO
	 

);


	 
/*******************************/
	 
reg [7:0] i;
reg [7:0] isStart;
reg [7:0] rData;


wire Done_Sig;
wire [7:0] Time_Read_Data;


/*******************************/
//DS1302 时钟设置和读取程序	
/*******************************/
always @ ( posedge CLK or negedge RSTn )
    if( !RSTn ) begin
			      i <= 8'd0;
			      isStart <= 8'd0;
					rData <= 8'd0;
	 end
	 else 
	     case( i )
			  
	        0://设置Write unprotect
			if( Done_Sig ) begin isStart <= 8'd0; i <= i + 1'b1; end
			else begin isStart <= 8'b1000_0000; rData <= 8'h00; end 
			
			1: //判断是否有时钟配置请求
			if( Time_set_en==1'b1 ) begin  i <= i + 1'b1; end			
			else begin i <= 4'd8; end		

			2://设置year
			if( Done_Sig ) begin isStart <= 8'd0; i <= i + 1'b1; end
			else begin isStart <= 8'b0001_0101; rData <= Time_year_set; end
					
			3://设置month
			if( Done_Sig ) begin isStart <= 8'd0; i <= i + 1'b1; end
			else begin isStart <= 8'b0001_0100; rData <= Time_month_set ; end
					
			4://设置date
			if( Done_Sig ) begin isStart <= 8'd0; i <= i + 1'b1; end
			else begin isStart <= 8'b0001_0011; rData <= Time_date_set; end			
					
			5://设置hour
			if( Done_Sig ) begin isStart <= 8'd0; i <= i + 1'b1; end
			else begin isStart <= 8'b0001_0010; rData <= Time_hour_set; end
					
			6://设置munite
			if( Done_Sig ) begin isStart <= 8'd0; i <= i + 1'b1; end
			else begin isStart <= 8'b0001_0001; rData <= Time_munite_set ; end
					
			7://设置second
			if( Done_Sig ) begin isStart <= 8'd0; i <= i + 1'b1; end
			else begin isStart <= 8'b0001_0000; rData <= Time_second_set; end
		
			8://读year
			if( Done_Sig ) begin Time_year <= Time_Read_Data; isStart <= 8'd0; i <= i + 1'b1; end
			else begin isStart <= 8'b0000_0110; end
			
			9://读month
            if( Done_Sig ) begin Time_month <= Time_Read_Data; isStart <= 8'd0; i <= i + 1'b1; end
            else begin isStart <= 8'b0000_0101; end
            
            10://读date
            if( Done_Sig ) begin Time_date <= Time_Read_Data; isStart <= 8'd0; i <= i + 1'b1; end
            else begin isStart <= 8'b0000_0100; end
            
            11://读hour
            if( Done_Sig ) begin Time_hour <= Time_Read_Data; isStart <= 8'd0; i <= i + 1'b1; end
            else begin isStart <= 8'b0000_0011; end    
            
             12://读munite
            if( Done_Sig ) begin Time_munite <= Time_Read_Data; isStart <= 8'd0; i <= i + 1'b1; end
            else begin isStart <= 8'b0000_0010; end

			 13://读second
            if( Done_Sig ) begin Time_second <= Time_Read_Data; isStart <= 8'd0; i <= 1; end
            else begin isStart <= 8'b0000_0001; end            

					
	      endcase
			  

	 
ds1302_module U1
(
        .CLK( CLK ), 
	     .RSTn( RSTn ),
	     .Start_Sig( isStart ),
	     .Done_Sig( Done_Sig ),
	     .Time_Write_Data( rData ),
	     .Time_Read_Data( Time_Read_Data ),
	     .RST( RST ),
	     .SCLK( SCLK ),
	     .SIO( SIO )
);
	 
	 

endmodule
