function [trialTF] = trialTF(trialDat, frex, numfrex, stds, srate)

%trialTF is going to be the hilbert transformed complex time series of all
%trials across a range of frequencies
%Trials X time X freq  
trialTF = zeros(size(trialDat,2), size(trialDat, 1), numfrex); 


for snip = 1:size(trialTF,1)
%         snip
        hz = linspace(0, srate, size(trialTF,2)*3 );
        snipDat = trialDat(:,snip);
        padDat = flip(snipDat);
        padDat = [padDat; snipDat; padDat]; 
        fftDat = fft(padDat, [], 1);
        
        for fi = 1:numfrex
            % create Gaussian
            s  = stds*(2*pi-1)/(4*pi); % normalized width
            x  = hz-frex(fi);                 % shifted frequencies (pre insert the mean for the gaussian)
            fx = exp(-.5*(x/s).^2);    % gaussian
            fx = fx./abs(max(fx));     % gain-normalized

            %filter 
            fDat = ifft( fftDat.*fx');
            %convert to power
            trialTF(snip,:,fi) = 2*real(fDat(length(snipDat)+1:length(snipDat)*2 )).^2;
           
        end
        
end


































end