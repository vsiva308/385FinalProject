module health_bar (
	input Clk, Reset, hit, block, other_death,
	output logic [7:0] health, 
	output logic death
);

	//Basically converts hit into a one clock cycle one time hit

	enum logic [2:0] {Waiting, Hit, Block, HitIdle, BlockIdle} curr_state, next_state;
	logic [1:0] decrement;
	logic [7:0] hbar = 8'd250; //health bar
	assign health = hbar;
	
	always_ff @ (posedge Clk or posedge Reset)
	begin
		if (Reset) begin //async reset
			curr_state <= Waiting;
			hbar <= 8'd250;
			death <= 1'b0;
		end else begin
			curr_state <= next_state;
			case (decrement)
				2'b01: 
					if (hbar >= 10)
						hbar <= hbar - 10;
					else begin
						hbar <= 8'd0;
						death <= 1'b1;
					end
				2'b10: 
					if (hbar >= 4)
						hbar <= hbar - 5;
					else begin
						hbar <= 8'd0;
						death <= 1'b1;
					end
				default: ;
			endcase
		end
	end
	
	always_comb
	begin
		next_state = curr_state;
		decrement = 2'b00;
		
		unique case(curr_state)
			Waiting: 
				if (hit && ~death && ~other_death)
					next_state = Hit; 
				else if (block && ~death && ~other_death)
						next_state = Block;
			Hit: next_state = HitIdle;
			Block: next_state = BlockIdle;
			
			HitIdle: if (~hit)
				next_state = Waiting;
			BlockIdle: if (~block)
				next_state = Waiting;
		endcase
		
		case(curr_state)
			Waiting: decrement = 2'b00;
			Hit: decrement = 2'b01;
			Block: decrement = 2'b10;
			default: decrement = 2'b00;
		endcase
	end	
endmodule
			
			
				
		
				