module akuma_sprite (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY, AkumaX, AkumaY,
	input logic [3:0] sprite,
	input logic blank,
	output logic [3:0] red, green, blue,
	output logic akuma_on
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
		7 - Jumping Attack
	=================================================================
	*/

	//=======================================================
	//  Akuma Logic
	//=======================================================
	logic [3:0] stand_red, stand_green, stand_blue, punch_red, punch_green, punch_blue, jump_red, jump_green, jump_blue, crouch_red, crouch_green, crouch_blue; 
	logic [3:0] left_red, left_green, left_blue, right_red, right_green, right_blue, death_red, death_green, death_blue, jatk_red, jatk_green, jatk_blue, pulse_red, pulse_green, pulse_blue;
	logic stand_on, punch_on, jump_on, crouch_on, left_on, right_on, death_on, jatk_on, pulse_on;

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
	
	akuma_pulse_sprite pulse(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(pulse_red),
		.green(pulse_green),
		.blue(pulse_blue),
		.akuma_on(pulse_on)
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
	
	akuma_crouch_sprite crouching(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(crouch_red),
		.green(crouch_green),
		.blue(crouch_blue),
		.akuma_on(crouch_on)
	);
	
	akuma_left_sprite left(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(left_red),
		.green(left_green),
		.blue(left_blue),
		.akuma_on(left_on)
	);
	
	akuma_right_sprite right(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(right_red),
		.green(right_green),
		.blue(right_blue),
		.akuma_on(right_on)
	);
	
	akuma_death_sprite death(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(death_red),
		.green(death_green),
		.blue(death_blue),
		.akuma_on(death_on)
	);
	
	akuma_jump_atk_sprite jatk(
		.vga_clk(vga_clk),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.AkumaX(AkumaX),
		.AkumaY(AkumaY),
		.blank(blank),
		.red(jatk_red),
		.green(jatk_green),
		.blue(jatk_blue),
		.akuma_on(jatk_on)
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
			4'b0000:
			begin
				red = stand_red;
				green = stand_green;
				blue = stand_blue;
				akuma_on = stand_on;
			end
			4'b0001:
			begin
				red = pulse_red;
				green = pulse_green;
				blue = pulse_blue;
				akuma_on = pulse_on;
			end
			4'b0010:
			begin
				red = punch_red;
				green = punch_green;
				blue = punch_blue;
				akuma_on = punch_on;
			end
			4'b0011:
			begin
				red = jump_red;
				green = jump_green;
				blue = jump_blue;
				akuma_on = jump_on;
			end
			4'b0100:
			begin
				red = crouch_red;
				green = crouch_green;
				blue = crouch_blue;
				akuma_on = crouch_on;
			end
			4'b0101:
			begin
				red = left_red;
				green = left_green;
				blue = left_blue;
				akuma_on = left_on;
			end
			4'b0110:
			begin
				red = right_red;
				green = right_green;
				blue = right_blue;
				akuma_on = right_on;
			end
			4'b0111:
			begin
				red = death_red;
				green = death_green;
				blue = death_blue;
				akuma_on = death_on;
			end
			4'b1000:
			begin
				red = jatk_red;
				green = jatk_green;
				blue = jatk_blue;
				akuma_on = jatk_on;
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
