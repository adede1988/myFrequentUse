function [peakToUse] = peakDetector(values)    
    diffVals = diff(values); 
    test = smoothdata(diffVals, 1, 'gaussian', 7);
    test2 = diff(test); 
    [~, peakToUse] = min(test2); 
   
end
