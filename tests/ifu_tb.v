module ifu_tb;
	reg         clock;                  // system clock
	reg         reset;                  // system reset
	reg         gp_branch;              // taken-branch signal for alu
	reg         fp_branch;              // taken-branch signal for fpu 
	reg         jump;                   // jump signal
	reg         use_reg;                // if JR or JALR
	reg  [31:0] pc_from_reg;            // use if use_reg is TRUE
	wire  [31:0] inst_from_mem;          // Data coming back from instruction-memory

	wire  [31:0] pc_to_mem;              // Address sent to Instruction memory
	wire  [31:0] pc_8_out;               // PC of to store in reg31 for JAL & JALR (PC+8)
	wire  [31:0] inst_out;                // fetched instruction out

	reg [8*80-1:0] memfile;

	ifu IFU(
		.clock (clock),                  // system clock
		.reset (reset),                  // system reset
		.gp_branch (gp_branch),              // taken-branch signal for alu
		.fp_branch (fp_branch),              // taken-branch signal for fpu 
		.jump (jump),                   // jump signal
		.use_reg (use_reg),                // if JR or JALR
		.pc_from_reg (pc_from_reg),            // use if use_reg is TRUE
		.inst_from_mem (inst_from_mem),          // Data coming back from instruction-memory

		.pc_to_mem (pc_to_mem),              // Address sent to Instruction memory
		.pc_8_out (pc_8_out),               // PC of to store in reg31 for JAL & JALR (PC+8)
		.inst_out (inst_out)               // fetched instruction out
	);

	imem IMEM(
		.addr(pc_to_mem),
		.instr(inst_from_mem)
	);

	always
		#50 clock = !clock;

		initial begin
			memfile = "../tests/instr.hex";
			$readmemh(memfile, IMEM.mem);
		end

		initial begin
			clock = 0;
			reset = 1;
			gp_branch = 0;
			fp_branch = 0;
			jump = 0;
			use_reg = 0;
			pc_from_reg = 0;
		end

		initial begin
			$monitor("clock=%d\treset=%d\tgp_branch=%d\tfp_branch=%d\tjump=%d\tuse_reg=%d\tpc_from_reg=%d\tinst_from_mem=%x\tpc_to_mem=%d\tpc_8_out=%d\tinst_out=%h\t",
			clock,reset,gp_branch,fp_branch,jump,use_reg,pc_from_reg,inst_from_mem,pc_to_mem,pc_8_out,inst_out);
		end

		initial begin
			#100 reset = 0; 


		end


		initial
			#500 $finish;
endmodule
