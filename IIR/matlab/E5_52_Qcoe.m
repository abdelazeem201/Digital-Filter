function [Qb,Qa] = E5_52_Qcoe(b, a, Qcoe)
% Quantize the coefficients of the system.
%
% Inputs:
%   b - Numerator coefficients of the system
%   a - Denominator coefficients of the system
%   Qcoe - Number of quantization bits
%
% Outputs:
%   Qb - Quantized numerator coefficients
%   Qa - Quantized denominator coefficients

% fs = 2000;        % Sampling frequency
% fc = 500;         % Cut-off frequency
% Rs = 60;          % Stopband attenuation (dB)
% N = 7;            % Filter order

% [b,a] = cheby2(N, Rs, 2 * fc / fs); 

m = max(max(abs(a), abs(b))); % Get the maximum absolute value of the filter coefficients
Qm = floor(log2(m / a(1)));   % Compute integer exponent for scaling

if Qm < log2(m / a(1))
    Qm = Qm + 1;
end

Qm = 2^Qm; % Compute the quantization base value

% Perform rounding for quantization
Qb = round(b / Qm * (2^(Qcoe - 1))); % Round to nearest quantized value
Qa = round(a / Qm * (2^(Qcoe - 1))); % Round to nearest quantized value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare the frequency response before and after quantization
% delta = [1, zeros(1, 1023)];
% figure(1); freqz(b, a, 1024, fs);
% figure(2); freqz(Qb, Qa, 1024, fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
