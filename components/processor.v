module processor(
	//Global signals
	 input clock,
	 input reset,
	//DMEM signals
	 output [0:31]addr_to_mem,
	 output write_enable_to_mem,
	 output byte_to_mem,
	 output half_word_to_mem,
	 output sign_extend_to_mem,
	 output [0:31]data_to_mem,
	 input [0:31]data_from_mem,
	//IMEM signals
	 output [0:31]iaddr,
	 input [0:31]inst_from_mem
);

	/*~~~~~ Single Bit Signals  ~~~~~*/
	logic
		//If stage
		if_branch, if_gp_branch, if_fp_branch, if_jump, if_jump_use_reg, if_stall,
		//ID stage
		id_branch, id_jump, id_fpu_ctrl_bits, id_mem_we, id_mov_instr, id_mem_byte, id_mem_half_word, id_mem_sign_extend, id_jal_instr, id_jump_use_reg, ld_stall, id_alu_src, id_reg_we,
		//EX stage
		ex_fpu_ctrl_bits, ex_branch, ex_mem_we, ex_mem_to_reg, ex_mov_instr, ex_mem_byte, ex_mem_half_word, ex_mem_sign_extend, ex_jal_instr, ex_jump, ex_jump_use_reg, ex_gp_branch, ex_fp_branch, ex_alu_src, ex_reg_we,
		//MEM stage
		mem_mem_we, mem_mem_byte, mem_mem_half_word, mem_mem_sign_extend, mem_jal_instr, mem_mem_to_reg, mem_mov_instr, mem_reg_we,
		//WB stage
		wb_jal_instr, wb_mem_to_reg, wb_mov_instr, wb_reg_we,
		//Pipe register stalls
		if_id_stall, id_ex_stall, ex_mem_stall, mem_wb_stall;

	/*~~~~~ 2 Bit Signals  ~~~~~*/
	logic [0:1]
		//ID stage
		id_op_a_sel, id_op_b_sel,
		//EX stage
		ex_op_a_sel, ex_op_b_sel;

	/*~~~~~ 4 Bit Signals  ~~~~~*/
	logic [0:3]
		//ID stage
		id_alu_ctrl_bits,
		//EX stage
		ex_alu_ctrl_bits;

	/*~~~~~ 5 Bit Signals  ~~~~~*/
	logic [0:4]
		//ID stage
		id_rw, 
		//EX stage
		ex_rw, mem_rw,
		//WB stage
		wb_rw;

	/*~~~~~ 32 Bit Signals  ~~~~~*/
	logic [0:31]
		//IF stage
		if_operand_a, if_pc_plus_8, if_instr, if_branch_offset, if_jump_offset,
		//ID stage
		id_instr,id_operand_a, id_operand_b, id_pc_plus_8, id_bus_b, id_f_operand_a, id_f_operand_b, id_jump_offset,
		//EX stage
		ex_operand_a, ex_operand_b, ex_f_operand_a, ex_f_operand_b, ex_alu_out, ex_fpu_out, ex_pc_plus_8,ex_bus_b, ex_jump_offset,

		//Forwarding intermediates
		fwd_ex_operand_a, fwd_ex_operand_b, fwd_ex_bus_b,
		//MEM stage
		mem_alu_out, mem_fpu_out, mem_bus_b, mem_f_operand_b, mem_mem_data, mem_operand_a, mem_f_operand_a, mem_pc_plus_8,
		//WB stage
		wb_alu_out, wb_fpu_out, wb_operand_a, wb_f_operand_a, wb_mem_data, wb_pc_plus_8,
		//WB-ID connections
		bus_w, fbus_w;


	/*~~~~~ IFU Stage ~~~~~*/
	ifu IFU(
		.clock (clock),                  // system clock
		.reset (reset),                  // system reset
		.branch (if_branch),
		.gp_branch (if_gp_branch),              // taken-branch signal for alu
		.fp_branch (if_fp_branch),              // taken-branch signal for fpu 
		.jump (if_jump),                   // jump signal
		.use_reg (if_jump_use_reg),                // if JR or JALR
		.stall (if_stall),
		.branch_offset (if_branch_offset),
		.jump_offset (if_jump_offset),
		.pc_from_reg (if_operand_a),            // use if use_reg is TRUE
		.inst_from_mem (inst_from_mem),          // Data coming back from instruction-memory

		.pc_to_mem (iaddr),              // Address sent to Instruction memory
		.pc_8_out (if_pc_plus_8),               // PC of to store in reg31 for JAL & JALR (PC+8)
		.inst_out (if_instr)               // fetched instruction out
	);

	/*~~~~~ Signals to forward to the ifu immediately ~~~~~*/
	always @(*) begin
		if_branch <= ex_branch;
		if_gp_branch <= ex_gp_branch;
		if_fp_branch <= ex_fp_branch;
		if_jump <= ex_jump;
		if_jump_use_reg <= ex_jump_use_reg;
		if_operand_a <= ex_operand_a;
		if_stall <= ld_stall | mul_stall;
		if_branch_offset <= ex_bus_b;
		if_jump_offset <= ex_jump_offset; 
	end

	/*~~~~~ IFU ID Pipe Register ~~~~~*/
	always @(posedge clock) begin
		if (reset) begin
			id_instr <= 32'b0;
			id_pc_plus_8 <= 32'b0;
		end
		else if (mul_stall) begin
			id_instr <= id_instr;
			id_pc_plus_8 <= id_pc_plus_8;
		end
		else begin
			id_instr <= if_instr;
			id_pc_plus_8 <= if_pc_plus_8;
		end
	end

	/*~~~~~ ID Stage ~~~~~*/
	ID_Stage ID(
		.clk(clock),
		.reset(reset),
		.instruction(id_instr),
		.BUS_W(bus_w),
		.FBUS_W(fbus_w),
		.Rw_ID_EX(ex_rw),
		.Rw_EX_MEM(mem_rw),
		.LD_from_ID_EX(ex_mem_to_reg),
		.Rw_in(wb_rw),
		.jump_offset (id_jump_offset),
		.reg_we_in(wb_reg_we),
		.reg_we_from_ID_EX(ex_reg_we), ////////////////
		.reg_we_from_EX_MEM(mem_reg_we), ////////////////
		.reg_we_out(id_reg_we),
		.Rw_out(id_rw),
		.OPERAND_A(id_operand_a),
		.OPERAND_B(id_operand_b),
		.BUS_B(id_bus_b),
		.F_OPERAND_A(id_f_operand_a),
		.F_OPERAND_B(id_f_operand_b),
		.BRANCH(id_branch),
		.JUMP(id_jump),
		.ALU_CTRL_BITS(id_alu_ctrl_bits),
		.FPU_CTRL_BITS(id_fpu_ctrl_bits),
		.ALU_SRC(id_alu_src),
		.MEM_WR(id_mem_we),
		.MEM_TO_REG(id_mem_to_reg),
		.MOV_INSTR(id_mov_instr),
		.MEM_BYTE_OP(id_mem_byte),
		.MEM_HALFWORD_OP(id_mem_half_word),
		.MEM_SIGN_EXT(id_mem_sign_extend),
		.JAL_INSTR(id_jal_instr),
		.JUMP_USE_REG(id_jump_use_reg),
		.Stall_ID(ld_stall),
		.OP_A_SEL(id_op_a_sel),
		.OP_B_SEL(id_op_b_sel)
	);

	/*~~~~~ ID EX Pipe Register ~~~~~*/
	always @(posedge clock) begin
		if (reset | ld_stall) begin
			ex_operand_a <= 32'b0;
			ex_operand_b <= 32'b0;
			ex_bus_b <= 32'b0;
			ex_f_operand_a <= 32'b0;
			ex_f_operand_b <= 32'b0;
			ex_branch <= 1'b0;
			ex_jump <= 1'b0;
			ex_alu_ctrl_bits <= 2'b0;
			ex_fpu_ctrl_bits <= 1'b0;
			ex_mem_we <= 1'b0;
			ex_mem_to_reg <= 1'b0;
			ex_mov_instr <= 1'b0;
			ex_mem_byte <= 1'b0;
			ex_mem_half_word <= 1'b0;
			ex_mem_sign_extend <= 1'b0;
			ex_jal_instr <= 1'b0;
			ex_jump_use_reg <= 1'b0;
			ex_alu_src <= 1'b0;
			ex_rw <= 4'b0000;
			ex_reg_we <= 1'b0;
			ex_op_a_sel <= 2'b00;
			ex_op_b_sel <= 2'b00;
			ex_jump_offset <= 32'b0;

			ex_pc_plus_8 <= 32'b0;
		end
		else if (mul_stall) begin
			ex_operand_a <= ex_operand_a;
			ex_operand_b <= ex_operand_b;
			ex_bus_b <= ex_bus_b;
			ex_f_operand_a <= ex_f_operand_a;
			ex_f_operand_b <= ex_f_operand_b;
			ex_branch <= ex_branch;
			ex_jump <= ex_jump;
			ex_alu_ctrl_bits <= ex_alu_ctrl_bits;
			ex_fpu_ctrl_bits <= ex_fpu_ctrl_bits;
			ex_mem_we <= ex_mem_we;
			ex_mem_to_reg <= ex_mem_to_reg;
			ex_mov_instr <= ex_mov_instr;
			ex_mem_byte <= ex_mem_byte;
			ex_mem_half_word <= ex_mem_half_word;
			ex_mem_sign_extend <= ex_mem_sign_extend;
			ex_jal_instr <= ex_jal_instr;
			ex_jump_use_reg <= if_jump_use_reg;
			ex_alu_src <= ex_alu_src;
			ex_rw <= ex_rw;
			ex_reg_we <= ex_reg_we;
			ex_op_a_sel <= ex_op_a_sel;
			ex_op_b_sel <= ex_op_b_sel;
			ex_jump_offset <= ex_jump_offset;

			ex_pc_plus_8 <= ex_pc_plus_8;
		end
		else begin
			ex_operand_a <= id_operand_a;
			ex_operand_b <= id_operand_b;
			ex_bus_b <= id_bus_b;
			ex_f_operand_a <= id_f_operand_a;
			ex_f_operand_b <= id_f_operand_b;
			ex_branch <= id_branch;
			ex_jump <= id_jump;
			ex_alu_ctrl_bits <= id_alu_ctrl_bits;
			ex_fpu_ctrl_bits <= id_fpu_ctrl_bits;
			ex_mem_we <= id_mem_we;
			ex_mem_to_reg <= id_mem_to_reg;
			ex_mov_instr <= id_mov_instr;
			ex_mem_byte <= id_mem_byte;
			ex_mem_half_word <= id_mem_half_word;
			ex_mem_sign_extend <= id_mem_sign_extend;
			ex_jal_instr <= id_jal_instr;
			ex_jump_use_reg <= id_jump_use_reg;
			ex_alu_src <= id_alu_src;
			ex_rw <= id_rw;
			ex_reg_we <= id_reg_we;
			ex_op_a_sel <= id_op_a_sel;
			ex_op_b_sel <= id_op_b_sel;
			ex_jump_offset <= id_jump_offset;

			ex_pc_plus_8 <= id_pc_plus_8;
		end
	end
		
	always@(*)
	begin

	//add fwd_ex_operand_a, fwd_ex_operand_b, fwd_ex_bus_b

	if(ex_op_a_sel == FWD_FROM_EX_MEM)
		fwd_ex_operand_a = mem_alu_out;
	else if(ex_op_a_sel == FWD_FROM_MEM_WB)
		fwd_ex_operand_a = bus_w;
	else 
		fwd_ex_operand_a= ex_operand_a;

	if(ex_alu_src == 1)
		fwd_ex_operand_b= ex_operand_b;
	else begin
		if(ex_op_b_sel == FWD_FROM_EX_MEM)
			fwd_ex_operand_b = mem_alu_out;
		else if(ex_op_b_sel == FWD_FROM_MEM_WB)
			fwd_ex_operand_b = bus_w;
		else 
			fwd_ex_operand_b = ex_operand_b;
	end


	if(ex_mem_we == 1) begin
		if(ex_op_b_sel == FWD_FROM_EX_MEM)
			fwd_ex_bus_b = mem_alu_out;
		else if(ex_op_b_sel == FWD_FROM_MEM_WB)
			fwd_ex_bus_b = wb_alu_out;
		else 
			fwd_ex_bus_b = ex_bus_b;
		end
	end
	
	/*~~~~~ EX Stage ~~~~~*/
	alufpu ALUFPU(
		.busA(fwd_ex_operand_a),
		.busB(fwd_ex_operand_b),
		.res_EX_MEM(mem_alu_out),
		.res_MEM_WB(bus_w),
		.ALU_SRC(ex_alu_src),
		.busA_sel(ex_op_a_sel),
		.busB_sel(ex_op_b_sel),
		.ALUctrl(ex_alu_ctrl_bits),
		.fbusA(ex_f_operand_a),
		.fbusB(ex_f_operand_b),
		.FPUctrl(ex_fpu_ctrl_bits),
		.ALUout(ex_alu_out),
		.FPUout(ex_fpu_out),
		.gp_branch(ex_gp_branch),
		.fp_branch(ex_fp_branch),
		.multStall(mul_stall)
	);

	/*~~~~~ EX MEM Pipe Register ~~~~~*/
	always @(posedge clock) begin
		if (reset) begin
			mem_alu_out <= 32'b0;
			mem_fpu_out <= 32'b0;

			mem_operand_a <= 32'b0;
			mem_f_operand_a <= 32'b0;
			mem_bus_b <= 32'b0;
			mem_f_operand_b <= 32'b0;
			mem_mem_we <= 1'b0;
			mem_mem_byte <= 1'b0;
			mem_mem_half_word <= 1'b0;
			mem_mem_sign_extend <= 1'b0;
			mem_jal_instr <= 1'b0;
			mem_mem_to_reg <= 1'b0;
			mem_mov_instr <= 1'b0;
			mem_rw <= 4'b0000;
			mem_reg_we <= 1'b0;

			mem_pc_plus_8 <= 32'b0;
		end
		else if (mul_stall) begin
			mem_alu_out <= mem_alu_out;
			mem_fpu_out <= mem_fpu_out;

			mem_operand_a <= mem_operand_a;
			mem_f_operand_a <= mem_f_operand_a;
			mem_bus_b <= mem_bus_b;
			mem_f_operand_b <= mem_f_operand_b;
			mem_mem_we <= mem_mem_we;
			mem_mem_byte <= mem_mem_byte;
			mem_mem_half_word <= mem_mem_half_word;
			mem_mem_sign_extend <= mem_mem_sign_extend;
			mem_jal_instr <= mem_jal_instr;
			mem_mem_to_reg <= mem_mem_to_reg;
			mem_mov_instr <= mem_mov_instr;
			mem_rw <= mem_rw;
			mem_reg_we <= mem_reg_we;

			mem_pc_plus_8 <= mem_pc_plus_8;
		end
		else begin
			mem_alu_out <= ex_alu_out;
			mem_fpu_out <= ex_fpu_out;

			mem_operand_a <= fwd_ex_operand_a;
			mem_f_operand_a <= ex_f_operand_a;
			mem_bus_b <= fwd_ex_bus_b;
			mem_f_operand_b <= ex_f_operand_b;
			mem_mem_we <= ex_mem_we;
			mem_mem_byte <= ex_mem_byte;
			mem_mem_half_word <= ex_mem_half_word;
			mem_mem_sign_extend <= ex_mem_sign_extend;
			mem_jal_instr <= ex_jal_instr;
			mem_mem_to_reg <= ex_mem_to_reg;
			mem_mov_instr <= ex_mov_instr;
			mem_rw <= ex_rw;
			mem_reg_we <= ex_reg_we;

			mem_pc_plus_8 <= ex_pc_plus_8;
		end
	end


	/*~~~~~ MEM Stage ~~~~~*/
	mem_stage MEM(
		.store_fp(1'b0),
		//Connections to processor
		.addr_from_proc(mem_alu_out),
		.gp_data_from_proc(mem_bus_b),
		.fp_data_from_proc(mem_f_operand_b),
		.write_enable_from_proc(mem_mem_we),
		.byte_from_proc(mem_mem_byte),
		.half_word_from_proc(mem_mem_half_word),
		.sign_extend_from_proc(mem_mem_sign_extend),
		.data_to_proc(mem_mem_data),

		//Connections to memory
		.addr_to_mem(addr_to_mem),
		.data_to_mem(data_to_mem),
		.write_enable_to_mem(write_enable_to_mem),
		.byte_to_mem(byte_to_mem),
		.half_word_to_mem(half_word_to_mem),
		.sign_extend_to_mem(sign_extend_to_mem),
		.data_from_mem(data_from_mem)
	);


	/*~~~~~ MEM WB Pipe Register ~~~~~*/
	always @(posedge clock) begin
		if (reset) begin
			wb_mem_data <= 32'b0;

			wb_alu_out <= 32'b0;
			wb_fpu_out <= 32'b0;
			wb_operand_a <= 32'b0;
			wb_f_operand_a <= 32'b0;
			wb_jal_instr <= 1'b0;
			wb_mem_to_reg <= 1'b0;
			wb_rw <= 4'b0000;
			wb_reg_we <= 1'b0;

			wb_pc_plus_8 <= 32'b0;
		end
		else if (mul_stall) begin
			wb_mem_data <= wb_mem_data;

			wb_alu_out <= wb_alu_out;
			wb_fpu_out <= wb_fpu_out;
			wb_operand_a <= wb_operand_a;
			wb_f_operand_a <= wb_f_operand_a;
			wb_jal_instr <= wb_jal_instr;
			wb_mem_to_reg <= wb_mem_to_reg;
			wb_rw <= wb_rw;
			wb_reg_we <= wb_reg_we;

			wb_pc_plus_8 <= wb_pc_plus_8;
		end
		else begin
			wb_mem_data <= mem_mem_data;

			wb_alu_out <= mem_alu_out;
			wb_fpu_out <= mem_fpu_out;
			wb_operand_a <= mem_operand_a;
			wb_f_operand_a <= mem_f_operand_a;
			wb_jal_instr <= mem_jal_instr;
			wb_mem_to_reg <= mem_mem_to_reg;
			wb_rw <= mem_rw;
			wb_reg_we <= mem_reg_we;

			wb_pc_plus_8 <= mem_pc_plus_8;
		end
	end

	/*~~~~~ WB Stage ~~~~~*/
	wb WB(
		.ALUout(wb_alu_out),
		.FPUout(wb_fpu_out),
		.busA(wb_operand_a),
		.fbusA(wb_f_operand_a),
		.MEMout(wb_mem_data),
		.busW(bus_w),
		.fbusW(fbus_w),
		.busWctrl(wb_jal_instr),
		.memToReg(wb_mem_to_reg),
		.movInstr(wb_mov_instr),
		.jalOut(wb_pc_plus_8)
	);


endmodule
