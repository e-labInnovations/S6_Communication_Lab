clc;
clear all;
close all;
fs=20;%sampling rate
fd=1;%input sampling frequency
pd=500;%Total number of message bits 
x=randi([0,1],[1,pd]);
delay=3;
%rolloff factor 0.2
rcv1=rcosflt(x,fd,fs,'fir/normal',0.2,delay);
%rolloff factor 0.4 
rcv2=rcosflt(x,fd,fs,'fir/normal',0.4,delay);
%rolloff factor 0.6
rcv3=rcosflt(x,fd,fs,'fir/normal',0.6,delay);
%rolloff factor 0.8 
rcv4=rcosflt(x,fd,fs,'fir/normal',0.8,delay); 
n=fs/fd;
eyediagram(rcv1,n)%for plotting eye diagram for rolloff factor 0.2 
eyediagram(rcv2,n)%for plotting eye diagram for rolloff factor 0.4 
eyediagram(rcv3,n)%for plotting eye diagram for rolloff factor 0.6 
eyediagram(rcv4,n)%for plotting eye diagram for rolloff factor 0.8
