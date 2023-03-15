module WISH_FSM( 
	input clk, reset,  stb, cyc, we,
	output reg adr_en, read_en, write_en,ack);

	reg [1:0] pstate, nstate;
	reg [1:0] IDLE=0, ADR=1, ACCESS=2,BUFF=3;

	always @(*) 
		begin
			case (pstate)
				IDLE:  nstate <= (stb & cyc)? ADR : IDLE;
				ADR:   nstate <= (cyc)? (stb)? ACCESS : ADR : IDLE;
				ACCESS:nstate <= (cyc)? (stb)? (we? ADR : BUFF) : ADR : IDLE;
				BUFF:  nstate <= (cyc)? ADR : IDLE;
			endcase

		end

	always @(*)
		begin

			case (pstate)
				IDLE:  
					begin
					adr_en  <=0;
					read_en <=0;
					write_en<=0;
					ack     <=0;
					end 

				ADR: 
					begin
					adr_en  <=1;
					read_en <=0;
					write_en<=we;					
					ack     <=1;
					end 

				ACCESS: 
					begin
					adr_en  <=0;
					read_en <=~we;
					write_en<=1;					
					ack     <=1;
					end 
				BUFF: 
					begin
					adr_en  <=0;
					read_en <=1;
					write_en<=0;					
					ack     <=1;
					end

			endcase
		end


	always @(posedge clk, negedge reset)
		begin 
			if(~reset)
				pstate<= IDLE;

			else
				pstate<= nstate;
		end

endmodule

