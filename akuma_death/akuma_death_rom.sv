module akuma_death_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:5427] /* synthesis ram_init_file = "./akuma_death/akuma_death.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
