% E5_54_MatlabSim.M

% Compute coefficients of a Chebyshev Type II IIR filter
[b,a] = cheby2(7, 60, 0.5);

% Convert direct form filter to cascaded form
[b0, B, A] = E5_51_dir2cas(b, a);

% Quantize cascaded filter coefficients to 12-bit precision
[Qb1, Qa1] = E5_52_Qcoe(b0 * B(1,:), A(1,:), 12);
[Qb2, Qa2] = E5_52_Qcoe(B(2,:), A(2,:), 12);
[Qb3, Qa3] = E5_52_Qcoe(B(3,:), A(3,:), 12);
[Qb4, Qa4] = E5_52_Qcoe(B(4,:), A(4,:), 12);

% Generate test input signals (quantized signals and noise)
[Q_s, Q_noise] = E5_53_NoiseAndCarrier;

% Apply cascaded IIR filtering on noise signal
N1 = filter(Qb1, Qa1, Q_noise);
N2 = filter(Qb2, Qa2, N1);
N3 = filter(Qb3, Qa3, N2);
Nout = filter(Qb4, Qa4, N3);

% Apply cascaded IIR filtering on signal
S1 = filter(Qb1, Qa1, Q_s);
S2 = filter(Qb2, Qa2, S1);
S3 = filter(Qb3, Qa3, S2);
Sout = filter(Qb4, Qa4, S3);

% Compute bit width required for each stage output
QN1 = ceil(log2(max(abs(N1))) + 1);
if 2^(QN1 + 1) == max(abs(N1))
    QN1 = QN1 + 1;
end

QN2 = ceil(log2(max(abs(N2))) + 1);
if 2^(QN2 + 1) == max(abs(N2))
    QN2 = QN2 + 1;
end

QN3 = ceil(log2(max(abs(N3))) + 1);
if 2^(QN3 + 1) == max(abs(N3))
    QN3 = QN3 + 1;
end

QNout = ceil(log2(max(abs(Nout))) + 1);
if 2^(QNout + 1) == max(abs(Nout))
    QNout = QNout + 1;
end

QS1 = ceil(log2(max(abs(S1))) + 1);
if 2^(QS1 + 1) == max(abs(S1))
    QS1 = QS1 + 1;
end

QS2 = ceil(log2(max(abs(S2))) + 1);
if 2^(QS2 + 1) == max(abs(S2))
    QS2 = QS2 + 1;
end

QS3 = ceil(log2(max(abs(S3))) + 1);
if 2^(QS3 + 1) == max(abs(S3))
    QS3 = QS3 + 1;
end

QSout = ceil(log2(max(abs(Sout))) + 1);
if 2^(QSout + 1) == max(abs(Sout))
    QSout = QSout + 1;
end

% Ensure bit width matches for signal and noise filtering
QS1 = max(QS1, QN1);
QS2 = max(QS2, QN2);
QS3 = max(QS3, QN3);
QSout = max(QSout, QNout);

% Set frequency axis in Hz
Fs = 2000;
x_f = [0:(Fs / length(Q_noise)):Fs/2];

% Compute frequency response
FNin = 20 * log10(abs(fft(Q_noise))); FNin = FNin - max(FNin);
FNout = 20 * log10(abs(fft(Nout))); FNout = FNout - max(FNout);
FSin = 20 * log10(abs(fft(Q_s))); FSin = FSin - max(FSin);
FSout = 20 * log10(abs(fft(Sout))); FSout = FSout - max(FSout);

% Plot frequency response
FNin = FNin(1:length(x_f));
FNout = FNout(1:length(x_f));
FSin = FSin(1:length(x_f));
FSout = FSout(1:length(x_f));

subplot(211);
plot(x_f, FNout, '-', x_f, FNin, '--');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)'); title('Filtered Noise Signal Frequency Response');
legend('Input Signal Spectrum', 'Output Signal Spectrum', 'Filter Response');
grid;

subplot(212);
plot(x_f, FSout, '-', x_f, FSin, '--');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)'); title('Filtered Sinusoidal Signal Frequency Response');
legend('Input Signal Spectrum', 'Output Signal Spectrum', 'Filter Response');
grid;
