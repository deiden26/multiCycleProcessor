module alufputest;
        reg [0:31] FBUSA, FBUSB, BUSA, BUSB;
	reg [0:3] ALUCTRL;
	reg CLOCK;
        reg [0:3] FPUCTRL;
        wire [0:31] FPUOUT, ALUOUT;
	wire GP_BRANCH, FP_BRANCH, MULTSTALL;

        alufpu ALUFPU(.clock(CLOCK), .busA(BUSA), .busB(BUSB), .multStall(MULTSTALL), .ALUctrl(ALUCTRL), .fbusA(FBUSA), .fbusB(FBUSB), .FPUctrl(FPUCTRL), .ALUout(ALUOUT), .FPUout(FPUOUT), .gp_branch(GP_BRANCH), .fp_branch(FP_BRANCH));

       initial begin
        $monitor("MULTSTALL = %d FPUOUT = %d CONTROL = %d", MULTSTALL, FPUOUT, FPUCTRL);
  //      #0 CLOCK=0; BUSA=2; BUSB=4; ALUCTRL=0; ISMULT=0;
//	#60 BUSA=$signed(-1); ALUCTRL=1;
//	#110 ALUCTRL=2;
//	#1 BUSA=28; ALUCTRL=3;
//	#1 BUSA=36; ALUCTRL=4;
//	#1 BUSA=32; BUSB=0; ALUCTRL=5;
//	#1 BUSB=36; ALUCTRL=6;
//	#1 BUSA=4; ALUCTRL=7;
//	#1 ALUCTRL=12;
//	#1 BUSA=40;
//	#1 BUSA=36;
//	#1 BUSB=40; ALUCTRL=13;
//	#1 BUSA=41;
//	#1 BUSA=40;
//	#1 BUSB=32; ALUCTRL=14;

	#0 CLOCK=0; BUSA=5000; BUSB=2; FBUSA=5000; FBUSB=2; FPUCTRL=0;
	#1000 FPUCTRL=1;
	#1200 FPUCTRL=2;
	#1300 FPUCTRL=3;
	#1400 FPUCTRL=4;
	#1500 FPUCTRL=8;

	end

	always
		#50 CLOCK=!CLOCK;
	initial
		#8000 $finish;
endmodule

