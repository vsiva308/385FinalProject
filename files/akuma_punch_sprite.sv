module akuma_punch_sprite (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY, AkumaX, AkumaY,
	input logic blank,
	output logic [3:0] red, green, blue,
	output logic akuma_on
);

	logic [13:0] rom_address;
	logic [3:0] rom_q;

	logic [3:0] palette_red, palette_green, palette_blue;

	logic negedge_vga_clk;
	
	int AkumaXFist;
	
	assign AkumaXFist = AkumaX - 49;

	// read from ROM on negedge, set pixel on posedge
	assign negedge_vga_clk = ~vga_clk;

	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	
	always_comb begin
		if ((DrawX >= AkumaXFist) && (DrawX < AkumaXFist + 183) && (DrawY >= AkumaY) && (DrawY < AkumaY + 239))
				rom_address = ((((DrawX * 92) / 184) + (((DrawY * 120) / 240) * 92)) - (((AkumaXFist * 92) / 184) + (((AkumaY * 120) / 240) * 92)));
		else
				rom_address = 14'd0;
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

	akuma_punch_rom akuma_punch_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
	);

	akuma_punch_palette akuma_punch_palette (
		.index (rom_q),
		.red   (palette_red),
		.green (palette_green),
		.blue  (palette_blue)
	);

endmodule
