function [aperiodic, periodic, raw] = IRASA(data)


%data:              chans X timePoints X trials OR 1 X timePoints X trials

%note: if data are input as a single channel, then there's no need for the
%parfor loop. 

%initialize some variables for the frequency decomposition
frex = logspace(log10(2),log10(30),50);
numfrex = length(frex); 
stds = linspace(2,4,numfrex);
fs = 1000; 
h = [1.1:.05:1.9];

if size(data,1)>1 
    %% multi channel data! 

    %get the power spectra for all resampling rates, up/down/raw, channels,
    %trials, frequencies
    allPowSpects = zeros([length(h),3, size(data,1), size(data,3), length(frex)]); 
    tic
    parfor tt = 1:size(data,3)
        curSnip = double(data(:,:,tt)); 
    
       
    
        fftN = size(curSnip,2)*3; 
        nChan = size(curSnip,1); 
        %time points X chans*resamps array of all FFTed data
        allFFTs = zeros(fftN, nChan*length(h)*2); 
        hz = linspace(0,fs, fftN);
       
        for ii = 1:length(h)
            [n,d] = rat(h(ii));
            udat = resample(curSnip', n,d);
            ddat = resample(curSnip', d,n); 
            
    %         [ut, ~] = size(udat);
    %         [dt, ~] = size(ddat);
    
    %         ufs = fs * (n/d);
    %         dfs = fs * (d/n); 
    
            udat = mirrorPad(udat);
            ddat = mirrorPad(ddat);  
            %make standard fftN and a standard set of frequencies to grab then
            %do fft on different resamplings of data and pretend that the
            %frequency values are constant anyway. 
    
            ufft = fft(udat, fftN);
            dfft = fft(ddat, fftN); 
            
            
            allFFTs(:, (ii-1)*2*nChan+1:(ii-1)*2*nChan+nChan) = fft(udat, fftN); 
            allFFTs(:, (ii-1)*2*nChan+nChan+1: ii*2*nChan) = fft(ddat, fftN); 
        end
    
        rdat = mirrorPad(curSnip');
        rfft = fft(rdat, fftN); 
    %         uhz = linspace(0,fftN, size(curSnip,2)); %linspace(0, fs, size(curSnip,2) );
    %         dhz = uhz; %linspace(0, fs, size(curSnip,2) );
            
        curPowSpect = zeros(size(squeeze(allPowSpects(:,:,:,tt,:)))); 
    
        for fi = 1:numfrex
            s  = stds(fi)*(2*pi-1)/(4*pi); % normalized width
            x  = hz-frex(fi);                 % shifted frequencies (pre insert the mean for the gaussian)
            fx = exp(-.5*(x/s).^2);    % gaussian
            fx = fx./abs(max(fx));     % gain-normalized
    %             dx  = dhz-frex(fi);                 % shifted frequencies (pre insert the mean for the gaussian)
    %             dfx = exp(-.5*(dx/s).^2);    % gaussian
    %             dfx = dfx./abs(max(dfx));     % gain-normalized
    
            %testing out grabbing under the gaussian in frequency space directly:
    %         pow = allFFTs.*fx'; 
    %         pow = pow .*sqrt(2./fftN); 
    %         pow = abs(pow).^2; 
    %         pow = sum(pow,1) ./ sum(fx); 
    
            %apply filter
            allFilt = 2*real(ifft( allFFTs.*fx'));
    %             dfilt = 2*real(ifft( dfft.*fx')); 
    
            pow = mean(allFilt(size(curSnip,2)+1:size(curSnip,2)*2,:).^2);
    
            %get the mean power over the epoch
            for ii = 1:length(h)
                curPowSpect(ii, 1, :, fi) = pow((ii-1)*2*nChan+1:(ii-1)*2*nChan+nChan);
                curPowSpect(ii, 2, :, fi) = pow((ii-1)*2*nChan+nChan+1: ii*2*nChan);
                        %do the raw only once
                if ii == length(h)
                    rfilt = 2*real(ifft( rfft.*fx')); 
                    rpow = mean(rfilt(size(curSnip,2)+1:size(curSnip,2)*2,:).^2);
                    curPowSpect(:, 3, :, fi) = repmat(rpow, [17,1]); 
                end
            end
    
    
    
    
        end
        allPowSpects(:,:,:,tt,:) = curPowSpect;  
    
    end
    toc
    
        test = squeeze(mean(allPowSpects, 4));
        meanUDsamp = zeros([length(h), size(test,3), length(frex)]);
        for hi = 1:length(h)
            meanUDsamp(hi,:,:) = mean(test(hi,[1,2],:,:), 2);
    
        end
    
        aperiodic = squeeze(median(meanUDsamp, 1)); 
        raw = squeeze(test(1,3,:,:)); 
        periodic = raw - aperiodic; 

else
    %% single channel data

       %get the power spectra for all resampling rates, up/down/raw, 
    %trials, frequencies
    allPowSpects = zeros([length(h),3, size(data,3),  length(frex)]); 
    
%     parfor tt = 1:size(data,3)
        curSnip = squeeze(data)'; %switch it to be trials X timePoints so that it's analogous in shape to a channels X timepoints matrix 
    
%         tt
    
        fftN = size(curSnip,2)*3; 
%         fftN = 2^nextpow2(fftN);
        nChan = size(curSnip,1); 
        %time points X chans*resamps array of all FFTed data
        allFFTs = zeros(fftN, nChan*length(h)*2); 
        hz = linspace(0,fs, fftN);
       
        for ii = 1:length(h)
            [n,d] = rat(h(ii));
            udat = resample(curSnip', n,d);
            ddat = resample(curSnip', d,n); 
            
    %         [ut, ~] = size(udat);
    %         [dt, ~] = size(ddat);
    
    %         ufs = fs * (n/d);
    %         dfs = fs * (d/n); 
    
            udat = mirrorPad(udat);
            ddat = mirrorPad(ddat);  
            %make standard fftN and a standard set of frequencies to grab then
            %do fft on different resamplings of data and pretend that the
            %frequency values are constant anyway. 
    
            ufft = fft(udat, fftN);
            dfft = fft(ddat, fftN); 
            
            
            allFFTs(:, (ii-1)*2*nChan+1:(ii-1)*2*nChan+nChan) = fft(udat, fftN); 
            allFFTs(:, (ii-1)*2*nChan+nChan+1: ii*2*nChan) = fft(ddat, fftN); 
        end
    
        rdat = mirrorPad(curSnip');
        rfft = fft(rdat, fftN); 
    %         uhz = linspace(0,fftN, size(curSnip,2)); %linspace(0, fs, size(curSnip,2) );
    %         dhz = uhz; %linspace(0, fs, size(curSnip,2) );
            
%         curPowSpect = zeros(size(squeeze(allPowSpects(:,:,:,tt,:)))); 
    
        for fi = 1:numfrex
%             fi
            s  = stds(fi)*(2*pi-1)/(4*pi); % normalized width
            x  = hz-frex(fi);                 % shifted frequencies (pre insert the mean for the gaussian)
            fx = exp(-.5*(x/s).^2);    % gaussian
            fx = fx./abs(max(fx));     % gain-normalized
    %             dx  = dhz-frex(fi);                 % shifted frequencies (pre insert the mean for the gaussian)
    %             dfx = exp(-.5*(dx/s).^2);    % gaussian
    %             dfx = dfx./abs(max(dfx));     % gain-normalized
    
            %testing out grabbing under the gaussian in frequency space directly:
    %         pow = allFFTs.*fx'; 
    %         pow = pow .*sqrt(2./fftN); 
    %         pow = abs(pow).^2; 
    %         pow = sum(pow,1) ./ sum(fx); 
    
            %apply filter
            allFilt = 2*real(ifft( allFFTs.*fx'));
    %             dfilt = 2*real(ifft( dfft.*fx')); 
    
            pow = mean(allFilt(size(curSnip,2)+1:size(curSnip,2)*2,:).^2);
    
            %get the mean power over the epoch
            for ii = 1:length(h)
                allPowSpects(ii, 1, :, fi) = pow((ii-1)*2*nChan+1:(ii-1)*2*nChan+nChan);
                allPowSpects(ii, 2, :, fi) = pow((ii-1)*2*nChan+nChan+1: ii*2*nChan);
                        %do the raw only once
                if ii == length(h)
                    rfilt = 2*real(ifft( rfft.*fx')); 
                    rpow = mean(rfilt(size(curSnip,2)+1:size(curSnip,2)*2,:).^2);
                    allPowSpects(:, 3, :, fi) = repmat(rpow, [17,1]); 
                end
            end
    
    
    
    
        end
       
    
%     end
  
    
        test = squeeze(mean(allPowSpects, 3)); %mean over trials
        meanUDsamp = zeros([length(h), length(frex)]);
        for hi = 1:length(h)
            meanUDsamp(hi,:) = mean(test(hi,[1,2],:), 2);
    
        end
    
        aperiodic = squeeze(median(meanUDsamp, 1)); 
        raw = squeeze(test(1,3,:))'; 
        periodic = raw - aperiodic; 










end

  
    
end


