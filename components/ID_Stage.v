module ID_Stage(
	input clk,
	input reset,
	input [0:31] instruction,
	input [0:31] BUS_W ,
	input [0:31] FBUS_W,
	input [0:4] Rw_ID_EX,
	input [0:4] Rw_EX_MEM,
	input  LD_from_ID_EX,
	input reg_we_in,
	input reg_we_from_ID_EX,
	input reg_we_from_EX_MEM,
	input [0:4] Rw_in,
	output logic [0:31] jump_offset,
	output reg_we_out,
	output logic [0:4] Rw_out,
	output logic [0:31] OPERAND_A,
	output logic [0:31] OPERAND_B,
	output logic [0:31] BUS_B,
	output [0:31] F_OPERAND_A,
	output [0:31] F_OPERAND_B,
	output BRANCH,
	output JUMP,
	output [0:3] ALU_CTRL_BITS,
	output [0:1] FPU_CTRL_BITS,
	output ALU_SRC,
	output MEM_WR,
	output MEM_TO_REG,
	output MOV_INSTR,
	output MEM_BYTE_OP,
	output MEM_HALFWORD_OP,
	output MEM_SIGN_EXT,
	output JAL_INSTR,
	output JUMP_USE_REG,
	output Stall_ID,
	output [0:1] OP_A_SEL,
	output [0:1] OP_B_SEL
	);

logic temp_REG_DST, temp_R_31, temp_F_REG_WR, temp_IMM_ZERO, temp_EXT_OP;
logic [0:31] temp_bus_A,temp_bus_B, temp_f_bus_B;
logic [0:4] Rs;
logic [0:4] Rt;
logic [0:4] Rd;
logic [0:4] Rd_or_Rt;
logic [0:5] opcode;
logic [0:15]IMM_FIELD;
logic [0:31] IMM_FIELD_EXT;

reg [0:4] Rw_Buffer[0:1];


control_logic control_0(
	.instruction(instruction),
	.REG_DST(temp_REG_DST),
	.REG_WR(reg_we_out),
	.F_REG_WR(temp_F_REG_WR),
	.BRANCH(BRANCH),
	.JUMP(JUMP),
	.ALU_CTRL_BITS(ALU_CTRL_BITS),
	.FPU_CTRL_BITS(FPU_CTRL_BITS),
	.ALU_SRC(ALU_SRC),
	.IMM_ZERO(temp_IMM_ZERO),
	.MEM_WR(MEM_WR),
	.MEM_TO_REG(MEM_TO_REG),
	.MOV_INSTR(MOV_INSTR),
	.EXT_OP(temp_EXT_OP),
	.MEM_BYTE_OP(MEM_BYTE_OP),
	.MEM_HALFWORD_OP(MEM_HALFWORD_OP),
	.MEM_SIGN_EXT(MEM_SIGN_EXT),
	.JAL_INSTR(JAL_INSTR),
	.JUMP_USE_REG(JUMP_USE_REG)
	);

gprFile gprFile0(
	.clk(clk),
	.reset(reset),
	.regWr(reg_we_in),
	.Rs(Rs),
	.Rt(Rt),
	.Rw(Rw_in),
	.busW(BUS_W),
	.busA(temp_bus_A),
	.busB(temp_bus_B)
	);

fprFile fprFile0(
	.clk(clk),
	.reset(reset),
	.regWr(reg_we_in),
	.Rs(Rs),
	.Rt(Rt),
	.Rw(Rw_in),
	.busW(FBUS_W),
	.busA(F_OPERAND_A),
	.busB(F_OPERAND_B)
	);

hazardDetector hD(
	.opcode(instruction[0:5]),
	.Rs_ID(Rs),
	.Rt_ID(Rt),
	.ALU_SRC(ALU_SRC),
	.Rw_ID_EX(Rw_ID_EX),
	.Rw_EX_MEM(Rw_EX_MEM),
	.we_ID_EX(reg_we_from_ID_EX),
	.we_EX_MEM(reg_we_from_EX_MEM),
	.LD_ID_EX(LD_from_ID_EX),
	.Stall_ID(Stall_ID),
	.OP_A_SEL(OP_A_SEL),
	.OP_B_SEL(OP_B_SEL)
	);

always @(*) begin
	Rs = instruction[6:10];
	Rt = instruction[11:15];
	Rd = instruction[16:20];
	jump_offset = instruction[6:31];
	opcode = instruction[0:5];
	case(temp_REG_DST)
		0: Rd_or_Rt = Rt;
		1: Rd_or_Rt = Rd;
	endcase

	case(JAL_INSTR)
		0: Rw_out = Rd_or_Rt;
		1: Rw_out = 5'b11111;
	endcase


	IMM_FIELD = (temp_IMM_ZERO == 1) ? 16'h0 : instruction[16:31];


	OPERAND_A = temp_bus_A;

	if (temp_EXT_OP == 1)
		IMM_FIELD_EXT = $signed(IMM_FIELD);
	else
		IMM_FIELD_EXT = $unsigned(IMM_FIELD);

	if(opcode == BEQZ || opcode == BNEZ)
		BUS_B = $signed(instruction[16:31]);
	else
		BUS_B = temp_bus_B;

	if(ALU_SRC == 1)
		OPERAND_B = IMM_FIELD_EXT;
	else 
		OPERAND_B = temp_bus_B;
	
	end //always
endmodule
