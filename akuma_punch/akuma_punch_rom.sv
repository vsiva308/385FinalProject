module akuma_punch_rom (
	input logic clock,
	input logic [13:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:11039] /* synthesis ram_init_file = "./akuma_punch/akuma_punch.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
