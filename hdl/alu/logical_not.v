/* Representation of a 32-bit NOT operation in Verilog HDL. */
/* Flips each bit of A and stores the result in 'result' */
module logical_not (input wire [31:0] A, output wire [31:0] result);
	
	assign result = ~A;

endmodule // not end.