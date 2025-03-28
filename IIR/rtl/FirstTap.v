module FirstTap (
    rst, clk, Xin,
    Yout);
    
    input   rst;   // Reset signal, active high
    input   clk;   // FPGA system clock, frequency: 2kHz
    input   signed [11:0] Xin;  // Input data with a frequency of 2kHz
    output  signed [7:0] Yout;  // Filtered output data
    
    // Implementation of zero coefficients
    // Store input data in shift registers
    reg signed[11:0] Xin1, Xin2;
    always @(posedge clk or posedge rst)
        if (rst)
            // Initialize registers to 0
            begin
                Xin1 <= 12'd0;
                Xin2 <= 12'd0;
            end    
        else
            begin
                Xin1 <= Xin;
                Xin2 <= Xin1;
            end

    // Implement multiplication using shift and add operations
    wire signed [23:0] XMult0, XMult1, XMult2;
    assign XMult0 = {{7{Xin[11]}}, Xin, 5'd0} - {{11{Xin[11]}}, Xin, 1'd0};      //*30
    assign XMult1 = {{7{Xin1[11]}}, Xin1, 5'd0} + {{9{Xin1[11]}}, Xin1, 3'd0};   //*40
    assign XMult2 = {{7{Xin2[11]}}, Xin2, 5'd0} - {{11{Xin2[11]}}, Xin2, 1'd0};  //*30

    // Accumulate multiplication results of filter coefficients and input data
    wire signed [23:0] Xout;
    assign Xout = XMult0 + XMult1 + XMult2;
    
    // Implementation of pole coefficients
    wire signed[7:0] Yin;
    reg signed[7:0] Yin1, Yin2;
    always @(posedge clk or posedge rst)
        if (rst)
            // Initialize registers to 0
            begin
                Yin1 <= 9'd0;
                Yin2 <= 9'd0;
            end
        else
            begin
                Yin1 <= Yin;
                Yin2 <= Yin1;
            end
    
    // Implement multiplication using shift and add operations
    wire signed [23:0] YMult1, YMult2;
    wire signed [23:0] Ysum, Ydiv;
    assign YMult1 = {{7{Yin1[7]}}, Yin1, 9'd0} + {{9{Yin1[7]}}, Yin1, 7'd0} + {{10{Yin1[7]}}, Yin1, 6'd0} +
                    {{15{Yin1[7]}}, Yin1, 1'd0} + {{16{Yin1[7]}}, Yin1};  //*707
    assign YMult2 = {{9{Yin2[7]}}, Yin2, 7'd0} + {{10{Yin2[7]}}, Yin2, 6'd0} + {{12{Yin2[7]}}, Yin2, 4'd0} -
                    {{14{Yin2[7]}}, Yin2, 2'd0};  //*212

    // First-stage IIR filter implementation
    assign Ysum = Xout + YMult1 - YMult2;
    assign Ydiv = {{11{Ysum[23]}}, Ysum[23:11]}; // Division by 2048
    
    // Based on simulation results, the output range of the first-stage filter can be represented with 9 bits
    assign Yin = (rst ? 8'd0 : Ydiv[7:0]);
    
    // Add an extra register stage to improve processing speed
    reg signed [7:0] Yout_reg;
    always @(posedge clk)
        Yout_reg <= Yin;
    assign Yout = Yout_reg;
    
endmodule
