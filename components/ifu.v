/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  ifu.v                                               //
//                                                                     //
//  Description :  Instruction fetch component of processor. Get       //
//                 the instruction and send it to the decoder          // 
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

module ifu(
	input clock,                  // system clock
	input reset,                  // system reset
	input branch,                 // whether to branch at all
	input gp_branch,              // taken-branch signal for alu
	input fp_branch,              // taken-branch signal for fpu 
	input jump,                   // jump signal
	input use_reg,                // if JR or JALR
	input stall,
	input [0:31] branch_offset, 
	input [0:31] jump_offset,
	input [0:31] pc_from_reg,            // use if use_reg is TRUE
	input  [0:31] inst_from_mem,          // Data coming back from instruction-memory

	output [0:31] pc_to_mem,              // Address sent to Instruction memory
	output [0:31] pc_8_out,               // PC of to store in reg31 for JAL & JALR (PC+8)
	output [0:31] inst_out                // fetched instruction out
);

	wire [0:31] pc_plus_4;               // Default next pc

	reg [0:31] next_pc;                 // Actual next pc
	reg [0:31] current_pc;              // PC we are currently fetching

	assign pc_to_mem = {current_pc[0:29], 2'b0};

	// pass instruction fetched from memory to output (assumes memory passes back 32 bits)
	assign inst_out = inst_from_mem;

	// default next PC value
	assign pc_plus_4 = current_pc + 4;

	// Pass PC+8 out to reg31
	assign pc_8_out = pc_plus_4 + 4;

	// calculate next pc
	always @(*) begin
		//If branching, next_pc = pc + 4 + signExtend(inst_out[0:15])
		if ((gp_branch || fp_branch) && branch)
			next_pc <= pc_plus_4 + branch_offset;
		//If JALR or JR, next_pc = reg31
		else if (jump && use_reg)
			next_pc <= pc_from_reg;
		//If jumping (without reg), next_pc = pc + 4 + signExtend(inst_out[0:25])
		else if (jump)
			next_pc <= pc_plus_4 + jump_offset;
		//Default: move to next word in mem, pc = pc + 4
		else
			next_pc <= pc_plus_4;
	end

	// This register holds the PC value
	always@(negedge clock) begin
		if(reset)
			current_pc <= 32'b0;       // initial PC value is 0
		else if(stall)
			current_pc <= current_pc;  //Keep the current PC
		else
			current_pc <= next_pc;    // transition to next PC
	end 

endmodule
