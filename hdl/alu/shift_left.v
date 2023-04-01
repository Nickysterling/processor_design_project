/* Representation of a 32-bit Left Bit Shift operation in Verilog HDL. */
/* A is the data to be shifted, and B specifies the number of bits to shift */
/* The double left-shift operator '<<' is a logical shift that fills in the vacated bits with zeroes */
module shift_left(
    // Left Shift Inputs
    input wire [31:0] A, B,
    
    // Left Shift Output
    output wire [31:0] result);

    // Shifts 'A' Left by B bits
    assign result = A << B;      

endmodule // shift_left end.