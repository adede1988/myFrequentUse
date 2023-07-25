function [tVal] = myT(X, Y, option)


if option==1 
    [~, ~, ~, stats] = ttest2(X, Y); 
    tVal = stats.tstat; 
else
    allVals = [X;Y]; 
    allVals = randsample(allVals, length(allVals), false);
    [~,~,~,stats2] = ttest2(allVals(1:length(X)), allVals(length(X)+1:end));
    tVal = stats2.tstat; 
end

end