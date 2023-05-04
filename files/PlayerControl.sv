module  PlayerControl ( input Reset, frame_clk,
					input [7:0] keycode_0, keycode_1, keycode_2, keycode_3,
               output [9:0]  Player1X, Player1Y, Player2X, Player2Y);
					
					
    logic [9:0] Player1_X_Pos, Player1_Y_Pos;
	 logic [9:0] Player1_X_Motion, Player1_Y_Motion;
	 
	 logic [9:0] Player2_X_Pos, Player2_Y_Pos;
	 logic [9:0] Player2_X_Motion, Player2_Y_Motion;
	 
    parameter [9:0] Player1_X_Center=40;  // Center position on the X axis
	 parameter [9:0] Player2_X_Center=480;  // Center position on the X axis
    parameter [9:0] Player1_Y_Center=220;  // Center position on the Y axis
	 parameter [9:0] Player2_Y_Center=160;  // Topleft position on the Y axis
    parameter [9:0] Bound_X_Min=4;       // Leftmost point on the X axis
    parameter [9:0] Bound_X_Max=639;     // Rightmost point on the X axis
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
	 
	 logic[9:0] overlap_left;
	 logic[9:0] overlap_right;
	 logic[9:0] overlap_top;
	 logic[9:0] overlap_bottom;
	 
	 int Player1_Collision_X;
	 int Player1_Collision_Y;
	 int Player2_Collision_X;
	 int Player2_Collision_Y;
	 
	 logic[9:0] keycodeAllP1X, keycodeAllP1Y, keycodeAllP2X, keycodeAllP2Y;
	 
	 logic[9:0] keycode_0P1X, keycode_0P1Y, keycode_0P2X, keycode_0P2Y;
	 logic[9:0] keycode_1P1X, keycode_1P1Y, keycode_1P2X, keycode_1P2Y;
	 logic[9:0] keycode_2P1X, keycode_2P1Y, keycode_2P2X, keycode_2P2Y;
	 logic[9:0] keycode_3P1X, keycode_3P1Y, keycode_3P2X, keycode_3P2Y;
	 
	 assign Player1X = Player1_X_Pos;
    assign Player1Y = Player1_Y_Pos;
	 
	 assign Player2X = Player2_X_Pos;
    assign Player2Y = Player2_Y_Pos;
	
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
				//if ((keycode_0 >= 8'h20 || keycode_0 == 8'h00) && (keycode_1 >= 8'h20 || keycode_1 == 8'h00) && (keycode_2 <= 8'h20 || keycode_2 == 0) && (keycode_3 <= 8'h20 || keycode_3 == 8'h00))
					//begin
						//Player1_X_Motion <= 0;
						//JumpP1 = 0;
					//end
				if (keycode_0 == 8'h04 || keycode_1 == 8'h04 || keycode_2 == 8'h04 || keycode_3 == 8'h04)
					begin
						Player1_X_Motion <= -2;//A
						JumpP1 <= 0;
					end
				if (keycode_0 == 8'h07 || keycode_1 == 8'h07 || keycode_2 == 8'h07 || keycode_3 == 8'h07)
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

			
				Player1_Y_Pos <= (Player1_Y_Pos + Player1_Y_Motion + Player1_Collision_Y);  // Update ball position
				Player1_X_Pos <= (Player1_X_Pos + Player1_X_Motion + Player1_Collision_X);	
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
				if (keycode_0 == 8'h0d || keycode_1 == 8'h0d || keycode_2 == 8'h0d || keycode_3 == 8'h0d)
					begin
						Player2_X_Motion <= -2;//A
						JumpP2 <= 0;
					end
				if (keycode_0 == 8'h0f || keycode_1 == 8'h0f || keycode_2 == 8'h0f || keycode_3 == 8'h0f)
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
				 
				Player2_Y_Pos <= (Player2_Y_Pos + Player2_Y_Motion + Player2_Collision_Y);  // Update ball position
				Player2_X_Pos <= (Player2_X_Pos + Player2_X_Motion + Player2_Collision_X);
				end

				
		  end
	 logic JumpP2 = 1'b0;
	 
	 Jcontrol JumpControl2(
		.Reset(Reset),
		.clk(frame_clk),
		.Jump(JumpP2),
		.Ball_Y_Motion(Player2_Y_Motion)
		);
	
	 
	 
	 always_comb
		begin
			Player1_left = Player1_X_Pos;
			Player1_right = Player1_X_Pos + Player1_Width;
			Player1_top = Player1_Y_Pos; 
			Player1_bottom = Player1_Y_Pos + Player1_Height;
			
			Player2_left = Player2_X_Pos; 
			Player2_right = Player2_X_Pos + Player2_Width;
			Player2_top = Player2_Y_Pos; 
			Player2_bottom = Player2_Y_Pos + Player2_Height;
			
			//overlap_left = Player1_left - Player2_right; 
			//overlap_right = Player2_left - Player1_right;
			//overlap_top = Player1_top - Player2_bottom;
			//overlap_bottom = Player2_top - Player1_bottom;
		end
	 
	 	 
	 always_ff @ (posedge Reset or posedge frame_clk)
	 begin: Collision_Engine
			if(Reset)
			begin
					Player1_Collision_X <= 0;
					Player1_Collision_Y <= 0;
					Player2_Collision_X <= 0;
					Player2_Collision_Y <= 0;
					//overlap_left <= 0;
					//overlap_right <= 0;
					//overlap_top <= 0;
					//overlap_bottom <= 0;
			end
			else
				begin 
				if((Player1_right) >= Bound_X_Max)
					begin
						Player1_Collision_X <= Bound_X_Max - Player1_right;
					end
				else if((Player1_X_Pos) <= Bound_X_Min)
					begin
						Player1_Collision_X <= Bound_X_Min - Player1_X_Pos;
					end
				else
					begin
						Player1_Collision_X <= 0;
						Player1_Collision_Y <= 0;
					end
					
					
				if((Player2_right) >= Bound_X_Max)
					begin
						Player2_Collision_X <= Bound_X_Max - Player2_right;
					end
				else if(Player2_X_Pos <= Bound_X_Min)
					begin
						Player2_Collision_X <= Bound_X_Min - Player2_X_Pos;
					end
				else
					begin
						Player2_Collision_X <= 0;
						Player2_Collision_Y <= 0;
					end
				end
				
				//if((overlap_left != 0) && (Player1_left < Player2_right))
					//begin
						//Player1_Collision_X <= overlap_left;
						//Player2_Collision_X <= overlap_right;
					//end
				
	 end

endmodule