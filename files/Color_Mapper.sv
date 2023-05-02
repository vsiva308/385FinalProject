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


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
							  input logic blank,
							  input logic vga_clk,
                       output logic [3:0]  Red, Green, Blue );
    
    logic ball_on;
	 logic [3:0] bg_red, bg_green, bg_blue;
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
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
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) //ball
        begin 
            Red = 4'hf;
            Green = 4'h5;
            Blue = 4'hf;
        end       
        else 
        begin //background
            Red = bg_red; 
            Green = bg_green;
            Blue = bg_blue;
        end      
    end 
    
endmodule
