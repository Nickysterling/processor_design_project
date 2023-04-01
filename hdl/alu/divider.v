/* 
  This module performs a signed integer division operation. 
  It takes a 32-bit signed integer dividend and divisor as input, 
  and provides the quotient and remainder as output.
*/
module divider (
    input signed [31:0] dividend, // 32-bit signed dividend
    input signed [31:0] divisor,  // 32-bit signed divisor
    output wire [31:0] quotient,  // 32-bit signed quotient
    output wire [31:0] remainder  // 32-bit signed remainder
);

  reg [32:0] A, M;  // Registers for storing the values of A and M
  wire [31:0] twosComp; // 2's complement of the divisor
  integer k,i; // Integer variables used in the loop
  reg signed [64:0] divide; // Register for storing the intermediate result of division
  
  // Calculate 2's complement of the divisor
  assign twosComp = ~divisor + 1;
  
  // Initialize A to zero
  initial A = 32'h000000000;

  // Combinational logic for division
  always @(*) begin
    if(divisor[31] == 1) begin
      M = twosComp; // If the divisor is negative, use its 2's complement
      k = 1;
    end
    else begin
      M = divisor;
      k = 0;
    end
    divide = {A, dividend}; // Combine A and dividend to form a 64-bit dividend
    
    // Perform 32 iterations of the division algorithm
    for(i=0;i<32;i=i+1) begin
      divide = divide << 1; // Left shift the dividend and quotient
      if(divide[64] == 0) begin
        divide[64:32] = divide[64:32] - M; // Subtract M from the dividend if it's greater than or equal to M
        divide[0] = 1; // Set the quotient bit to 1
      end
      else if(divide[64] == 1) begin 
        divide[64:32] = divide[64:32] + M; // Add M to the dividend if it's less than M
        divide[0] = 0; // Set the quotient bit to 0
      end
      // Check for overflow/underflow and adjust the dividend and quotient
      if(divide[64] == 0) divide[0] = 1;
      else if(divide[64] == 1) divide[0] = 0;
    end
    
    // Adjust the remainder and quotient if necessary
    if(divide[64] == 1) divide[64:32] = divide[64:32] + M; // Add M to the dividend to obtain the correct remainder
    if(k == 1) divide[64:32] = ~divide[64:32] + 1; // Negate the quotient if the divisor is negative
  end

  // Assign the quotient and remainder to the output ports
  assign quotient = divide[31:0];
  assign remainder = divide[63:32];

endmodule // divider end.