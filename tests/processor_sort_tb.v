module processor_tb();
	parameter IMEMFILE = "../tests/sort_instr.hex";
    parameter DMEMFILE = "../tests/sort_data.hex";
    reg [8*80-1:0] filename;
    reg reset, clock; 
    wire [0:31] addr, iaddr, data_from_mem, data_from_reg, instr,data_from_proc;
	wire write_enable, mem_byte, mem_half_word, sign_extend;

    integer i;

    dmem #(.SIZE(16384)) DMEM(
		.addr(addr),
		.data_out(data_from_mem),
		.data_in(data_from_proc),
		.write_enable(write_enable),
		.mem_byte(mem_byte),
		.mem_half_word(mem_half_word),
		.sign_extend(sign_extend),
		.clock(clock)
	);

	imem #(.SIZE(1024)) IMEM(
		.addr(iaddr),
		.instr(instr)
	);

	processor PROCESSOR(
		//Global signals
		.clock(clock),
		.reset(reset),
		//DMEM signals
		.addr_to_mem(addr),
		.write_enable_to_mem(write_enable),
		.byte_to_mem(mem_byte),
		.half_word_to_mem(mem_half_word),
		.sign_extend_to_mem(sign_extend),
		.data_to_mem(data_from_proc),
		.data_from_mem(data_from_mem),
		//IMEM signals
		.iaddr(iaddr),
		.inst_from_mem(instr)
	);

	always begin
		//Clock cycle is 100
		#100 clock = !clock;
// 		if((instr == 32'hac612000 || instr == 32'hac622000) && clock ==1)
// 			$display("clock = %b \t reset = %b \t iaddr = %x \t instruction = %x \t addr_to_mem = %x \tdata_to_mem =%d \t data_from_mem =%x\n\n", clock, reset, iaddr, instr, addr,data_from_proc, data_from_mem);
	end
    initial begin
		$monitor("clock = %b \t reset = %b \t iaddr = %x \t instruction = %x \t addr_to_mem = %x \tdata_to_mem =%d \t data_from_mem =%x",
		clock, reset, iaddr, instr, addr,data_from_proc, data_from_mem);

        // Clear DMEM
        for (i = 0; i < DMEM.SIZE; i = i+1)
            DMEM.mem[i] = 8'h0;

		// Load IMEM from file
		if (!$value$plusargs("instrfile=%s", filename)) begin
			filename = IMEMFILE;
		end
		$readmemh(filename, IMEM.mem);

        // Load DMEM from file
        if (!$value$plusargs("datafile=%s", filename)) begin
            filename = DMEMFILE;
        end
        $readmemh(filename, DMEM.mem);

		//Print memory
		$display("Memory Before");
		for (i = 8192; i<8292; i = i+1) begin
			$display("%d", DMEM.mem[i]);
		end

		//Start clock

		#0 clock = 1;
		#0 reset = 1;
		//Reset registers for 1 cycle

		#199 reset = 0;

	end

	always begin
		if(^instr === 1'bx && reset === 0) begin
			//Print memory
			$display("Memory After");
			for (i = 8192; i<8292; i = i+1) begin
				$display("%d", DMEM.mem[i]);
			end
			//End Sumulation
			$finish;
		end
		else
			#100;
	end

endmodule

