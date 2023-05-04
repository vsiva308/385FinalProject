module KcontrolP2 (input clk, Punch, Reset,
					output int Ball_X_Motion);
					
	enum logic [7:0] {Rest, A, A1, B, B1, C, C1, D, D1, E, E1, F, F1, G, G1, H, H1, I, I1, J, J1, K, K1, L, L1, M, M1, N, N1, O, O1, P, Q, R, S, T, U} curr_jstate, next_jstate;
	
	always_ff @ (posedge clk)
	begin
		curr_jstate <= next_jstate;
	end
	
	
	always_comb
	begin
		next_jstate = curr_jstate;
	
	
		unique case(curr_jstate)
			Rest: if(Punch)
				next_jstate = A;
				
			A: next_jstate = A1;
			A1: next_jstate = B;
			B: next_jstate = B1;
			B1: next_jstate = C;
			C: next_jstate = C1;
			C1: next_jstate = Rest;
		endcase
		
		case(curr_jstate)
			Rest: Ball_X_Motion = 0;
			A: Ball_X_Motion = 7;
			A1: Ball_X_Motion = 7;
			B:	Ball_X_Motion = 5;
			B1: Ball_X_Motion = 5;
			C: Ball_X_Motion = 3;
			C1: Ball_X_Motion = 3;
		endcase
	end
endmodule