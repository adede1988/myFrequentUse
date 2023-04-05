function [ispc] = getChanISPC(trialDat, trialDat2, frex, numfrex, stds, srate, di, trials)

%trialDat:            timepoints X trials data points
%trialDat2:            timepoints X trials data points



    %down sample indices to shrink the data
%     di = [1:20:size(trialDat,1)];

    ispc = zeros([length(di), numfrex, 2]); 

    padDat = mirrorPad(trialDat(:,trials)); 
    padDat2 = mirrorPad(trialDat2(:,trials)); 

   

    hz = linspace(0, srate, size(padDat,1) );

    fftDat = fft(padDat); 
    fftDat2 = fft(padDat2); 

   
    for fi = 1:numfrex
        
        % create Gaussian
        s  = stds(fi)*(2*pi-1)/(4*pi); % normalized width
        x  = hz-frex(fi);                 % shifted frequencies (pre insert the mean for the gaussian)
        fx = exp(-.5*(x/s).^2);    % gaussian
        fx = fx./abs(max(fx));     % gain-normalized

        %filter and convert to phase angle
        fDat =  angle(ifft(fftDat.*fx')); 
        fDat2 = angle(ifft(fftDat2.*fx'));

        %trim off the mirror pads
        fDat = fDat(size(trialDat,1)+1:size(trialDat,1)*2, :); 
        fDat2 = fDat2(size(trialDat,1)+1:size(trialDat,1)*2, :); 
    
        %downsample for speed and compactness 
        fDat = fDat(di,:); 
        fDat2 = fDat2(di,:); 

        %get ispc
        ispc(:,fi,1) = arrayfun(@(x) abs(sum(exp(1i * (fDat(x,:) - fDat2(x,:))))./size(fDat,2)) , 1:size(fDat,1) );
        
        %implementing pairwise phase consistency from Vink et al., 2010 

        %equation 15: but taking the looping parameters from equation 14
        difVals = cell2mat(arrayfun(@(j) ...
                    cell2mat(arrayfun(@(k) ...
                        cos(fDat(:,j)).*cos(fDat2(:,k)) + sin(fDat(:,j)).*sin(fDat2(:,k)), j+1:size(fDat,2), ...
                    'uniformoutput', false)),...
                  1:size(fDat,2)-1, 'uniformoutput', false));

        %equation 14 using equation 15 as input: 
        ispc(:,fi,2) = arrayfun(@(tt) (2/(size(fDat,2)*(size(fDat,2)-1))) * sum(difVals(tt,:)), 1:size(difVals,1) ); 
       


    end










end




















