/* Representation of a 32-bit AND operation in Verilog HDL. */
module logical_and (input wire [31:0] A, B, output wire [31:0] result);

	assign result = A & B;

endmodule // and end.