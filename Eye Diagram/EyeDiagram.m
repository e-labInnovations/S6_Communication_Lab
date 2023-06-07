clc;
clear all;
close all;
fs=20;
fd=1;
pd=500;
x=randi([0,4],[1,pd]);
delay=3;
rcv1=rcosflt(x,fd,fs,'fir/normal',0.1,delay);
rcv2=rcosflt(x,fd,fs,'fir/normal',0.8,delay);
rcv3=rcosflt(x,fd,fs,'fir/normal',0.9,delay);
rcv4=rcosflt(x,fd,fs,'fir/normal',1,delay); 
n=fs/fd;
eyediagram(rcv1,n)
eyediagram(rcv2,n)
eyediagram(rcv3,n)
eyediagram(rcv4,n)
