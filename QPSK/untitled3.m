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
xlabel('L');
ylabel('SNR'); 
title('L vs SNR');
