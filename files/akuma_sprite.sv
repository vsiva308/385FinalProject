module akuma_sprite (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY, AkumaX, AkumaY,
	input logic [2:0] sprite,
	input logic blank,
	output logic [3:0] red, green, blue,
	output logic akuma_on
);
/*
	==========================Dictionary=============================
		0 - Standing
		1 - Punching
		2 - Jumping
	=================================================================
	*/

	//=======================================================
	//  Akuma Logic
	//=======================================================
	logic [3:0] stand_red, stand_green, stand_blue, punch_red, punch_green, punch_blue, jump_red, jump_green, jump_blue;
	logic stand_on, punch_on, jump_on;

	akuma_standing_sprite standing(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(stand_red),
		.green(stand_green),
		.blue(stand_blue),
		.akuma_on(stand_on)
	);

	akuma_punch_sprite punching(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(punch_red),
		.green(punch_green),
		.blue(punch_blue),
		.akuma_on(punch_on)
	);
	
	akuma_jump_sprite jumping(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(jump_red),
		.green(jump_green),
		.blue(jump_blue),
		.akuma_on(jump_on)
	);

	//=======================================================
	//  Akuma Select Logic
	//=======================================================
	always_comb
	begin
		red = 4'h0;
		green = 4'h0;
		blue = 4'h0;
		akuma_on = 1'b0;
		
		case(sprite)
			3'b000:
			begin
				red = stand_red;
				green = stand_green;
				blue = stand_blue;
				akuma_on = stand_on;
			end
			3'b001:
			begin
				red = punch_red;
				green = punch_green;
				blue = punch_blue;
				akuma_on = punch_on;
			end
			3'b010:
			begin
				red = jump_red;
				green = jump_green;
				blue = jump_blue;
				akuma_on = jump_on;
			end
			default: 
			begin
				red = stand_red;
				green = stand_green;
				blue = stand_blue;
				akuma_on = stand_on;
			end
		endcase
	end

endmodule
