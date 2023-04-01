`timescale 1ns/10ps
module control_unit(
	// Control Unit Inputs
	input wire clk, reset, con_output,
	input wire [31:0] IR_Data,
    
	// ALU Opcode
	output reg [4:0] alu_instruction,

	// RAM Read/Write Signals
	output reg read, write,

	// Select Encode Logic Signals
	output reg Gra, Grb, Grc, r_enable, r_select, ba_select,

	// Control Unit Enable Signal Outputs
	output reg PC_enable, PC_increment_enable, IR_enable, con_enable, Y_enable, Z_enable, HI_enable, LO_enable,
	MAR_enable, MDR_enable, outport_enable, manual_R15_enable,

	// Control Unit Select Signal Outputs
	output reg MDR_select, Z_HI_select, Z_LO_select, HI_select, LO_select, PC_select, inport_select, c_select);

parameter 
// Initial State
reset_state = 8'b00000000, 

// Instruction Fetch
fetch0 = 8'b00000001, fetch1 = 8'b00000010, fetch2= 8'b00000011,

// Add Instruction
add3 = 8'b00000100, add4= 8'b00000101, add5= 8'b00000110, 

// Sub Instruction
sub3 = 8'b00000111, sub4 = 8'b00001000, sub5 = 8'b00001001,

// Multiply Instruction
mul3 = 8'b00001010, mul4 = 8'b00001011, mul5 = 8'b00001100, mul6 = 8'b00001101, 

// Divide Instruction
div3 = 8'b00001110, div4 = 8'b00001111, div5 = 8'b00010000, div6 = 8'b00010001, 

// Or Instruction
or3 = 8'b00010010, or4 = 8'b00010011, or5 = 8'b00010100, and3 = 8'b00010101,

// And Instruction
and4 = 8'b00010110, and5 = 8'b00010111, 

// Shift Left Instruction
shl3 = 8'b00011000, shl4 = 8'b00011001, shl5 = 8'b00011010, 

// Shift Right Instruction
shr3 = 8'b00011011, shr4 = 8'b00011100, shr5 = 8'b00011101, 

// Rotate Left Instruction
rol3 = 8'b00011110, rol4 = 8'b00011111, rol5 = 8'b00100000, 

// Rotate Right Instruction
ror3 = 8'b00100001, ror4 = 8'b00100010, ror5 = 8'b00100011, 

// Negate Instruction
neg3 = 8'b00100100, neg4 = 8'b00100101, neg5 = 8'b00100110, 

// Not Instruction
not3 = 8'b00100111, not4 = 8'b00101000, not5 = 8'b00101001, 

// Load Instruction
ld3 = 8'b00101010, ld4 = 8'b00101011, ld5 = 8'b00101100, ld6 = 8'b00101101, ld7 = 8'b00101110, 

// Load Immediate Instruction
ldi3 = 8'b00101111, ldi4 = 8'b00110000, ldi5 = 8'b00110001, 

// Store Instruction
st3 = 8'b00110010, st4 = 8'b00110011, st5 = 8'b00110100, st6 = 8'b00110101, 

// Add Immediate Instruction
addi3 = 8'b00110111, addi4 = 8'b00111000, addi5 = 8'b00111001,

// And Immediate Instruction
andi3 = 8'b00111010, andi4 = 8'b00111011, andi5 = 8'b00111100, 

// Or Immediate Instruction
ori3 = 8'b00111101, ori4 = 8'b00111110, ori5 = 8'b00111111,

// Branch Instruction
br3 = 8'b01000000, br4 = 8'b01000001, br5 = 8'b01000010, br6 = 8'b01000011,

// Jump Instructions
jr3 = 8'b01000100, 

jal3 = 8'b01000101, jal4 = 8'b01000110, 

// Move from LO/HI Instruction
mfhi3 = 8'b01000111, mflo3 = 8'b01001000, 

// In/Out Port Instruction
in3 = 8'b01001001, out3 = 8'b01001010, 

// No Instruction
nop3 = 8'b01001011, halt3 = 8'b01001100,

// Shift Right Arithmetic Instruction
shra3 = 8'b01001101, shra4 = 8'b01001110, shra5 = 8'b01001111;

parameter ld = 5'b00000, ldi = 5'b00001, st = 5'b00010, 
add = 5'b00011, sub = 5'b00100, AND = 5'b00101, OR = 5'b00110,
shr = 5'b00111, shra = 5'b01000, shl = 5'b01001, ror = 5'b01010, rol = 5'b01011,
mul = 5'b01111, div = 5'b10000, neg = 5'b10001, NOT = 5'b10010,
addi = 5'b01100, andi = 5'b01101, ori = 5'b01110, 
br = 5'b10011, jr = 5'b10100, jal = 5'b10101,
in = 5'b10110, out = 5'b10111, mfhi = 5'b11000, mflo = 5'b11001,
nop = 5'b11010, halt = 5'b11011;

reg [7:0] present_state = reset_state;      // adjust the bit pattern based on the number of states

always @(posedge clk, posedge reset)  //con_ff finite state machine; if clk or reset rising-edge
begin
   if (reset == 1'b1) present_state = reset_state;
   else case (present_state)
        reset_state : present_state = fetch0;
        fetch0 : present_state = fetch1;
        fetch1 : present_state = fetch2;
        fetch2 : begin
        case (IR_Data[31:27]) // inst. decoding based on the opcode to set the next state
            5'b00011 : present_state = add3; 
            5'b00100 : present_state = sub3;
            5'b01111 : present_state = mul3;
            5'b10000 : present_state = div3;
            5'b00111 : present_state = shr3;
				5'b01000 : present_state = shra3;
            5'b01001 : present_state = shl3;
            5'b01010 : present_state = ror3;
            5'b01011 : present_state = rol3;
            5'b00101 : present_state = and3;
            5'b00110 : present_state = or3;
            5'b10001 : present_state = neg3;
            5'b10010 : present_state = not3;
            5'b00000 : present_state = ld3;
            5'b00001 : present_state = ldi3;
            5'b00010 : present_state = st3;
            5'b01100 : present_state = addi3;
            5'b01100 : present_state = andi3;
            5'b01110 : present_state = ori3;
            5'b10011 : present_state = br3;
            5'b10100 : present_state = jr3;
            5'b10101 : present_state = jal3;
            5'b11000 : present_state = mfhi3;
            5'b11001 : present_state = mflo3;
            5'b10110 : present_state = in3;
            5'b10111 : present_state = out3;                
            5'b11010 : present_state = nop3;
            5'b11011 : present_state = halt3;
        endcase
        end

        add3 : present_state = add4;
        add4 : present_state = add5;
        add5 : present_state = fetch0;
               
        addi3 : present_state = addi4;
        addi4 :	present_state = addi5;
        addi5 : present_state = fetch0;
               
        sub3 : present_state = sub4;
        sub4 : present_state = sub5;
        sub5 : present_state = fetch0;
       
        mul3 : present_state = mul4;
        mul4 : present_state = mul5;
        mul5 : present_state = mul6;
        mul6 : present_state = fetch0; 
       
        div3 : present_state = div4;
        div4 : present_state = div5;
        div5 : present_state = div6;
        div6 : present_state = fetch0;
               
        or3 : present_state = or4;
        or4 : present_state = or5;
        or5	: present_state = fetch0;
               
        and3 : present_state = and4;
        and4 : present_state = and5;
        and5 : present_state = fetch0;
               
        shl3 : present_state = shl4;
        shl4 : present_state = shl5;
        shl5 : present_state = fetch0;
               
        shr3 : present_state = shr4;
        shr4 : present_state = shr5;
        shr5 : present_state = fetch0;
		  
		  shra3 : present_state = shra4;
        shra4 : present_state = shra5;
        shra5 : present_state = fetch0;
               
        rol3 : present_state = rol4;
        rol4 : present_state = rol5;
        rol5 : present_state = fetch0;
               
        ror3 : present_state = ror4;
        ror4 : present_state = ror5;
        ror5 : present_state = fetch0;
               
        neg3 : present_state = neg4;
        neg4 : present_state = fetch0;
               
        not3 : present_state = not4;
        not4 : present_state = fetch0;
               
        ld3 : present_state = ld4;
        ld4 : present_state = ld5;
        ld5 : present_state = ld6;
        ld6 : present_state = ld7;
        ld7 : present_state = fetch0;
               
        ldi3 : present_state = ldi4;
        ldi4 : present_state = ldi5;
        ldi5 : present_state = fetch0;
               
        st3 : present_state = st4;
        st4 : present_state = st5;
        st5 : present_state = st6;
        st6 : present_state = fetch0;
               
        andi3 : present_state = andi4;
        andi4 : present_state = andi5;
        andi5 : present_state = fetch0;
               
        ori3 : present_state = ori4;
        ori4 : present_state = ori5;
        ori5 : present_state = fetch0;
               
        jal3 : present_state = jal4;
        jal4 : present_state = fetch0;
               
        jr3 : present_state = fetch0;
               
        br3 : present_state = br4;
        br4 : present_state = br5;
        br5 : present_state = br6;
        br6 : present_state = fetch0;
               
        out3 : present_state = fetch0;
               
        in3 : present_state = fetch0;
               
        mflo3 : present_state = fetch0;
       
        mfhi3 : present_state = fetch0;
       
        nop3 : present_state = fetch0;
    endcase
end

always @(present_state) // do the job for each state
begin
    case (present_state) // assert the required signals in each state
    reset_state: begin
    // RAM Read/Write Signals
	read <= 0; write <= 0;

	// Select Encode Logic Signals
	Gra <= 0; Grb <= 0; Grc <= 0; r_enable <= 0; r_select <= 0; ba_select <= 0;

	// Control Unit Enable Signal Outputs
	PC_enable <= 0; PC_increment_enable <= 0; IR_enable <= 0; con_enable <= 0; Y_enable <= 0; 
	Z_enable <= 0; HI_enable <= 0; LO_enable <= 0; MAR_enable <= 0; MDR_enable <= 0; outport_enable <= 0; 
	manual_R15_enable <= 0;

	// Control Unit Select Signal Outputs
	MDR_select <= 0; Z_HI_select <= 0; Z_LO_select <= 0; HI_select <= 0; LO_select <= 0; PC_select <= 0; 
	inport_select <= 0; c_select <= 0;

	// ALU Instruction
	alu_instruction <= 0;
    
	end
   
    fetch0: begin
        #10 PC_select <= 1; MAR_enable <= 1; 
		#75 PC_select <= 0; MAR_enable <= 0; 
    end

	fetch1: begin
	    #10 PC_increment_enable <= 1; read <= 1; MDR_enable <= 1;
		#75 PC_increment_enable <= 0; read <= 0; MDR_enable <= 0;
	end

	fetch2: begin
		#10 MDR_select <= 1; IR_enable <= 1;
		#75 MDR_select <= 0; IR_enable <= 0;
	end 

	// Addition Operation
	add3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end

	add4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= add; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end

	add5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// Subtraction Operation
	sub3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end

	sub4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= sub; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end

	sub5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// Or Operation
	or3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end
	
    or4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= OR; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
	
    or5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// And Operation
	and3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end
	
    and4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= AND; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
	
    and5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// SHR Operation
	shr3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end
	
    shr4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= shr; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
	
    shr5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// SHL Operation
	shl3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end
	
    shl4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= shl; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
	
    shl5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// shra Operation
	shra3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end
	
    shra4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= shra; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
	
    shra5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// ror Operation
	ror3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end
	
    ror4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= ror; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
	
    ror5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// rol Operation
	rol3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;
	end
	
    rol4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= rol; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
	
    rol5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end
	
   // Multiplication Operation
	mul3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;  		
	end
	
    mul4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= mul; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;			
	end
	
    mul5: begin
		#10 Z_LO_select <= 1; LO_enable <= 1;
		#75 Z_LO_select <= 0; LO_enable <= 0;			
	end
	
    mul6: begin
		#10 Z_HI_select <= 1; HI_enable <= 1;
		#75 Z_HI_select <= 0; HI_enable <= 0;	
	end

	// Division Operation
	div3: begin	
		#10 Grb <= 1; r_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; Y_enable <= 0;  		
	end
	
    div4: begin
		#10 Grc <= 1; r_select <= 1; alu_instruction <= div; Z_enable <= 1;
		#75 Grc <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;			
	end
	
    div5: begin
		#10 Z_LO_select <= 1; LO_enable <= 1;
		#75 Z_LO_select <= 0; LO_enable <= 0;			
	end
	
    div6: begin
		#10 Z_HI_select <= 1; HI_enable <= 1;
		#75 Z_HI_select <= 0; HI_enable <= 0;	
	end
		
    // Not Operation
	not3: begin	
		#10 Grb <= 1; r_select <= 1; alu_instruction <= NOT; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; alu_instruction <= 0; Y_enable <= 0;
	end
	
    not4: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// Negate Operation
	neg3: begin	
		#10 Grb <= 1; r_select <= 1; alu_instruction <= neg; Y_enable <= 1;
		#75 Grb <= 0; r_select <= 0; alu_instruction <= 0; Y_enable <= 0;
	end
	
    neg4: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end

	// And Immediate Operation
	andi3: begin
		#10 c_select <= 1; Y_enable <= 1;
		#75 c_select <= 0; Y_enable <= 0;
	end

	andi4: begin
		#10 Grb <= 1; r_select <= 1; alu_instruction <= AND; Z_enable <= 1;
		#75 Grb <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end

	andi5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end
		
    // Add Immediate Operation
	addi3: begin
		#10 c_select <= 1; Y_enable <= 1;
		#75 c_select <= 0; Y_enable <= 0;
	end

	addi4: begin
		#10 Grb <= 1; r_select <= 1; alu_instruction <= add; Z_enable <= 1;
		#75 Grb <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end

	addi5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end
		
    // Or Immediate Operation
	ori3: begin
		#10 c_select <= 1; Y_enable <= 1;
		#75 c_select <= 0; Y_enable <= 0;
	end

	ori4: begin
		#10 Grb <= 1; r_select <= 1; alu_instruction <= OR; Z_enable <= 1;
		#75 Grb <= 0; r_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end

	ori5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end
		
    // Load Operation
	ld3: begin
		#10 Grb <= 1; ba_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; ba_select <= 0; Y_enable <= 0;
	end
				
	ld4: begin
		#10 c_select <= 1; alu_instruction <= add; Z_enable <= 1;
		#75 c_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
				
	ld5: begin
		#10 Z_LO_select <= 1; MAR_enable <= 1;
		#75 Z_LO_select <= 0; MAR_enable <= 0;
	end

	ld6: begin
		#10 read <= 1; MDR_enable <= 1;
		#75 read <= 0; MDR_enable <= 0;
	end

	ld7: begin
		#10 MDR_select <= 1; Gra <= 1; r_enable <= 1;
		#75 MDR_select <= 0; Gra <= 0; r_enable <= 0;
	end
		
    // Load Immediate Operation
	ldi3: begin
		#10 Grb <= 1; ba_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; ba_select <= 0; Y_enable <= 0;
	end
				
	ldi4: begin
		#10 c_select <= 1; alu_instruction <= add; Z_enable <= 1;
		#75 c_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
				
	ldi5: begin
		#10 Z_LO_select <= 1; Gra <= 1; r_enable <= 1;
		#75 Z_LO_select <= 0; Gra <= 0; r_enable <= 0;
	end
		
    //Store Operation
	st3: begin
		#10 Grb <= 1; ba_select <= 1; Y_enable <= 1;
		#75 Grb <= 0; ba_select <= 0; Y_enable <= 0;
	end
				
	st4: begin
		#10 c_select <= 1; alu_instruction <= add; Z_enable <= 1;
		#75 c_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end
				
	st5: begin
		#10 Z_LO_select <= 1; MAR_enable <= 1;
		#75 Z_LO_select <= 0; MAR_enable <= 0;
	end

    st6: begin
		#10 write <= 1; MDR_enable <= 1; Gra <= 1; r_select <= 1;
		#75 write <= 0; MDR_enable <= 0; Gra <= 0; r_select <= 0;
	end
	
    // Jump Register Operation
	jr3: begin
		#10 Gra <= 1; r_select <= 1; PC_enable <= 1;
		#75 Gra <= 0; r_select <= 0; PC_enable <= 0;
	end
		
    //Jump and Link Operation
	jal3: begin
		#10 manual_R15_enable <= 1; PC_select <= 1;
		#75 manual_R15_enable <= 0; PC_select <= 0;
	end

	jal4: begin
		#10 Gra <= 1; r_select <= 1; PC_enable <= 1;
		#75 Gra <= 0; r_select <= 0; PC_enable <= 0;
	end
		
    // Move from Hi Register Operation
	mfhi3: begin
		#10 Gra <= 1; r_enable <= 1; HI_select <= 1;
		#75 Gra <= 0; r_enable <= 0; HI_select <= 0;
	end
		
    // Move from Lo Register Operation
	mflo3: begin
		#10 Gra <= 1; r_enable <= 1; LO_select <= 1;
		#75 Gra <= 0; r_enable <= 0; LO_select <= 0;
	end
		
    // Inputting Operation
	in3: begin
		#10 Gra <= 1; r_enable <= 1; inport_select <= 1;
		#75 Gra <= 0; r_enable <= 0; inport_select <= 0;
	end
		
    // Outputting Operation
	out3: begin
		#10 Gra <= 1; r_select <= 1; outport_enable <= 1;
		#75 Gra <= 0; r_select <= 0; outport_enable <= 0;
	end
		
    // Branch Operation
	br3: begin
		#10 Gra <= 1; r_select <= 1; con_enable <= 1;
		#75 Gra <= 0; r_select <= 0; con_enable <= 0;
	end
				
	br4: begin
		#10 PC_select <= 1; Y_enable <= 1;
		#75 PC_select <= 0; Y_enable <= 0;
	end
				
	br5: begin
		#10 c_select <= 1; alu_instruction <= add; Z_enable <= 1;
		#75 c_select <= 0; alu_instruction <= 0; Z_enable <= 0;
	end

	br6: begin
		#10 Z_LO_select <= 1; PC_enable <= con_output;
		#75 Z_LO_select <= 0; PC_enable <= 0;
	end
		
    // No Operation
	nop3: begin
		MDR_select <= 0; IR_enable <= 0;
	end
		
    // Halt Operation (Stops instruction execution)
	halt3: begin
		MDR_select <= 0; IR_enable <= 0;
	end
		
    //Any other input would be default to do nothing
    default: begin 
	end
    endcase
end
endmodule
