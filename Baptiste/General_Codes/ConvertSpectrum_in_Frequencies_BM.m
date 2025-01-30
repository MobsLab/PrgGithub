
function [Spectrum_Frequency , Power] = ConvertSpectrum_in_Frequencies_BM(f , t , Data_Spectro , varargin)


for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'bin_size'
            bin_size = varargin{i+1};
        case 'frequency_band'
            frequency_band = varargin{i+1};
        case 'smooth_fact'
            smooth_fact = varargin{i+1};
    end
end

if ~exist('bin_size','var')
    bin_size=1;
end
if ~exist('frequency_band','var')
%     frequency_band=[1 15];
    frequency_band=[1 8];
%         frequency_band=[5 15];
end

F1 = min(find(f>frequency_band(1)-median(diff(f)) & f<frequency_band(1)+median(diff(f))));
F2 = min(find(f>frequency_band(2)-median(diff(f)) & f<frequency_band(2)+median(diff(f))));

if bin_size==1
    [Power , Spectrum_Peak] = max(Data_Spectro(:,F1:F2)'); % changed on 20/07/2023
%     [Power,Spectrum_Peak] = max((f(F1:F2).*Data_Spectro(:,F1:F2))');
    time=t;
else
    for i=1:ceil(max(length(t))./bin_size)-1
        [Power(i) , Spectrum_Peak(i)] = max(nanmean(Data_Spectro((i-1)*bin_size+1:i*bin_size,F1:F2))');
        time(i) = nanmean([t((i-1)*bin_size+1) t(i*bin_size)]);
    end
end
Frequencies_withNoise = f(Spectrum_Peak+F1-1);
Frequencies_withNoise(Frequencies_withNoise==f(F1))=NaN;


if exist('smooth_fact','var')
    Frequencies_withNoise = runmean_BM(Frequencies_withNoise,smooth_fact);
end

Spectrum_Frequency = tsd(time , Frequencies_withNoise');

Power(isnan(Frequencies_withNoise))=NaN;
Power = tsd(time , Power');

end



% Previous version
%
% function Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(f , t , Data_Spectro , thr)
%
% % thr: threshold in Hz for noise
%
% if ~exist('thr','var')
%     thr=1;
% end
%
% thr_ind=min(find(f>thr-0.05 & f<thr+0.05)); % threshold for noise on mean spectrum
%
% [~,Freq] = max(zscore_nan_BM(Data_Spectro(:,thr+1:end)'));
%
% Spectrum_Frequency = tsd(t , f(Freq+thr_ind)');
%
% end





