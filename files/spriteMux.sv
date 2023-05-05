module spriteMux(
	input logic punch, jump, crouch, left, right, death,
	output logic[2:0] spriteIndex
	);
	
	logic [5:0] action;
	assign action[5] = death;
	assign action[4] = right;
	assign action[3] = left;
	assign action[2] = crouch;
	assign action[1] = jump;
	assign action[0] = punch;

	always_comb
	begin
		spriteIndex = 3'b000; //stand only
		casez(action)
			6'b000001: spriteIndex = 3'b001; //punch only
			6'b000010: spriteIndex = 3'b010; //jump only
			6'b000011: spriteIndex = 3'b001; //jump + punch
			6'b0??1??: spriteIndex = 3'b011; //crouch
			6'b001000: spriteIndex = 3'b100; //left only
			6'b001001: spriteIndex = 3'b001; //left + punch
			6'b001010: spriteIndex = 3'b010; //left + jump
			6'b001011: spriteIndex = 3'b001; //left + jump + punch
			6'b010000: spriteIndex = 3'b101; //right only
			6'b010001: spriteIndex = 3'b001; //right + punch
			6'b010010: spriteIndex = 3'b010; //right + jump
			6'b010011: spriteIndex = 3'b001; //right + jump + punch
			6'b011000: spriteIndex = 3'b101; //right + left
			6'b011001: spriteIndex = 3'b001; //right + left + punch
			6'b011010: spriteIndex = 3'b010; //right + left + jump
			6'b011011: spriteIndex = 3'b001; //right + left + jump + punch
			6'b1?????: spriteIndex = 3'b110; //death
			default: ;
		endcase
	end	
	
	//000 = stand sprite
	//001 = punch sprite
	//010 = jump sprite
	//011 = crouch sprite
	//100 = left sprite
	//101 = right sprite
	//110 = death sprite

endmodule
	
	