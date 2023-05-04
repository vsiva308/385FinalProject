module ryu_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [4:0] q
);

logic [4:0] memory [0:21239] /* synthesis ram_init_file = "./ryu/ryu.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
