/* This module determines whether the correct condition has been met to cause branching to take place in a conditional branch instruction. */
module con_ff(
    // Bus Input
    input [31:0] bus_Data,

    // Instruction Register Input
    input [31:0] instruction,

    // Enable Signal for the CON Flip Flop
    input con_enable,

    // Q Output Signal from the CON Flip Flop
    output con_output);                                                

    reg [3:0] decoder_out;
    reg FF_Output;
    assign con_output = FF_Output;

    always @ (instruction[20:19]) begin
        case (instruction[20:19])
            2'b00: begin
                decoder_out = 4'b0001;
            end
            
            2'b01: begin
                decoder_out = 4'b0010;
            end
            
            2'b10: begin
                decoder_out = 4'b0100;
            end

            2'b11: begin
                decoder_out = 4'b1000;
            end
        endcase
    end

always @ (bus_Data && con_enable) begin
	if (bus_Data == 0 && decoder_out[0]) begin
		FF_Output = 1;
	end else if (bus_Data != 0 && decoder_out[1]) begin
		FF_Output = 1;
	end else if (bus_Data >= 0 && decoder_out[2]) begin
		FF_Output = 1;
	end else if (bus_Data[31] && decoder_out[3]) begin
		FF_Output = 1;
	end else begin
		FF_Output = 0;
	end
end

endmodule