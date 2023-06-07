clc;
clear
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
% y_truncated=y(midSample-1:end); %Remove unwanted portions(first few samples till the peak value) 
%Now the first sample contains the peak value of the response. From here the samples are extracted depending on the oversampling factor 
y_down = downsample(y,overSampling_Factor,1); 
%here offset=1 means starting from 1st sample %retain every 8th sample 
figure;
stem(y_down);
title('Down sampled output (ADC conversion and Sampling)'); 
xlabel('Samples');
ylabel('Amplitude'); 
