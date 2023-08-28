function [p_bin] = addRedOutline(p, alpha)
hold on 
p_bin = zeros(size(p)); 
p_bin(p<alpha) = 1; %1 = cluster!
out = p_bin; 
phor = diff(p_bin);
pver = diff(p_bin'); 
phor(phor ~= 0) = 1; 
pver(pver ~= 0) = 1; 
phor = [zeros(size(phor,2),1)'; phor]; 
pver = [zeros(size(pver,2),1)'; pver]; 
p_bin = phor + pver'; 
p_bin(p_bin>1) = 1; 


for ii = 1:size(p_bin,2)
    cur = p_bin(:,ii); 
    pnt = find(cur==1);
    scatter(pnt, ii-.5, 5, 'red', 'filled', 'square')
end

end