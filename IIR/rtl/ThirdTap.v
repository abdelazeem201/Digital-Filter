// This is the program listing for ThirdTap.v
module ThirdTap (
	rst, clk, Xin,
	Yout
);

	input		rst;   // Reset signal, active high
	input		clk;   // FPGA system clock, frequency = 2kHz
	input	 signed [8:0]	Xin;  // Input data, frequency = 2kHz
	output signed [10:0]	Yout; // Filtered output data
	
	// Implementation of the zero coefficients /////////////////////////
	// Store input data into a shift register
	reg signed [8:0] Xin1, Xin2;
	always @(posedge clk or posedge rst)
		if (rst)
			// Initialize register values to 0
			begin
				Xin1 <= 9'd0;
				Xin2 <= 9'd0;
			end	
		else
			begin
				Xin1 <= Xin;
				Xin2 <= Xin1;
			end
			
	// Implement multiplication using shift and addition operations
	wire signed [23:0] XMult0, XMult1, XMult2;
	assign XMult0 = {{5{Xin[8]}}, Xin, 10'd0};  //*1024
	assign XMult1 = {{10{Xin1[8]}}, Xin1, 5'd0} + {{11{Xin1[8]}}, Xin1, 4'd0} + {{13{Xin1[8]}}, Xin1, 2'd0};  //*52
	assign XMult2 = {{5{Xin2[8]}}, Xin2, 10'd0}; //*1024
 
	// Accumulate multiplication results of filter coefficients and input data
	wire signed [23:0] Xout;
	assign Xout = XMult0 + XMult1 + XMult2;
	
	
	// Implementation of the pole coefficients ///////////////////////
	wire signed [10:0] Yin;
	reg signed [10:0] Yin1, Yin2;
	always @(posedge clk or posedge rst)
		if (rst)
			// Initialize register values to 0
			begin
				Yin1 <= 11'd0;
				Yin2 <= 11'd0;
			end
		else
			begin
				Yin1 <= Yin;
				Yin2 <= Yin1;
			end
			
	// Implement multiplication using shift and addition operations
	wire signed [23:0] YMult1, YMult2;
	wire signed [23:0] Ysum, Ydiv;
	assign YMult1 = {{4{Yin1[10]}}, Yin1, 9'd0} + {{5{Yin1[10]}}, Yin1, 8'd0} + {{8{Yin1[10]}}, Yin1, 5'd0} +
	                {{11{Yin1[10]}}, Yin1, 2'd0} + {{13{Yin1[10]}}, Yin1};  //*805
	assign YMult2 = {{3{Yin2[10]}}, Yin2, 10'd0} - {{5{Yin2[10]}}, Yin2, 8'd0} - {{9{Yin2[10]}}, Yin2, 4'd0} -
	                {{10{Yin2[10]}}, Yin2, 3'd0} - {{13{Yin2[10]}}, Yin2};  //*743
						 
	// Implementation of the third-stage IIR filter ///////////////////////////
	assign Ysum = Xout + YMult1 - YMult2;	
	assign Ydiv = {{10{Ysum[23]}}, Ysum[23:10]}; // 1204
	// Based on simulation results, the output range of the fourth-stage filter can be represented with 11 bits
	assign Yin = (rst ? 11'd0 : Ydiv[10:0]);
	
	// Add an extra register stage to improve performance
	reg signed [10:0] Yout_reg;
	always @(posedge clk)
		Yout_reg <= Yin;
	assign Yout = Yout_reg;
	
endmodule
