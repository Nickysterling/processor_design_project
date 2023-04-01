/* Representation of the datapath in Verilog HDL. */
module datapath(
	// CPU signals
	input wire clk, clr,
	input wire [31:0] input_Data,
	output wire [31:0] outport_Data
	);

	/* Enable Signals */
	// General Register Enable Signals
	wire R15_enable;
	wire manual_R15_enable;
	wire [15:0] register_enable;
	
	// Program Counter Enable Signals
	wire PC_enable, PC_increment_enable;
	
	// Instruction Register Enable Signal
	wire IR_enable;

	// CON Flip Flop Enable Signal
	wire con_enable;

	// ALU 'Y' Register Enable Signal
	wire Y_enable; 
	
	// Z_HI and Z_LO Enable Signal
	wire Z_enable;

	// HI and LO Register Enable Signals
	wire HI_enable, LO_enable;

	// Memory Register Enable Signals
	wire MAR_enable, MDR_enable, read, write;
	
	// Outport Register Enable Signal
	wire outport_enable;

	/* Select Signals */
	// General Register Select Signals
	wire [15:0] register_select;

	// 32-to-5 Encoder Output
	wire [4:0] bus_select;

	// PC Register Select Signal
	wire PC_select;

	// HI/LO Register Select Signal
	wire HI_select, LO_select;

	// Z_HI/Z_LO Register Select Signal
	wire Z_HI_select, Z_LO_select;

	// MDR Select Signal
	wire MDR_select;

	// Inport Select Signal
	wire inport_select;

	// C_Sign_Extended Select Signal
	wire c_select;

	/* Data Signals */
	wire [31:0] bus_Data; // Data currently in the bus
	
	wire [63:0] aluResult;
	wire [4:0] alu_instruction; // ALU Opcode
	
	// General Register Contents 
	wire [31:0] R0_Data, R1_Data, R2_Data, R3_Data, R4_Data, R5_Data, R6_Data, R7_Data, 
	R8_Data, R9_Data, R10_Data, R11_Data, R12_Data, R13_Data, R14_Data, R15_Data;

	// Instruction Register and Program Counter Contents
	wire [31:0] PC_Data, IR_Data;
	
	// ALU Input Register 'Y' Contents
	wire [31:0] Y_Data;

	// ALU Output Register Contents
	wire [31:0] Z_HI_Data, Z_LO_Data;
	wire [31:0] HI_Data, LO_Data;

	// RAM Memory Address Register (MAR) Contents
	wire [8:0] MAR_Data;

	// RAM Memory Data Register (MDR) Contents
	wire [31:0] MDR_Data, MDataIN;
	
	// C Sign Extended Data
	wire [31:0] C_sign_ext_Data;

	// Port Register Contents
	wire [31:0] inport_Data;

	/* Select and Encode Signals */
	wire Gra, Grb, Grc, r_enable, r_select, ba_select;

	/* CON FF Output */
	wire con_output;

	/* Bus Components */
	// 32-to-5 Encoder
    encoder encoder_instance(.register_select(register_select), .HI_select(HI_select), .LO_select(LO_select), 
	.Z_HI_select(Z_HI_select), .Z_LO_select(Z_LO_select), .PC_select(PC_select), .MDR_select(MDR_select), 
	.inport_select(inport_select), .c_select(c_select), .selectSignal(bus_select));

	// 32-to-1 Multiplexer
    multiplexer multiplexer_instance(.selectSignal(bus_select), .muxIN_r0(R0_Data), 
    .muxIN_r1(R1_Data), .muxIN_r2(R2_Data), .muxIN_r3(R3_Data), .muxIN_r4(R4_Data),
    .muxIN_r5(R5_Data), .muxIN_r6(R6_Data), .muxIN_r7(R7_Data), .muxIN_r8(R8_Data),
    .muxIN_r9(R9_Data), .muxIN_r10(R10_Data), .muxIN_r11(R11_Data), .muxIN_r12(R12_Data),
    .muxIN_r13(R13_Data), .muxIN_r14(R14_Data), .muxIN_r15(R15_Data), .muxIN_HI(HI_Data),
    .muxIN_LO(LO_Data), .muxIN_Z_HI(Z_HI_Data), .muxIN_Z_LO(Z_LO_Data), .muxIN_PC(PC_Data), 
    .muxIN_MDR(MDR_Data), .muxIN_inport(inport_Data), .muxIN_C_sign_ext(C_sign_ext_Data), .muxOut(bus_Data));

	// General purpose registers r0 -> r15
	R0_revised r0 (.clk(clk), .clr(clr), .enable(register_enable[0]), .ba_select(ba_select), .bus_Data(bus_Data), .R0_Data(R0_Data)); 
	register r1 (.clk(clk), .clr(clr), .enable(register_enable[1]), .D(bus_Data), .Q(R1_Data)); 
	register r2 (.clk(clk), .clr(clr), .enable(register_enable[2]), .D(bus_Data), .Q(R2_Data));
	register r3 (.clk(clk), .clr(clr), .enable(register_enable[3]), .D(bus_Data), .Q(R3_Data));
	register r4 (.clk(clk), .clr(clr), .enable(register_enable[4]), .D(bus_Data), .Q(R4_Data));
	register r5 (.clk(clk), .clr(clr), .enable(register_enable[5]), .D(bus_Data), .Q(R5_Data));
	register r6 (.clk(clk), .clr(clr), .enable(register_enable[6]), .D(bus_Data), .Q(R6_Data));
	register r7 (.clk(clk), .clr(clr), .enable(register_enable[7]), .D(bus_Data), .Q(R7_Data));
	register r8 (.clk(clk), .clr(clr), .enable(register_enable[8]), .D(bus_Data), .Q(R8_Data));
	register r9 (.clk(clk), .clr(clr), .enable(register_enable[9]), .D(bus_Data), .Q(R9_Data));
	register r10 (.clk(clk), .clr(clr), .enable(register_enable[10]), .D(bus_Data), .Q(R10_Data));
	register r11 (.clk(clk), .clr(clr), .enable(register_enable[11]), .D(bus_Data), .Q(R11_Data));
	register r12 (.clk(clk), .clr(clr), .enable(register_enable[12]), .D(bus_Data), .Q(R12_Data));
	register r13 (.clk(clk), .clr(clr), .enable(register_enable[13]), .D(bus_Data), .Q(R13_Data));
	register r14 (.clk(clk), .clr(clr), .enable(register_enable[14]), .D(bus_Data), .Q(R14_Data));

	assign R15_enable = manual_R15_enable | register_enable[15];
	register r15 (.clk(clk), .clr(clr), .enable(R15_enable), .D(bus_Data), .Q(R15_Data));

	// ALU Output Registers
	register HI (.clk(clk), .clr(clr), .enable(HI_enable), .D(bus_Data), .Q(HI_Data));
	register LO (.clk(clk), .clr(clr), .enable(LO_enable), .D(bus_Data), .Q(LO_Data));
	register Z_HI (.clk(clk), .clr(clr), .enable(Z_enable), .D(aluResult[63:32]), .Q(Z_HI_Data));
	register Z_LO (.clk(clk), .clr(clr), .enable(Z_enable), .D(aluResult[31:0]), .Q(Z_LO_Data));
	register Y (.clk(clk), .clr(clr), .enable(Y_enable), .D(bus_Data), .Q(Y_Data));

	// ALU Instance
	alu alu_instance(.A(Y_Data), .B(bus_Data), .opcode(alu_instruction), .result(aluResult));

	// PC and IR Registers
	program_counter PC (.clk(clk), .clr(clr), .enable(PC_enable), .incPC(PC_increment_enable), .PC_Input(bus_Data), .PC_Output(PC_Data));
	register IR (.clk(clk), .clr(clr), .enable(IR_enable), .D(bus_Data), .Q(IR_Data));

	// Memory Registers
	register MAR (.clk(clk), .clr(clr), .enable(MAR_enable), .D(bus_Data), .Q(MAR_Data));
	md_register MDR (.clk(clk), .clr(clr), .enable(MDR_enable), .read(read), .MDataIN(MDataIN), .bus_Data(bus_Data), .Q(MDR_Data));
	 
	// Ram Instance
	ram ramInstance(.debug_port_01(debug_port_01), .debug_port_02(debug_port_02), .clk(clk), .read(read), .write(write), .data_in(MDR_Data), .address_in(MAR_Data), .data_out(MDataIN));

	select_encode_logic selInstance(.instruction(IR_Data), .Gra(Gra), .Grb(Grb), .Grc(Grc), .r_enable(r_enable), .r_select(r_select), 
	.ba_select(ba_select), .C_sign_ext_Data(C_sign_ext_Data), .register_enable(register_enable), .register_select(register_select));

	con_ff conInstance(.bus_Data(bus_Data), .instruction(IR_Data), .con_enable(con_enable), .con_output(con_output));
	
	inport inportInstance(.clk(clk), .clr(clr), .input_Data(input_Data), .inport_Data(inport_Data));
	outport outportInstance(.clk(clk), .clr(clr), .enable(outport_enable), .bus_Data(bus_Data), .outport_Data(outport_Data));

	control_unit cuInstance(
		clk, reset, con_output, IR_Data, alu_instruction, read, write, Gra, Grb, Grc, r_enable, r_select, ba_select,
		PC_enable, PC_increment_enable, IR_enable, con_enable, Y_enable, Z_enable, HI_enable, LO_enable,
		MAR_enable, MDR_enable, outport_enable, manual_R15_enable,
		MDR_select, Z_HI_select, Z_LO_select, HI_select, LO_select, PC_select, inport_select, c_select);

endmodule // Datapath end.