module IIRCas (
    rst, clk, din,
    dout);
    
    input   rst;   // Reset signal, active high
    input   clk;   // FPGA system clock, frequency: 2kHz
    input   signed [11:0] din;  // Input data with a frequency of 2kHz
    output  signed [11:0] dout; // Filtered output data
    
    // Instantiate the first stage of the filter
    wire signed [7:0] Y1;
    FirstTap U1 (
        .rst (rst),
        .clk (clk),
        .Xin (din),
        .Yout (Y1));

    // Instantiate the second stage of the filter
    wire signed [8:0] Y2;
    SecondTap U2 (
        .rst (rst),
        .clk (clk),
        .Xin (Y1),
        .Yout (Y2));

    // Instantiate the third stage of the filter
    wire signed [10:0] Y3;
    ThirdTap U3 (
        .rst (rst),
        .clk (clk),
        .Xin (Y2),
        .Yout (Y3));

    // Instantiate the fourth stage of the filter
    FourthTap U4 (
        .rst (rst),
        .clk (clk),
        .Xin (Y3),
        .Yout (dout));    
        
endmodule
