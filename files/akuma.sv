module  akuma ( input Reset, frame_clk,
					input [7:0] keycode_0, keycode_1, keycode_2, keycode_3,
					input logic GamePlaying,
					input int XDist, Akuma_Knockback,
               output logic [9:0]  AkumaX, AkumaY,
					output logic AkumaJump, AkumaCrouch, AkumaLeft, AkumaRight);
			
	 int Akuma_X_Pos, Akuma_Y_Pos;
	 int Akuma_X_Motion, Akuma_Y_Motion;
	 
	 parameter [9:0] Akuma_X_Center=480;  // Center position on the X axis
	 parameter [9:0] Akuma_Y_Center=170;  // Topleft position on the Y axis
	 parameter [9:0] Bound_X_Max=629;     // Rightmost point on the X axis
	 
	 int Akuma_Width = 140;
	 int Akuma_Height = 240;
	 
	 assign AkumaX = Akuma_X_Pos;
	 assign AkumaY = Akuma_Y_Pos;
	 
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Akuma
		
        if (Reset)  // Asynchronous Reset
        begin 
				Akuma_X_Motion <= 10'd0; //Movement;
				Akuma_Y_Pos <= Akuma_Y_Center;
				Akuma_X_Pos <= Akuma_X_Center;
        end
		  else if (GamePlaying)
				begin
				Akuma_X_Motion <= 0;
				JumpP2 <= 0;
				AkumaLeft <= 1'b0;
				AkumaRight <= 1'b0;
				AkumaCrouch <= 1'b0;
				if ((keycode_0 == 8'h0d || keycode_1 == 8'h0d || keycode_2 == 8'h0d || keycode_3 == 8'h0d) && (XDist > 105))
					begin
						Akuma_X_Motion <= -2;//A
						JumpP2 <= 0;
						AkumaLeft <= 1'b1;
					end
				if ((keycode_0 == 8'h0f || keycode_1 == 8'h0f || keycode_2 == 8'h0f || keycode_3 == 8'h0f) && ((Akuma_X_Pos + 125) < Bound_X_Max))
					begin
						Akuma_X_Motion <= 2;//D
						JumpP2 <= 0;
						AkumaRight <= 1'b1;
					end
				if (keycode_0 == 8'h0e || keycode_1 == 8'h0e || keycode_2 == 8'h0e || keycode_3 == 8'h0e)
					begin
						JumpP2 <= 0; //S
						Akuma_X_Motion <= 0;
						AkumaCrouch <= 1'b1;
					end
				if (keycode_0 == 8'h0c || keycode_1 == 8'h0c || keycode_2 == 8'h0c || keycode_3 == 8'h0c)
					begin
						JumpP2 <= 1; //W
					end
				 
				Akuma_Y_Pos <= (Akuma_Y_Pos + Akuma_Y_Motion);  // Update ball position
				if(Akuma_X_Pos > Bound_X_Max)
					Akuma_X_Pos <= Bound_X_Max;
				else
					Akuma_X_Pos <= (Akuma_X_Pos + Akuma_X_Motion + Akuma_Knockback);	
				end
			end

	 logic JumpP2 = 1'b0;
	 
	 Jcontrol JumpControl2(
		.Reset(Reset),
		.clk(frame_clk),
		.Jump(JumpP2),
		.Ball_Y_Motion(Akuma_Y_Motion),
		.Jmp(AkumaJump)
		);
		
endmodule 