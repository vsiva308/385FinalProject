module ryu_death_sprite (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY, RyuX, RyuY,
	input logic blank,
	output logic [3:0] red, green, blue,
	output logic ryu_on
);

	logic [12:0] rom_address;
	logic [3:0] rom_q;

	logic [3:0] palette_red, palette_green, palette_blue;

	logic negedge_vga_clk;

	// read from ROM on negedge, set pixel on posedge
	assign negedge_vga_clk = ~vga_clk;
	
	int RyuYOffset;
	
	assign RyuYOffset = 215 + 115;

	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	
	always_comb begin
		if ((DrawX >= RyuX) && (DrawX < RyuX + 255) && (DrawY >= RyuYOffset) && (DrawY < RyuYOffset + 65))
				rom_address = ((((DrawX * 128) / 256) + (((DrawY * 33) / 66) * 128)) - (((RyuX * 128) / 256) + (((RyuYOffset * 33) / 66) * 128)));
		else
				rom_address = 13'd0;
	end

	always_ff @ (posedge vga_clk) begin
		red <= 4'h0;
		green <= 4'h0;
		blue <= 4'h0;
		ryu_on <= 1'b0;

		if (blank && ~((palette_blue == 4'hf) && (palette_red == 4'hf) && (palette_green == 4'h0))) begin
			red <= palette_red;
			green <= palette_green;
			blue <= palette_blue;
			ryu_on <= 1'b1;
		end
	end

	ryu_death_rom ryu_death_rom (
		.clock   (negedge_vga_clk),
		.address (rom_address),
		.q       (rom_q)
	);

	ryu_death_palette ryu_death_palette (
		.index (rom_q),
		.red   (palette_red),
		.green (palette_green),
		.blue  (palette_blue)
	);

endmodule
