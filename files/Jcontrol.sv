module Jcontrol (input clk, Jump, Reset,
					output[9:0] Ball_Y_Motion);
					
	enum logic [7:0] {Rest, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W} curr_jstate, next_jstate;
	
	logic clkdiv, clkdiv2, clkdiv3, jumpclk;
	
	always_ff @ (posedge clk or posedge Reset )
    begin 
        if (Reset) 
            clkdiv <= 1'b0;
        else 
            clkdiv <= ~ (clkdiv);
    end
	
	always_ff @ (posedge clkdiv or posedge Reset )
    begin 
        if (Reset) 
            clkdiv2 <= 1'b0;
        else 
            clkdiv2 <= ~ (clkdiv2);
    end
	 
	 always_ff @ (posedge clkdiv2 or posedge Reset )
    begin 
        if (Reset) 
            clkdiv3 <= 1'b0;
        else 
            clkdiv3 <= ~ (clkdiv3);
    end
	 
	 always_ff @ (posedge clkdiv3 or posedge Reset )
    begin 
        if (Reset) 
            jumpclk <= 1'b0;
        else 
            jumpclk <= ~ (jumpclk);
    end
	
	always_ff @ (posedge clkdiv2)
	begin
		curr_jstate <= next_jstate;
	end
	
	
	always_comb
	begin
		next_jstate = curr_jstate;
	
	
		unique case(curr_jstate)
			Rest: if(Jump)
				next_jstate = A;
				
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
			Q: next_jstate = R;
			R: next_jstate = S;
			S: next_jstate = T;
			T: next_jstate = U;
			U: next_jstate = Rest;
		endcase
		
		case(curr_jstate)
			Rest: Ball_Y_Motion = 0;
			A: Ball_Y_Motion = -12;
			B:	Ball_Y_Motion = -9;
			C: Ball_Y_Motion = -9;
			D: Ball_Y_Motion = -6;
			E: Ball_Y_Motion = -6;
			F: Ball_Y_Motion = -3;
			G: Ball_Y_Motion = -3;
			H: Ball_Y_Motion = 0;
			I: Ball_Y_Motion = 3;
			J: Ball_Y_Motion = 3;
			K: Ball_Y_Motion = 6;
			L: Ball_Y_Motion = 6;
			M: Ball_Y_Motion = 9;
			N: Ball_Y_Motion = 9;
			O: Ball_Y_Motion = 12;
			P: Ball_Y_Motion = 0;
			Q: Ball_Y_Motion = 0;
			R: Ball_Y_Motion = 0;
			S: Ball_Y_Motion = 0;
			T: Ball_Y_Motion = 0;
			U: Ball_Y_Motion = 0;
			default: Ball_Y_Motion = 0;
		endcase
	end
endmodule