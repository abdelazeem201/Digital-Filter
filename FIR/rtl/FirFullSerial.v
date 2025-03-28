module FirFullSerial (
    rst, clk, Xin,
    Yout
);

    input        rst;   // Reset signal, active high
    input        clk;   // FPGA system clock, frequency: 16 kHz
    input  signed [11:0] Xin;  // Input data with a frequency of 2 kHz
    output signed [28:0] Yout; // Filtered output data

    // Instantiate the signed multiplier IP core (mult)
    reg  signed [11:0] coe;   // The filter uses 12-bit quantized data
    wire signed [12:0] add_s; // Input is 12-bit quantized data, adding two symmetric coefficients requires 13-bit storage
    wire signed [24:0] Mout;  
    mult Umult (
        .clock (clk),
        .dataa (coe),
        .datab (add_s),
        .result (Mout)
    );

    // Instantiate the signed adder IP core, extend the input data by 1-bit for sign extension, output result is 13-bit
    reg signed [12:0] add_a;
    reg signed [12:0] add_b;
    adder Uadder (
        .dataa (add_a),
        .datab (add_b),
        .result (add_s)
    );  

    // 3-bit counter with a counting period of 8, matching the input data rate
    reg [2:0] count;
    always @(posedge clk or posedge rst)
        if (rst)
            count = 3'd0;
        else
            count = count + 1;

    // Store data in the shift register Xin_Reg
    reg [11:0] Xin_Reg[15:0];
    reg [3:0] i, j; 
    always @(posedge clk or posedge rst)
        if (rst)
            // Initialize register values to 0
            begin 
                for (i = 0; i < 15; i = i + 1)
                    Xin_Reg[i] = 12'd0;
            end
        else
            begin
                if (count == 7)
                    begin
                        for (j = 0; j < 15; j = j + 1)
                            Xin_Reg[j + 1] <= Xin_Reg[j];
                        Xin_Reg[0] <= Xin;
                    end
            end

    // Add the input data for symmetric coefficients and send the corresponding filter coefficient to the multiplier
    // Note: The following code uses only one adder and one multiplier resource
    // The multiplier IP core is used at 8 times the data rate. Since the filter length is 16
    // and the coefficients are symmetric, all 8 filter coefficient multiplications can be completed in one data cycle.
    // To prevent overflow during addition, both input and output data are extended to 13 bits.
    always @(posedge clk or posedge rst)
        if (rst)
            begin
                add_a <= 13'd0;
                add_b <= 13'd0;
                coe   <= 12'd0;
            end
        else
            begin
                if (count == 3'd0)
                    begin
                        add_a <= {Xin_Reg[0][11], Xin_Reg[0]};
                        add_b <= {Xin_Reg[15][11], Xin_Reg[15]};
                        coe   <= 12'h000; // c0
                    end
                else if (count == 3'd1)
                    begin
                        add_a <= {Xin_Reg[1][11], Xin_Reg[1]};
                        add_b <= {Xin_Reg[14][11], Xin_Reg[14]};                    
                        coe   <= 12'hffd; // c1
                    end
                else if (count == 3'd2)
                    begin
                        add_a <= {Xin_Reg[2][11], Xin_Reg[2]};
                        add_b <= {Xin_Reg[13][11], Xin_Reg[13]};                        
                        coe   <= 12'h00f; // c2
                    end
                else if (count == 3'd3)
                    begin
                        add_a <= {Xin_Reg[3][11], Xin_Reg[3]};
                        add_b <= {Xin_Reg[12][11], Xin_Reg[12]};
                        coe   <= 12'h02e; // c3
                    end
                else if (count == 3'd4)
                    begin
                        add_a <= {Xin_Reg[4][11], Xin_Reg[4]};
                        add_b <= {Xin_Reg[11][11], Xin_Reg[11]};                        
                        coe   <= 12'hf8b; // c4
                    end
                else if (count == 3'd5)
                    begin
                        add_a <= {Xin_Reg[5][11], Xin_Reg[5]};
                        add_b <= {Xin_Reg[10][11], Xin_Reg[10]};                
                        coe   <= 12'hef9; // c5
                    end                    
                else if (count == 3'd6)
                    begin
                        add_a <= {Xin_Reg[6][11], Xin_Reg[6]};
                        add_b <= {Xin_Reg[9][11], Xin_Reg[9]};                        
                        coe   <= 12'h24e; // c6
                    end
                else
                    begin
                        add_a <= {Xin_Reg[7][11], Xin_Reg[7]};
                        add_b <= {Xin_Reg[8][11], Xin_Reg[8]};                        
                        coe   <= 12'h7ff; // c7
                    end
            end

    // Accumulate the multiplication results of filter coefficients and input data, then output the filtered data
    // Due to delays in the multiplier and accumulator, the accumulator must be reset when count = 2, 
    // and the filter output data is updated accordingly.
    // The exact delay can be obtained through precise calculation, but a better method is to observe the behavior simulation.
    reg signed [28:0] sum;
    reg signed [28:0] yout;
    always @(posedge clk or posedge rst)
        if (rst)
            begin 
                sum = 29'd0; 
                yout <= 29'd0;
            end
        else
            begin
                if (count == 2)
                    begin
                        yout <= sum;
                        sum  = 29'd0;
                        sum  = sum + Mout;
                    end
                else
                   sum = sum + Mout;
            end

    assign Yout = yout;

endmodule
