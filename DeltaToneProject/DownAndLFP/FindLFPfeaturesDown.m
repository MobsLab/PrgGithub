% FindLFPfeaturesDown
% 12.10.2017 KJ
%
% Look at the features of the LFP of the PFCx during Down states
%
%
%


clear

%params
window_after = 0.1E4;

%% Load data
load ChannelsToAnalyse/PFCx_deltadeep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_deltasup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch


%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end
Down = and(Down,SWSEpoch);
Down_more = intervalSet(Start(Down), End(Down) + window_after);
down_durations = End(Down) - Start(Down);


%LFP diff
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor = find(distance==min(distance))*0.1;
LFPdiff = tsd(Range(LFPdeep), Data(LFPdeep) - Factor*Data(LFPsup));


%% func

%max
func_max = @(a) measureOnSignal(a,'maximum');
[deep.maxima, ~, ~] = functionOnEpochs(LFPdeep, Down, func_max);
[diff.maxima, ~, ~] = functionOnEpochs(LFPdiff, Down, func_max);


%% signal
std_lfp_deep = std(Data(LFPdeep));
std_lfp_diff = std(Data(LFPdiff));

%% find thresh
pdist = fitdist(down.maxima','Normal');
thresh_detect = pdist.mu - 2*pdist.sigma;
thresh_detect = 100*round(thresh_detect/100);






























