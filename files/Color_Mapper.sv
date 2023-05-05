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
							  input logic [7:0] RyuHealth, AkumaHealth,
							  input logic blank,
							  input logic vga_clk,
                       output logic [3:0]  Red, Green, Blue );
							  
	 logic ryu_on;
	 logic akuma_on;
	 logic health_on;
	 
	 logic [3:0] bg_red, bg_green, bg_blue;
	 logic [3:0] ryu_red, ryu_green, ryu_blue, akuma_red, akuma_green, akuma_blue;
	 
	 
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
		.sprite(3'b000), //change this index - look at ryu_sprite.sv
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
		.sprite(3'b000), //change this index
		.blank(blank),
		.red(akuma_red),
		.green(akuma_green),
		.blue(akuma_blue),
		.akuma_on(akuma_on)
	);
	
	health_sprite health (
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuHealth(RyuHealth),
		.AkumaHealth(AkumaHealth),
		.blank(blank),
		.health_on(health_on)
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
		  if ((health_on == 1'b1))
		  begin
				Red = 4'h0;
				Green = 4'hf;
				Blue = 4'h0;
		  end
		  else if ((ryu_on == 1'b1))
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
