module hazardDetector_tb;	
	reg [0:4] Rs_ID;
	reg [0:4] Rt_ID;
	reg ALU_SRC;
	reg [0:4] Rw_ID_EX;
	reg [0:4] Rw_EX_MEM;
	reg LD_ID_EX;
	wire Stall_ID;
	wire [0:1] OP_A_SEL;
	wire [0:1] OP_B_SEL;

hazardDetector hd(
	.Rs_ID(Rs_ID),
	.Rt_ID(Rt_ID),
	.ALU_SRC(ALU_SRC),
	.Rw_ID_EX(Rw_ID_EX),
	.Rw_EX_MEM(Rw_EX_MEM),
	.LD_ID_EX(LD_ID_EX),
	.Stall_ID(Stall_ID),
	.OP_A_SEL(OP_A_SEL),
	.OP_B_SEL(OP_B_SEL)
	);


initial
	begin

	$monitor("Rs_ID = %d\tRt_ID = %d\tALU_SRC = %d\tRw_ID_EX = %d\tRw_EX_MEM = %d\tLD_ID_EX = %d\tStall_ID = %d\tOP_A_SEL = %d\tOP_B_SEL = %d\t",Rs_ID,Rt_ID,ALU_SRC,Rw_ID_EX,Rw_EX_MEM,LD_ID_EX,Stall_ID,OP_A_SEL,OP_B_SEL);

	#0 begin
		Rs_ID = 5'h1;
		Rt_ID = 5'h2;
		ALU_SRC = 1;
		Rw_ID_EX = 5'h1;
		Rw_EX_MEM = 5'h2;
		LD_ID_EX = 0;
	end

	#2 begin
		Rs_ID = 5'h1;
		Rt_ID = 5'h2;
		ALU_SRC = 0;
		Rw_ID_EX = 5'h1;
		Rw_EX_MEM = 5'h2;
		LD_ID_EX = 0;
	end

	#4 begin
		Rs_ID = 5'h1;
		Rt_ID = 5'h2;
		ALU_SRC = 1;
		Rw_ID_EX = 5'h1;
		Rw_EX_MEM = 5'h2;
		LD_ID_EX = 1;
	end

	#10 $finish;

end

endmodule
