function [trialTF] = trialTF(trialDat, frex, numfrex, stds, srate)

%trialTF is going to be the hilbert transformed complex time series of all
%trials across a range of frequencies
%Trials X Channels X time X freq  
trialTF = zeros(length(trialDat), size(trialDat{1},1), size(trialDat{1},2), numfrex); 


for snip = 1:size(trialTF,1)
        snip
        hz = linspace(0, srate, size(trialTF,3)*3 );
        snipDat = trialDat{snip};
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
            %take the mean power over trials
            trialTF(snip,:,:,fi) = 2*fDat( : , size(snipDat,2)+1:size(snipDat,2)*2 );
           
        end
        
end


































end