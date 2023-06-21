clc;
clear all;
close all;

% Input
N = input('Enter N = ');
f = input('Enter frequency = ');
t = 0:0.01:0.49;
x = randi([0,1], [1,10000]);

% Separating odd and even components
even = [];
odd = [];
for i = 1:N/2
    even = [even x(2*i)];
end
for i = 0:N/2-1
    odd = [odd x((2*i)+1)];
end

% Even component BPSK
msge = [];
xe = [];
for i = 1:N/2
    if even(i) == 1
        xe = ones(1, 50);
    else
        xe = -1 .* ones(1, 50);
    end
    msge = [msge xe];
end
subplot(5, 1, 1);
plot(msge);
xlabel('Time');
ylabel('Amplitude');
title('Polar form of even binary signal');
axis([0 500 -2 2]);

s = sin(2*pi*f*t);
snor = s / sqrt(sum(s.*s));

bpske = [];
for i = 1:N/2
    if even(i) == 1
        se = snor;
    else
        se = -snor;
    end
    bpske = [bpske se];
end
subplot(5, 1, 2);
plot(bpske);
xlabel('Time');
ylabel('Amplitude');
title('BPSK signal from even');
axis([0 500 -0.5 0.5]);

% Odd component BPSK
msgo = [];
xo = [];
for i = 1:N/2
    if odd(i) == 1
        xo = ones(1, 50);
    else
        xo = -1 .* ones(1, 50);
    end
    msgo = [msgo xo];
end
subplot(5, 1, 3);
plot(msgo);
xlabel('Time');
ylabel('Amplitude');
title('Polar form of odd binary signal');
axis([0 500 -2 2]);

c = cos(2*pi*f*t);
cnor = c / sqrt(sum(c.*c));

bpsko = [];
for i = 1:N/2
    if odd(i) == 1
        so = cnor;
    else
        so = -cnor;
    end
    bpsko = [bpsko so];
end
subplot(5, 1, 4);
plot(bpsko);
xlabel('Time');
ylabel('Amplitude');
title('BPSK signal from odd');
axis([0 500 -0.5 0.5]);

% QPSK
qp = bpske + bpsko;
subplot(5, 1, 5);
plot(qp);
xlabel('Time');
ylabel('Amplitude');
title('QPSK signal');
axis([0 500 -1 1]);

% Adding AWGN, demodulation, detection
l = length(qp);
reshapede = [];
reshapedo = [];
pee = [];
peo = [];
snr = [];
ser = [];

for j = 0:0.1:1
    sd = sqrt(j);
    rcvd = qp + (sd .* randn(1, l));
    h = reshape(rcvd, 50, 5000);
    reshapede = snor * h; % Even
    reshapedo = cnor * h; % Odd
    
    if j == 0
        scatterplot([reshapede', reshapedo']);
        title(['Constellation diagram for noise variance=', num2str(j)]);
    elseif j == 0.1
        scatterplot([reshapede', reshapedo']);
        title(['Constellation diagram for noise variance=', num2str(j)]);
    elseif j == 0.2
        scatterplot([reshapede', reshapedo']);
        title(['Constellation diagram for noise variance=', num2str(j)]);
    end
    
    % BER, SER and PSD
    RE = reshapede > 0;
    RO = reshapedo > 0;
    dem = [];
    for i = 1:N/2
        dem = [dem RO(i) RE(i)];
    end
    
    pe_pr = (sum(xor(dem, x))) / N; % PRACTICAL BER
    pee = [pee pe_pr];
    
    SNR = 1 / (2 * j);
    SNR1 = 10 * log10(SNR); % dB
    snr = [snr SNR1];
    
    pe_th = 0.5 * erfc(sqrt(SNR)); % THEORETICAL BER
    peo = [peo pe_th];
    
    SER = erfc(sqrt(SNR));
    ser = [ser SER];
end

figure;
semilogy(snr, pee);
title('BER vs SNR');
xlabel('SNR');
ylabel('BER');

figure;
semilogy(snr, pee, '*', snr, peo, 'b');
title('PRACTICAL vs THEORETICAL');
legend('Practical', 'Theoretical');
xlabel('SNR');
ylabel('BER');

figure;
semilogy(snr, ser);
title('SER vs SNR');
xlabel('SNR');
ylabel('SER');
