% Scratch/learning work day 3
% 
% 
% Building conventional Beamscan method and seeing it fail on close sources
% 
% 
clc; clear all; close all;


scanDeg = -90:0.1:90;       % 1801 angles
% Grid spacing is a choice with a cost. At 0.1 deg spacing, peaks can only
% land on multiples of 0.1 deg, which is why our answers will be "rounded".
% We can use rounding as a floor in the error curves. 


G = numel(scanDeg);
P = zeros(1, G);            % preallocate: much faster than growing P
% Preallocation of a loop when you know the final size is much faster than
% trying to grow the matrix one entry in each pass. MATLAB has to copy the
% array every time and when we do Monte Carlo simulation that has to happen
% thousands of times.

% Compute anything that doesn't change inside the loop once before it. 

for g = 1:G
    P(g) = cos(scanDeg(g)*pi/180)^2;    % placeholder work
end
% section is important because it evaluates a formula for a set of angles.
% The computer can't do that if you don't give it a list of discrete
% variables to consider. We perform a computation at each position/angle
% and store it in a matrix (P). This is needed for the "spatial spectrum"
% analysis that we will do later.


figure;
plot(scanDeg, 10*log10(P/max(P)), 'LineWidth', 1.5); hold on;
% Normalizing to 0dB with 10*log10(P/max(P)). Beamscan peaks around 100
% while MUSIC can peak at 10,000 or higher. Dividing by the maximum puts
% every peak at 0 dB, so you compare shapes (width, dip depth) rather than
% raw size. This also helps keep the tall MUSIC needles from flattening
% everything else. 

% Hold on keeps all plots on same graph.

xline(8, '--');
% Marks the true angles so methods can be compared to the actual values
% they're trying to find. 

grid on; xlabel('angle (deg)'); ylabel('normalized power (dB)');
legend('beamscan'); xlim([-40 40]); ylim([-40 3]);
% limits the graphs to the interesting region - most action is between -40
% and 40 degrees.

exportgraphics(gcf, 'fig2.png');  % R2020a and newer; otherwise saveas(gcf, 'fig2.png')
% saving via code allows reruns to save automatically. 


peaks = [];
for g = 2:G-1           % skips the first and last point because they have no neighbors
    if P(g) > P(g-1) && P(g) >= P(g+1)
        peaks(end+1) = g;          % append to the list because we don't know exact # of peaks
        % growing is fine when we don't know size and we know it'll be
        % small.
    end
end
% A peak is a local maximum. A point higher than its left neighbor and at
% least as high as its right one: if line 60. >= on right side handles flat
% tops. Exactly one of a two-point plateau counts rather than both or
% none.

[~, order] = sort(P(peaks), 'descend');   % ~ throws away an output
% sort with 2 outputs gives the reordered matrix in argument 1 and the
% previous location of the index in argument 2

best = peaks(order(1));                 % indices of the two tallest
