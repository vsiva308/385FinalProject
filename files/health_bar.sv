module health_bar (
	input Clk, Reset, hit, block,
	output logic [7:0] health
);

	//Basically converts hit into a one clock cycle one time hit

	enum logic [2:0] {Waiting, Hit, Block, Idle} curr_state, next_state;
	logic Hdecrement, Bdecrement;
	logic [7:0] hbar = 8'd250; //health bar
	assign health = hbar;
	//logic [1:0] attacks;
	
	//00 = no decrement
	//01 = hit -10
	//10 = block - 4
	
	
	always_ff @ (posedge Clk or posedge Reset)
	begin
		if (Reset) begin //async reset
			curr_state <= Waiting;
			hbar <= 8'd250;
		end else begin
			curr_state <= next_state;
			if(Hdecrement)
				hbar <= hbar - 10;
			if(Bdecrement)
				hbar <= hbar - 4;
		end
	end
	
	always_comb
	begin
		next_state = curr_state;
		Hdecrement = 1'b0;
		Bdecrement = 1'b0;
		
		unique case(curr_state)
			Waiting: 
				if (hit)
					next_state = Hit;
				else if(block)
					next_state = Block;
			Hit: next_state = Idle;
			Block: next_state = Idle;
			Idle: if ((~hit)&&(~block))
				next_state = Waiting;
		endcase
		
		case(curr_state)
			Waiting: ;
			Hit: begin
				Hdecrement = 1'b1;
				Bdecrement = 1'b0;
			end
			Block: begin
				Hdecrement = 1'b0;
				Bdecrement = 1'b1;
			end
			default: begin
				Hdecrement = 1'b0;
				Bdecrement = 1'b0;
			end
		endcase
	end	
endmodule
			
			
				
		
				