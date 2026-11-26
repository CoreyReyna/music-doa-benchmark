%%
% Notes folder 
% 
% 
% 
% 
% The idea of the MUSIC paper describes using an antenna array with
% arbitrary values for sensors and an algorithm to determine multiple
% possible characteristics of the input signals. These multiple possible 
% solutions from the algorithm are then taken in context of the
% data to only be possible in the subspace outlined by the data.
% 
% 
% Why is the first entry of every steering vector exactly 1?
% 
% There is no phase shift on the first position and the exponential is cleared with a 0 from the first position. 
% It is the reference every other element is compared to because it has 0
% extra path and 0 phase
% 
% 
% Why is the phase a straight line in m, and what does its slope tell you?
% The phase is a straight line because each position is 0.25 wavelengths or
% -90 degrees with each position following the first one. The slope tells
% us that the slope is a constant -90 degree phase shift. The slope encodes
% sin(theta) - estimating a direction means estimating that slope.
% 
% 
% What does keeping d <= Lmab/2 protect you from?
% the d = .5 steps keep 2(pi)d*sin(theta) between [-pi, pi] for every
% angle, so each angle gives a unique phase step. With larger d, two
% different angles can wrap to the same phase step. Their steering vectors
% are then identical and no algorithm can tell them apart.
% 
% 
% 
% 
% Fell off a little with the notes but heres to day 4. 
% 
% Match each symbol in the music algorithm to variables I have already
% created/coded so far
% 
% a^H = a single column of my conjugate transpose steering vector matrix A'
% E_n = eigenvector subspace of noise
% E_n = the transposed Eigenvector subspace of noise
% a = a single column of my steering vector matrix
% 
%%