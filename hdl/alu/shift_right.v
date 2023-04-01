/* Representation of a 32-bit Right Bit Shift operation in Verilog HDL. */
/* A is the data to be shifted, and B specifies the number of bits to shift */
/* The double right-shift operator '>>' is a logical shift that fills in the vacated bits with zeroes */
module shift_right(
    // Right Shift Inputs
    input wire [31:0] A, B,
    
    // Right Shift Output
    output wire [31:0] result);

    // Shifts 'A' Right by B bits
    assign result = A >> B;      

endmodule // shift_right end.