module spriteMux(
	input logic clk, Reset,
	input logic punch, jump, crouch, left, right, death,
	output logic[3:0] Index
	);
	
	logic pulseFSM;
	logic [3:0] pulseIndex, spriteIndex;
	logic [5:0] action;
	assign action[5] = death;
	assign action[4] = right;
	assign action[3] = left;
	assign action[2] = crouch;
	assign action[1] = jump;
	assign action[0] = punch;
	//assign pulseFSM = 1'b0;
	
	always_comb
	begin
		pulseFSM = 1'b0;
		casez(action)
			6'b000000: begin
						  pulseFSM = 1'b1;
						  spriteIndex =4'b0000;
						  end
			6'b000001: spriteIndex = 4'b0010; //punch only
			6'b000010: spriteIndex = 4'b0011; //jump only
			6'b000011: spriteIndex = 4'b1000; //jump + punch
			6'b0??1??: spriteIndex = 4'b0100; //crouch
			6'b001000: spriteIndex = 4'b0101; //left only
			6'b001001: spriteIndex = 4'b0010; //left + punch
			6'b001010: spriteIndex = 4'b0011; //left + jump
			6'b001011: spriteIndex = 4'b1000; //left + jump + punch
			6'b010000: spriteIndex = 4'b0110; //right only
			6'b010001: spriteIndex = 4'b0010; //right + punch
			6'b010010: spriteIndex = 4'b0011; //right + jump
			6'b010011: spriteIndex = 4'b1000; //right + jump + punch
			6'b011000: spriteIndex = 4'b0110; //right + left
			6'b011001: spriteIndex = 4'b0010; //right + left + punch
			6'b011010: spriteIndex = 4'b0011; //right + left + jump
			6'b011011: spriteIndex = 4'b1000; //right + left + jump + punch
			6'b1?????: spriteIndex = 4'b0111; //death
			default: ;
		endcase
		
		if(pulseFSM)
			Index = pulseIndex;
		else
			Index = spriteIndex;
	end

	//0000 = stand sprite
	//0001 = pulse sprite
	//0010 = punch sprite
	//0011 = jump sprite
	//0100 = crouch sprite
	//0101 = left sprite
	//0110 = right sprite
	//0111 = death sprite
	//1000 = jumping punch sprite
		
	logic clkdiv, clkdiv2;
	
	enum logic [7:0] {Rest, A, A1, B, B1, C, C1, D, D1, E, E1, F, F1, G, G1, H, H1, I, I1, J, J1, K, K1, L, L1, M, M1, N, N1, O, O1, P, Q, R, S, T, U} curr_state, next_state;
	
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
	
	always_ff @ (posedge clkdiv2)
	begin
		curr_state <= next_state;
	end
	
	always_comb
	begin
		next_state = curr_state;
		
		unique case(curr_state)			
			A: next_state = B;
			B: next_state = C;
			C: next_state = D;
			D: next_state = E;
			E: next_state = F;
			F: next_state = G;
			G: next_state = H;
			H: next_state = I;
			I: next_state = J;
			J: next_state = K;
			K: next_state = L;
			L: next_state = A;
		endcase
		
		
		case(curr_state)
			A: pulseIndex = 4'b0000;
			B: pulseIndex = 4'b0000;
			C: pulseIndex = 4'b0000;
			D: pulseIndex = 4'b0000;
			E: pulseIndex = 4'b0000;
			F: pulseIndex = 4'b0000;
			G: pulseIndex = 4'b0001;
			H: pulseIndex = 4'b0001;
			I: pulseIndex = 4'b0001;
			J: pulseIndex = 4'b0001;
			K: pulseIndex = 4'b0001;
			L: pulseIndex = 4'b0001;
		endcase
	end

endmodule
	
	