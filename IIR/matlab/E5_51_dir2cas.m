function [b0,B,A]=E5_51_dir2cas(b,a);
% Convert a direct-form IIR filter structure into a cascade-form structure.
% b0: Gain coefficient
% B: K-row by 3-column matrix containing the numerator coefficients bk
% A: K-row by 3-column matrix containing the denominator coefficients ak
% a: Denominator polynomial coefficients in direct form
% b: Numerator polynomial coefficients in direct form

% Compute the gain coefficient
bb = b; aa = a;

b0 = b(1); b = b / b0;
a0 = a(1); a = a / a0;
b0 = b0 / a0;

% Ensure numerator and denominator coefficient vectors have the same length
M = length(b); N = length(a);
if N > M
    b = [b zeros(1, N-M)];
elseif M > N
    a = [a zeros(1, M-N)]; 
    N = M;
else
    N = M;
end

% Initialize the cascade form coefficient matrices
K = floor(N/2); 
B = zeros(K,3); 
A = zeros(K,3);

if K*2 == N
    b = [b 0];
    a = [a 0];
end

% Compute the polynomial roots and sort them into conjugate pairs
broots = cplxpair(roots(b));
aroots = cplxpair(roots(a));

% Extract conjugate root pairs and convert them back into polynomial form
for i = 1:2:2*K
    Brow = broots(i:1:i+1,:);
    Brow = real(poly(Brow));
    B(fix(i+1)/2,:) = Brow;
    
    Arow = aroots(i:1:i+1,:);
    Arow = real(poly(Arow));
    A(fix(i+1)/2,:) = Arow;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% When the filter order is 8
% Test the frequency response before and after transformation
delta = [1, zeros(1,31)];
F1 = filter(bb, aa, delta);
figure(1); plot(abs(fft(F1)));

% Uncommented sections for multi-stage filtering
% F21 = filter(B(1,:), A(1,:), delta);
% F22 = filter(B(2,:), A(2,:), F21);
% F23 = filter(B(3,:), A(3,:), F22);
% F2 = filter(b0 * B(4,:), A(4,:), F23);

% Test the frequency response after quantization
% [Qb1, Qa1] = E5_52_Qcoe(B(1,:), A(1,:), 12);
% [Qb2, Qa2] = E5_52_Qcoe(B(2,:), A(2,:), 12);
% [Qb3, Qa3] = E5_52_Qcoe(B(3,:), A(3,:), 12);
% [Qb4, Qa4] = E5_52_Qcoe(b0 * B(4,:), A(4,:), 12);

% QF21 = filter(B(1,:), A(1,:), delta);
% QF22 = filter(B(2,:), A(2,:), QF21);
% QF23 = filter(B(3,:), A(3,:), QF22);
% QF2 = filter(B(4,:), A(4,:), QF23);
% figure(2); plot(abs(fft(QF2)));

%%%%%%%%%%%%%%%%%%%%%%%
% Compare the results of F1 and F2
