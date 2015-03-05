module alufputest;
        reg [31:0] BUSA, BUSB, FBUSA, FBUSB;
	reg [3:0] ALUCTRL;
        reg FPUCTRL;
        wire [31:0] FPUOUT, ALUOUT;
	wire GP_BRANCH, FP_BRANCH;

        alufpu ALUFPU(.busA(BUSA), .busB(BUSB), .ALUctrl(ALUCTRL), .fbusA(FBUSA), .fbusB(FBUSB), .FPUctrl(FPUCTRL), .ALUout(ALUOUT), .FPUout(FPUOUT), .gp_branch(GP_BRANCH), .fp_branch(FP_BRANCH));

       initial begin
        $monitor("FBUSA = %d FBUSB = %d FPUCTRL = %b FPUOUT = %d", FBUSA, FBUSB, FPUCTRL, FPUOUT);
//      #0 BUSA=2; BUSB=4; ALUCTRL=0;
//	#1 BUSA=$signed(-1); ALUCTRL=1;
//	#1 ALUCTRL=2;
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

	#0 FBUSA=2; FBUSB=8; FPUCTRL=0;
	#1 FBUSB=-8;
	#1 FPUCTRL=1;
	#1 FBUSA=35;
	#1 FBUSA=1000; FBUSB=2000;
        end
endmodule

