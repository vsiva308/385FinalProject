module health_sprite(
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic [7:0] RyuHealth, AkumaHealth,
	input logic blank,
	output logic health_on
);

	parameter [9:0] Ryu_X_Health = 50; //left bound
	parameter [9:0] Akuma_X_Health = 590; //right bound
	parameter [9:0] Ryu_X_Max = 295; //50 + 245
	parameter [9:0] Akuma_X_Min = 345; //590 - 245
	parameter [9:0] Y_Health_U = 34;
	parameter [9:0] Y_Health_L = 48;
	
	logic [9:0] Ryu_X_Lower, Akuma_X_Upper;
	logic bar;
	
	//assign Ryu_X_Upper = Ryu_X_Health + RyuHealth;
	assign Ryu_X_Lower = Ryu_X_Max - RyuHealth;
	assign Akuma_X_Upper = Akuma_X_Min + AkumaHealth;
	
	always_comb
	begin
		if ((((DrawX >= Ryu_X_Health) && (DrawX >= Ryu_X_Lower) && (DrawX < Ryu_X_Max)) || ((DrawX < Akuma_X_Upper) && (DrawX < Akuma_X_Health) && (DrawX >= Akuma_X_Min))) && (DrawY >= Y_Health_U) && (DrawY < Y_Health_L))
			bar = 1'b1;
		else
			bar = 1'b0;
	end
	
	always_ff @ (posedge vga_clk) begin
		health_on <= 1'b0;
		if (blank)
			health_on <= bar;
	end
endmodule
	