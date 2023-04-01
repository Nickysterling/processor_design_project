module select_encode_logic(
    // Instruction Register Data
    input [31:0] instruction,
    
    // Select and Encode Logic Control Signals
    input Gra, Grb, Grc, r_enable, r_select, ba_select,

    // Array of Enable and Select Output Signals
    output [15:0] register_enable, register_select,
    
    // Sign Extension of Constant C
    output [31:0] C_sign_ext_Data);

    // Instruction Register Content Variables
    reg [3:0] Ra, Rb, Rc;

    // 4 to 16 Decoder Input/Output Variable
    reg [3:0] decoder_input;
    reg [15:0] decoder_out;

    always @ (instruction, Gra, Grb, Grc) begin
        // Assigning Values to Instruction Register Content Variables
        Ra = instruction [26:23];        // Bit 23 -> 26 of the instruction register is register a    
        Rb = instruction [22:19];        // Bit 19 -> 22 of the instruction register is register b
        Rc = instruction [19:15];        // Bit 15 -> 19 of the instruction register is register c
        
        if (Gra) decoder_input = Ra;
        else if (Grb) decoder_input = Rb;
        else if (Grc) decoder_input = Rc;
        
        case (decoder_input)
            4'd0: decoder_out = 16'd1;
            4'd1: decoder_out = 16'd2;
            4'd2: decoder_out = 16'd4;
            4'd3: decoder_out = 16'd8;
            4'd4: decoder_out = 16'd16;
            4'd5: decoder_out = 16'd32;
            4'd6: decoder_out = 16'd64;
            4'd7: decoder_out = 16'd128;
            4'd8: decoder_out = 16'd256;
            4'd9: decoder_out = 16'd512;
            4'd10: decoder_out = 16'd1024;
            4'd11: decoder_out = 16'd2048;
            4'd12: decoder_out = 16'd4096;
            4'd13: decoder_out = 16'd8192;
            4'd14: decoder_out = 16'd16384;
            4'd15: decoder_out = 16'd32768;
        endcase
    end

    // Assigning Values to the Outputs
    assign register_enable = {16{r_enable}} & decoder_out;
    assign register_select = ({16{ba_select}} | {16{r_select}}) & decoder_out;
    assign C_sign_ext_Data = {{13{instruction[18]}}, instruction[18:0]};

endmodule

