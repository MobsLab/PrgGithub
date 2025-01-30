%%FindExampleRealFakeSlow
% 13.09.2019 KJ
%
% Infos
%   Examples figures as in Sirota 2005, but with :
%       - good inversion with down states
%       - bad inversion without down states
%
% see
%     PlotExampleRealFakeSlow
%
%



%% load

Dir = PathForExperimentsFakeSlowWave('sup');
p=5
    
disp(' ')
disp('****************************************************************')
cd(Dir.path{p})
disp(pwd)

clearvars -except Dir p
    
%params
binsize_mua = 10;
binsize_met = 10;
nbBins_met  = 160;
factorLFP = 0.195;

%raster
load('RasterLFPDeltaWaves.mat','deltadeep', 'ch_deep', 'ch_sup', 'deltadeep_tmp') 

%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

%down
load('DownState.mat', 'down_PFCx')
 
%delta epoch
name_var = ['delta_ch_' num2str(ch_deep)];
load('DeltaWavesChannels.mat', name_var)
eval(['deltas = ' name_var ';'])
%Restrict    
DeltaDeep = and(deltas, NREM);
st_deep = Start(DeltaDeep);
center_deep = (Start(DeltaDeep) + End(DeltaDeep))/2;


%% Quantification good and fake

%delta deep>PFCsup
deltadeep_tmp = Range(deltadeep_tmp);
nb_sample = round(length(deltadeep_tmp)/8);

raster_tsd = deltadeep.sup;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
vmean1 = mean(Mat(:,x_tmp>0&x_tmp<0.2e4),2);
[~, idxMat1] = sort(vmean1);

high_deep = sort(deltadeep_tmp(idxMat1(1:nb_sample)));%good
low_deep = sort(deltadeep_tmp(idxMat1(end-nb_sample+1:end)));%fake

%down or not down
[RealDelta,~,Istat, idreal] = GetIntersectionsEpochs(DeltaDeep, down_PFCx);
FakeDelta = subset(DeltaDeep, setdiff(1:length(Start(DeltaDeep)), idreal)');

nb_delta = length(Start(DeltaDeep));
nb_real = length(Start(RealDelta));
nb_fake = length(Start(FakeDelta));
nb_high = high_deep;


%% Find good moments

verylow_deep = sort(deltadeep_tmp(idxMat1(end-500:end)));%fake
LowDeep = intervalSet(verylow_deep-800,verylow_deep+800);
GoodExamples = GetIntersectionsEpochs(FakeDelta, LowDeep);
st_exemple_fake = Start(GoodExamples);

save fake_example.mat st_exemple_fake

% %good inversion and down
% [~, intervals, ~] = InIntervals(high_deep,[Start(RealDelta)-0.05e4 End(RealDelta)]);
% intervals = unique(intervals);
% intervals(intervals==0)=[];
% GoodDelta = subset(RealDelta,intervals);
% gooddelta_tmp = Start(GoodDelta);
% 
% 
% %nor inversion neither down
% [~, intervals, ~] = InIntervals(low_deep,[Start(FakeDelta)-0.05e4 End(FakeDelta)]);
% intervals = unique(intervals);
% intervals(intervals==0)=[];
% BadDelta = subset(FakeDelta,intervals);
% BadDelta = dropShortIntervals(BadDelta,0.12e4);
% baddelta_tmp = Start(BadDelta);
% 
% 
% %find examples in same window
% maxdistance = 3e4; %2s
% 
% list_example = [];
% for i=1:length(gooddelta_tmp)
%     idx = find(abs(baddelta_tmp - gooddelta_tmp(i))<= maxdistance);
%     list_example = [list_example ; [repmat(i,length(idx),1) idx]];
% end



















