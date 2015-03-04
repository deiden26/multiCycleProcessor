module ID_Stage_tb;
	reg clk;
	reg reset;
	reg [0:31] instruction;
	reg [0:31] BUS_W ;
	reg [0:31] FBUS_W;
	wire [0:31] OPERAND_A;
	wire [0:31] OPERAND_B;
	wire [0:31] F_OPERAND_A;
	wire [0:31] F_OPERAND_B;
	wire BRANCH;
	wire JUMP;
	wire [0:3] ALU_CTRL_BITS;
	wire FPU_CTRL_BITS;
	wire ALU_SRC;
	wire MEM_WR;
	wire MEM_TO_REG;
	wire MOV_INSTR;
	wire MEM_BYTE_OP;
	wire MEM_HALFWORD_OP;
	wire MEM_SIGN_EXT;
	wire JAL_INSTR;


	ID_Stage ID_State0 (
	.clk(clk),
	.reset(reset),
	.instruction(instruction),
	.BUS_W(BUS_W),
	.FBUS_W(FBUS_W),
	.OPERAND_A(OPERAND_A),
	.OPERAND_B(OPERAND_B),
	.F_OPERAND_A(F_OPERAND_A),
	.F_OPERAND_B(F_OPERAND_B),
	.BRANCH(BRANCH),
	.JUMP(JUMP),
	.ALU_CTRL_BITS(ALU_CTRL_BITS),
	.FPU_CTRL_BITS(FPU_CTRL_BITS),
	.ALU_SRC(ALU_SRC),
	.MEM_WR(MEM_WR),
	.MEM_TO_REG(MEM_TO_REG),
	.MOV_INSTR(MOV_INSTR),
	.MEM_BYTE_OP(MEM_BYTE_OP),
	.MEM_HALFWORD_OP(MEM_HALFWORD_OP),
	.MEM_SIGN_EXT(MEM_SIGN_EXT),
	.JAL_INSTR(JAL_INSTR)
	);

always
	#5 clk = !clk;

initial

	begin

	//$monitor("clk = %d\t reset = %d\t instruction = %h\t BUS_W = %h\t FBUS_W = %h\t OPERAND_A = %h\t OPERAND_B = %h\t F_OPERAND_A = %h\t F_OPERAND_B = %h\t BRANCH = %d\t JUMP = %d\t ALU_CTRL_BITS = %b\t FPU_CTRL_BITS = %d\t ALU_SRC = %d\t MEM_WR = %d\t MEM_TO_REG = %d\t MOV_INSTR = %d\t MEM_BYTE_OP = %d\t MEM_HALFWORD_OP = %d\t MEM_SIGN_EXT = %d\t JAL_INSTR = %d\t", clk,reset,instruction,BUS_W, FBUS_W, OPERAND_A, OPERAND_B, F_OPERAND_A, F_OPERAND_B, BRANCH, JUMP, ALU_CTRL_BITS, FPU_CTRL_BITS, ALU_SRC, MEM_WR, MEM_TO_REG, MOV_INSTR, MEM_BYTE_OP, MEM_HALFWORD_OP, MEM_SIGN_EXT, JAL_INSTR);


	#0 
	begin
	clk = 0;
	reset = 1;
		$display("clk = %d\t reset = %d\t instruction = %h\t BUS_W = %h\t FBUS_W = %h\t OPERAND_A = %h\t OPERAND_B = %h\t F_OPERAND_A = %h\t F_OPERAND_B = %h\t BRANCH = %d\t JUMP = %d\t ALU_CTRL_BITS = %b\t FPU_CTRL_BITS = %d\t ALU_SRC = %d\t MEM_WR = %d\t MEM_TO_REG = %d\t MOV_INSTR = %d\t MEM_BYTE_OP = %d\t MEM_HALFWORD_OP = %d\t MEM_SIGN_EXT = %d\t JAL_INSTR = %d\t", clk,reset,instruction,BUS_W, FBUS_W, OPERAND_A, OPERAND_B, F_OPERAND_A, F_OPERAND_B, BRANCH, JUMP, ALU_CTRL_BITS, FPU_CTRL_BITS, ALU_SRC, MEM_WR, MEM_TO_REG, MOV_INSTR, MEM_BYTE_OP, MEM_HALFWORD_OP, MEM_SIGN_EXT, JAL_INSTR);
end

	#7 reset = 0;

	#15 
	begin
	instruction = 32'h20010008;
	BUS_W = 32'h8;
	FBUS_W = 32'h0;
	end

	#17 $display("clk = %d\t reset = %d\t instruction = %h\t BUS_W = %h\t FBUS_W = %h\t OPERAND_A = %h\t OPERAND_B = %h\t F_OPERAND_A = %h\t F_OPERAND_B = %h\t BRANCH = %d\t JUMP = %d\t ALU_CTRL_BITS = %b\t FPU_CTRL_BITS = %d\t ALU_SRC = %d\t MEM_WR = %d\t MEM_TO_REG = %d\t MOV_INSTR = %d\t MEM_BYTE_OP = %d\t MEM_HALFWORD_OP = %d\t MEM_SIGN_EXT = %d\t JAL_INSTR = %d\t", clk,reset,instruction,BUS_W, FBUS_W, OPERAND_A, OPERAND_B, F_OPERAND_A, F_OPERAND_B, BRANCH, JUMP, ALU_CTRL_BITS, FPU_CTRL_BITS, ALU_SRC, MEM_WR, MEM_TO_REG, MOV_INSTR, MEM_BYTE_OP, MEM_HALFWORD_OP, MEM_SIGN_EXT, JAL_INSTR);
	
	#25 begin
		instruction = 32'h20220008;
		end
	#27 $display("clk = %d\t reset = %d\t instruction = %h\t BUS_W = %h\t FBUS_W = %h\t OPERAND_A = %h\t OPERAND_B = %h\t F_OPERAND_A = %h\t F_OPERAND_B = %h\t BRANCH = %d\t JUMP = %d\t ALU_CTRL_BITS = %b\t FPU_CTRL_BITS = %d\t ALU_SRC = %d\t MEM_WR = %d\t MEM_TO_REG = %d\t MOV_INSTR = %d\t MEM_BYTE_OP = %d\t MEM_HALFWORD_OP = %d\t MEM_SIGN_EXT = %d\t JAL_INSTR = %d\t", clk,reset,instruction,BUS_W, FBUS_W, OPERAND_A, OPERAND_B, F_OPERAND_A, F_OPERAND_B, BRANCH, JUMP, ALU_CTRL_BITS, FPU_CTRL_BITS, ALU_SRC, MEM_WR, MEM_TO_REG, MOV_INSTR, MEM_BYTE_OP, MEM_HALFWORD_OP, MEM_SIGN_EXT, JAL_INSTR);

	#50 $finish;



end
endmodule



