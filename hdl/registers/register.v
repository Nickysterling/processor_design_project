/* Representation of a register in Verilog HDL. */
/* Declared 3, 1-bit signals, 1, 32-bit D-input, and 1, 32-bit Q-output. */
/* Data type of each signal/input is a wire and output is a reg. */
module register(input clk, input clr, input enable, input [31:0] D, output reg [31:0] Q);

    /* While loop that iterates every positive clock edge. */
    always @(posedge clk) 
    begin
        /* If clear signal is high, set Q output to 0. */
        if(clr)
            Q <= 0;

        /* If enable signal is high, set Q output to follow (or equal to) D input. */
        else if(enable)
            Q = D;        
    end
endmodule // Register end.