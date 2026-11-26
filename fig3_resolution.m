%% Figure 3: how close can two sources be before each method fails?
%
% Source 1 stays at 0 deg. Source 2 moves from 2 to 16 deg away.
% At each separation we run T random trials and count how often each
% method "resolves" the pair.
%
% RESOLVED = both estimates land within half the separation of their
% true angles. (Then each estimate is closer to its own source than to
% the other one, so the method really saw two separate sources.)
%
% Expected (10 dB, N = 100): MUSIC resolves from ~4 deg, MVDR from ~6 deg,
% beamscan only from ~10-12 deg (theory: 11.5 deg for 10 elements).

clc; clear; close all;

% ---- settings ----
pos = (0:9)' * 0.5;          % 10 elements, half-wavelength spacing
scanDeg = -90:0.1:90;
snrDb = 10;
N = 100;
T = 20;                      % trials per separation (more = smoother, slower)
sepList = 2:2:16;            % separations to test, in degrees
K = 2;
rng(1);

% ---- results table: rows = methods, columns = separations ----
% row 1 = beamscan, row 2 = MVDR, row 3 = MUSIC
pctResolved = zeros(3, length(sepList));

for i = 1:length(sepList)
    trueDeg = [0, sepList(i)];
    halfSep = sepList(i) / 2;
    count = zeros(3, 1);                      % successes for each method

    for t = 1:T
        % one random data set, shared by all three methods (fair test)
        X = simulateData(trueDeg, pos, snrDb, N);
        R = X * X' / N;

        estBs = pickPeaks(beamscan(R, scanDeg, pos), scanDeg, K);
        estMv = pickPeaks(mvdr(R, scanDeg, pos), scanDeg, K);
        estMu = pickPeaks(musicSpectrum(R, K, scanDeg, pos), scanDeg, K);

        % resolved if the WORST of the two errors is under half the separation
        count(1) = count(1) + (max(abs(estBs - trueDeg)) < halfSep);
        count(2) = count(2) + (max(abs(estMv - trueDeg)) < halfSep);
        count(3) = count(3) + (max(abs(estMu - trueDeg)) < halfSep);
    end

    pctResolved(:, i) = 100 * count / T;
    fprintf('separation %2d deg | beamscan %3.0f%% | MVDR %3.0f%% | MUSIC %3.0f%%\n', ...
        sepList(i), pctResolved(1, i), pctResolved(2, i), pctResolved(3, i));
end

% ---- plot ----
figure;
plot(sepList, pctResolved(1, :), 'o-', 'LineWidth', 1.5); hold on;
plot(sepList, pctResolved(2, :), 's-', 'LineWidth', 1.5);
plot(sepList, pctResolved(3, :), 'd-', 'LineWidth', 1.5);
xline(11.5, 'k--', 'beamscan limit 11.5°');       % theory: first null of the beam
grid on; ylim([-5 105]);
xlabel('source separation (deg)');
ylabel('trials resolved (%)');
legend('beamscan', 'MVDR', 'MUSIC', 'Location', 'southeast');
title(sprintf('Resolution vs separation (%d dB, N = %d, %d trials each)', snrDb, N, T));
exportgraphics(gcf, 'fig3_resolution.png');