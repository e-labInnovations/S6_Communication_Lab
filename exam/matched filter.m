%Matlab function to implement Square Root Raised Cosine Filter:
function [response]=srrc(os_factor,roll_off)
a=roll_off;
t=-4:1/os_factor:4; %Limiting the response to -4T to 4T
%This can be increased or decreased according to the requirement
p=zeros(1,length(t));
for i=1:1:length(t)
    if t(i)==0
        p(i)= (1-a)+4*a/pi;
    else if t(i)==1/(4*a) || t(i)==-1/(4*a)
            p(i)=a/sqrt(2)*((1+2/pi)*sin(pi/(4*a)+(1- 2/pi)*cos(pi/(4*a))));
    else p(i) = (sin(pi*t(i)*(1-a))+4*a*t(i).*cos(pi*t(i)*(1+a)))./(pi*t(i).*(1-(4*a*t(i)).^2));
    end
    end
end
response=p./sqrt(sum(p.^2)); %Normalization to unit energy
end





%Simulation of Square Root Raised Cosine Filter in Matlab:
clc;
clear all;
close all;
overSampling_Factor=8;
Input_bit = [1]; %Bits to be transmitted
Input_bit_os=upsample(Input_bit,overSampling_Factor); %oversampling
alpha=0.1; % roll-offfactor of Root Raised Cosine Filter
pt = srrc(overSampling_Factor,alpha);
figure;
stem(pt);
output_of_srrc_filter = conv(Input_bit_os,pt);
figure;
stem(output_of_srrc_filter);
output_of_srrc_filter=awgn(output_of_srrc_filter,100);
title('Response of SRRC Filter at Tx side')
xlabel('Samples')
ylabel('Amplitude')
%Receiver side; using a matched filter (that is matched to the SRRC pulse in the transmitter)
y = conv(output_of_srrc_filter,pt);
figure;
stem(y);
title('Matched filter (SRRC) response at Rx side');
xlabel('Samples');
ylabel('Amplitude');
midSample=length(-4:1/overSampling_Factor:4);
%y_truncated=y(midSample-1:end); %Remove unwanted portions(first few samples till the peak value)
%Now the first sample contains the peak value of the response. From here the samples are extracted depending on the oversampling factor
y_down = downsample(y,overSampling_Factor,1);
%here offset=1 means starting from 1st sample %retain every 8th sample
figure;
stem(y_down);
title('Down sampled output (ADC conversion and Sampling)');
xlabel('Samples');
ylabel('Amplitude');
