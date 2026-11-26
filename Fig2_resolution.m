% Figure 2 resolution code
% Using the true covariance, plot beamscan spectra for sources at [0, 8] 
% and at [0, 14] on one figure. Then repeat with simulated data (N = 100,
% 10 dB). Print pickPeaks's estimates for each.

%%
clc; clear; close all;

thetaDeg_1 = [0, 8];
thetaDeg_2 = [0, 14];
pos = (0:9)'*0.5;
scanDeg = -90:0.1:90;
snrDb = 10;
N = 100;
% use given parameters  


K_1 = length(thetaDeg_1);
K_2 = length(thetaDeg_2);
M = length(pos);

A_1 = steeringVector(thetaDeg_1,pos);
A_2 = steeringVector(thetaDeg_2,pos);



Rtrue_1 = A_1 * (snrDb*eye(K_1)) * A_1' + eye(M);
Rtrue_2 = A_2 * (snrDb*eye(K_2)) * A_2' + eye(M);

Pbs_1 = beamscan(Rtrue_1, scanDeg, pos);
Pbs_2 = beamscan(Rtrue_2, scanDeg, pos);

est_1 = pickPeaks(Pbs_1, scanDeg, K_1);
est_2 = pickPeaks(Pbs_2, scanDeg, K_2);

fprintf('True cov, sources %s: beamscan estimates %s\n', mat2str(thetaDeg_1), mat2str(est_1, 4));
fprintf('True cov, sources %s: beamscan estimates %s\n', mat2str(thetaDeg_2), mat2str(est_2, 4));
% mat2str turns a vector into readable text like [0 8], and the 4 means "4 significant digits".

figure;
subplot(1, 2, 1);
plot(scanDeg, 10*log10(Pbs_1/max(Pbs_1)), 'LineWidth', 1.5); hold on;
plot(scanDeg, 10*log10(Pbs_2/max(Pbs_2)), 'LineWidth', 1.5);


xline(0, 'm--'); xline(8, 'm--'); xline(14, 'm--');
% Marks the true angles in vertical lines as a magenta dashed line so we
% can see how close the estimates were to the actual angles. 

xlim([-40 40]); ylim([-40 3]); grid on;
% plots are only "interesting" areas

xlabel('angle (deg)'); ylabel('normalized power (dB)');

legend('sources [0 8]', 'sources [0 14]', 'Location','south');
title('Beamscan, true covariance');




rng(1);
% set random seed so I get the same random numbers over and over again

X_1 = simulateData(thetaDeg_1, pos, snrDb, N);
X_2 = simulateData(thetaDeg_2, pos, snrDb, N);
% simulate data using each set of angle pairs and given values

R_1 = X_1 * X_1'/N;
R_2 = X_2 * X_2'/N;
% sample covariance from the simulated data


Psim_1 = beamscan(R_1,scanDeg,pos);
Psim_2 = beamscan(R_2,scanDeg,pos);
% run beam scan on simulated data

est_sim_1 = pickPeaks(Psim_1, scanDeg, K_1);
est_sim_2 = pickPeaks(Psim_2, scanDeg, K_2);

fprintf('Simulated, sources %s: beamscan estimates %s\n', mat2str(thetaDeg_1), mat2str(est_sim_1, 4));
fprintf('Simulated, sources %s: beamscan estimates %s\n', mat2str(thetaDeg_2), mat2str(est_sim_2, 4));
% mat2str turns a vector into readable text like [0 8], and the 4 means "4 significant digits".

subplot(1, 2, 2);
plot(scanDeg, 10*log10(Psim_1/max(Psim_1)), 'LineWidth', 1.5); hold on;
plot(scanDeg, 10*log10(Psim_2/max(Psim_2)), 'LineWidth', 1.5);


xline(0, 'm--'); xline(8, 'm--'); xline(14, 'm--');
% Marks the true angles in vertical lines as a magenta dashed line so we
% can see how close the estimates were to the actual angles. 

xlim([-40 40]); ylim([-40 3]); grid on;
% zoom in on the region around the sources

xlabel('angle (deg)'); ylabel('normalized power (dB)');

legend('sources [0 8]', 'sources [0 14]', 'Location','south');
title('Beamscan, simulated data (N = 100)');

exportgraphics(gcf, 'fig2_resolution.png');

% The simulated data matches the true covariance as expected. The beamscan
% method struggles with angles close together and therefor the model on
% simulated data will see that exact issue also. The simulations are
% accurate.

Pmu_1 = musicSpectrum(R_1, K_1, scanDeg, pos);
est_mu_1 = pickPeaks(Pmu_1, scanDeg, K_1);        % pickPeaks on Pmu_1
fprintf('Simulated, sources %s: MUSIC estimates %s\n', ...
    mat2str(thetaDeg_1), mat2str(est_mu_1, 4));

% Pmu_1_Rtrue = musicSpectrum(Rtrue_1, K_1, scanDeg, pos);


Pmv_1 = mvdr(R_1, scanDeg, pos);
est_mv_1 = pickPeaks(Pmv_1, scanDeg, K_1);        % pickPeaks on Pmv_1
fprintf('Simulated, sources %s: MVDR estimates %s\n', ...
    mat2str(thetaDeg_1), mat2str(est_mv_1, 4));


figure;
plot(scanDeg, 10*log10(Psim_1/max(Psim_1)), 'LineWidth', 1.5); hold on;
plot(scanDeg, 10*log10(Pmu_1/max(Pmu_1)),   'LineWidth', 1.5);
plot(scanDeg, 10*log10(Pmv_1/max(Pmv_1)), 'LineWidth', 1.5);
% plot(scanDeg, 10*log10(Pmu_1_Rtrue/max(Pmu_1_Rtrue)), 'y--', 'LineWidth', 1.5);
% Normalizing the power to each ones max to allow both to show up on the
% same graph. The peaks for MUSIC are very very high and beam scan wouldn't
% be perceivable otherwise.

xline(0, 'm--');  xline(8, 'm--');
xlim([-30 40]);  ylim([-50 3]);  grid on;
% Musics dips go very deep and limiting to -40 dB keeps both curves
% readable

xlabel('angle (deg)');  ylabel('normalized spectrum (dB)');
legend('beamscan', 'MUSIC', 'MVDR', 'Location', 'south');
title('Sources at 0° and 8°: beamscan merges them, MUSIC resolves them (N = 100, 10 dB)');
exportgraphics(gcf, 'fig2_music_vs_beamscan.png');