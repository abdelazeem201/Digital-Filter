f1=200;       
f2=800;       
Fs=2000;      
N=12;         

% Read input signal data from files
fid=fopen('D:\FilterVerilog\Chapter_4\E4_7\FirFullSerial\simulation\modelsim\E4_7_Int_noise.txt','r');
[Noise_in,N_n]=fscanf(fid,'%lg',inf);
fclose(fid);

fid=fopen('D:\FilterVerilog\Chapter_4\E4_7\FirFullSerial\simulation\modelsim\E4_7_Int_s.txt','r');
[S_in,S_n]=fscanf(fid,'%lg',inf);
fclose(fid);

% Read output signal data from files
fid=fopen('D:\FilterVerilog\Chapter_4\E4_7\FirFullSerial\simulation\modelsim\E4_7_Noiseout.txt','r');
[Noise_out,N_count]=fscanf(fid,'%lg',inf);
fclose(fid);

fid=fopen('D:\FilterVerilog\Chapter_4\E4_7\FirFullSerial\simulation\modelsim\E4_7_Sout.txt','r');
[S_out,S_count]=fscanf(fid,'%lg',inf);
fclose(fid);

% Normalize signals
Noise_out=Noise_out/max(abs(Noise_out));
S_out=S_out/max(abs(S_out));
Noise_in=Noise_in/max(abs(Noise_in));
S_in=S_in/max(abs(S_in));

% Compute frequency response
out_noise=20*log(abs(fft(Noise_out,1024)))/log(10); out_noise=out_noise-max(out_noise);
out_s=20*log(abs(fft(S_out,1024)))/log(10); out_s=out_s-max(out_s);

in_noise=20*log(abs(fft(Noise_in,1024)))/log(10); in_noise=in_noise-max(in_noise);
in_s=20*log(abs(fft(S_in,1024)))/log(10); in_s=in_s-max(in_s);

hn=E4_7_Fir8Serial;
m_hn=20*log(abs(fft(hn,1024)))/log(10); m_hn=m_hn-max(m_hn);

% Set horizontal axis in Hz
x_f=[0:(Fs/length(out_noise)):Fs/2];

% Plot frequency response
figure(1);
subplot(211);
plot(x_f,in_noise(1:length(x_f)),'--',x_f,out_noise(1:length(x_f)),'-',x_f,m_hn(1:length(x_f)),'--');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('FPGA Simulation: Noise Signal Before and After Filtering');
legend('Input Spectrum','Filtered Spectrum','Filter Response');
grid;

subplot(212);
plot(x_f,in_s(1:length(x_f)),'--',x_f,out_s(1:length(x_f)),'-',x_f,m_hn(1:length(x_f)),'--');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('FPGA Simulation: Combined Signal Before and After Filtering');
legend('Input Spectrum','Filtered Spectrum','Filter Response');
grid;
