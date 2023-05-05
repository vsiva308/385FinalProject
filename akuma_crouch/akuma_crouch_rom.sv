module akuma_crouch_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:6263] /* synthesis ram_init_file = "./akuma_crouch/akuma_crouch.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
