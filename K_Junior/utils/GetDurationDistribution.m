%%GetDurationDistribution
% 12.03.2018 KJ
%
% Return the distribution of interval duration (down, delta...) 
%
% distribution_dur = CompareDecreaseDensity(interval, duration_bins)
%
%   see 
%       
%


function distribution_dur = GetDurationDistribution(interval, duration_bins)

    durations_intv = (End(interval) - Start(interval)) / 10; %ms
    
    %distributions
    distribution_dur = zeros(1, length(duration_bins));
    for j=1:length(duration_bins)
        binvalue = duration_bins(j);
        distribution_dur(j) = sum(durations_intv==binvalue);
    end
    
end