module KcontrolP1 (input clk, Punch, Reset, crouch, RyuLeft,
					input int Xpos,
					output int Ball_X_Motion);
					
	enum logic [7:0] {Rest, A, A1, B, B1, C, C1, D, D1, E, E1, F, F1, G, G1, H, H1, I, I1, J, J1, K, K1, L, L1, M, M1, N, N1, O, O1, P, Q, R, S, T, U} curr_jstate, next_jstate;
	
	parameter [9:0] Bound_X_Min=10;
	//logic[9:0] Bound_X_Min;
		
	 //always_comb
	 //begin
		//if(RyuLeft)
			//Bound_X_Min = 10;
		//else
			//Bound_X_Min = 7;
			
	 //end
	
	int leftWallDist;
	
	always_comb
	begin
		//if(RyuLeft)
			//leftWallDist = Xpos - Bound_X_Min-3;
		//else
			leftWallDist = Xpos - Bound_X_Min;
	end
	
	always_ff @ (posedge clk)
	begin
		curr_jstate <= next_jstate;
	end
	
	
	always_comb
	begin
		next_jstate = curr_jstate;
	
		unique case(curr_jstate)
			Rest: 
				begin
					if(crouch)
						next_jstate = D;
					if(Punch)
					begin
						if(leftWallDist < 9)
						begin
							next_jstate = Rest;
						end
					else
						begin
							next_jstate = A;
						end
					end
				end
				
			A: begin
					//if(Xpos < Bound_X_Min)
						//next_jstate = H;
					if(leftWallDist < 8)
						begin
							next_jstate = G;
						end
					else
						begin
							next_jstate = B;
						end
				end
			B: begin
					//if(Xpos < Bound_X_Min)
						//next_jstate = H;
					if(leftWallDist < 7)
						begin
							next_jstate = G;
						end
					else
						begin
							next_jstate = C;
						end
				end
			C: begin
					//if(Xpos < Bound_X_Min)
						//next_jstate = H;
					if(leftWallDist < 6)
						begin
							next_jstate = G;
						end
					else
						begin
							next_jstate = D;
						end
				end
			D: begin
					//if(Xpos < Bound_X_Min)
						//next_jstate = H;
					if(leftWallDist < 5)
						begin
							next_jstate = G;
						end
					else
						begin
							next_jstate = E;
						end
				end
			E: begin
					//if(Xpos < Bound_X_Min)
						//next_jstate = H;
					if(leftWallDist < 4)
						begin
							next_jstate = G;
						end
					else
						begin
							next_jstate = F;
						end
				end
			F: next_jstate = Rest;
			G: next_jstate = Rest;
			
		endcase
		
		case(curr_jstate)
			Rest: Ball_X_Motion = 0;
			A: Ball_X_Motion = -8;
			B: Ball_X_Motion = -8;
			C:	Ball_X_Motion = -7;
			D: Ball_X_Motion = -6;
			E: Ball_X_Motion = -5;
			F: Ball_X_Motion = -5;
			G: begin
				//if(leftWallDist < 0) 
					//Ball_X_Motion = ((-2*leftWallDist));
				//else 
					Ball_X_Motion = (-1*leftWallDist); 
				end
		endcase
	end
endmodule