
`timescale 1ns/10ps
module datapath_shl_tb;
	// CPU signals
	reg clk;
	
	// Register write/enable signals 
	reg r1_enable, r3_enable, r5_enable; 
	reg PC_enable, PC_increment_enable, IR_enable; 
	reg Y_enable, Z_enable; 
	reg MAR_enable, MDR_enable; 

	// Memory Data Multiplexer Read/Select Signal
	reg read;

	// Encoder Output Select Signals
	reg r3_select, r5_select; 
	reg PC_select;
	reg Z_HI_select;
	reg Z_LO_select;
	reg MDR_select;
	
	wire [4:0] encode_sel_signal;
	
	// ALU Opcode
	reg [4:0] alu_instruction;

	// Input Data Signals
	reg [31:0] MDataIN;

	// Output Data Signals
	wire [31:0] bus_Data; // Data currently in the bus
	wire [63:0] aluResult;
	
	wire [31:0] R1_Data, R3_Data, R5_Data;

	wire [31:0] PC_Data, IR_Data;
	wire [31:0] Y_Data;
	wire [31:0] Z_HI_Data, Z_LO_Data;
	wire [31:0] MAR_Data, MDR_Data;

	// Time Signals and Load Registers
	parameter Default = 4'b0000, 
	Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, 
	Reg_load2a = 4'b0011, Reg_load2b = 4'b0100, 
	Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, 
	T0 = 4'b0111, T1 = 4'b1000, T2 = 4'b1001, 
	T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
 
	reg [3:0] Present_state = Default;

	datapath datapathAND(	// CPU signals
	.clk(clk), 
	
	// Register write/enable signals
	.r1_enable(r1_enable), .r3_enable(r3_enable), .r5_enable(r5_enable),
	.PC_enable(PC_enable), .PC_increment_enable(PC_increment_enable), .IR_enable(IR_enable), 
	.Y_enable(Y_enable), .Z_enable(Z_enable), 
	.MAR_enable(MAR_enable), .MDR_enable(MDR_enable), 

	// Memory Data Multiplexer Read/Select Signal
	.read(read),

	// Encoder Output Select Signals
	.r3_select(r3_select), .r5_select(r5_select), 
	.PC_select(PC_select),
	.Z_HI_select(Z_HI_select), .Z_LO_select(Z_LO_select), 
	.MDR_select(MDR_select),

	.encode_sel_signal(encode_sel_signal),
	
	// ALU Opcode
	.alu_instruction(alu_instruction),

	// Input Data Signals
	.MDataIN(MDataIN),

	// Output Data Signals
	.bus_Data(bus_Data), // Data currently in the bus
	.aluResult(aluResult),
	
	.R1_Data(R1_Data), .R3_Data(R3_Data), .R5_Data(R5_Data),

	.PC_Data(PC_Data), .IR_Data(IR_Data),
	.Y_Data(Y_Data),
	.Z_HI_Data(Z_HI_Data), .Z_LO_Data(Z_LO_Data),
	.MAR_Data(MAR_Data), .MDR_Data(MDR_Data));
	
	// add test logic here
	always #10 clk = ~clk;

	initial begin
		clk = 0;
	end

	always @(posedge clk) // finite state machine; if clk rising-edge
		begin
			case (Present_state)
				Default : #40 Present_state = Reg_load1a;
				Reg_load1a : #40 Present_state = Reg_load1b;
				Reg_load1b : #40 Present_state = Reg_load2a;
				Reg_load2a : #40 Present_state = Reg_load2b;
				Reg_load2b : #40 Present_state = Reg_load3a;
				Reg_load3a : #40 Present_state = Reg_load3b;
				Reg_load3b : #40 Present_state = T0;
				T0 : #40 Present_state = T1;
				T1 : #40 Present_state = T2;
				T2 : #40 Present_state = T3;
				T3 : #40 Present_state = T4;
				T4 : #40 Present_state = T5;
			endcase
		end
	
	always @(Present_state) // do the required job in each state
		begin
			case (Present_state) // assert the required signals in each clk cycle
				Default: begin
				 	PC_select <= 0; Z_LO_select <= 0; MDR_select <= 0; // initialize the signals
					r3_select <= 0; r5_select <= 0; MAR_enable <= 0; Z_enable <= 0;
					PC_enable <=0; MDR_enable <= 0; IR_enable <= 0; Y_enable <= 0;
					PC_increment_enable <= 0; read <= 0; alu_instruction <= 0;
					r1_enable <= 0; r3_enable <= 0; r5_enable <= 0; MDataIN <= 32'h00000000;
				end
			
				Reg_load1a: begin
					MDataIN <= 32'h00000012;
					read = 0; MDR_enable = 0; // the first zero is there for completeness
					#10 read <= 1; MDR_enable <= 1;
					#15 read <= 0; MDR_enable <= 0;
				end
	
				Reg_load1b: begin
					#10 MDR_select <= 1; r3_enable <= 1;
					#15 MDR_select <= 0; r3_enable <= 0; // initialize R2 with the value $12
				end
			
				Reg_load2a: begin
					MDataIN <= 32'h00000014;
					#10 read <= 1; MDR_enable <= 1;
					#15 read <= 0; MDR_enable <= 0;
				end
				
				Reg_load2b: begin
					#10 MDR_select <= 1; r5_enable <= 1;
					#15 MDR_select <= 0; r5_enable <= 0; // initialize R3 with the value $14
				end
				
				Reg_load3a: begin
					MDataIN <= 32'h00000018;
					#10 read <= 1; MDR_enable <= 1;
					#15 read <= 0; MDR_enable <= 0;
				end
				
				Reg_load3b: begin
					#10 MDR_select <= 1; r1_enable <= 1;
					#15 MDR_select <= 0; r1_enable <= 0; // initialize R1 with the value $18
				end
				
				T0: begin // see if you need to de-assert these signals
					#10 PC_select <= 1; MAR_enable <= 1; PC_increment_enable <= 1; Z_enable <= 1;
					#15 PC_select <= 0; MAR_enable <= 0; PC_increment_enable <= 0; Z_enable <= 0;
				end
				
				T1: begin
					#10 Z_LO_select <= 1; PC_enable <= 1; read <= 1; MDR_enable <= 1; MDataIN <= 32'h489A8000; // opcode for “SHL R1, R3, R5"
					#15 Z_LO_select <= 0; PC_enable <= 0; read <= 0; MDR_enable <= 0;			 
				end
				
				T2: begin
					#10 MDR_select <= 1; IR_enable <= 1;
					#15 MDR_select <= 0; IR_enable <= 0;
				end
				
				T3: begin
					#10 r3_select <= 1; Y_enable <= 1;
					#15 r3_select <= 0; Y_enable <= 0;
				end
				
				T4: begin
					#10 r5_select <= 1; alu_instruction <= 5'b01001; Z_enable <= 1;
					#15 r5_select <= 0; alu_instruction <= 0; Z_enable <= 0;
				end
				
				T5: begin
					#10 Z_LO_select <= 1; r1_enable <= 1;
					#15 Z_LO_select <= 0; r1_enable <= 0;
				end
			endcase
		end
endmodule
