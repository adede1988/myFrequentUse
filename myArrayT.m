function tVals = myArrayT(X, Y, optVal)

Xn = size(X,1); 
Yn = size(Y,1); 

if optVal == 2 %shuffling!!!!!..........................................
    %shuffle the data if option 2
    allIdx = [1:Xn, 1+100000:Yn+100000]; %set of X and Y specific index values
    %get a random sample indexing into allIdx agnostic of X and Y OG
    %membership
    X1 = randsample(1:length(allIdx), Xn, false); 
    Y1 = [1:length(allIdx)]; 
    Y1(X1) = []; 
    %get the OG membership information back
    X2 = allIdx(X1); 
    Y2 = allIdx(Y1);
    %put the originals aside for a second    
    tmpX = X; 
    tmpY = Y; 
    
    %get Xs drawn from X
    idx = {X2(X2<100000), ':'};
    dimL = length(size(tmpX));
    if dimL>2
        for ii = 3:dimL
            idx{ii} = ':'; 
        end
    end
    X(1:sum(X2<100000),:,:,:,:) = tmpX(idx{:}); 
    %get Xs drawn from Y
    idx{1} = X2(X2>100000) - 100000;
    X(sum(X2<100000)+1:Xn, :, :) = tmpY(idx{:});
    %get Ys drawn from X
    idx{1} = Y2(Y2<100000);
    Y(1:sum(Y2<100000),:,:) = tmpX(idx{:}); 
    %get Ys drawn from Y
    idx{1} = Y2(Y2>100000) - 100000;
    Y(sum(Y2<100000)+1:Yn, :, :) = tmpY(idx{:});

end






Xmean = sum(X, 1) ./ Xn; 
Ymean = sum(Y, 1) ./ Yn; 

Xvar = sum(bsxfun(@minus, X, Xmean).^2, 1) ./ Xn; 
Yvar = sum(bsxfun(@minus, Y, Ymean).^2, 1) ./ Yn; 


tVals = squeeze((Xmean - Ymean) ./ sqrt(Xvar/Xn + Yvar/Yn)); 



% tic
% Xvar = squeeze(var(X, [], 1));
% Yvar = squeeze(var(Y, [], 1)); 
% toc

% ii = 1; 



end