% Day 1 check script

clc; clear all; close all;

% steeringVector([30 0], (0:3)'*0.5)

M = 10;
pos = (0:M-1)' * 0.5;               % 0.5 is the wavelength spacing of the positions
a = steeringVector(30, pos);         % the ' is to transpose the rows to columns
                                    % so it plays nice with the function
                                    % mxn x nxp matrix calculations 

wrapAngle = angle(a) * 180/pi;          % the angle function gives the angle of each arrow in radians between -pi and pi

unwrapAngel = unwrap(angle(a)) *180/pi;   % unwrap gives the full 0 to 2pi spectrum 

figure;
plot(1:M, unwrapAngel, 'o-'); hold on;      % unwraped angel in degrees
plot(1:M, wrapAngle, 'x--');                % wraped angle in degrees
grid on; xlabel('element number m'); ylabel('phase (deg');
legend('unwrapped','wrapped');