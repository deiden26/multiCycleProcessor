module forwarder(
	input logic [0:1] op_a_sel,
	input logic [0:1] op_b_sel,
	input logic alu_src,
	input logic mem_we,
	input logic [0:31] ex_stage_op_a,
	input logic [0:31] ex_stage_op_b,
	input logic [0:31] ex_stage_bus_b,
	input logic [0:31] mem_stage_data,
	input logic [0:31] wb_stage_data,
	output logic [0:31] fwd_op_a,
	output logic [0:31] fwd_op_b,
	output logic [0:31] fwd_bus_b
);

	always@(*) begin
		if(op_a_sel == FWD_FROM_EX_MEM)
			fwd_op_a = mem_stage_data;
		else if(op_a_sel == FWD_FROM_MEM_WB)
			fwd_op_a = wb_stage_data;
		else 
			fwd_op_a= ex_stage_op_a;

		if(alu_src == 1)
			fwd_op_b= ex_stage_op_b;
		else begin
			if(op_b_sel == FWD_FROM_EX_MEM)
				fwd_op_b = mem_stage_data;
			else if(op_b_sel == FWD_FROM_MEM_WB)
				fwd_op_b = wb_stage_data;
			else 
				fwd_op_b = ex_stage_op_b;
		end


		if(mem_we == 1) begin
			if(op_b_sel == FWD_FROM_EX_MEM)
				fwd_bus_b = mem_stage_data;
			else if(op_b_sel == FWD_FROM_MEM_WB)
				fwd_bus_b = wb_stage_data;
			else 
				fwd_bus_b = ex_stage_bus_b;
		end
	end
endmodule
	
