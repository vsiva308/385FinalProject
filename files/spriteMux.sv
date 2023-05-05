module spriteMux(
	input logic punch, jump,
	output logic[2:0] spriteIndex
	);
	
	logic [5:0] action;
	assign action[5] = 1'b0;
	assign action[4] = 1'b0;
	assign action[3] = 1'b0;
	assign action[2] = 1'b0;
	assign action[1] = jump;
	assign action[0] = punch;

	always_comb
	begin
		spriteIndex = 3'b000;
			
		case(action)
			6'b000001: spriteIndex = 3'b001; //punch only
			6'b000010: spriteIndex = 3'b010; //jump only
			6'b000011: spriteIndex = 3'b001; //jump + punch
			default: ;
		endcase
	end	
			

endmodule
	
	