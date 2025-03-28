% E4_7_NoiseAndCarrier.M
f1 = 200;       % Signal 1 frequency (200 Hz)
f2 = 800;       % Signal 2 frequency (800 Hz)
Fs = 2000;      % Sampling frequency (2 kHz)
N = 12;         % Number of quantization bits

% Generate time vector
t = 0:1/Fs:1;

% Generate sinusoidal signals
c1 = 2 * pi * f1 * t;
c2 = 2 * pi * f2 * t;
s1 = sin(c1); % Generate sine wave for f1
s2 = sin(c2); % Generate sine wave for f2
s = s1 + s2;  % Combine both sine waves

% Generate random noise (Gaussian white noise)
noise = randn(1, length(t));

% Normalize noise and signal
noise = noise / max(abs(noise));
s = s / max(abs(s));

% 12-bit quantization
Q_noise = round(noise * (2^(N-1) - 1));
Q_s = round(s * (2^(N-1) - 1));

% Apply the designed FIR filter
hn = E4_7_Fir8Serial;
Filter_noise = filter(hn, 1, Q_noise);
Filter_s = filter(hn, 1, Q_s);

% Compute frequency responses
m_noise = 20 * log10(abs(fft(Q_noise, 1024))); 
m_noise = m_noise - max(m_noise);
m_s = 20 * log10(abs(fft(Q_s, 1024))); 
m_s = m_s - max(m_s);

% Frequency response after filtering
Fm_noise = 20 * log10(abs(fft(Filter_noise, 1024))); 
Fm_noise = Fm_noise - max(Fm_noise);
Fm_s = 20 * log10(abs(fft(Filter_s, 1024))); 
Fm_s = Fm_s - max(Fm_s);

% Frequency response of the filter itself
m_hn = 20 * log10(abs(fft(hn, 1024))); 
m_hn = m_hn - max(m_hn);

% Set frequency axis in Hz
x_f = [0:(Fs / length(m_s)):Fs/2];

% Extract positive frequency response
mf_noise = m_noise(1:length(x_f));
mf_s = m_s(1:length(x_f));
Fmf_noise = Fm_noise(1:length(x_f));
Fmf_s = Fm_s(1:length(x_f));
Fm_hn = m_hn(1:length(x_f));

% Plot frequency response of noise before and after filtering
subplot(211)
plot(x_f, mf_noise, '-.', x_f, Fmf_noise, '-', x_f, Fm_hn, '--');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('White Noise Frequency Response Before and After Filtering');
legend('Input Signal Spectrum', 'Filtered Signal Spectrum', 'Filter Response');
grid;

% Plot frequency response of signal before and after filtering
subplot(212)
plot(x_f, mf_s, '-.', x_f, Fmf_s, '-', x_f, Fm_hn, '--');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Combined Sinusoidal Signal Frequency Response Before and After Filtering');
legend('Input Signal Spectrum', 'Filtered Signal Spectrum', 'Filter Response');
grid;

% Save quantized data as text files in decimal format
fid = fopen('D:\FilterVerilog\Chapter_4\E4_7\E4_7_Int_noise.txt', 'w');
fprintf(fid, '%8d\r\n', Q_noise);
fprintf(fid, ';'); 
fclose(fid);

fid = fopen('D:\FilterVerilog\Chapter_4\E4_7\E4_7_Int_s.txt', 'w');
fprintf(fid, '%8d\r\n', Q_s);
fprintf(fid, ';'); 
fclose(fid);

% Save quantized data as text files in binary format
fid = fopen('D:\FilterVerilog\Chapter_4\E4_7\E4_7_Bin_noise.txt', 'w');
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

fid = fopen('D:\FilterVerilog\Chapter_4\E4_7\E4_7_Bin_s.txt', 'w');
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
