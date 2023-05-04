module akuma_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [4:0] q
);

logic [4:0] memory [0:18899] /* synthesis ram_init_file = "./akuma/akuma.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
