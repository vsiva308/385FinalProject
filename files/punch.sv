module punch(input Reset, frame_clk,
					input [7:0] keycode_0, keycode_1, keycode_2, keycode_3,
					input int XDist, P1Ypos, P2Ypos, P1Xpos, P2Xpos,
					output logic hitP1, hitP2, PunchP1, PunchP2,
					output int Ryu_Knockback, Akuma_Knockback
);
	 int fistPosP1;
	 int fistPosP2;

	 always_comb
	 begin
		fistPosP1 = P1Ypos + 30;
		fistPosP2 = P2Ypos + 60;
	 end
	
	 always_ff @ (posedge frame_clk)
	 begin: Knockback_Engine 
			PunchP1 <= 1'b0;
			PunchP2 <= 1'b0;
			hitP1 <= 1'b0;
			hitP2 <= 1'b0;
			
			if((keycode_0 == 8'h06) || (keycode_1 == 8'h06) || (keycode_2 == 8'h06) || (keycode_3 == 8'h06))
				begin
					PunchP1 <= 1'b1;
					if((XDist < 135) && (fistPosP1 > P2Ypos))
						begin
							hitP2 <= 1'b1;
						end
				end
				
			if((keycode_0 == 8'h11) || (keycode_1 == 8'h11) || (keycode_2 == 8'h11) || (keycode_3 == 8'h11))
				begin
					PunchP2 <= 1'b1;
					if((XDist < 135) && (fistPosP2 > P1Ypos))
						begin
							hitP1 <= 1'b1;
						end
				end				
	 end
	 
	 KcontrolP1 KControlP1(
		.Reset(Reset),
		.clk(frame_clk),
		.Punch(hitP1),
		.Xpos(P1Xpos),
		.Ball_X_Motion(Ryu_Knockback)
		);
	 
	 KcontrolP2 KControlP2(
		.Reset(Reset),
		.clk(frame_clk),
		.Punch(hitP2),
		.Xpos(P2Xpos),
		.Ball_X_Motion(Akuma_Knockback)
		);
		
endmodule 