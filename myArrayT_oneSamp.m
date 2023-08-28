function [tVals] = myArrayT_oneSamp(dat, comparison)
    dat = dat - comparison; 
    meanVal = mean(dat,1); 
    datVar = sum(bsxfun(@minus, dat, meanVal).^2, 1) ./ size(dat,1); 

    tVals = squeeze(meanVal ./ (sqrt(datVar) ./ sqrt(size(dat,1))));














end