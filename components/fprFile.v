module fprFile
	(input clk,
	 input reset,
	 input regWr,
	 input [0:4] Rs,
	 input [0:4] Rt,
	 input [0:4] Rw,
	 input [0:31] busW,
	 output logic [0:31] busA,
	 output logic [0:31] busB
	 );

	 reg [0:31] regFile[0:31];


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
			 
			if(regWr)
				regFile[Rw] =busW;
			else
				regFile[Rw] <=regFile[Rw];
		end

	end

endmodule
