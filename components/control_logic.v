module control_logic(
	input [0:31] instruction,
	output logic REG_DST,
	output logic REG_WR,
	output logic F_REG_WR,
	output logic BRANCH,
	output logic JUMP,
	output logic [0:3] ALU_CTRL_BITS,
	output logic FPU_CTRL_BITS,
	output logic ALU_SRC,
	output logic IMM_ZERO,
	output logic MEM_WR,
	output logic MEM_TO_REG,
	output logic MOV_INSTR,
	output logic EXT_OP,
	output logic MEM_BYTE_OP,
	output logic MEM_HALFWORD_OP,
	output logic MEM_SIGN_EXT,
	output logic JAL_INSTR,
	output logic JUMP_USE_REG);

logic [0:5] opcode;
logic [0:5] func;


always @(*) begin

opcode = instruction[0:5];
func = instruction[26:31];

//Set Defaults of 0
	  REG_DST = 0;
	  REG_WR = 0;
	  F_REG_WR = 0;
	  BRANCH = 0;
	  JUMP = 0;
	  ALU_CTRL_BITS = 3'b0;
	  FPU_CTRL_BITS = 0;
	  ALU_SRC = 0;
	  IMM_ZERO = 0;
	  MEM_WR = 0;
	  MEM_TO_REG = 0;
	  MOV_INSTR = 0;
	  EXT_OP = 0;
	  MEM_BYTE_OP = 0;
	  MEM_HALFWORD_OP = 0;
	  MEM_SIGN_EXT = 0;
	  JAL_INSTR = 0;
	  JUMP_USE_REG = 0;

case(opcode)
	
	ALU_OP: begin
		REG_DST = 1;

		case(func)

			ALU_SLL: begin
				ALU_CTRL_BITS = ALU_SLL_CTRL;
				REG_WR = 1;
				end

			ALU_SRL: begin
				ALU_CTRL_BITS = ALU_SRL_CTRL;
				REG_WR = 1;
				end

			ALU_SRA: begin
				ALU_CTRL_BITS = ALU_SRA_CTRL;
				REG_WR = 1;
				end

			ALU_ADD: begin
				ALU_CTRL_BITS = ALU_ADD_CTRL;
				REG_WR = 1;
				end

			ALU_ADDU: begin
				ALU_CTRL_BITS = ALU_ADD_CTRL;
				REG_WR = 1;
				end

			ALU_SUB: begin
				ALU_CTRL_BITS = ALU_SUB_CTRL;
				REG_WR = 1;
				end

			ALU_SUBU: begin
				ALU_CTRL_BITS = ALU_SUB_CTRL;
				REG_WR = 1;
				end

			ALU_OR: begin
				ALU_CTRL_BITS = ALU_OR_CTRL;
				REG_WR = 1;
				end

			ALU_AND: begin
				ALU_CTRL_BITS = ALU_AND_CTRL;
				REG_WR = 1;
				end

			ALU_XOR: begin
				ALU_CTRL_BITS = ALU_XOR_CTRL;
				REG_WR = 1;
				end

			ALU_SEQ: begin
				ALU_CTRL_BITS = ALU_SEQ_CTRL;
				REG_WR = 1;
				end

			ALU_SNE: begin
				ALU_CTRL_BITS = ALU_SNE_CTRL;
				REG_WR = 1;
				end

			ALU_SLT: begin
				ALU_CTRL_BITS = ALU_SLT_CTRL;
				REG_WR = 1;
				end

			ALU_SGT: begin
				ALU_CTRL_BITS = ALU_SGT_CTRL;
				REG_WR = 1;
				end

			ALU_SLE: begin
				ALU_CTRL_BITS = ALU_SLE_CTRL;
				REG_WR = 1;
				end

			ALU_SGE: begin
				ALU_CTRL_BITS = ALU_SGE_CTRL;
				REG_WR = 1;
				end

			MOVFP2I: begin
				ALU_CTRL_BITS = ALU_ADD_CTRL;
				REG_WR = 1;
				MOV_INSTR = 1;
				end

			MOVI2FP: begin
				ALU_CTRL_BITS = ALU_ADD_CTRL;
				F_REG_WR = 1;
				MOV_INSTR = 1;
				end

			default: begin						//NOP, invalid
				ALU_CTRL_BITS = ALU_ADD_CTRL;
				REG_WR = 0;
				end

		endcase //case(func)
	end //ALU_OP:


	FPU_OP: begin //change for fun times laterrrrrrrr
		REG_DST = 1;
		F_REG_WR = 1;	
	end//FPU_OP

	J: JUMP = 1;

	JAL: begin
		REG_WR = 1;
		JUMP =1;
		JAL_INSTR = 1;

	end // JAL

	BEQZ: begin
		BRANCH = 1;
		ALU_CTRL_BITS = ALU_SEQ_CTRL;
		ALU_SRC = 1;
		IMM_ZERO = 1;
	end // BEQZ

	BNEZ: begin
		BRANCH = 1;
		ALU_CTRL_BITS = ALU_SNE_CTRL;
		ALU_SRC = 1;
		IMM_ZERO = 1;
	end // BNEZ

	ADDI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		EXT_OP = 1;
	end //ADDI

	ADDUI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
	end //ADDUI

	SUBI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SUB_CTRL;
		ALU_SRC = 1;
		EXT_OP = 1;
	end //SUBI

	SUBUI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SUB_CTRL;
		ALU_SRC = 1;
	end //SUBUI

	ANDI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_AND_CTRL;
		ALU_SRC = 1;
	end //ANDI

	ORI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_OR_CTRL;
		ALU_SRC = 1;
	end //ORI

	XORI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_XOR_CTRL;
		ALU_SRC = 1;
	end //XORI

	LHI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_LHI_CTRL;
		ALU_SRC = 1;
	end //LHI

	JR: begin
		JUMP = 1;
		JUMP_USE_REG = 1;
	end// JR

	JALR: begin
		REG_WR = 1;
		JUMP = 1;
		JAL_INSTR = 1;
		JUMP_USE_REG = 1;
	end //JALR

	SLLI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SLL_CTRL;
		ALU_SRC = 1;
	end //SLLI

	SRLI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SRL_CTRL;
		ALU_SRC = 1;
	end //SRLI

	SRAI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SRA_CTRL;
		ALU_SRC = 1;
	end //SRAI

	SEQI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SEQ_CTRL;
		ALU_SRC = 1;
		EXT_OP = 1;
	end //SEQI

	SNEI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SNE_CTRL;
		ALU_SRC = 1;
		EXT_OP = 1;
	end //SNEI

	SLTI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SLT_CTRL;
		ALU_SRC = 1;
		EXT_OP = 1;
	end //SLTI

	SGTI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SGT_CTRL;
		ALU_SRC = 1;
		EXT_OP = 1;
	end //SGTI

	SLEI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SLE_CTRL;
		ALU_SRC = 1;
		EXT_OP = 1;
	end //SLEI

	SGEI: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_SGE_CTRL;
		ALU_SRC = 1;
		EXT_OP = 1;
	end //SGEI

	LB: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		MEM_TO_REG = 1;
		EXT_OP = 1;
		MEM_BYTE_OP = 1;
		MEM_SIGN_EXT = 1;
	end //LB

	LH: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		MEM_TO_REG = 1;
		EXT_OP = 1;
		MEM_HALFWORD_OP = 1;
		MEM_SIGN_EXT = 1;
	end //LH

	LW: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		MEM_TO_REG = 1;
		EXT_OP = 1;
	end //LH

	LBU: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		MEM_TO_REG = 1;
		EXT_OP = 1;
		MEM_BYTE_OP = 1;
	end //LBU

	LHU: begin
		REG_WR = 1;
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		MEM_TO_REG = 1;
		EXT_OP = 1;
		MEM_HALFWORD_OP = 1;
	end //LHU
	
	SB: begin
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		MEM_WR = 1;
		MEM_BYTE_OP = 1;
		EXT_OP = 1;
	end //SB

	SH: begin
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		MEM_WR = 1;
		MEM_HALFWORD_OP = 1;
		EXT_OP = 1;
	end //SH

	SW: begin
		ALU_CTRL_BITS = ALU_ADD_CTRL;
		ALU_SRC = 1;
		MEM_WR = 1;
		EXT_OP = 1;
	end //SW

	default: ;

endcase //case(opcode)
end //always

endmodule