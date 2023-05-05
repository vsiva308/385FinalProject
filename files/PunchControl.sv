module PunchControl (input clk, PunchIn, Reset, hit,
					input logic[7:0] keycode_0, keycode_1, keycode_2, keycode_3, keycode_punch,
					output logic PunchOut);
					
	enum logic [7:0] {Rest, A, A1, B, B1, C, C1, D, D1, E, E1, F, F1, G, G1, H, H1, I, I1, J, J1, K, K1, L, L1, M, M1, N, N1, O, O1, P, Q, R, S, T, U} curr_jstate, next_jstate;
	logic clkdiv;
	
	always_ff @ (posedge clk or posedge Reset )
    begin 
        if (Reset) 
            clkdiv <= 1'b0;
        else 
            clkdiv <= ~ (clkdiv);
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
					if(PunchIn)
						next_jstate = A;
					if(hit)
						next_jstate = J;
				end
				
			A: next_jstate = B;
			B: next_jstate = C;
			C: next_jstate = D;
			D: next_jstate = E;
			E: next_jstate = F;
			F: next_jstate = G;
			G: next_jstate = H;
			H: next_jstate = I;
			I: next_jstate = J;
			J: next_jstate = K;
			K: next_jstate = L;
			L: next_jstate = M;
			M: next_jstate = N;
			N: next_jstate = O;
			O: next_jstate = P;
			P: next_jstate = Q;
			Q: begin
					if((keycode_0 == keycode_punch) || (keycode_1 == keycode_punch) || (keycode_2 == keycode_punch) || (keycode_3 == keycode_punch))
						begin
							next_jstate = M;
						end
					else
						begin
							next_jstate = Rest;
						end
				end
			//R: next_jstate = S;
			//S: next_jstate = T;
			//T: next_jstate = U;
			//U: next_jstate = Rest;
		endcase
		
		case(curr_jstate)
			Rest: PunchOut = 1'b0;
			A: PunchOut = 1'b1;
			B:	PunchOut = 1'b1;
			C: PunchOut = 1'b1;
			D: PunchOut = 1'b1;
			E: PunchOut = 1'b1;
			F: PunchOut = 1'b1;
			G: PunchOut = 1'b1;
			H: PunchOut = 1'b0;
			I: PunchOut = 1'b0;
			J: PunchOut = 1'b0;
			K: PunchOut = 1'b0;
			L: PunchOut = 1'b0;
			M: PunchOut = 1'b0;
			N: PunchOut = 1'b0;
			O: PunchOut = 1'b0;
			P: PunchOut = 1'b0;
			Q: PunchOut = 1'b0;
			//R: Ball_Y_Motion = 0;
			//S: Ball_Y_Motion = 0;
			//T: Ball_Y_Motion = 0;
			//U: Ball_Y_Motion = 0;
			default: PunchOut = 1'b0;
		endcase
	end
endmodule