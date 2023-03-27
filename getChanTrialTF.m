function [trialTF] = getChanTrialTF(trialDat, frex, numfrex, stds, srate)

%trialDat:            timepoints X trials data points


%trialTF is going to be the hilbert transformed complex time series of all
%trials across a range of frequencies
%time X trials X freq  
trialTF = zeros([size(trialDat), numfrex]); 



padDat = mirrorPad(trialDat);     

hz = linspace(0, srate, size(padDat,1) );
    
  
fftDat = fft(padDat);
    
    for fi = 1:numfrex
        % create Gaussian
        s  = stds(fi)*(2*pi-1)/(4*pi); % normalized width
        x  = hz-frex(fi);                 % shifted frequencies (pre insert the mean for the gaussian)
        fx = exp(-.5*(x/s).^2);    % gaussian
        fx = fx./abs(max(fx));     % gain-normalized

        %filter 
        fDat = ifft( fftDat.*fx');
        %take the mean power over trials
       
        outTF = 2*fDat(size(trialDat,1)+1:size(trialDat,1)*2, : );

        trialTF(:,:,fi) = outTF; 
       
    end
        



end