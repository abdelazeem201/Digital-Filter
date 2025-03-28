function [Q_s, Q_noise] = E5_53_NoiseAndCarrier
% Generate signal and noise sequences and perform quantization.
%
% Outputs:
%   Q_s - Quantized signal sequence
%   Q_noise - Quantized noise sequence

f1 = 200;       % Signal 1 frequency = 200 Hz
f2 = 800;       % Signal 2 frequency = 800 Hz
Fs = 2000;      % Sampling frequency = 2 kHz
N = 12;         % Bit-width for quantization

% Generate signals
t = 0:1/Fs:5;
c1 = 2 * pi * f1 * t;
c2 = 2 * pi * f2 * t;
s1 = sin(c1);   % Generate sine wave for signal 1
s2 = sin(c2);   % Generate sine wave for signal 2
s = s1 + s2;    % Combine the two signals

% Generate a random noise sequence
noise = randn(1, length(t)); % Generate Gaussian white noise

% Normalize the signals
noise = noise / max(abs(noise));
s = s / max(abs(s));

% 12-bit quantization
Q_noise = round(noise * (2^(N-1) - 1));
Q_s = round(s * (2^(N-1) - 1));

% Save generated data in text format (decimal representation)
fid = fopen('D:\DuYong\Filter_VHDL\IIRCas\E5_5_Int_noise.txt', 'w');
fprintf(fid, '%8d\r\n', Q_noise);
fprintf(fid, ';'); 
fclose(fid);

fid = fopen('D:\DuYong\Filter_VHDL\IIRCas\E5_5_Int_s.txt', 'w');
fprintf(fid, '%8d\r\n', Q_s);
fprintf(fid, ';'); 
fclose(fid);

% Save generated data in text format (binary representation)
fid = fopen('D:\DuYong\Filter_VHDL\IIRCas\E5_5_Bin_noise.txt', 'w');
for i = 1:length(Q_noise)
    B_noise = dec2bin(Q_noise(i) + (Q_noise(i) < 0) * 2^N, N);
    for j = 1:N
       if B_noise(j) == '1'
           tb = 1;
       else
           tb = 0;
       end
       fprintf(fid, '%d', tb);  
    end
    fprintf(fid, '\r\n');
end
fprintf(fid, ';'); 
fclose(fid);

fid = fopen('D:\DuYong\Filter_VHDL\IIRCas\E5_5_Bin_s.txt', 'w');
for i = 1:length(Q_s)
    B_s = dec2bin(Q_s(i) + (Q_s(i) < 0) * 2^N, N);
    for j = 1:N
       if B_s(j) == '1'
           tb = 1;
       else
           tb = 0;
       end
       fprintf(fid, '%d', tb);  
    end
    fprintf(fid, '\r\n');
end
fprintf(fid, ';'); 
fclose(fid);
