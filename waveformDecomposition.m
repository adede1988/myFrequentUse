function [wfDec] = waveformDecomposition(wf)

    L = size(wf,2);

    [a, d] = haart(wf(:,1:64)', 4); 

    haarCov = cov(a); 

    test = DBscanDynamicEpi(haarCov, 3, 2, 1, 1);



    haarBaseSet = zeros(2^round((L/5))); 




    wavelet = zeros(16,1); 
    wavelet(7:8) = -1; 
    wavelet(9:10) = 1; 
    

    a = [-10:10]; 
    b = [-10:10]; 

    %a dim X b dim X time X wf
    wfDec = zeros(length(a), length(b), L, size(wf,1));
    figure
    hold on 
    for aa = 1:length(a)
        for bb = 1:length(b)
            curW = zeros(size(wavelet)); 
            for tt = 1:length(wavelet)
                curW(tt) = sqrt(abs(a(aa))) * wavelet(a(aa)^2 * tt - b(bb));
            end
            plot(curW)
        end
    end
            curW = sqrt(abs(a(aa) .* wavelet













end