function hn = E5_IIRQcoe(Qcoe)
    % E5_IIRQcoe.m
    % Designs a Chebyshev Type II IIR filter, quantizes its coefficients,
    % and analyzes its impulse response and frequency response.

    % Filter design parameters
    fs = 2000;   % Sampling frequency (Hz)
    fc = 500;    % Cutoff frequency (Hz)
    Rs = 60;     % Stopband attenuation (dB)
    N = 7;       % Filter order

    % Design the Chebyshev Type II low-pass filter
    [b, a] = cheby2(N, Rs, 2*fc/fs);

    % Determine scaling factor for quantization
    m = max(max(abs(a), abs(b)));  % Get max absolute value of coefficients
    Qm = floor(log2(m / a(1)));    % Compute integer exponent for scaling
    if Qm < log2(m / a(1))
        Qm = Qm + 1;
    end
    Qm = 2^Qm;  % Convert Qm to power of 2

    % Quantize the filter coefficients
    Qb = round(b / Qm * (2^(Qcoe-1) - 1)); % Quantized numerator coefficients
    Qa = round(a / Qm * (2^(Qcoe-1) - 1)); % Quantized denominator coefficients

    % Compute impulse response of the quantized filter
    delta = [1, zeros(1, 1023)];  % Unit impulse of length 1024
    hn = filter(Qb, Qa, delta);

    % Plot frequency response of the original filter
    figure(1);
    freqz(b, a, 1024, fs);
    title('Frequency Response of Original Filter');

    % Plot frequency response of the quantized filter
    figure(2);
    freqz(Qb, Qa, 1024, fs);
    title('Frequency Response of Quantized Filter');
end
