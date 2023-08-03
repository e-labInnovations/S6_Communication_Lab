% PCM CODE
clc;
clear all;
close all;% closing any opened figures
% Plotting the offset sinusoidal signal 
time = 0:.0005:.05;
freq_msg=100; %wave form frequency 
dc_ofst=2; % signal offset
signal=sin(2*pi*freq_msg*time)+dc_ofst; %Generating the signal
% plotting the signal 
figure;
plot(time,signal); 
xlabel('time'); 
ylabel('Amplitude'); 
title('Signal');
 
% Sampling the signal 
freq_sample=15*freq_msg; % sampling frequency
samp_time=0:1/freq_sample:0.05; % sampling time 
samp_signal=dc_ofst+sin(2*pi*freq_msg*samp_time);% generating the sampled signal
hold on
plot(samp_time,samp_signal,'rx') % plotting the sampled signal 
title('Sampled Signal')
legend('Original signal','Sampled signal');
 
% Uniform Quantizer
L=8; %No of Quantization levels 
smin=round(min(signal)); smax=round(max(signal));
Quant_levl=linspace(smin,smax,L); % Length 8, to represent 9 intervals
codebook = linspace(0,smax,L+1); % Length 9, one entry for each interval
[index,quants] = quantiz(samp_signal,Quant_levl,codebook); % Quantize.
 
figure;
plot(samp_time,samp_signal,'x',samp_time,quants,'.-')% plotting sampled signal and quantization level title('Quantized Signal')
legend('Original signal','Quantized signal'); 
figure;
plot(samp_time,index,'.-')% plotting quantization levels of input signal
title('Encoded Signal');
 
% Binary coding
for i=1:length(index) 
    bincode_sig{i}=dec2bin(round(index(i)),3);
end
disp('binary encoded signal');
disp(bincode_sig)
% SNR ratio calculation
noise=quants-samp_signal; % calculating noise 
figure;
plot(samp_time,noise,'.-'); % plotting figure 
title('Noise');
r=snr(index,noise);% SNR 
snr1=['SNR :',num2str(r)]; 
disp(snr1)







% Function for ploting Quant_level vs SNR 
function [ r ] = IMPL_Quant( l,b )
% Plotting the offset sinusoidal signal 
time = 0:.0005:.05;
freq_msg=100; %wave form frequency 
dc_ofst=2; % signal offset
signal=sin(2*pi*freq_msg*time)+dc_ofst; %Generating the signal
 
% Sampling the signal 
freq_sample=15*freq_msg; % sampling frequency
samp_time=0:1/freq_sample:0.05; % sampling time 
samp_signal=dc_ofst+sin(2*pi*freq_msg*samp_time);% generating the sampled signal
 
% Uniform Quantizer
L=l; %No of Quantization levels 
smin=round(min(signal)); 
smax=round(max(signal));
Quant_levl=linspace(smin,smax,L); % Length 8, to represent 9 intervals
codebook = linspace(0.7,smax,L+1); % Length 9, one entry for each interval
[index,quants] = quantiz(samp_signal,Quant_levl,codebook);
% Quantize.
 
% Binary coding
for i=1:length(quants) 
    bincode_sig{i}=dec2bin(round(quants(i)),b);
end
 
% SNR ratio calculation
noise=quants-samp_signal; % calculating noise 
r=snr(index,noise);% SNR
end







% PCM SNR PLOT
% Program for plotting quantization level vs SNR
clc;
clear all;
close all;
l=[8,16,32,64,128];% defining different levels 
b=[3,4,5,6,7];
for i=1:length(l)
r(i) = IMPL_Quant(l(i),b(i));% calling the function
end
%Plotting 
figure;
plot(l,r);
xlabel('L');
ylabel('SNR'); 
title('L vs SNR');
