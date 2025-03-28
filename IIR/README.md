# README - Digital Filter Implementation and Simulation

## Overview

This project consists of Verilog and MATLAB files used for designing, implementing, and simulating digital filters, including Infinite Impulse Response (IIR) filters. The MATLAB scripts generate filter coefficients, analyze performance, and simulate filter behavior, while the Verilog files describe hardware implementations of these filters for FPGA applications.

## Files and Descriptions

### Verilog Files

1. **ThirdTap.v**

   - Implements a third-order IIR filter.
   - Uses shift and add operations to perform multiplications.
   - Contains zero and pole coefficient calculations.
   - Includes a pipeline register for performance optimization.

2. **FourthTap.v**

   - Implements a fourth-order IIR filter.
   - Similar to `ThirdTap.v`, but adapted for different coefficients and input bit-widths.

### MATLAB Files

1. **E5\_51\_dir2cas.m**
   - Converts a direct-form representation of a digital filter into a cascaded-form representation.
2. **E5\_52\_Qcoe.m**
   - Generates quantized filter coefficients for implementation in hardware.
   - Applies fixed-point representation based on given quantization levels.
3. **E5\_53\_NoiseAndCarrier.m**
   - Generates a test signal consisting of a noise signal and a carrier wave.
   - Used for filter testing under real-world-like conditions.
4. **E5\_54\_MatlabSim.m**
   - Simulates the digital filter using MATLAB.
   - Applies the filter to input signals and evaluates performance.
5. **E5\_55\_NoiseAndCarrierOut.m**
   - Processes the test signal through the designed filter.
   - Analyzes the output to assess filtering performance.

## Usage

### MATLAB

1. Run `E5_52_Qcoe.m` to generate filter coefficients.
2. Use `E5_51_dir2cas.m` to convert the filter structure.
3. Generate a test signal with `E5_53_NoiseAndCarrier.m`.
4. Simulate the filter with `E5_54_MatlabSim.m`.
5. Analyze the output using `E5_55_NoiseAndCarrierOut.m`.

### Verilog (FPGA Implementation)

1. Synthesize `ThirdTap.v` or `FourthTap.v` using an FPGA development tool (e.g., Xilinx Vivado or Intel Quartus).
2. Simulate the design with testbench waveforms.
3. Implement the filter on an FPGA and verify with real-time input signals.

## Notes

- Ensure proper fixed-point scaling when transferring MATLAB coefficients to Verilog.
- The project is designed for a 2kHz sampling rate.
- Modify coefficient quantization (`Qcoe`) as needed to balance precision and FPGA resource usage.

## Author

- **Translated and documented by:** Ahmed Abdelazeem

