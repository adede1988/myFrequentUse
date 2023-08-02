function [allCors] = myArrayCorr(array1, array2)

    mean1 = mean(array1, 1); 
    mean2 = mean(array2, 1); 
    SS1 = sum((array1 - mean1).^2, 1);
    SS2 = sum((array2 - mean2).^2, 1); 
    SS12 = sum((array1-mean1).*(array2-mean2),1);

    allCors = SS12 ./ sqrt(SS1.*SS2);








end