function [trialTF] = getTrialTF(trialDat, frex, numfrex, stds, srate)

%trialTF is going to be the hilbert transformed complex time series of all
%trials across a range of frequencies
%Trials X Channels X time X freq  
trialTF = zeros(length(trialDat), size(trialDat{1},1), size(trialDat{1},2), numfrex); 
trialN = size(trialTF,3); 

for snip = 1:size(trialTF,1)
        snip
        snipDat = trialDat{snip};
        hz = linspace(0, srate, size(snipDat,2)*3 );
        
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
           
            outTF = 2*fDat( : , size(snipDat,2)+1:size(snipDat,2)*2 );
            if size(outTF,2) ~= trialN
                outTF = [outTF, repmat(outTF(:,size(outTF,2)), [1, trialN-size(outTF,2)] )];
            end
            
            trialTF(snip,:,:,fi) = outTF; 
           
        end
        
end


end