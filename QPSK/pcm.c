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
xlabel(&#39;time&#39;);
ylabel(&#39;Amplitude&#39;);
title(&#39;Signal&#39;);

% Sampling the signal
freq_sample=15*freq_msg; % sampling frequency
samp_time=0:1/freq_sample:0.05; % sampling time
samp_signal=dc_ofst+sin(2*pi*freq_msg*samp_time);% generating the sampled signal
hold on
plot(samp_time,samp_signal,&#39;rx&#39;) % plotting the sampled signal
title(&#39;Sampled Signal&#39;)
legend(&#39;Original signal&#39;,&#39;Sampled signal&#39;);

% Uniform Quantizer
L=8; %No of Quantization levels
smin=round(min(signal)); smax=round(max(signal));
Quant_levl=linspace(smin,smax,L); % Length 8, to represent 9 intervals
codebook = linspace(0,smax,L+1); % Length 9, one entry for each interval
[index,quants] = quantiz(samp_signal,Quant_levl,codebook); % Quantize.

figure;
plot(samp_time,samp_signal,&#39;x&#39;,samp_time,quants,&#39;.-&#39;)% plotting sampled signal and
quantization level title(&#39;Quantized Signal&#39;)
legend(&#39;Original signal&#39;,&#39;Quantized signal&#39;);
figure;
plot(samp_time,index,&#39;.-&#39;)% plotting quantization levels of input signal
title(&#39;Encoded Signal&#39;);

% Binary coding

for i=1:length(index)
bincode_sig{i}=dec2bin(round(index(i)),3);
end
disp(&#39;binary encoded signal&#39;);
disp(bincode_sig)
% SNR ratio calculation
noise=quants-samp_signal; % calculating noise
figure;
plot(samp_time,noise,&#39;.-&#39;); % plotting figure
title(&#39;Noise&#39;);
r=snr(index,noise);% SNR
snr1=[&#39;SNR :&#39;,num2str(r)];
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
xlabel(&#39;L&#39;);
ylabel(&#39;SNR&#39;);
title(&#39;L vs SNR&#39;);