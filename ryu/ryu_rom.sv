module ryu_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [4:0] q
);

logic [4:0] memory [0:5309] /* synthesis ram_init_file = "./ryu/ryu.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
