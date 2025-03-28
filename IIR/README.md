## IIR Filter Implementation in Verilog

### Overview
This project implements an Infinite Impulse Response (IIR) filter in Verilog. The filter consists of multiple stages (taps) implemented as separate modules, which are cascaded together in the main `IIRCas.v` file.

### Files and Structure
- `IIRCas.v`: This is the top-level module that connects all the taps together to form the full IIR filter.
- `FirstTap.v`: Implements the first stage of the IIR filter.
- `SecondTap.v`: Implements the second stage of the IIR filter.
- `ThirdTap.v`: Implements the third stage of the IIR filter.
- `FourthTap.v`: Implements the fourth stage of the IIR filter.

### Functionality
Each tap in the filter performs the following:
1. Takes an input sample and applies a weighted sum using coefficients.
2. Uses feedback from previous outputs to compute the new output.
3. Passes the processed output to the next stage in the cascade.

### How to Use
1. Instantiate `IIRCas` in your testbench or top-level design.
2. Provide the necessary clock and reset signals.
3. Feed input samples and observe the filtered output.

### Assumptions
- The filter operates on a fixed-point arithmetic representation.
- The coefficients are pre-determined and hardcoded in the Verilog files.

### Future Enhancements
- Parameterizing coefficients for flexibility.
- Implementing floating-point support.
- Optimizing for FPGA/ASIC implementation.
