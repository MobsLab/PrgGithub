%FindDeltaBurst2
% 15.11.2017 KJ
% 
% Find burst of delta waves
%
%%INPUTS
%  tDeltas
%  threshold_burst          
%  correction
%
%%OUTPUT
%   BurstDeltaEpoch
% 
% 
% 
%
% see FindNREMFeatures FindDeltaBurst
%


function [BurstDeltaEpoch, burst_data]=FindDeltaBurst2(tDeltas,threshold_burst,correction)


%% Inititation
if ~ exist('correction','var')
    correction = 1;
end
if ~ exist('threshold_burst','var')
    threshold_burst = 0.6;
end
threshold_burst = threshold_burst*1E4; %in ts
threshold_merge = threshold_burst + 0.3e4; % add 300ms for the merge condition
interval_extension = 0.2e4; %burst intervalSet are not just at the beggining-end of delta waves
if ~ exist('nb_delta_min','var')
    nb_delta_min = 3;
end


%% Find burst
%times of delta and ISI
rg = Range(tDeltas);
ISI = diff(rg);
%burst times
idburst = find(ISI<threshold_burst);
start_burst = rg(idburst);
end_burst = rg(idburst+1);

%Burst Epoch (merge close burst)
warning off
BurstDeltaEpoch = intervalSet(start_burst-interval_extension, end_burst+interval_extension);
BurstDeltaEpoch = mergeCloseIntervals(BurstDeltaEpoch, threshold_merge);
warning on


%% burst info: number of deltas and duration
burst_data(:,2) = (End(BurstDeltaEpoch)-Start(BurstDeltaEpoch)) / 1e4;
b=1;
for k=1:length(Start(BurstDeltaEpoch))  
    burst_data(k,1) = length(Range(Restrict(tDeltas,subset(BurstDeltaEpoch,k))));
end
    

%% correction - just keep
if correction
    % 29-08-2019 there was a mistake here - line should not be indexed on k
    % old line : BurstDeltaEpoch=subset(BurstDeltaEpoch, find(burst_data(k,1)>=nb_delta_min));
    BurstDeltaEpoch=subset(BurstDeltaEpoch, find(burst_data(:,1)>=nb_delta_min));
    
end

end
