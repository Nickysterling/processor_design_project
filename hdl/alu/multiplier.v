/* Representation of a 32-bit Multiplier operation in Verilog HDL. */
module multiplier (
	// Multiplier Inputs
	input signed [31:0] A, B,
	
	// Multiplier Output
	output wire [63:0] multiplier_result);
	
	// Declare array of 16 elements, where each element is a 3-bit register
	// Used to store the control bits for each stage of the Booth's Algorithm
	reg [2:0] controlBits [15:0];
	
	// Declare an array of 16 elements, where each element is a 33-bit register
	// Used to store the partial products computed in each stage of the Booth's Algorithm
	reg [32:0] partialProducts [15:0];
	
	// Declare array of 16 elements, where each element is a 64-bit register
	// Used to store the signed version of the partial products computed in each stage of the Booth's Algorithm
	reg [63:0] signedPartialProduct [15:0];
	
	// Stores the combined 'signedPartialProduct' and stores it in 'product' 
	reg [63:0] product;
	
	// Stores the Two's Complement of the Multiplicand A
	wire [32:0] negateA;
	
	// Used as loop counters in the 'always' block
	integer i, k;

	// Negate Operation used to take the Two's Complement of A
	negate negateInstance(A, negateA);

	always @ (A or B or negateA)
	begin
		// Initializes control bits for least significant bits of multiplier
		controlBits[0] = {B[1],B[0],1'b0};

		// Generates the control bits needed to multiply two 32-bit numbers
		for(k = 1; k < 16; k = k + 1)
			controlBits[k] = {B[2*k+1], B[2*k], B[2*k-1]};

		// Generates appropriate partial product for each group of three bits based on control signal
		for(k = 0; k < 16; k = k + 1)
		begin
			case(controlBits[k])
				// Generates a partial product that corresponds to a positive multiplicand shifted left by one bit
				3'b001 , 3'b010 : partialProducts[k] = {A[31],A};
				
				// Generates a partial product that corresponds to a positive multiplicand shifted left by two bits
				3'b011 : partialProducts[k] = {A,1'b0};
				
				// Generates a partial product that corresponds to a negative multiplicand shifted left by one bit
				3'b100 : partialProducts[k] = {negateA[31:0],1'b0};
				
				// Generates a partial product that corresponds to a negative multiplicand (32-bit negated multiplicand 'negateA')
				3'b101 , 3'b110 : partialProducts[k] = negateA;

				// Generates a partial product of zero
				default : partialProducts[k] = 0;
			endcase

			// Converts the 33-bit 'partialProducts[k]' signal into a signed 33-bit singal stored in 'signedPartialProduct[k]'
			signedPartialProduct[k] = $signed(partialProducts[k]);

			// Performs a left shift operation on the 'signedPartialProduct[k]' signal by multiplying it by 2^2 * k
			// Creates a series of shifted partial products so they are aligned for addition
			for(i = 0; i < k; i = i + 1)
				signedPartialProduct[k] = {signedPartialProduct[k], 2'b00};
		end

		// Initialize the 'product' variable with first bit of 'signedPartialProduct' 
		product = signedPartialProduct[0];

		// Accumulates all the shifted partial products together
		for(k = 1; k < 16; k = k + 1)
			product = product + signedPartialProduct[k];
	end

	// Return the result
	assign multiplier_result = product;

endmodule // multiplier end.