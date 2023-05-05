module punch(input Reset, frame_clk, crouchP1, crouchP2, RyuLeft,
					input [7:0] keycode_0, keycode_1, keycode_2, keycode_3,
					input int XDist, P1Ypos, P2Ypos, P1Xpos, P2Xpos,
					output logic hitP1, hitP2, PunchP1, PunchP2, blockP1, blockP2,
					output int Ryu_Knockback, Akuma_Knockback
);
	 int fistPosP1;
	 int fistPosP2;

	 logic PunchInP1, PunchOutP1;
	 logic PunchInP2, PunchOutP2;
	 
	 parameter[7:0] keycode_punchP1 = 8'h06;
	 parameter[7:0] keycode_punchP2 = 8'h11;
	 
	 always_comb
	 begin
		fistPosP1 = P1Ypos + 30;
		fistPosP2 = P2Ypos + 60;
	 end
	
	 always_ff @ (posedge frame_clk)
	 begin: Knockback_Engine 
			PunchInP1 <= 1'b0;
			PunchInP2 <= 1'b0;
			hitP1 <= 1'b0;
			hitP2 <= 1'b0;
			blockP1 <= 1'b0;
			blockP2 <= 1'b0;
			
			if((keycode_0 == 8'h06) || (keycode_1 == 8'h06) || (keycode_2 == 8'h06) || (keycode_3 == 8'h06) && ~crouchP1)
				begin
					PunchInP1 <= 1'b1;
				end
			
			if((XDist < 135) && (fistPosP1 > P2Ypos) && PunchP1)
				begin
					if(crouchP2)
						blockP2 <= 1'b1;
					else
						hitP2 <= 1'b1;
				end
				
			if((keycode_0 == 8'h11) || (keycode_1 == 8'h11) || (keycode_2 == 8'h11) || (keycode_3 == 8'h11) && ~crouchP2)
				begin
					PunchInP2 <= 1'b1;
				end

			if((XDist < 135) && (fistPosP2 > P1Ypos) && PunchP2)
				begin
					if(crouchP1)
						blockP1 <= 1'b1;
					else
						hitP1 <= 1'b1;
				end
						
	 end
	 
	 KcontrolP1 KControlP1(
		.Reset(Reset),
		.clk(frame_clk),
		.Punch(hitP1),
		.Xpos(P1Xpos),
		.Ball_X_Motion(Ryu_Knockback),
		.crouch(crouchP1),
		.RyuLeft(RyuLeft)
		);
	 
	 KcontrolP2 KControlP2(
		.Reset(Reset),
		.clk(frame_clk),
		.Punch(hitP2),
		.Xpos(P2Xpos),
		.Ball_X_Motion(Akuma_Knockback),
		.crouch(crouchP2)
		);
	
	assign PunchP1 = PunchOutP1;
	assign PunchP2 = PunchOutP2;
	
	 PunchControl PunchControlP1(
		.Reset(Reset),
		.clk(frame_clk),
		.PunchIn(PunchInP1),
		.keycode_punch(keycode_punchP1),
		.keycode_0(keycode_0),
		.keycode_1(keycode_1),
		.keycode_2(keycode_2),
		.keycode_3(keycode_3),
		.PunchOut(PunchOutP1),
		.hit(hitP1)
	 );
	 
	 PunchControl PunchControlP2(
		.Reset(Reset),
		.clk(frame_clk),
		.PunchIn(PunchInP2),
		.keycode_punch(keycode_punchP2),
		.keycode_0(keycode_0),
		.keycode_1(keycode_1),
		.keycode_2(keycode_2),
		.keycode_3(keycode_3),
		.PunchOut(PunchOutP2),
		.hit(hitP2)
	 );
		
endmodule 