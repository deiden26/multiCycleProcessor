module hazardDetector(
	input logic [0:5] opcode,
	input logic [0:4] Rs_ID,
	input logic [0:4] Rt_ID,
	input logic ALU_SRC,
	input logic [0:4] Rw_ID_EX,
	input logic [0:4] Rw_EX_MEM,
	input we_ID_EX,
	input we_EX_MEM,
	input LD_ID_EX,
	output logic Stall_ID,
	output logic [0:1] OP_A_SEL,
	output logic [0:1] OP_B_SEL
	);

always @(*) begin

	OP_A_SEL = NO_FWD;
	OP_B_SEL = NO_FWD;
	Stall_ID = 0;

	//Determine Rs Forwarding

	if(Rs_ID == Rw_ID_EX && we_ID_EX== 1) begin
			if(LD_ID_EX ==1)
				Stall_ID = 1;
			else
				OP_A_SEL = FWD_FROM_EX_MEM;

	end //if(Rs_ID == Rw_ID_EX)

	else if(Rs_ID == Rw_EX_MEM && we_EX_MEM ==1)
		OP_A_SEL = FWD_FROM_MEM_WB;

	else
		OP_A_SEL = NO_FWD;


	//Determine Rt Forwarding if applicable

	if(ALU_SRC == 0 || (opcode == SB || opcode == SH || opcode == SW) ) begin

		if(Rt_ID == Rw_ID_EX && we_ID_EX ==1 ) begin
			if(LD_ID_EX ==1)
				Stall_ID = 1;
			else
				OP_B_SEL = FWD_FROM_EX_MEM;
					
		end //if(Rt_ID == Rw_ID_EX)

		else if(Rt_ID == Rw_EX_MEM && we_EX_MEM ==1)
			OP_B_SEL = FWD_FROM_MEM_WB;

		else
			OP_B_SEL = NO_FWD;

	end //if(ALU_SRC == 0)

end //always
endmodule