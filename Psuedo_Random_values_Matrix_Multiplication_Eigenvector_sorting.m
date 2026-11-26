% MATLAB Lesson
%%
rng(1)              % setting the random seed
n = rand(1, 5)      % 5 Gaussian samples, variance 1
P = 4;
s = sqrt(P/2) * (rand(1, 1e5) + 1j*randn(1, 1e5));
mean(abs(s).^2)     
%%
clc
A = ones(3, 2); 
S = ones(2,5);
size(A * S);            % [3 5]: (3x2) times (2x5); the inner sizes must match
B = [1 2; 3 4]          
B * B                   % does standard matrix multiplication
B .* B                  % multiplies the a_ij position by the same a_ij positions as the other only
B .^ 2                  % raises each position to the second power - gives same as previous line because its multiplying by itself
%%
% Eigenvalues as a matrix are a way to scale a vector or arrow without
% knocking it off its direction. 
% 
clear all; clc; close all;


R = [2 1; 1 2];
[V, D] = eig(R)         % R*V = V*D
lambda = diag(D)        % eigenvalues as a column 
%%
[lambda, idx] = sort(lambda, 'descend')         % sort returns the sorted column and an optional original position matrix in argument 2
%%
% The original vector matrix is then reordered to match the newly reordered
% diagonal matrix using the 2nd optional sorted position return of the sort
% function. By using (:, idx) you take all the rows in each column idx and
% put them in the order same as the eigenvalue diagonal matrix
% 

V
V = V(:, idx)          % reorder the columns the SAME way
