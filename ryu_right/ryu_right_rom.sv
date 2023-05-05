module ryu_right_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:5887] /* synthesis ram_init_file = "./ryu_right/ryu_right.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
