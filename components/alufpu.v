module alufpu(clock, busA, busB, res_EX_MEM, res_MEM_WB, ALU_SRC, busA_sel, busB_sel,  ALUctrl, fbusA, fbusB, FPUctrl, multStall, ALUout, FPUout, gp_branch, fp_branch);
	input [0:31] busA, busB, res_EX_MEM, res_MEM_WB,  fbusA, fbusB;
	input [0:3] ALUctrl;
	input [0:3] FPUctrl;
	input clock, ALU_SRC;
	input [0:1] busA_sel, busB_sel;

	//reg [0:31] busA, busB;
	output [0:31] ALUout, FPUout;
	reg [0:31] temp_busB;
	reg[0:31] temp_busA;
	output reg multStall;
	output reg gp_branch, fp_branch;
	reg branch;
	reg [0:5] counter;
	reg [0:31] multOut, multuOut, FPUout, ALUout, busAout, fbusAout;
	reg [0:31]  sllOut, srlOut, sraOut;
	reg [0:31]  addOut, subOut;
	reg [0:31]  orOut, andOut, xorOut;
	reg [0:31]  seqOut, sneOut, sltOut, sgtOut, sleOut, sgeOut;
	reg [0:31]  lhiOut;

	//make partial products
	reg [0:31] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8, pp9, pp10, pp11, pp12, pp13, pp14, pp15, pp16, pp17, pp18, pp19, pp20, pp21, pp22, pp23, pp24, pp25, pp26, pp27, pp28, pp29, pp30, pp31;




	always@(posedge clock) begin
		if (counter > 0)
			counter <= counter-1;
		if (counter == 31)
			temp_busA <= pp0;
		else
			temp_busA <= FPUout;
		case(counter)
		0: temp_busB <= 0;
		1: temp_busB <= pp1;
		2: temp_busB <= pp2;
		3: temp_busB <= pp3;
		4: temp_busB <= pp4;
		5: temp_busB <= pp5;
		6: temp_busB <= pp6;
		7: temp_busB <= pp7;
		8: temp_busB <= pp8;
		9: temp_busB <= pp9;
		10: temp_busB <= pp10;
		11: temp_busB <= pp11;
		12: temp_busB <= pp12;
		13: temp_busB <= pp13;
		14: temp_busB <= pp14;
		15: temp_busB <= pp15;
		16: temp_busB <= pp16;
		17: temp_busB <= pp17;
		18: temp_busB <= pp18;
		19: temp_busB <= pp19;
		20: temp_busB <= pp20;
		21: temp_busB <= pp21;
		22: temp_busB <= pp22;
		23: temp_busB <= pp23;
		24: temp_busB <= pp24;
		25: temp_busB <= pp25;
		26: temp_busB <= pp26;
		27: temp_busB <= pp27;
		28: temp_busB <= pp28;
		29: temp_busB <= pp29;
		30: temp_busB <= pp30;
		31: temp_busB <= pp31;
		endcase
	end

	always@(negedge clock)
		multOut <= temp_busA + temp_busB;

	always@(FPUctrl[3]) begin
		if (FPUctrl[3]==1)
			counter <= 32;
		else
			counter <= 0;
	end

	always@(counter) begin
		if (counter==0)
			multStall <= 0;
		else
			multStall <= 1;
	end
	
	always@(*)
	begin
	
	//ALU output
	sllOut <= busA << busB;
	srlOut <= busA >> busB;
	sraOut <= $signed(busA) >>> busB;
	addOut <= busA + busB;
	subOut <= busA - busB;
	andOut <= busA & busB;
	orOut <= busA | busB;
	xorOut <= busA ^ busB;
	lhiOut <= {busB[16:31], 16'b0};

	if (busA==busB) begin
	seqOut <= 1;
	sneOut <= 0;
	end
	
	else begin
	seqOut <= 0;
	sneOut <= 1;
	end

	if (busA<=busB) begin
	sleOut <= 1;
	sgtOut <= 0;
	end

	else begin
	sleOut <= 0;
	sgtOut <= 1;
	end

	if (busA>=busB) begin
	sgeOut <= 1;
	sltOut <= 0;
	end

	else begin
	sgeOut <= 0;
	sltOut <= 1;
	end

	case (ALUctrl)
	0: ALUout <= sllOut;
	1: ALUout <= srlOut;
	2: ALUout <= sraOut;
	3: ALUout <= addOut;
	4: ALUout <= subOut;
	5: ALUout <= orOut;
	6: ALUout <= andOut;
	7: ALUout <= xorOut;
	8: ALUout <= seqOut;
	9: ALUout <= sneOut;
	10: ALUout <= sltOut;
	11: ALUout <= sgtOut;
	12: ALUout <= sleOut;
	13: ALUout <= sgeOut;
	14: ALUout <= lhiOut;
	endcase

	 gp_branch = ALUout[31];

	end

	//FPU output
	always@(*)
        begin

        //multOut <= fbusA * fbusB;
        pp0 <= {(fbusA[0]&fbusB[31]), 31'b0};
        pp1 <= {(fbusA[1]&fbusB[30]), (fbusA[1]&fbusB[31]), 30'b0};
        pp2 <= {(fbusA[2]&fbusB[29]), (fbusA[2]&fbusB[30]), (fbusA[2]&fbusB[31]), 29'b0};
        pp3 <= {(fbusA[3]&fbusB[28]), (fbusA[3]&fbusB[29]), (fbusA[3]&fbusB[30]), (fbusA[3]&fbusB[31]), 28'b0};
        pp4 <= {(fbusA[4]&fbusB[27]), (fbusA[4]&fbusB[28]), (fbusA[4]&fbusB[29]), (fbusA[4]&fbusB[30]), (fbusA[4]&fbusB[31]), 27'b0};
        pp5 <= {(fbusA[5]&fbusB[26]), (fbusA[5]&fbusB[27]), (fbusA[5]&fbusB[28]), (fbusA[5]&fbusB[29]), (fbusA[5]&fbusB[30]), (fbusA[5]&fbusB[31]), 26'b0};
	pp6 <= {(fbusA[6]&fbusB[25]), (fbusA[6]&fbusB[26]), (fbusA[6]&fbusB[27]), (fbusA[6]&fbusB[28]), (fbusA[6]&fbusB[29]), (fbusA[6]&fbusB[30]), (fbusA[6]&fbusB[31]), 25'b0};
	pp7 <= {(fbusA[7]&fbusB[24]), (fbusA[7]&fbusB[25]), (fbusA[7]&fbusB[26]), (fbusA[7]&fbusB[27]), (fbusA[7]&fbusB[28]), (fbusA[7]&fbusB[29]), (fbusA[7]&fbusB[30]), (fbusA[7]&fbusB[31]), 24'b0};
        pp8 <= {(fbusA[8]&fbusB[23]), (fbusA[8]&fbusB[24]), (fbusA[8]&fbusB[25]), (fbusA[8]&fbusB[26]), (fbusA[8]&fbusB[27]), (fbusA[8]&fbusB[28]), (fbusA[8]&fbusB[29]), (fbusA[8]&fbusB[30]), (fbusA[8]&fbusB[31]), 23'b0};
        pp9 <= {(fbusA[9]&fbusB[22]), (fbusA[9]&fbusB[23]), (fbusA[9]&fbusB[24]), (fbusA[9]&fbusB[25]), (fbusA[9]&fbusB[26]), (fbusA[9]&fbusB[27]), (fbusA[9]&fbusB[28]), (fbusA[9]&fbusB[29]), (fbusA[9]&fbusB[30]), (fbusA[9]&fbusB[31]), 22'b0};
        pp10 <= {(fbusA[10]&fbusB[21]), (fbusA[10]&fbusB[22]), (fbusA[10]&fbusB[23]), (fbusA[10]&fbusB[24]), (fbusA[10]&fbusB[25]), (fbusA[10]&fbusB[26]), (fbusA[10]&fbusB[27]), (fbusA[10]&fbusB[28]), (fbusA[10]&fbusB[29]), (fbusA[10]&fbusB[30]), (fbusA[10]&fbusB[31]), 21'b0};
        pp11 <= {(fbusA[11]&fbusB[20]), (fbusA[11]&fbusB[21]), (fbusA[11]&fbusB[22]), (fbusA[11]&fbusB[23]), (fbusA[11]&fbusB[24]), (fbusA[11]&fbusB[25]), (fbusA[11]&fbusB[26]), (fbusA[11]&fbusB[27]), (fbusA[11]&fbusB[28]), (fbusA[11]&fbusB[29]), (fbusA[11]&fbusB[30]), (fbusA[11]&fbusB[31]), 20'b0};
  	pp12 <= {(fbusA[12]&fbusB[19]), (fbusA[12]&fbusB[20]), (fbusA[12]&fbusB[21]), (fbusA[12]&fbusB[22]), (fbusA[12]&fbusB[23]), (fbusA[12]&fbusB[24]), (fbusA[12]&fbusB[25]), (fbusA[12]&fbusB[26]), (fbusA[12]&fbusB[27]), (fbusA[12]&fbusB[28]), (fbusA[12]&fbusB[29]), (fbusA[12]&fbusB[30]), (fbusA[12]&fbusB[31]), 19'b0};
        pp13 <= {(fbusA[13]&fbusB[18]), (fbusA[13]&fbusB[19]), (fbusA[13]&fbusB[20]), (fbusA[13]&fbusB[21]), (fbusA[13]&fbusB[22]), (fbusA[13]&fbusB[23]), (fbusA[13]&fbusB[24]), (fbusA[13]&fbusB[25]), (fbusA[13]&fbusB[26]), (fbusA[13]&fbusB[27]), (fbusA[13]&fbusB[28]), (fbusA[13]&fbusB[29]), (fbusA[13]&fbusB[30]), (fbusA[13]&fbusB[31]), 18'b0};
        pp14 <= {(fbusA[14]&fbusB[17]), (fbusA[14]&fbusB[18]), (fbusA[14]&fbusB[19]), (fbusA[14]&fbusB[20]), (fbusA[14]&fbusB[21]), (fbusA[14]&fbusB[22]), (fbusA[14]&fbusB[23]), (fbusA[14]&fbusB[24]), (fbusA[14]&fbusB[25]), (fbusA[14]&fbusB[26]), (fbusA[14]&fbusB[27]), (fbusA[14]&fbusB[28]), (fbusA[14]&fbusB[29]), (fbusA[14]&fbusB[30]), (fbusA[14]&fbusB[31]), 17'b0};
        pp15 <= {(fbusA[15]&fbusB[16]), (fbusA[15]&fbusB[17]), (fbusA[15]&fbusB[18]), (fbusA[15]&fbusB[19]), (fbusA[15]&fbusB[20]), (fbusA[15]&fbusB[21]), (fbusA[15]&fbusB[22]), (fbusA[15]&fbusB[23]), (fbusA[15]&fbusB[24]), (fbusA[15]&fbusB[25]), (fbusA[15]&fbusB[26]), (fbusA[15]&fbusB[27]), (fbusA[15]&fbusB[28]), (fbusA[15]&fbusB[29]), (fbusA[15]&fbusB[30]), (fbusA[15]&fbusB[31]), 16'b0};
        pp16 <= {(fbusA[16]&fbusB[15]), (fbusA[16]&fbusB[16]), (fbusA[16]&fbusB[17]), (fbusA[16]&fbusB[18]), (fbusA[16]&fbusB[19]), (fbusA[16]&fbusB[20]), (fbusA[16]&fbusB[21]), (fbusA[16]&fbusB[22]), (fbusA[16]&fbusB[23]), (fbusA[16]&fbusB[24]), (fbusA[16]&fbusB[25]), (fbusA[16]&fbusB[26]), (fbusA[16]&fbusB[27]), (fbusA[16]&fbusB[28]), (fbusA[16]&fbusB[29]), (fbusA[16]&fbusB[30]), (fbusA[16]&fbusB[31]), 15'b0};
        pp17 <= {(fbusA[17]&fbusB[14]), (fbusA[17]&fbusB[15]), (fbusA[17]&fbusB[16]), (fbusA[17]&fbusB[17]), (fbusA[17]&fbusB[18]), (fbusA[17]&fbusB[19]), (fbusA[17]&fbusB[20]), (fbusA[17]&fbusB[21]), (fbusA[17]&fbusB[22]), (fbusA[17]&fbusB[23]), (fbusA[17]&fbusB[24]), (fbusA[17]&fbusB[25]), (fbusA[17]&fbusB[26]), (fbusA[17]&fbusB[27]), (fbusA[17]&fbusB[28]), (fbusA[17]&fbusB[29]), (fbusA[17]&fbusB[30]), (fbusA[17]&fbusB[31]), 14'b0};
        pp18 <= {(fbusA[18]&fbusB[13]), (fbusA[18]&fbusB[14]), (fbusA[18]&fbusB[15]), (fbusA[18]&fbusB[16]), (fbusA[18]&fbusB[17]), (fbusA[18]&fbusB[18]), (fbusA[18]&fbusB[19]), (fbusA[18]&fbusB[20]), (fbusA[18]&fbusB[21]), (fbusA[18]&fbusB[22]), (fbusA[18]&fbusB[23]), (fbusA[18]&fbusB[24]), (fbusA[18]&fbusB[25]), (fbusA[18]&fbusB[26]), (fbusA[18]&fbusB[27]), (fbusA[18]&fbusB[28]), (fbusA[18]&fbusB[29]), (fbusA[18]&fbusB[30]), (fbusA[18]&fbusB[31]), 13'b0};
        pp19 <= {(fbusA[19]&fbusB[12]), (fbusA[19]&fbusB[13]), (fbusA[19]&fbusB[14]), (fbusA[19]&fbusB[15]), (fbusA[19]&fbusB[16]), (fbusA[19]&fbusB[17]), (fbusA[19]&fbusB[18]), (fbusA[19]&fbusB[19]), (fbusA[19]&fbusB[20]), (fbusA[19]&fbusB[21]), (fbusA[19]&fbusB[22]), (fbusA[19]&fbusB[23]), (fbusA[19]&fbusB[24]), (fbusA[19]&fbusB[25]), (fbusA[19]&fbusB[26]), (fbusA[19]&fbusB[27]), (fbusA[19]&fbusB[28]), (fbusA[19]&fbusB[29]), (fbusA[19]&fbusB[30]), (fbusA[19]&fbusB[31]), 12'b0};
        pp20 <= {(fbusA[20]&fbusB[11]), (fbusA[20]&fbusB[12]), (fbusA[20]&fbusB[13]), (fbusA[20]&fbusB[14]), (fbusA[20]&fbusB[15]), (fbusA[20]&fbusB[16]), (fbusA[20]&fbusB[17]), (fbusA[20]&fbusB[18]), (fbusA[20]&fbusB[19]), (fbusA[20]&fbusB[20]), (fbusA[20]&fbusB[21]), (fbusA[20]&fbusB[22]), (fbusA[20]&fbusB[23]), (fbusA[20]&fbusB[24]), (fbusA[20]&fbusB[25]), (fbusA[20]&fbusB[26]), (fbusA[20]&fbusB[27]), (fbusA[20]&fbusB[28]), (fbusA[20]&fbusB[29]), (fbusA[20]&fbusB[30]), (fbusA[20]&fbusB[31]), 11'b0};
        pp21 <= {(fbusA[21]&fbusB[10]), (fbusA[21]&fbusB[11]), (fbusA[21]&fbusB[12]), (fbusA[21]&fbusB[13]), (fbusA[21]&fbusB[14]), (fbusA[21]&fbusB[15]), (fbusA[21]&fbusB[16]), (fbusA[21]&fbusB[17]), (fbusA[21]&fbusB[18]), (fbusA[21]&fbusB[19]), (fbusA[21]&fbusB[20]), (fbusA[21]&fbusB[21]), (fbusA[21]&fbusB[22]), (fbusA[21]&fbusB[23]), (fbusA[21]&fbusB[24]), (fbusA[21]&fbusB[25]), (fbusA[21]&fbusB[26]), (fbusA[21]&fbusB[27]), (fbusA[21]&fbusB[28]), (fbusA[21]&fbusB[29]), (fbusA[21]&fbusB[30]), (fbusA[21]&fbusB[31]), 10'b0};
        pp22 <= {(fbusA[22]&fbusB[9]), (fbusA[22]&fbusB[10]), (fbusA[22]&fbusB[11]), (fbusA[22]&fbusB[12]), (fbusA[22]&fbusB[13]), (fbusA[22]&fbusB[14]), (fbusA[22]&fbusB[15]), (fbusA[22]&fbusB[16]), (fbusA[22]&fbusB[17]), (fbusA[22]&fbusB[18]), (fbusA[22]&fbusB[19]), (fbusA[22]&fbusB[20]), (fbusA[22]&fbusB[21]), (fbusA[22]&fbusB[22]), (fbusA[22]&fbusB[23]), (fbusA[22]&fbusB[24]), (fbusA[22]&fbusB[25]), (fbusA[22]&fbusB[26]), (fbusA[22]&fbusB[27]), (fbusA[22]&fbusB[28]), (fbusA[22]&fbusB[29]), (fbusA[22]&fbusB[30]), (fbusA[22]&fbusB[31]), 9'b0};
        pp23 <= {(fbusA[23]&fbusB[8]), (fbusA[23]&fbusB[9]), (fbusA[23]&fbusB[10]), (fbusA[23]&fbusB[11]), (fbusA[23]&fbusB[12]), (fbusA[23]&fbusB[13]), (fbusA[23]&fbusB[14]), (fbusA[23]&fbusB[15]), (fbusA[23]&fbusB[16]), (fbusA[23]&fbusB[17]), (fbusA[23]&fbusB[18]), (fbusA[23]&fbusB[19]), (fbusA[23]&fbusB[20]), (fbusA[23]&fbusB[21]), (fbusA[23]&fbusB[22]), (fbusA[23]&fbusB[23]), (fbusA[23]&fbusB[24]), (fbusA[23]&fbusB[25]), (fbusA[23]&fbusB[26]), (fbusA[23]&fbusB[27]), (fbusA[23]&fbusB[28]), (fbusA[23]&fbusB[29]), (fbusA[23]&fbusB[30]), (fbusA[23]&fbusB[31]), 8'b0};
        pp24 <= {(fbusA[24]&fbusB[7]), (fbusA[24]&fbusB[8]), (fbusA[24]&fbusB[9]), (fbusA[24]&fbusB[10]), (fbusA[24]&fbusB[11]), (fbusA[24]&fbusB[12]), (fbusA[24]&fbusB[13]), (fbusA[24]&fbusB[14]), (fbusA[24]&fbusB[15]), (fbusA[24]&fbusB[16]), (fbusA[24]&fbusB[17]), (fbusA[24]&fbusB[18]), (fbusA[24]&fbusB[19]), (fbusA[24]&fbusB[20]), (fbusA[24]&fbusB[21]), (fbusA[24]&fbusB[22]), (fbusA[24]&fbusB[23]), (fbusA[24]&fbusB[24]), (fbusA[24]&fbusB[25]), (fbusA[24]&fbusB[26]), (fbusA[24]&fbusB[27]), (fbusA[24]&fbusB[28]), (fbusA[24]&fbusB[29]), (fbusA[24]&fbusB[30]), (fbusA[24]&fbusB[31]), 7'b0};
        pp25 <= {(fbusA[25]&fbusB[6]), (fbusA[25]&fbusB[7]), (fbusA[25]&fbusB[8]), (fbusA[25]&fbusB[9]), (fbusA[25]&fbusB[10]), (fbusA[25]&fbusB[11]), (fbusA[25]&fbusB[12]), (fbusA[25]&fbusB[13]), (fbusA[25]&fbusB[14]), (fbusA[25]&fbusB[15]), (fbusA[25]&fbusB[16]), (fbusA[25]&fbusB[17]), (fbusA[25]&fbusB[18]), (fbusA[25]&fbusB[19]), (fbusA[25]&fbusB[20]), (fbusA[25]&fbusB[21]), (fbusA[25]&fbusB[22]), (fbusA[25]&fbusB[23]), (fbusA[25]&fbusB[24]), (fbusA[25]&fbusB[25]), (fbusA[25]&fbusB[26]), (fbusA[25]&fbusB[27]), (fbusA[25]&fbusB[28]), (fbusA[25]&fbusB[29]), (fbusA[25]&fbusB[30]), (fbusA[25]&fbusB[31]), 6'b0};
        pp26 <= {(fbusA[26]&fbusB[5]), (fbusA[26]&fbusB[6]), (fbusA[26]&fbusB[7]), (fbusA[26]&fbusB[8]), (fbusA[26]&fbusB[9]), (fbusA[26]&fbusB[10]), (fbusA[26]&fbusB[11]), (fbusA[26]&fbusB[12]), (fbusA[26]&fbusB[13]), (fbusA[26]&fbusB[14]), (fbusA[26]&fbusB[15]), (fbusA[26]&fbusB[16]), (fbusA[26]&fbusB[17]), (fbusA[26]&fbusB[18]), (fbusA[26]&fbusB[19]), (fbusA[26]&fbusB[20]), (fbusA[26]&fbusB[21]), (fbusA[26]&fbusB[22]), (fbusA[26]&fbusB[23]), (fbusA[26]&fbusB[24]), (fbusA[26]&fbusB[25]), (fbusA[26]&fbusB[26]), (fbusA[26]&fbusB[27]), (fbusA[26]&fbusB[28]), (fbusA[26]&fbusB[29]), (fbusA[26]&fbusB[30]), (fbusA[26]&fbusB[31]), 5'b0};
        pp27 <= {(fbusA[27]&fbusB[4]), (fbusA[27]&fbusB[5]), (fbusA[27]&fbusB[6]), (fbusA[27]&fbusB[7]), (fbusA[27]&fbusB[8]), (fbusA[27]&fbusB[9]), (fbusA[27]&fbusB[10]), (fbusA[27]&fbusB[11]), (fbusA[27]&fbusB[12]), (fbusA[27]&fbusB[13]), (fbusA[27]&fbusB[14]), (fbusA[27]&fbusB[15]), (fbusA[27]&fbusB[16]), (fbusA[27]&fbusB[17]), (fbusA[27]&fbusB[18]), (fbusA[27]&fbusB[19]), (fbusA[27]&fbusB[20]), (fbusA[27]&fbusB[21]), (fbusA[27]&fbusB[22]), (fbusA[27]&fbusB[23]), (fbusA[27]&fbusB[24]), (fbusA[27]&fbusB[25]), (fbusA[27]&fbusB[26]), (fbusA[27]&fbusB[27]), (fbusA[27]&fbusB[28]), (fbusA[27]&fbusB[29]), (fbusA[27]&fbusB[30]), (fbusA[27]&fbusB[31]), 4'b0};
        pp28 <= {(fbusA[28]&fbusB[3]), (fbusA[28]&fbusB[4]), (fbusA[28]&fbusB[5]), (fbusA[28]&fbusB[6]), (fbusA[28]&fbusB[7]), (fbusA[28]&fbusB[8]), (fbusA[28]&fbusB[9]), (fbusA[28]&fbusB[10]), (fbusA[28]&fbusB[11]), (fbusA[28]&fbusB[12]), (fbusA[28]&fbusB[13]), (fbusA[28]&fbusB[14]), (fbusA[28]&fbusB[15]), (fbusA[28]&fbusB[16]), (fbusA[28]&fbusB[17]), (fbusA[28]&fbusB[18]), (fbusA[28]&fbusB[19]), (fbusA[28]&fbusB[20]), (fbusA[28]&fbusB[21]), (fbusA[28]&fbusB[22]), (fbusA[28]&fbusB[23]), (fbusA[28]&fbusB[24]), (fbusA[28]&fbusB[25]), (fbusA[28]&fbusB[26]), (fbusA[28]&fbusB[27]), (fbusA[28]&fbusB[28]), (fbusA[28]&fbusB[29]), (fbusA[28]&fbusB[30]), (fbusA[28]&fbusB[31]), 3'b0};
        pp29 <= {(fbusA[29]&fbusB[2]), (fbusA[29]&fbusB[3]), (fbusA[29]&fbusB[4]), (fbusA[29]&fbusB[5]), (fbusA[29]&fbusB[6]), (fbusA[29]&fbusB[7]), (fbusA[29]&fbusB[8]), (fbusA[29]&fbusB[9]), (fbusA[29]&fbusB[10]), (fbusA[29]&fbusB[11]), (fbusA[29]&fbusB[12]), (fbusA[29]&fbusB[13]), (fbusA[29]&fbusB[14]), (fbusA[29]&fbusB[15]), (fbusA[29]&fbusB[16]), (fbusA[29]&fbusB[17]), (fbusA[29]&fbusB[18]), (fbusA[29]&fbusB[19]), (fbusA[29]&fbusB[20]), (fbusA[29]&fbusB[21]), (fbusA[29]&fbusB[22]), (fbusA[29]&fbusB[23]), (fbusA[29]&fbusB[24]), (fbusA[29]&fbusB[25]), (fbusA[29]&fbusB[26]), (fbusA[29]&fbusB[27]), (fbusA[29]&fbusB[28]), (fbusA[29]&fbusB[29]), (fbusA[29]&fbusB[30]), (fbusA[29]&fbusB[31]), 2'b0};
	pp30 <= {(fbusA[30]&fbusB[1]), (fbusA[30]&fbusB[2]), (fbusA[30]&fbusB[3]), (fbusA[30]&fbusB[4]), (fbusA[30]&fbusB[5]), (fbusA[30]&fbusB[6]), (fbusA[30]&fbusB[7]), (fbusA[30]&fbusB[8]), (fbusA[30]&fbusB[9]), (fbusA[30]&fbusB[10]), (fbusA[30]&fbusB[11]), (fbusA[30]&fbusB[12]), (fbusA[30]&fbusB[13]), (fbusA[30]&fbusB[14]), (fbusA[30]&fbusB[15]), (fbusA[30]&fbusB[16]), (fbusA[30]&fbusB[17]), (fbusA[30]&fbusB[18]), (fbusA[30]&fbusB[19]), (fbusA[30]&fbusB[20]), (fbusA[30]&fbusB[21]), (fbusA[30]&fbusB[22]), (fbusA[30]&fbusB[23]), (fbusA[30]&fbusB[24]), (fbusA[30]&fbusB[25]), (fbusA[30]&fbusB[26]), (fbusA[30]&fbusB[27]), (fbusA[30]&fbusB[28]), (fbusA[30]&fbusB[29]), (fbusA[30]&fbusB[30]), (fbusA[30]&fbusB[31]), 1'b0};
	pp31 <= {(fbusA[31]&fbusB[0]), (fbusA[31]&fbusB[1]), (fbusA[31]&fbusB[2]), (fbusA[31]&fbusB[3]), (fbusA[31]&fbusB[4]), (fbusA[31]&fbusB[5]), (fbusA[31]&fbusB[6]), (fbusA[31]&fbusB[7]), (fbusA[31]&fbusB[8]), (fbusA[31]&fbusB[9]), (fbusA[31]&fbusB[10]), (fbusA[31]&fbusB[11]), (fbusA[31]&fbusB[12]), (fbusA[31]&fbusB[13]), (fbusA[31]&fbusB[14]), (fbusA[31]&fbusB[15]), (fbusA[31]&fbusB[16]), (fbusA[31]&fbusB[17]), (fbusA[31]&fbusB[18]), (fbusA[31]&fbusB[19]), (fbusA[31]&fbusB[20]), (fbusA[31]&fbusB[21]), (fbusA[31]&fbusB[22]), (fbusA[31]&fbusB[23]), (fbusA[31]&fbusB[24]), (fbusA[31]&fbusB[25]), (fbusA[31]&fbusB[26]), (fbusA[31]&fbusB[27]), (fbusA[31]&fbusB[28]), (fbusA[31]&fbusB[29]), (fbusA[31]&fbusB[30]), (fbusA[31]&fbusB[31])};


        if (multOut>2147483648)
                multuOut <= 0 - multOut;
        else
                multuOut <= multOut;

		case (FPUctrl)
		0: FPUout <= seqOut;
		1: FPUout <= sneOut;
		2: FPUout <= sltOut;
		3: FPUout <= sgtOut;
		4: FPUout <= sleOut;
		5: FPUout <= sgeOut;
		8: FPUout <= multOut;
		9: FPUout <= multuOut;
		endcase

        fp_branch = 0;

        end
        
endmodule
