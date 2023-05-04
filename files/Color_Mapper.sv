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


module  color_mapper ( input        [9:0] RyuX, RyuY, AkumaX, AkumaY, DrawX, DrawY,
							  input logic blank,
							  input logic vga_clk,
                       output logic [3:0]  Red, Green, Blue );
							  
	 //PASS THIS IN FROM SOME OTHER MODULE THAT ACTUALLY CHANGES POSITION - ryu_on can be kept here its like ball_on
//	 logic [9:0] RyuX = 40;  // TOPLEFT position on the X axis
//    logic [9:0] RyuY = 220;  // TOPLEFT position on the Y axis
//	 logic [9:0] AkumaX = 502;
//	 logic [9:0] AkumaY = 220;
	 logic ryu_on;
	 logic akuma_on;
	 
	 //THE RYU STUFF IS ABOVE
	 logic [3:0] bg_red, bg_green, bg_blue;
	 logic [3:0] ryu_red, ryu_green, ryu_blue, akuma_red, akuma_green, akuma_blue;
//	  
//    int DistX1, DistY1, DistX2, DistY2, Size;
//	 assign DistX1 = DrawX - BallX1;
//    assign DistY1 = DrawY - BallY1;
//	 assign DistX2 = DrawX - BallX2;
//    assign DistY2 = DrawY - BallY2;
	 
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
	
	ryu_sprite ryu (
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuX(RyuX),
		.RyuY(RyuY),
		.blank(blank),
		.red(ryu_red),
		.green(ryu_green),
		.blue(ryu_blue),
		.ryu_on(ryu_on)
	);
	
	akuma_sprite akuma (
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(akuma_red),
		.green(akuma_green),
		.blue(akuma_blue),
		.akuma_on(akuma_on)
	);
		
	  
	 //logic for coloring ball or background (combinational since pixel logic is in ball.sv)
//    always_comb
//    begin:Ball_on_proc1
//        //if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
//		  if(DistX1 < 120 & DistX1 >= 0 & DistY1 < 180 & DistY1 >= 0)
//            ball_on1 = 1'b1;
//        else 
//            ball_on1 = 1'b0;
//     end
//	  
//	 always_comb
//    begin:Ball_on_proc2
//        //if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
//		  if(DistX2 < 120 & DistX2 >= 0 & DistY2 < 180 & DistY2 >= 0)
//            ball_on2 = 1'b1;
//        else 
//            ball_on2 = 1'b0;
//     end 
       
    always_comb
    begin:RGB_Display
		  if ((ryu_on == 1'b1))
		  begin
				Red = ryu_red;
				Green = ryu_green;
				Blue = ryu_blue;
		  end
		  else if ((akuma_on == 1'b1))
		  begin
				Red = akuma_red;
				Green = akuma_green;
				Blue = akuma_blue;
		  end
        else 
        begin
            Red = bg_red; 
            Green = bg_green;
            Blue = bg_blue;
        end      
    end 
    
endmodule
