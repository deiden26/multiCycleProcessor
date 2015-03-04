module wb(ALUout, FPUout, busA, fbusA, MEMout, busW, fbusW, busWctrl, memToReg, movInstr, jalOut);
	input [0:31] ALUout, FPUout, busA, fbusA, MEMout, jalOut;
	input busWctrl, memToReg, movInstr;

	output [0:31] busW, fbusW;
	reg [0:31] busW, fbusW, muxout1, muxout2, muxout3;

	always@(*)
	begin

	if (memToReg) begin
		muxout1 <= MEMout;
		muxout2 <= MEMout;
	end
	else begin
		muxout1 <= ALUout;
		muxout2 <= FPUout;
	end

	if (movInstr) begin
		muxout3 <= fbusA;
		fbusW <= busA;
	end
	else begin
		muxout3 <= muxout1;
		fbusW <= muxout2;
	end

	if (busWctrl)
		busW <= jalOut;
	else
		busW <= muxout3;

	end
		
endmodule
