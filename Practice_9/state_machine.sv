module state_machine(
	input logic clk, reset, enable,
	input logic [7:0] state1_duration, state2_duration, state3_duration,
	output logic done, irrigation_active, ventilation_active
);

	typedef enum logic [2:0] {IDLE, STATE1, STATE2, STATE3, END_STATE} statetype;
	
	statetype state, nextstate;
	logic [7:0] counter;
	
	// state register
	always_ff @(posedge clk, posedge reset)
	if (reset) state <= IDLE;
	else state <= nextstate;
	
	// next state logic
	always_ff @(posedge clk, posedge reset) begin
		if (reset) 
			counter <= 8'd0;
		else if (state != nextstate)
			counter <= 8'd0;
		else if (state != IDLE && state != END_STATE)
			counter <= counter + 8'd1;
		else
			counter <= 8'd0;
	end
	
	// state transition logic
	always_comb begin
		case (state)
			IDLE: begin
				if (enable) 
					nextstate = STATE1;
				else 
					nextstate = IDLE;
			end
			STATE1: begin
				if (enable)
					if (counter >= state1_duration - 1)
						nextstate = STATE2;
					else
						nextstate = STATE1;
				else
					nextstate = IDLE; 
			end
			STATE2: begin
				if (enable)
					if (counter >= state2_duration - 1)
						nextstate = STATE3;
					else
						nextstate = STATE2;
				else
					nextstate = IDLE; 
			end
			STATE3: begin
				if (enable)
					if (counter >= state3_duration - 1)
						nextstate = END_STATE;
					else
						nextstate = STATE3;
				else
					nextstate = IDLE;
			end
			END_STATE: begin
				if (!enable)
					nextstate = IDLE;
				else
					nextstate = END_STATE;
			end
			default: nextstate = IDLE;
		endcase
	end
	
	// output logic
	always_comb begin
		case (state)
			IDLE, STATE2: begin
				done = 1'b0;
				irrigation_active = 1'b0;
				ventilation_active = 1'b0;
			end
			STATE1: begin
				done = 1'b0;
				irrigation_active = 1'b1;
				ventilation_active = 1'b0;
			end
			STATE3: begin
				done = 1'b0;
				irrigation_active = 1'b0;
				ventilation_active = 1'b1;
			end
			END_STATE: begin
				done = 1'b1;
				irrigation_active = 1'b0;
				ventilation_active = 1'b0;
			end
			default: begin
				done = 1'b0;
				irrigation_active = 1'b0;
				ventilation_active = 1'b0;
			end
		endcase
	end

endmodule