%some scratch spike sorting
load('C:\Users\dtf8829\Downloads\chanSum_mlam7 (1).mat')
%get chansum file from Sam. 
%load it in! 

ups = chanSum.waveforms(:,20)>0; 
downs = chanSum.waveforms(:,20)<0; 

wf = chanSum.waveforms; 


[a, d] = haart(wf(:,1:64)', 4); 

haarCov = cov(a); 

upClust = DBscanDynamicEpi(haarCov(ups, ups), 3, 2, 1, 1);
downClust = DBscanDynamicEpi(haarCov(downs, downs), 3, 2, 1, 1);
upIDX = find(ups); 
downIDX = find(downs); 
up_wf = wf(upIDX, :); 
down_wf = wf(downIDX,:); 
up_a = a(:,ups);
down_a = a(:,downs); 
upIDs = unique(upClust); 
downIDs = unique(downClust); 




% colors = {[0,0,1,.5], 'red', 'blue', 'black'}; 
% ci = 1;
% figure
% hold on 
for ii = 1:length(upIDs)
    if sum(upClust==upIDs(ii))>100
        figure
        hold on
        plot(wf', 'color', [0,0,0,.01])
        plot(up_wf(upClust==upIDs(ii), :)', 'color', [34/256, 139/256, 34/256, .1])
    end


end

for ii = 1:length(downIDs)
     if sum(downClust==downIDs(ii))>100
        figure('visible', false)
        hold on
        plot(wf', 'color', [0,0,0,.01])
        plot(down_wf(downClust==downIDs(ii), :)', 'color', [34/256, 139/256, 34/256, .1])
        export_fig(join([  '.jpg'],''), '-r300')
    end


end







wfDec = waveformDecomposition(chanSum.waveforms); 



peakVals = chanSum.waveforms(:,20);

troughVals = zeros(size(peakVals)); 
troughLocs = zeros(size(peakVals)); 

test = diff(diff(chanSum.waveforms(ups,:)'));
troughIDX = arrayfun(@(x) find(test(20:end,x)>0,1), [1:size(test,2)])+2;
upIDX = find(ups); 
troughVals(upIDX) = arrayfun(@(x) chanSum.waveforms(upIDX(x),troughIDX(x)), 1:length(upIDX)); 
troughLocs(upIDX) = troughIDX; 

test = diff(diff(chanSum.waveforms(downs,:)'));
troughIDX = arrayfun(@(x) find(test(20:end,x)<0,1), [1:size(test,2)])+2;
downIDX = find(downs); 
troughVals(downIDX) = arrayfun(@(x) chanSum.waveforms(downIDX(x),troughIDX(x)), 1:length(downIDX)); 
troughLocs(downIDX) = troughIDX; 


ampVals = peakVals - troughVals; 

test = [peakVals, troughVals, troughLocs];
testCov = pdist2(test(ups,:), test(ups,:));

clust = DBscanDynamicEpi(testCov, 3, 3,1,1);

clustCount = arrayfun(@(x) sum(clust==x), -1:max(clust));
clustCount(2) = []; 
clustIDs = unique(clust);

for cc = 1:length(clustIDs)
    if clustCount(cc)<100
        clust(clust==clustIDs(cc)) = -1; 
    end
end

colors = {'green', 'red', 'black', 'red'}; 

figure
hold on 
arrayfun(@(x) plot(chanSum.waveforms(upIDX(x),:), 'color', colors{clust(x)}), 1:length(upIDX) )


downCov = cov(chanSum.waveforms(downs,:)'); 

upClust = DBscanDynamicEpi(upCov, 10, 2,1,1);

downClust = DBscanDynamicEpi(downCov, 10, 2,1,1);