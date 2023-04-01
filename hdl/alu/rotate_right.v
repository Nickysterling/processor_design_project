/* Representation of a 32-bit Right Bit Rotatation operation in Verilog HDL. */
/* A is the data to be rotated, and B specifies the number of bits to rotate */
module rotate_right (
    // Right Rotate Inputs
    input wire [31:0] A, B,
                   
    // Right Rotate Output
    output wire [31:0] result);

    // Shift Instance Outputs
    wire [31:0] shiftOneResult, shiftTwoResult;
    
    // Shift Instances
    shift_left leftShift(A, (32 - B), shiftOneResult);     // Shifts right (32 - B) times
    shift_right rightShift(A, B, shiftTwoResult);            // Shifts right B times
    
    // OR Operation Instance
    logical_or orInstance(shiftOneResult, shiftTwoResult, result);      // Performs the OR operation and produces the final result

endmodule // rotate_right end.