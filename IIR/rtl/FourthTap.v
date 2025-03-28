// This is the program listing for FourthTap.v
module FourthTap (
	rst, clk, Xin,
	Yout
);

	input		rst;   // Reset signal, active high
	input		clk;   // FPGA system clock, frequency = 2kHz
	input	 signed [10:0]	Xin;  // Input data, frequency = 2kHz
	output signed [11:0]	Yout; // Filtered output data
	
	// Implementation of the zero coefficients
	reg signed [10:0] Xin1;
	always @(posedge clk or posedge rst)
		if (rst)
			// Initialize register value to 0
			Xin1 <= 11'd0;
		else
			Xin1 <= Xin;

	// Implement multiplication using shift and addition operations
	wire signed [21:0] XMult_zer;
	wire signed [21:0] XMUlt_fir;
	assign XMult_zer = {Xin, 11'd0};  //*2048
	assign XMUlt_fir = {Xin1, 11'd0}; //*2048

	// Accumulate multiplication results of filter coefficients and input data
	wire signed [22:0] Xout;
	assign Xout = {XMult_zer[21], XMult_zer} + {XMUlt_fir[21], XMUlt_fir};
	
	// Implementation of the pole coefficients
	wire signed [11:0] Yin;
	reg signed [11:0] Yin1;
	always @(posedge clk or posedge rst)
		if (rst)
			// Initialize register value to 0
			Yin1 <= 12'd0;
		else
			Yin1 <= Yin;

	// Implement multiplication using shift and addition operations
	wire signed [23:0] YMult1;
	wire signed [23:0] Ysum;
	wire signed [23:0] Ydiv;
	assign YMult1 = {{4{Yin1[11]}}, Yin1, 8'd0} + {{8{Yin1[11]}}, Yin1, 4'd0} + {{10{Yin1[11]}}, Yin1, 2'd0};  //*276
 	assign Ysum = Xout + YMult1; 
	assign Ydiv = {{11{Ysum[23]}}, Ysum[23:11]};
	
	// Based on simulation results, the output range of the fourth-stage filter can be represented with 12 bits
	assign Yin = (rst ? 12'd0 : Ydiv[11:0]);
	assign Yout = Yin;
	
endmodule
