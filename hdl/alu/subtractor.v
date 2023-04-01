/* Representation of a Subtractor using the 32-bit Carry Look-Ahead Adder in Verilog HDL. */
module subtractor (
    // Subtractor Inputs
    input wire [31:0] A,
    input wire [31:0] B,
    
    // Subtractor Outputs
    output wire [31:0] difference,
    output wire borrowOut
);

// Perform Two's Complement on 'B' and store it in 'negateB'
wire [31:0] negateB;
negate negateInstance(.A(B), .result(negateB));

// Carry Look-Ahead Adder Outputs
wire [31:0] sum;
wire carryOut;

// Use the Carry Look-Ahead Adder to compute A - B
adder adderInstance(.A(A), .B(negateB), .sum(sum), .carryOut(carryOut));

// Output 'difference' and 'borrowOut'
assign difference = sum;
assign borrowOut = ~carryOut;

endmodule // subtractor end.