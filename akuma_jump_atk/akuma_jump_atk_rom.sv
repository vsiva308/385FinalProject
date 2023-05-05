module akuma_jump_atk_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:5493] /* synthesis ram_init_file = "./akuma_jump_atk/akuma_jump_atk.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
