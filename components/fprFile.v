module fprFile
	(input clk,
	 input reset,
	 input regWr,
	 input [0:4] Rs,
	 input [0:4] Rt,
	 input [0:4] Rd,
	 input Rdst,
	 input [0:31] busW,
	 output logic [0:4] Rw,
	 output logic [0:31] busA,
	 output logic [0:31] busB
	 );

	 reg [0:31] regFile[0:31];
	 reg [0:4] Rd_or_Rt;


	 integer i;

	 always@(*) begin
	 	busA=regFile[Rs];
		busB=regFile[Rt];
	 end
	 
	 always @(negedge clk) begin
	 	if(reset) begin
		 	for (i = 0; i < 32; i = i+1) begin
	 			regFile[i] = 0;
 			end
		end 

		else begin
			 case(Rdst)
		 	 	0:  Rw = Rt;
				1:  Rw = Rd;
			 endcase
			 
			if(regWr)
				regFile[Rw] =busW;
			else
				regFile[Rw] <=regFile[Rw];
		end

	end

endmodule
