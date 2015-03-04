module gprFile
	(input clk,
	 input reset,
	 input regWr,
	 input [0:4] Rs,
	 input [0:4] Rt,
	 input [0:4] Rd,
	 input Rdst,
	 input jal_instr,
	 input [0:31] busW,
	 output logic [0:31] busA,
	 output logic [0:31] busB
	 );

	 reg [0:31] regFile[0:31];

	 reg [0:4] Rw;
	 reg [0:4] Rd_or_Rt;


	 integer i;

	 always @(posedge clk) begin
	 	if(reset) begin
		 	for (i = 0; i < 32; i = i+1) begin
	 			regFile[i] = 0;
 			end
		end 

		else begin
			 case(Rdst)
			 	0: Rd_or_Rt = Rt;
				1: Rd_or_Rt = Rd;
			 endcase

			 case(jal_instr)
		 	 	0: Rw = Rd_or_Rt;
				1: Rw = 5'b11111;
			 endcase

			if(regWr)
				regFile[Rw] =busW;
			else
				regFile[Rw] <=regFile[Rw];

			regFile[0] <= 0;
		end


	end//always

	assign busA=regFile[Rs];
	assign busB=regFile[Rt];
endmodule