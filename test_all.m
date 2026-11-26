% TEST_ALL  Unit tests for the MUSIC project.
%
% Run with:   results = runtests('test_all')
%
% HOW IT WORKS
%   Each %% section below is ONE test. A test passes if it runs without
%   an error. assert(condition, message) throws an error (= fail) with
%   your message when the condition is false.
%   Code ABOVE the first %% line is shared setup and runs before every test.
%
% WHY THESE TESTS
%   Tests on the TRUE covariance have no randomness, so any failure is a
%   code bug, not bad luck. Tests on simulated data use rng() so they give
%   the same numbers every time.

pos = (0:9)' * 0.5;          % 10 elements, half-wavelength spacing
M = length(pos);
scanDeg = -90:0.1:90;        % search grid
snrDb = 10;
Psrc = 10^(snrDb/10);        % source power (noise power = 1)

%% Steering vector matches the hand calculation
% 4 elements, d = 0.5, 30 deg: each step is -90 deg -> [1; -j; -1; j]
a = steeringVector(30, (0:3)' * 0.5);
expected = [1; -1j; -1; 1j];
assert(max(abs(a - expected)) < 1e-12, 'steering vector does not match hand calculation');

%% Steering vector entries all have magnitude 1, and 0 deg gives all ones
A = steeringVector([-40 0 25], pos);
assert(max(abs(abs(A(:)) - 1)) < 1e-12, 'entries must have magnitude 1');
assert(max(abs(A(:, 2) - 1)) < 1e-12, 'broadside (0 deg) must be all ones');

%% Sample covariance converges to the true covariance
rng(1);
N = 20000;
A = steeringVector([0 8], pos);
Rtrue = A * (Psrc * eye(2)) * A' + eye(M);
X = simulateData([0 8], pos, snrDb, N);
R = X * X' / N;
relErr = norm(R - Rtrue) / norm(Rtrue);
assert(relErr < 0.05, sprintf('R-hat too far from R: relative error %.3f', relErr));

%% Beamscan finds a single source (true covariance)
a1 = steeringVector(23.4, pos);
R1 = a1 * Psrc * a1' + eye(M);
est = pickPeaks(beamscan(R1, scanDeg, pos), scanDeg, 1);
assert(abs(est - 23.4) < 0.05, sprintf('beamscan got %.2f instead of 23.4', est));

%% MUSIC resolves 0 and 8 deg (true covariance)
A = steeringVector([0 8], pos);
Rtrue = A * (Psrc * eye(2)) * A' + eye(M);
est = pickPeaks(musicSpectrum(Rtrue, 2, scanDeg, pos), scanDeg, 2);
assert(max(abs(est - [0 8])) < 0.05, sprintf('MUSIC got %s', mat2str(est, 4)));

%% MVDR resolves 0 and 8 deg (true covariance)
A = steeringVector([0 8], pos);
Rtrue = A * (Psrc * eye(2)) * A' + eye(M);
est = pickPeaks(mvdr(Rtrue, scanDeg, pos), scanDeg, 2);
assert(max(abs(est - [0 8])) < 0.3, sprintf('MVDR got %s', mat2str(est, 4)));

%% Beamscan does NOT resolve 0 and 8 deg (the limitation is real)
% 8 deg is less than the 11.5 deg resolution limit, so at least one
% estimate must be badly off. If this ever passes the other way,
% something in beamscan is wrong.
A = steeringVector([0 8], pos);
Rtrue = A * (Psrc * eye(2)) * A' + eye(M);
est = pickPeaks(beamscan(Rtrue, scanDeg, pos), scanDeg, 2);
assert(max(abs(est - [0 8])) > 1, 'beamscan should NOT resolve 8 deg with 10 elements');

%% True steering vectors are orthogonal to the noise subspace
A = steeringVector([0 8], pos);
Rtrue = A * (Psrc * eye(2)) * A' + eye(M);
[~, En] = musicSpectrum(Rtrue, 2, scanDeg, pos);
assert(max(max(abs(A' * En))) < 1e-10, 'steering vectors not orthogonal to noise subspace');