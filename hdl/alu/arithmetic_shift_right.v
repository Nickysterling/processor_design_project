/* Representation of a 32-bit Arithmetic Shift Right operation in Verilog HDL. */
/* Shifts the bits of input signal A to the right by the number of bits specified by input signal B */
/* Operator used is >>> instead of >> which preserves the sign of the input signal */ 
module arithmetic_shift_right (
    // Arithemetic Shift Right Inputs
    input wire [31:0] A, B,
    
    // Arithemetic Shift Right Output
    output wire [31:0] result);
	 
    // Shifted result assigned to output signal 'result'
    assign result = $signed(A) >>> B;         

endmodule // arithmetic_shift_right end.