module akuma_jump_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:5669] /* synthesis ram_init_file = "./akuma_jump/akuma_jump.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
