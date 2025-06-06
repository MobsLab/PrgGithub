
%% Preprocessing of data

GUI_StepOne_ExperimentInfo

% spectrograms
clear channel
load('ChannelsToAnalyse/Bulb_deep.mat')
LowSpectrumSB([cd filesep],channel,'B')
MiddleSpectrum_BM([cd filesep],channel,'B')
HighSpectrum([cd filesep],channel,'B');

clear channel
% load('ChannelsToAnalyse/dHPC_rip.mat')
% LowSpectrumSB([cd filesep],channel,'H_rip')
% load('ChannelsToAnalyse/dHPC_rip.mat')
LowSpectrumSB([cd filesep],channel,'H')
load('ChannelsToAnalyse/dHPC_deep.mat')
% LowSpectrumSB([cd filesep],channel,'H_deep')

clear channel
load('ChannelsToAnalyse/PFCx_deep.mat')
LowSpectrumSB([cd filesep],channel,'PFCx')

clear channel
load('ChannelsToAnalyse/dHPC_rip.mat')
VeryHighSpectrum([cd filesep],channel,'H')

% channels_HPC = GetDifferentLocationStructure('dHPC');
% channels_Bulb = GetDifferentLocationStructure('Bulb');
% AllChans = [channels_HPC(:);channels_Bulb(:)];
% for ch = 1:length(AllChans)
%     disp(['Spectro ' num2str(AllChans(ch))])
%     LoadSpectrumML(AllChans(ch),[cd filesep],'low');
% end

% Noise
load('ChannelsToAnalyse/Bulb_deep.mat')
FindNoiseEpoch_BM([cd filesep],channel,0);

% Heart rate
MakeHeartRateForSession_BM

% defining epochs and variables
load('behavResources.mat')
load('StateEpochSB.mat')
smoofact_Acc = 30;
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
thresh = GetGaussianThresh_BM(Data(NewMovAcctsd)); close
th_immob=0.005;
thtps_immob=3;
th_immob_Acc = 10^(thresh);
TotEpoch=intervalSet(0,max(Range(NewMovAcctsd)))-TotalNoiseEpoch;
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.5*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
FreezeAccEpoch=and(FreezeAccEpoch , TotEpoch);
MovingEpoch=TotEpoch-FreezeAccEpoch;

Behav.FreezeAccEpoch = FreezeAccEpoch;
Behav.MovingEpoch = MovingEpoch;
Params.Accelero_thresh = thresh;

save('behavResources_SB.mat','Behav','Params')

% Ripples
CreateRipplesSleep

% InstFreq
MakeInstFreqForSession_BM


% add smooth gamma calculation
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
FilGamma = FilterLFP(LFP,[50 70],1024); 
tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); 
smootime=3;
smooth_ghi = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
    ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));

save('StateEpochSB.mat','smooth_ghi','-append')






