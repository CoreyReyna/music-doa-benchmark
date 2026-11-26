%  Pick Peaks function 

function est = pickPeaks(P, scanDeg, K)
% this function takes in the power spectrum created by beamscan, the range
% of angles in degrees, and the number of sources K. The output is a 1xK
% vector of estimated angles in degrees, sorted smallest to largest.


G = numel(scanDeg);
peaks = [];

for g = 2:G-1       
% the last and first index don't have an index on either side to compare
% to so we don't include them

    if P(g) > P(g-1) && P(g) >= P(g+1)
% This checks if the current index is larger than the one to its left and
% is at least as large or larger than the index on its right. If so, it adds that
% specific index value to the peak list. We can use the list of indices of
% peaks to pull them out of the list with their angles. The && operator
% logic ensures that exactly one point of a flat-topped peak is counted so
% it's neither missed nor double-counted.

        peaks(end+1) = g;
    end
end

numFound = length(peaks);

[~, order] = sort(P(peaks), 'descend');

peaks = peaks(order);

numUse = min(K, numFound);          % how many we can actually use
% Determines which number is smaller to use to fill the estimate vector.
% numUse = min(K, numFound) means that when you found more peaks than K,
% the first loop takes only the K tallest and ignores the rest; when you
% found fewer, it takes all of them and the fill loop covers the gap. 

est = zeros(1, K);                  % always return exactly K answers
for i = 1:numUse
    est(i) = scanDeg(peaks(i));     % angle of the i-th tallest peak
end


% Fill any missing slots with the tallest peak's angle
for i = numUse+1:K
    est(i) = est(1);
end

if numFound == 0
    [~, gMax] = max(P);            % fall back to the highest point overall
    est(:) = scanDeg(gMax);
end

est = sort(est);                   % smallest angle first aka left to right

end