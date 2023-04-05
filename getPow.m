function [allPow] = getPow(dat, frex, numfrex, stds, srate)

%input: 
%       chanDat     a struct with the fields data and srate 
%                   data is a channels X time X epochs array
%                   srate is a scalar (e.g. 500 or 1000)
%       frex        vector of frequency values to calculate power for
%       numfrex     length of the frex vector
%       stds        vector of standard deviations indicating the widths of
%                   the gaussians used in the filter design for narrowband
%                   filtering of data

%output: 
%       allPow      1 X numfrex X epochs power values

%this function performs wavelet convolution by multiplying data in the
%frequency domain with a gaussian. This is done independently for each frequency in frex
%and each epoch in the third dimension of data. The convolution yields
%narrowband filtered data, which is then converted into a power time
%series, and the mean is taken to yield an estimate of the epoch power for
%each frequency. 

%written by Adam Dede (adam.osman.dede@gmail.com)
%fall 2022

    allPow = zeros(size(dat,1), numfrex, size(dat,3)); 
     
    parfor snip = 1:size(dat,3)
        
        hz = linspace(0, srate, size(dat,2)*3 );
        snipDat = dat(:,:,snip);
        padDat = flip(snipDat,2);
        padDat = [padDat, snipDat, padDat]; 
        fftDat = fft(padDat', [], 1);
        
        for fi = 1:numfrex
            % create Gaussian
            s  = stds(fi)*(2*pi-1)/(4*pi); % normalized width
            x  = hz-frex(fi);                 % shifted frequencies (pre insert the mean for the gaussian)
            fx = exp(-.5*(x/s).^2);    % gaussian
            fx = fx./abs(max(fx));     % gain-normalized

            %filter 
            fDat = ifft( fftDat.*fx')';
            %take the mean power over time
            allPow(:,fi,snip) = squeeze(mean( abs(2*fDat( : , size(dat,2)+1:size(dat,2)*2 ).^2),2 ) );
           
        end
        
    end



end



