module inport(
    input clk, clr,
    input wire [31:0] input_Data,
    output wire [31:0] inport_Data);

reg [31:0] tempData;
initial tempData = 32'h0;

always @(posedge clk) 
begin
    if (clr) tempData <= {32{1'b0}};
    else tempData <= input_Data;
end

assign inport_Data = tempData[31:0];

endmodule
