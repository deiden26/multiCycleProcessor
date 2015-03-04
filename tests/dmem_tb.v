module dmem_tb();
    parameter DMEMFILE = "../tests/data.hex";
    reg [8*80-1:0] filename;
    reg [0:31] addr, data_in;
    wire [0:31] data_out;
    reg clock, write_enable, byte, half_word, sign_extend;

    integer i;

    dmem #(.SIZE(16384)) DMEM(.addr(addr), .data_out(data_out), .data_in(data_in), .write_enable(write_enable), .byte(byte), .half_word(half_word), .sign_extend(sign_extend), .clock(clock));

	always
		#50 clock = !clock;

    initial begin
        // Clear DMEM
        for (i = 0; i < DMEM.SIZE; i = i+1)
            DMEM.mem[i] = 8'h0;

        // Load DMEM from file
        if (!$value$plusargs("datafile=%s", filename)) begin
            filename = DMEMFILE;
        end
        $readmemh(filename, DMEM.mem);

        //// Debug: dump memory
        //$writememh("dmem", DMEM.mem);

		//Monitor all inputs and outputs
        $monitor("write enable=%b | byte=%b | half word=%b | sign extend=%b | address=%x | data out= %x | data in=%x",
			write_enable, byte, half_word, sign_extend, addr, data_out, data_in);

		//Start clock
		clock = 0;

        // Get some words
		write_enable = 0;
		byte = 0;
		half_word = 0;
		sign_extend = 0;
		data_in = 0;
        addr = 32'h2000;
		#100
        addr = 32'h2004;
		#100

        // Get some half words (zero extended)
		write_enable = 0;
		byte = 0;
		half_word = 1;
		sign_extend = 0;
		data_in = 0;
        addr = 32'h2000;
		#100
        addr = 32'h2004;
		#100
		
        // Get some half words (sign extended)
		write_enable = 0;
		byte = 0;
		half_word = 1;
		sign_extend = 1;
		data_in = 0;
        addr = 32'h2000;
		#100
        addr = 32'h2004;
		#100

        // Get some bytes (zero extended)
		write_enable = 0;
		byte = 1;
		half_word = 0;
		sign_extend = 0;
		data_in = 0;
        addr = 32'h2000;
		#100
        addr = 32'h2004;
		#100
		
        // Get some bytes (sign extended)
		write_enable = 0;
		byte = 1;
		half_word = 0;
		sign_extend = 1;
		data_in = 0;
        addr = 32'h2000;
		#100
        addr = 32'h2004;
		#100

        //Write some words
		write_enable = 1;
		byte = 0;
		half_word = 0;
		sign_extend = 0;
		data_in = $signed(1);
        addr = 32'h2000;
		#100
		data_in = $signed(-1);
        addr = 32'h2004;
		#100

		//Read back words
		write_enable = 0;
		byte = 0;
		half_word = 0;
		sign_extend = 0;
		data_in = 0;
        addr = 32'h2000;
		#100
        addr = 32'h2004;
		#100

        //Write some half words
		write_enable = 1;
		byte = 0;
		half_word = 1;
		sign_extend = 0;
		data_in = $signed(1);
        addr = 32'h2008;
		#100
		data_in = $signed(-1);
        addr = 32'h200c;
		#100

		//Read back half words
		write_enable = 0;
		byte = 0;
		half_word = 1;
		sign_extend = 0;
		data_in = 0;
        addr = 32'h2008;
		#100
        addr = 32'h200c;
		#100

        //Write some bytes
		write_enable = 1;
		byte = 1;
		half_word = 0;
		sign_extend = 0;
		data_in = $signed(1);
        addr = 32'h2010;
		#100
		data_in = $signed(-1);
        addr = 32'h2014;
		#100

		//Read back bytes
		write_enable = 0;
		byte = 1;
		half_word = 0;
		sign_extend = 0;
		data_in = 0;
        addr = 32'h2010;
		#100
        addr = 32'h2014;
		#100

		//End Simulations
		$finish;
	end
endmodule

