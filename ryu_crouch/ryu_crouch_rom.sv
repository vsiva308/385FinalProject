module ryu_crouch_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:4339] /* synthesis ram_init_file = "./ryu_crouch/ryu_crouch.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
