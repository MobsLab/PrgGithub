function[ToneNREM,ToneUp,ToneDown,ToneUpDown,ToneUpUp,ToneDownUp,ToneDownDown]=FindTonesInducingTransitions
% KJ
%
%
%
% see
%  
%



intv_success_down = 1000; %100ms
intv_success_up = 500; %50ms

%% load
% tones
load('behavResources.mat', 'ToneEvent')
ToneEvent;

%load Spikes of PFCx
load('SpikeData.mat', 'S')
load('InfoNeuronsAll.mat', 'InfoNeurons')
NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);
S = S(NumNeurons);

% Substages
load('SleepSubstages.mat', 'Epoch')
N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7};
N2N3 = or(N2,N3);


%MUA & Down
binsize_mua = 2;
minDuration = 50;
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
st_down = Start(down_PFCx);
end_down = End(down_PFCx);
%Up
up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));


%% Tones
ToneNREM = Restrict(ToneEvent, NREM);
ToneDown = Restrict(ToneNREM, down_PFCx);
ToneUp   = Restrict(ToneNREM, up_PFCx);

st_up = Start(up_PFCx);
st_down = Start(down_PFCx);

% Down to Up ?
intv_post_tones = [Range(ToneDown) Range(ToneDown)+intv_success_up];
[~,intervals,~] = InIntervals(st_up, intv_post_tones);
intervals = unique(intervals); intervals(intervals==0)=[];
ToneDownUp = subset(ToneDown, intervals);
ToneDownDown = subset(ToneDown, setdiff(1:length(ToneDown), intervals));
% Up to Down ?
intv_post_tones = [Range(ToneUp) Range(ToneUp)+intv_success_down];
[~,intervals,~] = InIntervals(st_down, intv_post_tones);
intervals = unique(intervals); intervals(intervals==0)=[];
ToneUpDown = subset(ToneUp, intervals);
ToneUpUp = subset(ToneUp, setdiff(1:length(ToneUp), intervals));






