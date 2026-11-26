% Music Spectrum function 
% 
% 
% 
% 


function [P, eig_noise_subspace] = musicSpectrum(R, K, scanDeg, pos)
% The music spectrum function takes in the covariance matrix R, Number of
% sources K, the range of angles to be tested scanDeg, and the sensors at
% their wavelength distances. 

% The function returns a 1xG psuedospectrum 



R = (R + R') / 2;
% Ensure the covariance matrix is Hermitian before eigendecomposition.

[eig_vectors, eig_values_mat] = eig(R);   
% eig returns the eigenvector matrix in output 1 and the eigenvalue
% diagonal matrix in output 2.

eig_values_col = real(diag(eig_values_mat));       
% Converts the diagonal matrix of eigenvalues into a column. Real ensures
% they are not complex - True covariance formula can return complex values
% because it can be off by 1e-16.

[eig_values_col, sort_order] = sort(eig_values_col, 'descend');
% sort with two outputs returns the sorted column in eig_values_col and the
% previous order in sort_order

eig_vectors_sorted = eig_vectors(:, sort_order);
% reorder the eigenvectors to match the sorted eigenvalues: the
% K highest-power directions (signal subspace) first, then the noise-only directions. 

eig_sig_subspace = eig_vectors_sorted(:, 1:K);        
% first K columns: signal subspace, M x K

eig_noise_subspace = eig_vectors_sorted(:, K+1:end);    
% remaining columns: noise subspace, M x (M-K)

projector_Noise = eig_noise_subspace * eig_noise_subspace';         
% M x M "projector" onto the noise subspace

norm(eig_sig_subspace' * eig_noise_subspace);         
% about 1e-16: the two subspaces are orthogonal

num_angles = numel(scanDeg);     % find my number of indexes or angles
P = zeros(1,num_angles);         % preallocate the P vector

Ascan = steeringVector(scanDeg,pos);    
% steering vectors for every scan angle (M × G), built once before the loop

for g = 1:num_angles

    a = Ascan(:,g);
   

    denom = real(a' * projector_Noise * a);
    
    if denom < 1e-12
        denom = 1e-12;
    end
    % On a true covariance value the denominator can be 0. We can keep the
    % function from failing by fixing the return value in the case of a 0. 

    P(g) = 1/denom;

    
    % perform the operation and put the result in the MUSIC vector
end


end


