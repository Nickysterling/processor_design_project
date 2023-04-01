/* Representation of an encoder in Verilog HDL. */
/* Declared 32, 1-bit inputs and 5 output select signals. */
/* Data type of each input is a wire. */
module encoder(input [15:0] register_select, input HI_select, input LO_select, input Z_HI_select, input Z_LO_select, 
input PC_select, input MDR_select, input inport_select, input c_select, output reg [4:0] selectSignal);

    /* While loop to update the selectSignal output wire. */
    always @* begin
        if (register_select[0]) selectSignal <= 5'b00000;
        else if (register_select[1]) selectSignal <= 5'b00001;
        else if (register_select[2]) selectSignal <= 5'b00010;
        else if (register_select[3]) selectSignal <= 5'b00011;
        else if (register_select[4]) selectSignal <= 5'b00100;
        else if (register_select[5]) selectSignal <= 5'b00101;
        else if (register_select[6]) selectSignal <= 5'b00110;
        else if (register_select[7]) selectSignal <= 5'b00111;
        else if (register_select[8]) selectSignal <= 5'b01000;
        else if (register_select[9]) selectSignal <= 5'b01001;
        else if (register_select[10]) selectSignal <= 5'b01010;
        else if (register_select[11]) selectSignal <= 5'b01011;
        else if (register_select[12]) selectSignal <= 5'b01100;
        else if (register_select[13]) selectSignal <= 5'b01101;
        else if (register_select[14]) selectSignal <= 5'b01110;
        else if (register_select[15]) selectSignal <= 5'b01111;
        else if (HI_select) selectSignal <= 5'b10000;
        else if (LO_select) selectSignal <= 5'b10001;
        else if (Z_HI_select) selectSignal <= 5'b10010;
        else if (Z_LO_select) selectSignal <= 5'b10011;
        else if (PC_select) selectSignal <= 5'b10100;
        else if (MDR_select) selectSignal <= 5'b10101;
        else if (inport_select) selectSignal <= 5'b10110;
        else if (c_select) selectSignal <= 5'b10111; 
        else selectSignal <= 5'b00000;  // optional, to avoid latch.
    end
endmodule // Encoder end.