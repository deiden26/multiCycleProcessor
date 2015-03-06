typedef enum logic [0:1] {
	NO_FWD = 2'b0,
	FWD_FROM_EX_MEM = 2'b1,
	FWD_FROM_MEM_WB = 2'b2
} FWD_SEL;


typedef enum logic [3:0] {
	ALU_SLL_CTRL 	= 4'b0000, 
	ALU_SRL_CTRL 	= 4'b0001,
	ALU_SRA_CTRL 	= 4'b0010,
	ALU_ADD_CTRL 	= 4'b0011,   
	ALU_SUB_CTRL 	= 4'b0100,
	ALU_OR_CTRL 	= 4'b0101,  
	ALU_AND_CTRL 	= 4'b0110,
	ALU_XOR_CTRL 	= 4'b0111,
	ALU_SEQ_CTRL 	= 4'b1000,   
	ALU_SNE_CTRL 	= 4'b1001,
	ALU_SLT_CTRL 	= 4'b1010,    
	ALU_SGT_CTRL 	= 4'b1011,
	ALU_SLE_CTRL 	= 4'b1100,
	ALU_SGE_CTRL 	= 4'b1101,
	ALU_LHI_CTRL 	= 4'b1110       
} ALU_CTRL;


typedef enum logic [5:0]{
	ALU_SLL  	= 6'h04, 
	ALU_SRL  	= 6'h06,
	ALU_SRA  	= 6'h07,
	ALU_ADD  	= 6'h20,
	ALU_ADDU  	= 6'h21,   
	ALU_SUB  	= 6'h22,
	ALU_SUBU  	= 6'h23,
	ALU_OR  	= 6'h25,  
	ALU_AND  	= 6'h24,
	ALU_XOR  	= 6'h26,
	ALU_SEQ  	= 6'h28,   
	ALU_SNE  	= 6'h29,
	ALU_SLT  	= 6'h2a,    
	ALU_SGT  	= 6'h2b,
	ALU_SLE  	= 6'h2c,
	ALU_SGE  	= 6'h2d,
	MOVFP2I 	= 6'h34,
	MOVI2FP 	= 6'h35,
	NOP 		= 6'h15
} ALU_FUNC;

//OPCODES
typedef enum logic [5:0]{
 ALU_OP 	=6'h00,
 FPU_OP 	=6'h01,
 J 		=6'h02,
 JAL 	=6'h03,
 BEQZ 	=6'h04,
 BNEZ 	=6'h05,
 ADDI 	=6'h08,
 ADDUI 	=6'h09,
 SUBI 	=6'h0a,
 SUBUI 	=6'h0b,
 ANDI 	=6'h0c,
 ORI 	=6'h0d,
 XORI 	=6'h0e,
 LHI 	=6'h0f,
 JR 	=	6'h12,
 JALR 	=6'h13,
 SLLI 	=6'h14,
 SRLI 	=6'h16,
 SRAI 	=6'h17,
 SEQI 	=6'h18,
 SNEI 	=6'h19,
 SLTI 	=6'h1a,
 SGTI 	=6'h1b,
 SLEI 	=6'h1c,
 SGEI 	=6'h1d,
 LB 	=	6'h20,
 LH 	=	6'h21,
 LW 	=	6'h23,
 LBU 	=6'h24,
 LHU 	=6'h25,
 SB 	=	6'h28,
 SH 	=	6'h29,
 SW 	=	6'h2b
}OPCODE;