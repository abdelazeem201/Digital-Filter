% Define signal parameters
f1 = 200;   % Frequency of signal 1 (200 Hz)
f2 = 800;   % Frequency of signal 2 (800 Hz)
Fs = 2000;  % Sampling frequency (2 kHz)
N = 12;     % Quantization bit depth

% Read input data from text files
fid = fopen('D:\FilterVerilog\Chapter_5\E5_5\IIRCas\simulation\modelsim\Int_noise.txt', 'r');
[Noise_in, N_n] = fscanf(fid, '%lg', inf);
fclose(fid);

fid = fopen('D:\FilterVerilog\Chapter_5\E5_5\IIRCas\simulation\modelsim\Int_s.txt', 'r');
[S_in, S_n] = fscanf(fid, '%lg', inf);
fclose(fid);

% Read filtered output data
fid = fopen('D:\FilterVerilog\Chapter_5\E5_5\IIRCas\simulation\modelsim\Noiseout.txt', 'r');
[Noise_out, N_count] = fscanf(fid, '%lg', inf);
fclose(fid);

fid = fopen('D:\FilterVerilog\Chapter_5\E5_5\IIRCas\simulation\modelsim\Sout.txt', 'r');
[S_out, S_count] = fscanf(fid, '%lg', inf);
fclose(fid);

% Normalize input and output signals
Noise_out = Noise_out / max(abs(Noise_out));
S_out = S_out / max(abs(S_out));
Noise_in = Noise_in / max(abs(Noise_in));
S_in = S_in / max(abs(S_in));

% Compute frequency response
out_noise = 20 * log10(abs(fft(Noise_out, 1024)));
out_noise = out_noise - max(out_noise);
out_s = 20 * log10(abs(fft(S_out, 1024)));
out_s = out_s - max(out_s);
in_noise = 20 * log10(abs(fft(Noise_in, 1024)));
in_noise = in_noise - max(in_noise);
in_s = 20 * log10(abs(fft(S_in, 1024)));
in_s = in_s - max(in_s);

% Compute filter's frequency response
hn = E5_IIRQcoe(12);
m_hn = 20 * log10(abs(fft(hn, 1024)));
m_hn = m_hn - max(m_hn);

% Define frequency axis
x_f = linspace(0, Fs/2, length(out_noise));

% Extract valid frequency response data
mf_noise = out_noise(1:length(x_f));
mf_s = out_s(1:length(x_f));
mf_in_noise = in_noise(1:length(x_f));
mf_in_s = in_s(1:length(x_f));
mf_hn = m_hn(1:length(x_f));

% Plot frequency response
figure(1);
subplot(211);
plot(x_f, mf_in_noise, '--', x_f, mf_noise, '-', x_f, mf_hn, '--');
axis([0 Fs/2 -100 3]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('FPGA Filtered White Noise Frequency Response');
legend('Input Signal Spectrum', 'Output Signal Spectrum', 'Filter Response');
grid on;

subplot(212);
plot(x_f, mf_in_s, '--', x_f, mf_s, '-', x_f, mf_hn, '--');
axis([0 Fs/2 -100 3]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('FPGA Filtered Single Tone Frequency Response');
legend('Input Signal Spectrum', 'Output Signal Spectrum', 'Filter Response');
grid on;

% Time-domain waveform visualization
t = (0:80) / Fs * 1000; % Convert to milliseconds
t_in_noise = Noise_in(1:length(t));
t_in_s = S_in(1:length(t));
t_out_noise = Noise_out(1:length(t));
t_out_s = S_out(1:length(t));

figure(2);
subplot(211);
plot(t, t_in_noise, '--', t, t_out_noise, '-');
xlabel('Time (ms)');
ylabel('Amplitude');
title('FPGA Filtered White Noise Time-Domain Response');
legend('Input Signal', 'Output Signal');
grid on;

subplot(212);
plot(t, t_in_s, '--', t, t_out_s, '-');
xlabel('Time (ms)');
ylabel('Amplitude');
title('FPGA Filtered Single Tone Time-Domain Response');
legend('Input Signal', 'Output Signal');
grid on;
