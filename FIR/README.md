# FIR Filter and Noise Analysis

## Overview
This project includes MATLAB and Verilog implementations for a FIR filter and noise analysis. The MATLAB scripts perform signal processing operations, while the Verilog module implements a fully serial FIR filter.

## Files Description

### MATLAB Scripts
- **E4_7_Fir8Serial.M**: Implements an 8-tap serial FIR filter in MATLAB.
- **E4_7_NoiseAndCarrier.M**: Generates a noise signal and carrier signal for analysis.
- **E4_7_NoiseAndCarrierOut.M**: Processes the noise and carrier signal and outputs the results.

### Verilog Module
- **FirFullSerial.v**: Implements a fully serial FIR filter in Verilog for FPGA or ASIC design.

## Usage
### Running MATLAB Scripts
1. Open MATLAB.
2. Navigate to the directory containing the scripts.
3. Run the desired script using the command:
   ```matlab
   E4_7_Fir8Serial
   ```
   or
   ```matlab
   E4_7_NoiseAndCarrier
   ```
4. View the generated signals and filter responses.

### Verilog Simulation
1. Open the **FirFullSerial.v** file in a Verilog simulator (such as ModelSim, Xilinx Vivado, or Cadence tools).
2. Compile the module.
3. Apply test inputs to verify the FIR filter operation.
4. Observe the output waveform to analyze the filtering effect.

## Dependencies
- MATLAB (for signal processing scripts)
- Verilog simulator (for hardware verification)

## Contact
For any questions or contributions, feel free to reach out!

