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
	=================================================================
	*/

	//=======================================================
	//  Ryu Logic
	//=======================================================
	logic [3:0] stand_red, stand_green, stand_blue, punch_red, punch_green, punch_blue;
	logic stand_on, punch_on;

	ryu_standing_sprite(
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

	ryu_punch_sprite(
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
			default: ;
		endcase
	end

endmodule
