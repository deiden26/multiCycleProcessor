module alufputest;
        reg [0:31] FBUSA, FBUSB;
	reg [0:3] ALUCTRL;
	reg CLOCK;
        reg FPUCTRL, ISMULT;
        wire [0:31] FPUOUT, ALUOUT;
	wire GP_BRANCH, FP_BRANCH, MULTSTALL;

        alufpu ALUFPU(.clock(CLOCK), .multStall(MULTSTALL), .ALUctrl(ALUCTRL), .fbusA(FBUSA), .fbusB(FBUSB), .FPUctrl(FPUCTRL), .isMult(ISMULT), .ALUout(ALUOUT), .FPUout(FPUOUT), .gp_branch(GP_BRANCH), .fp_branch(FP_BRANCH));

       initial begin
        $monitor("MULTSTALL = %d FPUOUT = %d ALUOUT = %d", MULTSTALL, FPUOUT, ALUOUT);
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

	#160 CLOCK=0; FBUSA=5000; FBUSB=2; FPUCTRL=0; ISMULT=1;
	#4060 ISMULT=0; ALUCTRL=3;

	end

	always
		#50 CLOCK=!CLOCK;
	initial
		#8000 $finish;
endmodule

