function outMat = multiDmirror(inMat)
    %mirror matrix around diagonal in all sub-square matrices in first two
    %dimensions


    dimVals = size(inMat); 
    outMat = zeros(size(inMat)); 


    if length(dimVals)==2
      
        outMat = inMat + inMat'; 

    else

        for ii = 1:dimVals(end)
         
            idx = cell(length(dimVals)-1, 1);
            for di = 1:length(idx)
                idx{di} = ':'; 
            end
            idx{di+1} = ii; 
            outMat(idx{:}) = multiDmirror(squeeze(inMat(idx{:})));
        end

    end













end