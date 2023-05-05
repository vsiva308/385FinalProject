module ryu_pulse_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:5300] /* synthesis ram_init_file = "./ryu_pulse/ryu_pulse.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
