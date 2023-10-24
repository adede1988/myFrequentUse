function [ppc] = getChanPPC_time(trialDat, trialDat2, frex, numfrex, stds, srate, di, trials)

%trialDat:            timepoints X trials data points
%trialDat2:            timepoints X trials data points


    %output is time X frequencies X trials
    %ispc stats are: ispc raw, ppc raw, ispc z-scored, ppc z-scored
    ppc = zeros([length(di), numfrex, sum(trials)]); 

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
%         fDat = fDat(di,:); 
%         fDat2 = fDat2(di,:); 



        %implementing pairwise phase consistency from Vink et al., 2010 
        difs = fDat - fDat2; 
    
        %need to think about how to do this for a sliding window
     

        for timi = 1:length(di)
         
            if di(timi)<500
                win = [1,di(timi)+500]; 
            elseif di(timi)>max(di)-500
                win = [di(timi)-500, max(di)];
            else
                win = [di(timi)-500, di(timi)+500]; 
            end

            tmp = difs(win(1):win(2), :); 
            L = size(tmp,1); 
            ppc(timi, fi, :) = mean(...
                cell2mat(arrayfun(@(j) ...
                    reshape(...
                    cell2mat(arrayfun(@(k) ...
                        cos(tmp(j,:)).*cos(tmp(k,:)) + sin(tmp(j,:)).*sin(tmp(k,:)), ...
                    j+1:L, 'uniformoutput', false)),...
                    size(tmp,2), []), ...
                1:L-1, 'uniformoutput', false)),...
            2);

            
          

        end



        

    
       


    end










end




















