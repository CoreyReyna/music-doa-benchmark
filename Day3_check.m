% Day 3 check


% This check is for making sure the estimated value of the angle from our
% beam scan function is close enough to the true value of the angle. This
% angle is the one/the ones we're choosing when we create the data. As long
% as we are close enough (within plus or minus 0.05) we are satisfied that
% this method of determining signal angle works.
% 
% This check uses the exact covariance (no random data), so
% beamscan + pickPeaks should recover the angle up to the 0.1° grid.
% A failure here is a code bug, not noise.
% 


clc; clear; close all;


thetaDeg = 23.43;        % Try using 23.43 to see the resolution error.
pos = (0:9)'*0.5;

K = length(thetaDeg);
M = length(pos);

A = steeringVector(thetaDeg,pos);
snrDb = 10;
P = 10^(snrDb/10);
scanDeg = -90:0.1:90;

Rtrue = A * (10*eye(K)) * A' + eye(M);

est = pickPeaks(beamscan(Rtrue, scanDeg, pos), scanDeg, K);

fprintf('Estimated angle: %.2f deg\nTrue angle:      %.2f deg\n', est, thetaDeg);

err = max(abs(est - sort(thetaDeg)));
assert(err < 0.05, 'beamscan check FAILED: error %.3f deg', err);
fprintf('beamscan check passed (error %.3f deg is less than 0.05)\n', err);