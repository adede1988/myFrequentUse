function [z, p] = corrdiff(r1, r2, n1, n2)

% Fisher's z-transform to normalize correlation coefficients
z1 = 0.5 .* log(ones(size(r1)) + r1) ./ (ones(size(r1)) - r1);
z2 = 0.5 .* log(ones(size(r2)) + r2) ./ (ones(size(r2)) - r2);
zdiff = z1 - z2;

% Calculate sigma given the number of trials
se = sqrt((1 / (n1 - 3)) + (1 / (n2 - 3)));

% Get z-score of the differences between correlation coefficients
z = zdiff ./ se;

% Calculate p-value
p = ones(size(z)) - normcdf(abs(z));

clear r1 r2 n1 n2 z1 z2 zdiff se

end