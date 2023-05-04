module  PlayerControl ( input Reset, frame_clk,
					input [7:0] keycode_0, keycode_1, keycode_2, keycode_3,
               output [9:0]  Player1X, Player1Y, Player2X, Player2Y);
					
					
    int Player1_X_Pos, Player1_Y_Pos;
	 int Player1_X_Motion, Player1_Y_Motion;
	 
	 int Player2_X_Pos, Player2_Y_Pos;
	 int Player2_X_Motion, Player2_Y_Motion;
	 
    parameter [9:0] Player1_X_Center=40;  // Center position on the X axis
	 parameter [9:0] Player2_X_Center=480;  // Center position on the X axis
    parameter [9:0] Player1_Y_Center=215;  // Center position on the Y axis
	 parameter [9:0] Player2_Y_Center=170;  // Topleft position on the Y axis
    parameter [9:0] Bound_X_Min=2;       // Leftmost point on the X axis
    parameter [9:0] Bound_X_Max=637;     // Rightmost point on the X axis
    parameter [9:0] Bound_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bound_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=2;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=2;      // Step size on the Y axis
	 
	 int Player1_Width = 120;
	 int Player1_Height = 180;

	 int Player2_Width = 140;
	 int Player2_Height = 240;
	 
	 int Player1_left;
	 int Player1_right;
	 int Player1_top;
	 int Player1_bottom;
	 
	 int Player2_left;
	 int Player2_right;
	 int Player2_top;
	 int Player2_bottom;
	 
	 int XDist;
	 
	 int Player1_Knockback;
	 int Player2_Knockback;
	 
	 logic[9:0] keycodeAllP1X, keycodeAllP1Y, keycodeAllP2X, keycodeAllP2Y;
	 
	 logic[9:0] keycode_0P1X, keycode_0P1Y, keycode_0P2X, keycode_0P2Y;
	 logic[9:0] keycode_1P1X, keycode_1P1Y, keycode_1P2X, keycode_1P2Y;
	 logic[9:0] keycode_2P1X, keycode_2P1Y, keycode_2P2X, keycode_2P2Y;
	 logic[9:0] keycode_3P1X, keycode_3P1Y, keycode_3P2X, keycode_3P2Y;
	 
	 assign Player1X = Player1_X_Pos;
    assign Player1Y = Player1_Y_Pos;
	 
	 assign Player2X = Player2_X_Pos;
    assign Player2Y = Player2_Y_Pos;
	 
	 assign XDist = Player2_X_Pos - Player1_X_Pos;
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Player1
        if (Reset)  // Asynchronous Reset
        begin 
            //Player1_Y_Motion <= 10'd0; //Ball_Y_Step;
				Player1_X_Motion <= 10'd0; //Ball_X_Step;
				Player1_Y_Pos <= Player1_Y_Center;
				Player1_X_Pos <= Player1_X_Center;
        end	
		  else
				begin
				Player1_X_Motion <= 0;
				JumpP1 <= 0;
				if ((keycode_0 == 8'h04 || keycode_1 == 8'h04 || keycode_2 == 8'h04 || keycode_3 == 8'h04) && (Player1_X_Pos > Bound_X_Min))
					begin
						Player1_X_Motion <= -2;//A
						JumpP1 <= 0;
					end
				if ((keycode_0 == 8'h07 || keycode_1 == 8'h07 || keycode_2 == 8'h07 || keycode_3 == 8'h07) && (XDist > 105))
					begin
						Player1_X_Motion <= 2;//D
						JumpP1 <= 0;
					end
				if (keycode_0 == 8'h16 || keycode_1 == 8'h16 || keycode_2 == 8'h16 || keycode_3 == 8'h16)
					begin
						JumpP1 <= 0; //S
						Player1_X_Motion <= 0;
					end
				if (keycode_0 == 8'h1A || keycode_1 == 8'h1A || keycode_2 == 8'h1A || keycode_3 == 8'h1A)
					begin
						JumpP1 <= 1; //W
					end

			
				Player1_Y_Pos <= (Player1_Y_Pos + Player1_Y_Motion);  // Update ball position
				Player1_X_Pos <= (Player1_X_Pos + Player1_X_Motion + Player1_Knockback);	
				end
			end
	 logic JumpP1 = 1'b0;
	 
	 Jcontrol JumpControl1(
		.Reset(Reset),
		.clk(frame_clk),
		.Jump(JumpP1),
		.Ball_Y_Motion(Player1_Y_Motion)
		); 
			
	always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Player2
		
        if (Reset)  // Asynchronous Reset
        begin 
            //Player1_Y_Motion <= 10'd0; //Ball_Y_Step;
				Player2_X_Motion <= 10'd0; //Ball_X_Step;
				Player2_Y_Pos <= Player2_Y_Center;
				Player2_X_Pos <= Player2_X_Center;
        end
		  else
				begin
				Player2_X_Motion <= 0;
				JumpP2 = 0;
				if ((keycode_0 == 8'h0d || keycode_1 == 8'h0d || keycode_2 == 8'h0d || keycode_3 == 8'h0d) && (XDist > 105))
					begin
						Player2_X_Motion <= -2;//A
						JumpP2 <= 0;
					end
				if ((keycode_0 == 8'h0f || keycode_1 == 8'h0f || keycode_2 == 8'h0f || keycode_3 == 8'h0f) && ((Player2_X_Pos + 125) < Bound_X_Max))
					begin
						Player2_X_Motion <= 2;//D
						JumpP2 <= 0;
					end
				if (keycode_0 == 8'h0e || keycode_1 == 8'h0e || keycode_2 == 8'h0e || keycode_3 == 8'h0e)
					begin
						JumpP2 <= 0; //S
						Player2_X_Motion <= 0;
					end
				if (keycode_0 == 8'h0c || keycode_1 == 8'h0c || keycode_2 == 8'h0c || keycode_3 == 8'h0c)
					begin
						JumpP2 <= 1; //W
					end
				 
				Player2_Y_Pos <= (Player2_Y_Pos + Player2_Y_Motion);  // Update ball position
				Player2_X_Pos <= (Player2_X_Pos + Player2_X_Motion + Player2_Knockback);
				end

				
		  end
	 logic JumpP2 = 1'b0;
	 
	 Jcontrol JumpControl2(
		.Reset(Reset),
		.clk(frame_clk),
		.Jump(JumpP2),
		.Ball_Y_Motion(Player2_Y_Motion)
		);

	 always_ff @ (posedge frame_clk)
	 begin: Knockback_Engine 
			PunchP1 = 1'b0;
			PunchP2 = 1'b0;
				
			if((XDist < 120) && ((keycode_0 == 8'h06) || (keycode_1 == 8'h06) || (keycode_2 == 8'h06) || (keycode_3 == 8'h06)))
				begin
					PunchP2 <= 1'b1;
				end
			if((XDist < 120) && ((keycode_0 == 8'h11) || (keycode_1 == 8'h11) || (keycode_2 == 8'h11) || (keycode_3 == 8'h11)))
				begin
					PunchP1 <= 1'b1;
				end				
	 end
	 
	 logic PunchP1 = 1'b0;
	 logic PunchP2 = 1'b0;
	 
	 KcontrolP1 KControlP1(
		.Reset(Reset),
		.clk(frame_clk),
		.Punch(PunchP1),
		.Ball_X_Motion(Player1_Knockback)
		);
	 
	 KcontrolP2 KControlP2(
		.Reset(Reset),
		.clk(frame_clk),
		.Punch(PunchP2),
		.Ball_X_Motion(Player2_Knockback)
		);
	 
	 
	
endmodule 