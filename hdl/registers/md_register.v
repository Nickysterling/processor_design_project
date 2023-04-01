/* Representation of a memory data register with 2 to 1 multiplexer in Verilog */
module md_register(input clk, input clr, input enable, input read, input [31:0] MDataIN, input [31:0] bus_Data, output reg [31:0] Q);

    /* While loop that iterates every positive clock edge. */
    always @(posedge clk) 
    begin
        
        /* If clear signal is high, set Q output to 0. */
        if(clr)
            Q <= 0;

        /* If enable signal is high, set Q output to follow (or equal to) D input. */
        else if(enable)
            Q <= read ? MDataIN : bus_Data;        
    end
endmodule // md_register end.