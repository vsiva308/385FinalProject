module akuma_jump_sprite (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY, AkumaX, AkumaY,
	input logic blank,
	output logic [3:0] red, green, blue,
	output logic akuma_on
);

	logic [12:0] rom_address;
	logic [3:0] rom_q;

	logic [3:0] palette_red, palette_green, palette_blue;

	logic negedge_vga_clk;

	// read from ROM on negedge, set pixel on posedge
	assign negedge_vga_clk = ~vga_clk;

	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	
	always_comb begin
		if ((DrawX >= AkumaX) && (DrawX < AkumaX + 139) && (DrawY >= AkumaY) && (DrawY < AkumaY + 161))
				rom_address = ((((DrawX * 70) / 140) + (((DrawY * 81) / 162) * 70)) - (((AkumaX * 70) / 140) + (((AkumaY * 81) / 162) * 70)));
		else
				rom_address = 13'd0;
	end

	always_ff @ (posedge vga_clk) begin
		red <= 4'h0;
		green <= 4'h0;
		blue <= 4'h0;
		akuma_on <= 1'b0;

		if (blank && ~((palette_blue == 4'hf) && (palette_red == 4'hf) && (palette_green == 4'h0))) begin
			red <= palette_red;
			green <= palette_green;
			blue <= palette_blue;
			akuma_on <= 1'b1;
		end
	end

	akuma_jump_rom akuma_jump_rom (
		.clock   (negedge_vga_clk),
		.address (rom_address),
		.q       (rom_q)
	);

	akuma_jump_palette akuma_jump_palette (
		.index (rom_q),
		.red   (palette_red),
		.green (palette_green),
		.blue  (palette_blue)
	);

endmodule
