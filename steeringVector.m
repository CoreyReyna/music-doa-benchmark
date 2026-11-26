function A = steeringVector(thetaDeg, pos)
% STEERINGVECTOR  angle in degrees of incoming signal, position is a matrix
% of each position that should be standard multiple of the wavelength from
% incoming signal. We keep estimated sensor distance to 0.5 mutliples of
% wavelengths so each phase is unique in the [-pi pi] wrap that happens.

M = length(pos);                        % total number of elements
K = length(thetaDeg);                   % total number of many angles
A = zeros(M,K);                         % rows = elements, columns = angles

for k = 1:K                             % outer loop: one angle at a time (a column)
    thetaRad = thetaDeg(k)*pi/180;      % convert angle k from degrees to radians

    for m = 1:M                                  % inner loop: one element at a time (down the column)
        phase = -2*pi*pos(m)*sin(thetaRad);      % -2*pi * (position of element m) * sin(the angle)
        A(m, k) = exp(1j*phase);                 % turn the phase into a unit arrow: exp(1j*...)
        % fprintf('element %d, angle %g deg: phase = %.1f deg\n', m, thetaDeg(k), phase*180/pi);
    end
end
end
