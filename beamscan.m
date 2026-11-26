% beamscan funciton 


function P = beamscan(R, scanDeg, pos)
% The inputs are the covariance matrix, the scan angles in degrees, 
% and the element positions in wavelengths. The output is a 1xG power 
% spectrum. 


    G = numel(scanDeg);     % find my number of indexes or angles
    P = zeros(1,G);         % preallocate the P vector

    Ascan = steeringVector(scanDeg,pos);    % required for the phase shifts

    for g = 1:G
        
        a = Ascan(:,g);

        P(g) = real(a'*R*a)/real(a'*a);   
        % perform the operation and put the result in the beamscan matrix
    end

end

% note: The beam scan function has a fixed shape where the first null sits
% where sin (theta) = 1/(Md), which is 11.5 degrees form the peak for
% M = 10, d = 0.5. Sources closer than roughly that distance blur into one
% lump (the Rayleigh limit).