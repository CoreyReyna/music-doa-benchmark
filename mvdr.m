function P = mvdr(R, scanDeg, pos)
%MVDR  Capon / MVDR (Minimum Variance Distortionless Response) spectrum.
%
%   P = mvdr(R, scanDeg, pos)
%
%   INPUTS
%     R       - M x M covariance matrix (sample or true)
%     scanDeg - 1 x G list of look angles in degrees
%     pos     - M x 1 element positions in wavelengths
%   OUTPUT
%     P       - 1 x G MVDR power spectrum (peaks = estimated directions)
%
%   IDEA
%   Beamscan uses the same fixed weights for every data set. MVDR designs
%   new weights for each look angle: keep the look direction at gain 1,
%   and make the TOTAL output power as small as possible. The only way to
%   lower the power is to put nulls on the other sources, so MVDR
%   "adapts" to the data and gets much sharper peaks than beamscan.
%
%   Solving that optimization gives the output power
%       P(theta) = 1 / ( a^H * R^-1 * a )
%
%   NOTE: needs R to be invertible, which requires N > M snapshots
%   (we use N = 100, M = 10).

G = numel(scanDeg);                     % number of look angles
P = zeros(1, G);                        % preallocate the spectrum
Ascan = steeringVector(scanDeg, pos);   % M x G: one steering vector per angle
Rinv = inv(R);                          % invert ONCE, reuse for every angle

for g = 1:G
    a = Ascan(:, g);                    % steering vector for this angle
    P(g) = 1 / real(a' * Rinv * a);     % MVDR output power at this angle
end
end