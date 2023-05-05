module ryu_sprite (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY, RyuX, RyuY,
	input logic [2:0] sprite,
	input logic blank,
	output logic [3:0] red, green, blue,
	output logic ryu_on
);
	/*
	==========================Dictionary=============================
		0 - Standing
		1 - Punching
		2 - Jumping
		3 - Crouching
		4 - Walk Left
		5 - Walk Right
		6 - Death
	=================================================================
	*/

	//=======================================================
	//  Ryu Logic
	//=======================================================
	logic [3:0] stand_red, stand_green, stand_blue, punch_red, punch_green, punch_blue, jump_red, jump_green, jump_blue, crouch_red, crouch_green, crouch_blue;
	logic [3:0] left_red, left_green, left_blue, right_red, right_green, right_blue, death_red, death_green, death_blue;
	logic stand_on, punch_on, jump_on, crouch_on, left_on, right_on, death_on;

	ryu_standing_sprite standing(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuX(RyuX),
		.RyuY(RyuY),
		.blank(blank),
		.red(stand_red),
		.green(stand_green),
		.blue(stand_blue),
		.ryu_on(stand_on)
	);

	ryu_punch_sprite punching(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuX(RyuX),
		.RyuY(RyuY),
		.blank(blank),
		.red(punch_red),
		.green(punch_green),
		.blue(punch_blue),
		.ryu_on(punch_on)
	);
	
	ryu_jump_sprite jumping(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuX(RyuX),
		.RyuY(RyuY),
		.blank(blank),
		.red(jump_red),
		.green(jump_green),
		.blue(jump_blue),
		.ryu_on(jump_on)
	);
	
	ryu_crouch_sprite crouching(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuX(RyuX),
		.RyuY(RyuY),
		.blank(blank),
		.red(crouch_red),
		.green(crouch_green),
		.blue(crouch_blue),
		.ryu_on(crouch_on)
	);
	
	ryu_left_sprite left(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuX(RyuX),
		.RyuY(RyuY),
		.blank(blank),
		.red(left_red),
		.green(left_green),
		.blue(left_blue),
		.ryu_on(left_on)
	);
	
	ryu_right_sprite right(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuX(RyuX),
		.RyuY(RyuY),
		.blank(blank),
		.red(right_red),
		.green(right_green),
		.blue(right_blue),
		.ryu_on(right_on)
	);
	
	ryu_death_sprite death(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.RyuX(RyuX),
		.RyuY(RyuY),
		.blank(blank),
		.red(death_red),
		.green(death_green),
		.blue(death_blue),
		.ryu_on(death_on)
	);

	//=======================================================
	//  Ryu Select Logic
	//=======================================================
	always_comb
	begin
		red = 4'h0;
		green = 4'h0;
		blue = 4'h0;
		ryu_on = 1'b0;
		
		case(sprite)
			3'b000:
			begin
				red = stand_red;
				green = stand_green;
				blue = stand_blue;
				ryu_on = stand_on;
			end
			3'b001:
			begin
				red = punch_red;
				green = punch_green;
				blue = punch_blue;
				ryu_on = punch_on;
			end
			3'b010:
			begin
				red = jump_red;
				green = jump_green;
				blue = jump_blue;
				ryu_on = jump_on;
			end
			3'b011:
			begin
				red = crouch_red;
				green = crouch_green;
				blue = crouch_blue;
				ryu_on = crouch_on;
			end
			3'b100:
			begin
				red = left_red;
				green = left_green;
				blue = left_blue;
				ryu_on = left_on;
			end
			3'b101:
			begin
				red = right_red;
				green = right_green;
				blue = right_blue;
				ryu_on = right_on;
			end
			3'b110:
			begin
				red = death_red;
				green = death_green;
				blue = death_blue;
				ryu_on = death_on;
			end
			default: 
			begin
				red = stand_red;
				green = stand_green;
				blue = stand_blue;
				ryu_on = stand_on;
			end
		endcase
	end

endmodule
