module ryu_jump_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:4157] /* synthesis ram_init_file = "./ryu_jump/ryu_jump.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
