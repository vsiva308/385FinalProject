module  ryu ( input Reset, frame_clk,
					input [7:0] keycode_0, keycode_1, keycode_2, keycode_3,
					input int XDist, Ryu_Knockback,
               output logic [9:0]  RyuX, RyuY,
					output logic RyuJump, RyuCrouch, RyuLeft, RyuRight);
					
	 int Ryu_X_Pos, Ryu_Y_Pos;
	 int Ryu_X_Motion, Ryu_Y_Motion;
	 
	 parameter [9:0] Ryu_X_Center=40;  // Center position on the X axis
    parameter [9:0] Ryu_Y_Center=215;  // Center position on the Y axis
	 
	 int Ryu_Width = 120;
	 int Ryu_Height = 180;
	 
	 parameter [9:0] Bound_X_Min=7;       // Leftmost point on the X axis
	 
	 assign RyuX = Ryu_X_Pos;
	 assign RyuY = Ryu_Y_Pos;
					
					
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ryu
        if (Reset)  // Asynchronous Reset
        begin 
            //Ryu_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ryu_X_Motion <= 10'd0; //Ball_X_Step;
				Ryu_Y_Pos <= Ryu_Y_Center;
				Ryu_X_Pos <= Ryu_X_Center;
        end	
		  else
				begin
				Ryu_X_Motion <= 0;
				JumpP1 <= 0;
				RyuLeft = 1'b0;
				RyuRight = 1'b0;
				RyuCrouch = 1'b0;
				if ((keycode_0 == 8'h04 || keycode_1 == 8'h04 || keycode_2 == 8'h04 || keycode_3 == 8'h04) && (Ryu_X_Pos > Bound_X_Min))
					begin
						Ryu_X_Motion <= -2;//A
						JumpP1 <= 0;
						RyuLeft = 1'b1;
					end
				if ((keycode_0 == 8'h07 || keycode_1 == 8'h07 || keycode_2 == 8'h07 || keycode_3 == 8'h07) && (XDist > 105))
					begin
						Ryu_X_Motion <= 2;//D
						JumpP1 <= 0;
						RyuRight = 1'b1;
					end
				if (keycode_0 == 8'h16 || keycode_1 == 8'h16 || keycode_2 == 8'h16 || keycode_3 == 8'h16)
					begin
						JumpP1 <= 0; //S
						Ryu_X_Motion <= 0;
						RyuCrouch = 1'b1;
					end
				if (keycode_0 == 8'h1A || keycode_1 == 8'h1A || keycode_2 == 8'h1A || keycode_3 == 8'h1A)
					begin
						JumpP1 <= 1; //W
					end

			
				Ryu_Y_Pos <= (Ryu_Y_Pos + Ryu_Y_Motion);  // Update ball position
				Ryu_X_Pos <= (Ryu_X_Pos + Ryu_X_Motion + Ryu_Knockback);	
				end
			end
	 logic JumpP1 = 1'b0;
	 
	 Jcontrol JumpControl1(
		.Reset(Reset),
		.clk(frame_clk),
		.Jump(JumpP1),
		.Ball_Y_Motion(Ryu_Y_Motion),
		.Jmp(RyuJump)
		);
		
endmodule 