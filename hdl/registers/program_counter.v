module program_counter(
    input wire clk, clr, enable, incPC,
    input wire [31:0] PC_Input,
    output wire [31:0] PC_Output
);

reg [31:0] Q;
reg incFlag; // flag to indicate that PC should be incremented on next clock edge

initial begin
    Q <= 0;
    incFlag = 1;
end

always @ (posedge clk) begin
     if (clr) begin
        Q <= 0;
    end
    else if (enable) begin
        Q <= PC_Input;
    end
    else begin
        if (incPC == 1 && incFlag == 1) begin
            Q <= Q + 1;
            incFlag <= 0;
        end
        else if (incPC == 0) begin
            incFlag <= 1;
        end
    end
end

assign PC_Output = Q;

endmodule
