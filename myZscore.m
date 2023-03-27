function zDat = myZscore(data)
%data:              trials X channels X time


%zDat:              trials X channels X time 


nsamps = 100; 

%permute it to channels X time X trials
data = permute(data, [2,3,1]); 
ntrials = size(data,3); 
nchan = size(data,1); 


tmp = reshape(data, [size(data,1), prod(size(data,[2,3])) ] );

dist = zeros(nchan, nsamps); 
for ii = 1:nsamps
    test = cell2mat(arrayfun(@(x) randsample(tmp(x,:), ntrials), [1:nchan], 'uniformoutput', false)); 
    test = reshape(test, [ntrials, nchan]); 
    dist(:,ii) = mean(test,1); 
end

zDat = (data - mean(dist,2)) ./ std(dist,[],2);








end