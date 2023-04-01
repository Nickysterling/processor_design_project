/* Representation of a 32-bit Negate operation in Verilog HDL. */
/* Performs the not operation on A and then adds 1 bit which returns the two's complement of A */
module negate (input wire [31:0] A, output wire [31:0] result);
		
	assign result = ~A + 1;

endmodule // negate end.