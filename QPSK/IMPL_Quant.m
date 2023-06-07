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




