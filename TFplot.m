function [] = TFplot(varargin)
%function for plotting time-frequency of a signal
%TFdat:                frequency X time complex valued analytic signals at 
%                      different frequencies
%frex (optional):      1 X frequency vector of frequency values in Hz,
%                      corresponds to frequency dimension of Tfdat. Default
%                      values: logspace(log10(2), log10(80), 100)
%time (optional):      1 X time vector of time values in sample rate
%                      increments. Corresponds to the time dimension of
%                      TFdat. Devault values: [1:size(TFdat,2)]


switch nargin
    case 1
        TFdat = varargin{1};
        frex = logspace(log10(2),log10(80),size(TFdat,1));
        time = [1:size(TFdat,2)];
    case 2
        TFdat = varargin{1}; 
        frex = varargin{2}; 
        time = [1:size(TFdat,2)]; 
    case 3
        TFdat = varargin{1}; 
        frex = varargin{2}; 
        time = varargin{3}; 
end



figure
subplot 211
imagesc(abs(TFdat).^2)
set(gca, 'YDir','normal')
colorbar
yticks([10:10:100])
yticklabels(round(frex([10:10:100])))
xticks([1:round(size(TFdat,2)/6):size(TFdat,2)])
xticklabels(round(time([1:round(size(TFdat,2)/6):size(TFdat,2)]))); 
if length(find(time==0))==1
    xline(find(time==0), 'color', 'red', 'linestyle', '--', 'linewidth', 3)
end

subplot 212
imagesc(angle(TFdat))
set(gca, 'YDir','normal')
colorbar
yticks([10:10:100])
yticklabels(round(frex([10:10:100])))
xticks([1:round(size(TFdat,2)/6):size(TFdat,2)])
xticklabels(round(time([1:round(size(TFdat,2)/6):size(TFdat,2)]))); 
if length(find(time==0))==1
    xline(find(time==0), 'color', 'red', 'linestyle', '--', 'linewidth', 3)
end

end