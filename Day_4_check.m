% Day 4 MATLAB Lessons - MUSIC/ Schmidt's algorithm

clear; clc; close all;  % clear doesn't clear all cache data and is faster

% rng(1);                 % same set of random values

thetaDeg = [0 8];       % signal angles
pos = (0:9)'*0.5;       % 10 sensors 0.5 wavelength apart
snrDb = 10;             % signal power of each signal
N = 20000;              % number of snapshots
scanDeg = -90:0.1:90;   % scan angles for MUSIC spectrum


A = steeringVector(thetaDeg,pos);   % steering vector MxK matrix

X = simulateData(thetaDeg,pos,snrDb, N);
% K = 2 sources 
% M = 10 sensors
% signal power is 10 - snrDb 10 = x10
% N = 20000 samples or snapshots of data

K = length(thetaDeg);
M = length(pos);

R = X*X'/N;         % Covariance matrix of based on sensors and data
% The Covariance matrix essentially tells you how much each signal bleeds
% into the other sensors and the average power at each sensor 

Rtrue = A * (10*eye(K)) * A' + eye(M);

[~, En] = musicSpectrum(Rtrue, K, scanDeg, pos);   % ~ = "I don't need P here"

testAngles = [0 8 30];
for i = 1:length(testAngles)
    a = steeringVector(testAngles(i), pos);          % build a(theta) directly
    fprintf('%5.1f deg: max |a''*En| = %.2e\n', testAngles(i), max(abs(a' * En)));
end
% verifies that I see near zero at my known signal locations and a value
% obviously not zero elsewhere.


pickPeaks(musicSpectrum(Rtrue, K, scanDeg, pos), scanDeg, K);
% This checks that my peaks are in fact at the angles I expect to find the
% sources.

Pmu_1 = musicSpectrum(R_1, K_1, scanDeg, pos);
est_mu_1 = ________;                           % pickPeaks on Pmu_1
fprintf('Simulated, sources %s: MUSIC estimates %s\n', ...
    mat2str(thetaDeg_1), mat2str(est_mu_1, 4));

