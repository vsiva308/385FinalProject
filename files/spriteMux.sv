module spriteMux(
	input logic punch,
	output logic[2:0] spriteIndex
	);

	always_comb
	begin
		if(punch)
			begin
				spriteIndex = 3'b001;
			end
		else
			begin
				spriteIndex = 3'b000;
			end
	end	
			

endmodule
	
	