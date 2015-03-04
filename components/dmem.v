module dmem(
	input [0:31] addr,
	input [0:31] data_in,
	input clock,
	input write_enable,
	input mem_byte,
	input mem_half_word,
    input sign_extend,

	output reg [0:31] data_out);

	parameter SIZE=32768;
	reg [0:7] mem[0:(SIZE-1)];

	always @ (negedge clock) begin
		//Write
		if (write_enable) begin
			if(mem_byte)
				mem[addr] <= data_in[24:31];
			else if(mem_half_word)
				{mem[addr], mem[addr+1]} <= data_in[16:31];
			else
				{mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} <= data_in[0:31];
		end
		//Read
		else begin
			if(mem_byte) begin
				if(sign_extend)
					data_out <= $signed(mem[addr]);
				else
					data_out <= $unsigned(mem[addr]);
			end

			else if(mem_half_word) begin
				if(sign_extend)
					data_out <= $signed({mem[addr], mem[addr+1]});
				else
					data_out <= $unsigned({mem[addr], mem[addr+1]});
			end

			else
				data_out <= {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
		end
	end

endmodule // dmem

