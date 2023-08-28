function Fvals = myArrayAnova(allDat, var1Sort, var2Sort, optVal)


if optVal == 2
    var1Sort = randsample(var1Sort, length(var1Sort), false); 
    var2Sort = randsample(var2Sort, length(var2Sort), false); 
end




if size(var1Sort,1) ~= size(var2Sort,1)
    var1Sort = var1Sort'; 
end

    dimL = length(size(allDat));  
    idx = cell(dimL, 1);
    for di = 1:length(idx)
        idx{di} = ':'; 
    end
   
%grand mean
Gmean = mean(allDat, 1); 


%var 1 mean and SS
var1IDs = unique(var1Sort); 
var1Means = zeros([length(var1IDs),size(allDat,(dimL-(dimL-2)):dimL)]); 

for ii = 1:length(var1IDs)
    idx{1} = var1Sort==var1IDs(ii); 
    outIdx = {ii, idx{2:end}};
    var1Means(outIdx{:}) = mean(allDat(idx{:}), 1);
end

var1SS = zeros(size(var1Means)); 
for ii = 1:length(var1IDs)
    idx{1} = var1Sort==var1IDs(ii); 
    outIdx = {ii, idx{2:end}};
    n = sum(var1Sort==var1IDs(ii));
    var1SS(outIdx{:}) = n * ((var1Means(outIdx{:}) - Gmean).^2); 
end
var1SS = squeeze(sum(var1SS)); 

%var 2 mean and SS
var2IDs = unique(var1Sort); 
var2Means = zeros([length(var2IDs),size(allDat,[(dimL-(dimL-2)):dimL])]); 

for ii = 1:length(var2IDs)
    idx{1} = var2Sort==var2IDs(ii); 
    outIdx = {ii, idx{2:end}};
    var2Means(outIdx{:}) = mean(allDat(idx{:}), 1);
end

var2SS = zeros(size(var2Means)); 
for ii = 1:length(var2IDs)
    idx{1} = var2Sort==var2IDs(ii); 
    outIdx = {ii, idx{2:end}};
    n = sum(var2Sort==var2IDs(ii));
    var2SS(outIdx{:}) = n* ((var2Means(outIdx{:}) - Gmean).^2); 
end
var2SS = squeeze(sum(var2SS)); 

%SS within 
SS_w = zeros([length(var1IDs)*length(var2IDs),size(allDat,(dimL-(dimL-2)):dimL)]);
wi = 1;
for ii = 1:length(var1IDs) %loop on variable 1 ID
    for jj = 1:length(var2IDs) %loop on variable 2 ID
        if sum(var1Sort==var1IDs(ii) & var2Sort == var2IDs(jj)) >1
        idx{1} = var1Sort==var1IDs(ii) & var2Sort == var2IDs(jj);
        outIdx = {wi, idx{2:end}}; 
        SS_w(outIdx{:}) = sum(bsxfun(@minus, allDat(idx{:}), mean(allDat(idx{:}))).^2) ; 
        end
        wi = wi + 1; 
    end
end
SS_w = squeeze(sum(SS_w)); 

%SS total
SStotal = squeeze(sum((allDat - Gmean).^2, 1));
%SS interaction
SSint = SStotal - var1SS - var2SS - SS_w; 

df1 = length(var1IDs)-1; 
df2 = length(var2IDs)-1; 
dfint = df1 * df2; 
dfw = size(allDat,1) - (length(var1IDs)*length(var2IDs)); 
dfT = size(allDat,1) - 1; 


MSwithin = SS_w ./ dfw;  
MS1 = var1SS ./ df1; 
MS2 = var2SS ./ df2; 
MSi = SSint ./ dfint; 

%var 1 main effect, var 2 main effect, interaction

Fvals = zeros([3, size(SSint)]); 

%var 1 main effect
outIdx{1} = 1; 
Fvals(outIdx{:}) = MS1 ./ MSwithin;
%var 2 main effect
outIdx{1} = 2; 
Fvals(outIdx{:}) = MS2 ./ MSwithin; 
%interaction
outIdx{1} = 3; 
Fvals(outIdx{:}) = MSi ./ MSwithin; 






end