module akuma_crouch_sprite (
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
	
	int AkumaYOffset;
	
	assign AkumaYOffset = AkumaY + 60;

	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	
	always_comb begin
		if ((DrawX >= AkumaX) && (DrawX < AkumaX + 144) && (DrawY >= AkumaYOffset) && (DrawY < AkumaYOffset + 173))
				rom_address = ((((DrawX * 72) / 144) + (((DrawY * 87) / 174) * 72)) - (((AkumaX * 72) / 144) + (((AkumaYOffset * 87) / 174) * 72)));
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

	akuma_crouch_rom akuma_crouch_rom (
		.clock   (negedge_vga_clk),
		.address (rom_address),
		.q       (rom_q)
	);

	akuma_crouch_palette akuma_crouch_palette (
		.index (rom_q),
		.red   (palette_red),
		.green (palette_green),
		.blue  (palette_blue)
	);

endmodule
