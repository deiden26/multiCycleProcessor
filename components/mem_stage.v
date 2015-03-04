module mem_stage(
	input store_fp,

	input [0:31] addr_from_proc,
	input [0:31] gp_data_from_proc,
	input [0:31] fp_data_from_proc,
	input write_enable_from_proc,
	input byte_from_proc,
	input half_word_from_proc,
    input sign_extend_from_proc,
	output reg [0:31] data_to_proc,

	output [0:31] addr_to_mem,
	output [0:31] data_to_mem,
	output write_enable_to_mem,
	output byte_to_mem,
	output half_word_to_mem,
	output sign_extend_to_mem,
	input [0:31] data_from_mem
);
	reg [0:31] data_from_proc;

	//always @(*) begin
	//	if (store_fp)
	//		data_from_proc = fp_data_from_proc;
	//	else
	//		data_from_proc = gp_data_from_proc;
	//end

	assign data_from_proc = (store_fp == 1) ? fp_data_from_proc : gp_data_from_proc;

	assign addr_to_mem = addr_from_proc;
	assign data_to_mem = data_from_proc;
	assign write_enable_to_mem = write_enable_from_proc;
	assign byte_to_mem = byte_from_proc;
	assign half_word_to_mem = half_word_from_proc;
	assign sign_extend_to_mem = sign_extend_from_proc;
	assign data_to_proc = data_from_mem;

endmodule // dmem
