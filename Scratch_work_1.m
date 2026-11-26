% Scratch work to prepare for simulate Data function

clc; clear all; close all;


% S = zeros(3,5);
% 
% for k = 1:5
%     S(:,k) = k * ones(3,1);
% end
% 
% S

% k = length(d);
K = 2;
M = 5;
S = zeros(K,M);
snrDb = [10 0];
N = 100000;


for k = 1:K
    P = 10^(snrDb(k)/10);       % Power is converted from dB scale  
    
    Signal = sqrt(P/2) * (randn(1,5) + 1j*randn(1,5));        
    % generating a signal/matrix of random numbers and applying an
    % amplitude to it via scale factor. The amplitude is determined by the
    % power I want the signal to have P = A^2. I divide the power by 2
    % because the power is split between the real and imaginary parts.
    
    
    S(k,:) = Signal .* ones(1,5);
    % Storeing the randomly generated signals separately in rows

    mean(abs(S(k,:)).^2)
    % confirming rows have expected power based on ampliude scal factor.
    % The averages could be somewhat off due to there only being 5 numbers
    % to average in this case.
end

