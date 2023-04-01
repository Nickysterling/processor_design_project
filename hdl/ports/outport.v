module outport(
    input clk, clr, enable,
    input wire [31:0] bus_Data,
    output wire [31:0] outport_Data);

reg [31:0] tempData;
initial tempData = 32'h0;

always @(posedge clk) 
begin
    if (clr) tempData <= {32{1'b0}};
    else if (enable) tempData <= bus_Data;
end

assign outport_Data = tempData[31:0];

endmodule