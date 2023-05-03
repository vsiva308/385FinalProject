//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX1, BallY1, BallX2, BallY2, DrawX, DrawY,
							  input logic blank,
							  input logic vga_clk,
                       output logic [3:0]  Red, Green, Blue );
    
    logic ball_on1, ball_on2;
	 logic [3:0] bg_red, bg_green, bg_blue;
	  
    int DistX1, DistY1, DistX2, DistY2, Size;
	 assign DistX1 = DrawX - BallX1;
    assign DistY1 = DrawY - BallY1;
	 assign DistX2 = DrawX - BallX2;
    assign DistY2 = DrawY - BallY2;
	 
	 //drawing background logic -> bg registers -> combinational logic with ball overlap
	 streetfighter_example bg (
		.vga_clk(vga_clk),
		.DrawX(DrawX), 
		.DrawY(DrawY),
		.blank(blank),
		.red(bg_red),
		.green(bg_green),
		.blue(bg_blue)
	);
	  
	 //logic for coloring ball or background (combinational since pixel logic is in ball.sv)
    always_comb
    begin:Ball_on_proc1
        //if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
		  if(DistX1 < 120 & DistX1 >= 0 & DistY1 < 180 & DistY1 >= 0)
            ball_on1 = 1'b1;
        else 
            ball_on1 = 1'b0;
     end
	  
	 always_comb
    begin:Ball_on_proc2
        //if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
		  if(DistX2 < 120 & DistX2 >= 0 & DistY2 < 180 & DistY2 >= 0)
            ball_on2 = 1'b1;
        else 
            ball_on2 = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on1 == 1'b1)) 
        begin 
            Red = 8'h55;
            Green = 8'hff;
            Blue = 8'h00;
        end
		  else if((ball_on2 == 1'b1))
		  begin
				Red = 8'hff;
            Green = 8'h55;
            Blue = 8'h00;
		  end       
        else 
        begin //background
            Red = bg_red; 
            Green = bg_green;
            Blue = bg_blue;
        end      
    end 
    
endmodule
