%%
% creating the simulate data function 
% 
%%

function X = simulateData(thetaDeg, pos, snrDb, N);

% angles of sources, number of sensors, signal to noise ratio in Db, number
% of snapshots of the data


% 1. sizes: M from pos, K from thetaDeg
K = length(thetaDeg);   % number of sources
M = length(pos);        % number of sensors

% 2. if one SNR was given, copy it for every source
if length(snrDb) == 1
    snrDb = snrDb * ones(K,M);
end

% 3. A = steering matrix for these angles
A = steeringVector(thetaDeg, pos);

% 4. preallocate S (K x N); loop over sources:
S = zeros(K,N);


for k = 1:K

    % power from dB -> fill row k with a random signal of that power
    P = 10^(snrDb(k)/10);

    signal = sqrt(P/2) * (randn(1,N) + 1*j*randn(1,N));
    % generate the random signal with appropriate power

    S(k,:) = signal;
end

% 5. noise (M x N), power 1, in one line
noise = sqrt(1/2) * (randn(M,N) + 1*j*randn(M,N));

% 6. X = A*S + noise
X = A*S + noise;
% note: the steering vector matrix is MxK and the signal matrix is KxN
% allowing the multiplication to happen. The result is an MxN matrix where
% each snapshot is a combination of all the signals and noise into one.
% This is essentially what the sensor would see as real data all scrambled
% together.

% This makes sense as A*S is essentially multiplying the rows of
% A (all unique phasors in order one sensor at a time) by the
% columns of S (all unique data in order for each source one snapshot at a time)
% and then adding those products together - creating the combined snapshots. 



% fprintf('noise power %.3f, source power %.3g\n', mean(abs(noise(:)).^2), mean(abs(S(:)).^2));

end




