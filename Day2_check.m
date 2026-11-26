% Day2_check
clear all; clc; close all; 

rng(1);

thetaDeg = [0 8];
pos = (0:9)'*0.5;
snrDb = 10;
N = 20000;

A = steeringVector(thetaDeg,pos);

X = simulateData(thetaDeg,pos,snrDb, N);
% K = 3 sources 
% M = 10 sensors
% signal power is 10 - snrDb 10 = x10
% N = 10000 samples or snapshots of data

K = length(thetaDeg);
M = length(pos);

R = X*X'/N;

% Rtrue = A * (10*eye(2))*A' + eye(10)
% 
% norm(R - Rtrue)/norm(Rtrue)



%%
% clc; clear all; close all;
% thetaDeg = 0;
% pos = (0:9)'*0.5;
% snrDb = 10;
% N = 10000;
% 
% rng(1);
% X = simulateData(thetaDeg, pos, snrDb, N);
% mean(abs(X(:)).^2)
% 
%%
% clc; clear all; close all;
% X = simulateData([0 8], (0:9)'*0.5, -100, 10000);

