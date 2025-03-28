function hn = E4_7_Fir8Serial
N = 16;      % Filter length
fs = 2000;   % Sampling frequency (Hz)
fc = 500;    % Cutoff frequency of the low-pass filter (Hz)
B = 12;      % Number of quantization bits

% Generate different window functions
% w_rect = rectwin(N)';  % Rectangular window
% w_hann = hann(N)';     % Hann window
% w_hamm = hamming(N)';  % Hamming window
w_kais = blackman(N)';   % Blackman window
% w_kais = kaiser(N, 7.856)';  % Kaiser window (alternative)

% Design FIR filter using fir1 function
% b_rect = fir1(N-1, fc*2/fs, w_rect);
% b_hann = fir1(N-1, fc*2/fs, w_hann);
% b_hamm = fir1(N-1, fc*2/fs, w_hamm);
% b_blac = fir1(N-1, fc*2/fs, w_blac);
b_kais = fir1(N-1, fc*2/fs, w_kais); % Using Blackman window

% Quantize filter coefficients
Q_kais = round(b_kais / max(abs(b_kais)) * (2^(B-1) - 1));
hn = Q_kais;

% Convert to 16-bit hexadecimal representation
Q_h = dec2hex(Q_kais + 2^B * (Q_kais < 0));

% Compute frequency response
% m_rect = 20 * log10(abs(fft(b_rect, 512)));
% m_hann = 20 * log10(abs(fft(b_hann, 512)));
% m_hamm = 20 * log10(abs(fft(b_hamm, 512)));
% m_blac = 20 * log10(abs(fft(b_blac, 512)));
m_kais = 20 * log10(abs(fft(b_kais, 1024))); 
m_kais = m_kais - max(m_kais);
Q_kais = 20 * log10(abs(fft(Q_kais, 1024))); 
Q_kais = Q_kais - max(Q_kais);

% Set frequency axis in Hz
x_f = [0:(fs / length(m_kais)):fs/2];

% Extract positive frequency response
% m1 = m_rect(1:length(x_f));
% m2 = m_hann(1:length(x_f));
% m3 = m_hamm(1:length(x_f));
% m4 = m_blac(1:length(x_f));
m5 = m_kais(1:length(x_f));
m6 = Q_kais(1:length(x_f));

% Plot frequency response
% plot(x_f, m1, '-', x_f, m2, '*', x_f, m3, '+', x_f, m4, '--', x_f, m5, '-.');
plot(x_f, m5, '-', x_f, m6, '--');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend('Unquantized', '12-bit Quantized');
grid;
