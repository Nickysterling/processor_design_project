/* Representation of a 32-bit Left Bit Rotatation operation in Verilog HDL. */
/* A is the data to be rotated, and B specifies the number of bits to rotate */
module rotate_left (
    // Left Rotate Inputs
    input wire [31:0] A, B,
                   
    // Left Rotate Output
    output wire [31:0] result);

    // Shift Instance Outputs
    wire [31:0] shiftOneResult, shiftTwoResult;

    // Shift Instances
    shift_left leftShiftOne(A, B, shiftOneResult);              // Shifts left B times
    shift_right rightShiftTwo(A, (32 - B), shiftTwoResult);       // Shifts left (32 - B) times

    // OR Operation Instance
    logical_or orInstance(shiftOneResult, shiftTwoResult, result);      // Performs the OR operation and produces the final result

endmodule // rotate_left end.