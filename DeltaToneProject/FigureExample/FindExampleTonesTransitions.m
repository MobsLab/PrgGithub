%%FindExampleTonesTransitions
% 18.09.2019 KJ
%
% Infos
%   Find good times for tones and ripples at transitions
%   
% see
%     
%


clear

%% load

Dir = PathForExperimentsRandomTonesSpikes;
p=1;

disp(' ')
disp('****************************************************************')
cd(Dir.path{p})
disp(pwd)

clearvars -except Dir p    

%params
binsize_met = 10;
nbBins_met  = 80;
range_up = [40 100]*10;
range_down = [0 100]*10;
binsize_mua = 2;

minDuration = 40;
maxDuration = 30e4;
    
%MUA & Down
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
st_down = Start(down_PFCx);
end_down = End(down_PFCx);
%Up
up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
st_up = Start(up_PFCx);
end_up = End(up_PFCx);



%substages
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

    
%tones
load('behavResources.mat', 'ToneEvent')

tonesup_tmp = Range(Restrict(Restrict(ToneEvent, NREM), up_PFCx));
tonesdown_tmp = Range(Restrict(Restrict(ToneEvent, NREM), down_PFCx));
    

%% Success to create a transition

%Up>Down
big_down = dropShortIntervals(down_PFCx,0.12e4);
intv = [tonesup_tmp+range_up(1) tonesup_tmp+range_up(2)];
[~,intervals,~] = InIntervals(Start(big_down), intv);
intervals(intervals==0)=[];
intervals = unique(intervals);
success_down = tonesup_tmp(intervals);

%Down>Up
intv = [tonesdown_tmp+range_down(1) tonesdown_tmp+range_down(2)];
[~,intervals,~] = InIntervals(Start(down_PFCx), intv);
intervals(intervals==0)=[];
intervals = unique(intervals);
success_up = tonesdown_tmp(intervals);











