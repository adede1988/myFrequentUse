function [ispc] = getChanISPC(trialDat, trialDat2, frex, numfrex, stds, srate, di, trials)

%trialDat:            timepoints X trials data points
%trialDat2:            timepoints X trials data points



    %down sample indices to shrink the data
%     di = [1:20:size(trialDat,1)];

    %ispc stats are: ispc raw, ppc raw, ispc z-scored, ppc z-scored
    ispc = zeros([length(di), numfrex, 4]); 

    padDat = mirrorPad(trialDat(:,trials)); 
    padDat2 = mirrorPad(trialDat2(:,trials)); 

   
    bootSamps = 1000; 
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


        %samples X time X stats (ISPC, PPC)
        bootDist = zeros(bootSamps, length(di), 2); 

        for bb = 1:bootSamps
            
            offSet = randsample(2:size(fDat,1), 1);
            temp = zeros(size(fDat)); 
            temp(offSet+1:end,:) = fDat(1:size(fDat,1)-offSet,:);
            temp(1:offSet,:) = fDat(size(fDat,1)-offSet+1:end,:); 
            
            bootDist(bb,:,1) = arrayfun(@(x) abs(sum(exp(1i * (temp(x,:) - fDat2(x,:))))./size(temp,2)) , 1:size(temp,1) );

            difs = temp - fDat2; 
            N = size(difs,2); 
            bootDist(bb,:,2) = mean(...
                cell2mat(arrayfun(@(j) ...
                    cell2mat(arrayfun(@(k) ...
                        cos(difs(:,j)).*cos(difs(:,k)) + sin(difs(:,j)).*sin(difs(:,k)), ...
                    j+1:N, 'uniformoutput', false)), ...
                1:N-1, 'uniformoutput', false)),...
            2);


        end

        %get ispc
        ispc(:,fi,1) = arrayfun(@(x) abs(sum(exp(1i * (fDat(x,:) - fDat2(x,:))))./size(fDat,2)) , 1:size(fDat,1) );
        ispcMean = mean(bootDist(:,:,1), [1,2]);  
        ispcSD = std(bootDist(:,:,1), [],[1,2]); 
        ispc(:,fi,3) = (ispc(:,fi,1) - ispcMean) / ispcSD; 



        %implementing pairwise phase consistency from Vink et al., 2010 
        difs = fDat - fDat2; 
        %equation 14
        ispc(:,fi,2) = mean(...
                    cell2mat(arrayfun(@(j) ...
                        cell2mat(arrayfun(@(k) ...
                            cos(difs(:,j)).*cos(difs(:,k)) + sin(difs(:,j)).*sin(difs(:,k)), ...
                        j+1:N, 'uniformoutput', false)), ...
                    1:N-1, 'uniformoutput', false)),...
                2);

        ppcMean = mean(bootDist(:,:,2), [1,2]);  
        ppcSD = std(bootDist(:,:,2), [],[1,2]); 
        ispc(:,fi,4) = (ispc(:,fi,2) - ppcMean) / ppcSD; 
       


    end










end




















