%% fig1_eigenvalues.m  -- eigenvalues of R-hat for different N
clear; close all; clc;
rng(1);

% ---- 1. setup ----
M = 10;
pos = (0:M-1)' * 0.5;
thetaDeg = [0 8];
snrDb = 10;
Nlist = [10 100 1000];          % the three snapshot counts to compare

% ---- 2. true covariance (reference) ----
A = steeringVector(thetaDeg, pos);
P = 10^(snrDb/10) * eye(2);              % 10 dB -> linear power
Rtrue = A * (10*eye(2))*A' + eye(10);       % the Day 2 formula
% eye(n) creates an identity matrix of size nxn - 1s along diagonal and 0s
% everywhere else.
% eye(10) works for the noise because we assume each noise signal has a
% power of 1. 

% Rtrue;
lambdaTrue = sort(real(eig(Rtrue)), 'descend');
% sort(matrix, type of sorting), real() - removes imaginary part,
% eig(Rtrue) - creates an eigen value matrix from the matrix passed into it
% This results in the eigen matrix of Rtrue

% lambdaTrue


% ---- 3. one column of eigenvalues per N ----
lambdaAll = zeros(M, length(Nlist));     % rows = eigenvalue #, columns = N
for i = 1:length(Nlist)
    N = Nlist(i);
    X = simulateData(thetaDeg,pos,snrDb,N);         % your simulateData
    R = X*X'/N;                                     % sample covariance
    lambda = sort(eig(R), 'descend');               % eigenvalues, sorted largest first
    % lambda  % Watching the eigen matrix get sorted
    lambdaAll(:, i) = lambda;                       % store as column i
    % lambdaAll     % seeing final sorted matrix of eigen columns
end

%---- 4. plot in dB ----
figure;
plot(1:M, 10*log10(lambdaAll(:,1)), 'ro-'); hold on;
% plot(x values, y values, line color and style) 
% hold on keeps the plots from being erased when the function is called
% again.

plot(1:M, 10*log10(lambdaAll(:,2)), 'gs-');
plot(1:M, 10*log10(lambdaAll(:,3)), 'bd-');
plot(1:M, 10*log10(lambdaTrue), 'm--');

% ---- 5. labels and save ----
grid on;
xlabel('eigenvalue number (largest first)');
ylabel('eigenvalue (dB)');
legend('N = 10', 'N = 100', 'N = 1000', 'true R');
title('Eigenvalues of the sample covariance');
% exportgraphics(gcf, 'fig1_eigenvalues.png');   % or saveas(gcf, 'fig1_eigenvalues.png')