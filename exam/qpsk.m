clc;
clear all:
close all;
 
% input
N=input('enter N=');
f=input('enter frequency=');
t=0:0.01:0.49;
x=randi([0,1],[1,10000]);


% Seperating odd and even components
even=[];
odd=[];
for i=1:N/2
    even=[even x(2*i)];
end;
for i=0:N/2-1
    odd=[odd x((2*i)+1)];
end;
 
% Even component BPSK
msge=[];
xe=[];
for i=1:N/2
if even(i)==1
        xe=ones(1,50);
else
        xe=-1.*ones(1,50);
end; 
msge=[msge xe];
end;
subplot(511);
plot(msge);
xlabel(' time');
ylabel('amplitude');
title('Polar form of even binary signal');
axis([0 500 -2 2]);
 
 
s=sin(2*pi*f*t);
snor=s/sqrt(sum(s.*s));
% plot(t,F1);
% xlabel(' time');
% ylabel('amplitude');
% title('Normalised carrier for even');
 
bpske=[];
for i=1:N/2
if even(i)==1;
        se=snor;
else
        se=-snor;
end
    bpske=[bpske se];
end
subplot (512);
plot(bpske);
xlabel(' time');
ylabel('amplitude');
title('BPSK signal from even');
axis([0 500 -.5 .5]);
 
% Odd component BPSK
msgo=[];
xo=[];
for i=1:N/2
if odd(i)==1
        xo=ones(1,50);
else
        xo=-1.*ones(1,50);
end; 
msgo=[msgo xo];
end;
subplot(513);
plot(msgo);
xlabel(' time');
ylabel('amplitude');
title('Polar form of odd binary signal');
axis([0 500 -2 2]);
 
 
c=cos(2*pi*f*t);
cnor=c/sqrt(sum(c.*c));
% plot(t,F2);
% xlabel(' time');
% ylabel('amplitude');
% title('Normalised carrier for odd');
 
bpsko=[];
for i=1:N/2;
if odd(i)==1;
        so=cnor;
else
        so=-cnor;
end;
    bpsko=[bpsko so];
end
subplot (514);
plot(bpsko);
xlabel(' time');
ylabel('amplitude');
title('BPSK signal from odd');
axis([0 500 -.5 .5]);
 
% QPSK
qp=bpske+bpsko;
subplot (515);
plot(qp);
xlabel(' time');
ylabel('amplitude');
title('QPSK signal');
axis([0 500 -1 1]);
 
% Adding AWGN, demodulation ,detection
l=length(qp);
reshapede=[];
reshapedo=[];
pee=[];
peo=[];
snr=[];
ser=[];
 
for j= 0:0.1:1;
sd=sqrt(j);
rcvd=qp+(sd.*randn(1,l));
h=reshape(rcvd,50,5000);
reshapede=snor*h;      %even
reshapedo=cnor*h;      %odd
 
if j==0
        scatterplot([reshapede',reshapedo']);
        title(['Constellation diagram for noise variance=',num2str(j)]);
elseif j==0.1
         scatterplot([reshapede',reshapedo']);
         title(['Constellation diagram for noise variance=',num2str(j)]);
elseif j==0.2
         scatterplot([reshapede',reshapedo']);
         title(['Constellation diagram for noise variance=',num2str(j)]);
end
 
% BER, SER and PSD
RE=reshapede>0;
RO=reshapedo>0;
dem=[];
for i=1:N/2
    dem=[dem RO(i) RE(i)];
end
pe_pr=(sum(xor(dem,x)))/N;  %PRACTICAL BER
pee=[pee pe_pr];
SNR=1/(2*j);
SNR1=10*log10(SNR);     %dB
snr=[snr SNR1];
pe_th=0.5*erfc(sqrt(SNR));   %THEORETICAL BER
peo=[peo pe_th];
SER=erfc(sqrt(SNR));
ser=[ser SER];
end
 
figure;
semilogy(snr,pee);
title('BER v/s SNR');
xlabel('SNR');
ylabel('BER');
 
 
figure;
semilogy(snr,pee,'*',snr,peo,'b');
title('PRACTICAL vs THEORETICAL');
legend('practical','theoretical');
xlabel('SNR');
ylabel('BER');
 
figure;
semilogy(snr,ser);
title('SER vs SNR');
xlabel('SNR');
ylabel('SER');
