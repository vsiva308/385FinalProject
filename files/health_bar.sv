module health_bar (
	input Clk, Reset, hit,
	output logic [7:0] health
);

	//Basically converts hit into a one clock cycle one time hit

	enum logic [1:0] {Waiting, Hit, Idle} curr_state, next_state;
	logic decrement;
	logic [7:0] hbar = 8'd250; //health bar
	assign health = hbar;
	
	always_ff @ (posedge Clk or posedge Reset)
	begin
		if (Reset) begin //async reset
			curr_state <= Waiting;
			hbar <= 8'd250;
		end else begin
			curr_state <= next_state;
			if (decrement)
				hbar <= hbar - 10;
		end
	end
	
	always_comb
	begin
		next_state = curr_state;
		decrement = 1'b0;
		
		unique case(curr_state)
			Waiting: if (hit)
				next_state = Hit;
			Hit: next_state = Idle;
			Idle: if (~hit)
				next_state = Waiting;
		endcase
		
		case(curr_state)
			Waiting: ;
			Hit: decrement = 1'b1;
			default: decrement = 1'b0;
		endcase
	end
	
endmodule
			
			
				
		
				