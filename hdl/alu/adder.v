/* Representation of a 32-bit Carry Look-Ahead Adder in Verilog HDL. */
module adder (
    // Adder Inputs
    input wire [31:0] A,
    input wire [31:0] B,

    // Adder Outputs
    output wire [31:0] sum,
    output wire carryOut
);

// Generate (G) Stage
wire [31:0] G;
assign G = A & B;

// Propagate (P) Stage
wire [31:0] P;
assign P = A | B;

// Generate Propagate (GP) Stage
wire [31:0] Gp, Pp;
assign Gp = G & P;
assign Pp = G ^ P;

// Carry (C) Stage
wire [31:0] C;
wire [31:0] S;
assign C[0] = 0;
assign S[0] = A[0] ^ B[0] ^ C[0];

genvar i;
generate
  for (i = 1; i < 32; i = i + 1) begin : carry_lookahead_loop
    assign C[i] = Gp[i-1] | (Pp[i-1] & C[i-1]);
    assign S[i] = A[i] ^ B[i] ^ C[i];
  end
endgenerate

// Output Sum and Carry Out
assign sum = S;
assign carryOut = C[31];

endmodule // adder end.