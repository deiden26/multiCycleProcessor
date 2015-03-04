module gprFile_tb;
	reg clk;
	 reg reset;
	 reg regWr;
	 reg [4:0] Rs;
	 reg [4:0] Rt;
	 reg [4:0] Rd;
	 reg Rdst;
	 reg jal_instr;
	 reg [31:0] busW;
	 wire [31:0] busA;
	 wire [31:0] busB;

	 gprFile file1(
	 .clk (clk),
	 .reset (reset),
	 .regWr (regWr),
	 .Rs (Rs),
	 .Rt (Rt),
	 .Rd (Rd),
	 .Rdst (Rdst),
	 .jal_instr (jal_instr),
	 .busW (busW),
	 .busA (busA),
	 .busB (busB) );

always
	#50 clk = !clk;

 initial
	begin
		clk = 0;
		reset = 1;
		regWr = 0;
		Rs = 0;
		Rt = 0;
		Rd = 0;
		Rdst = 0;
		jal_instr = 0;
		busW = 80;
	end

initial
	begin
		$monitor("Clk=%d\treset=%d\tregWr=%d\tRs=%d\tRt=%d\tRd=%d\tRdst=%d\tjal_instr=%d\tbusW=%d\tbusA=%d\tbusB=%d\t",clk,reset,regWr,Rs,Rt,Rd,Rdst,jal_instr,busW,busA,busB);
	end

initial
	begin
	#100 reset = 0; 
	regWr = 1;
	Rt = 5'b00100;

	#200 Rs = 4;
	Rt = 3;
	busW = 111;
	end
	

initial
	#500 $finish;



endmodule
