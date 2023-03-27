function zDat = myChanZscore(data)
%data:              time X trials


%zDat:              trials X time 


nsamps = 100; 

%permute it to channels X time X trials
% data = permute(data, [2,3,1]); 
ntrials = size(data,2); 


tmp = data(:); 

dist = zeros(nsamps,1); 
for ii = 1:nsamps
    test = randsample(tmp, ntrials); 
    dist(ii) = mean(test,1); 
end

zDat = (data - mean(dist)) ./ std(dist);








end