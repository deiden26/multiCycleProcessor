module alufputest;
        reg [0:31] BUSA, BUSB, FBUSA, FBUSB;
	reg [0:3] ALUCTRL;
        reg FPUCTRL;
        wire [0:31] FPUOUT, ALUOUT, BUSAOUT, FBUSAOUT;

        alufpu ALUFPU(.busA(BUSA), .busB(BUSB), .ALUctrl(ALUCTRL), .fbusA(FBUSA), .fbusB(FBUSB), .FPUctrl(FPUCTRL), .ALUout(ALUOUT), .FPUout(FPUOUT), .busAout(BUSAOUT), .fbusAout(FBUSAOUT));

       initial begin
        $monitor("BUSA = %d BUSB = %d ALUCTRL = %b ALUOUT = %d", BUSA, BUSB, ALUCTRL, ALUOUT);
        #0 BUSA=2; BUSB=4; ALUCTRL=0;
        end
endmodule

