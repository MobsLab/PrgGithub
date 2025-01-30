% This code generates pannels used in april draft
% It generates Fig4C,D,E
% This code hasn't been adapted for use with the information on the server
% in Paris yet and only works on harddrives in Montreal
clear all, 
%close all
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/M514_170322')
%cd('/Volumes/My Passport/M514_170322')
%cd /Users/sophiebagur/Desktop/M514_170323
%HPCOrderChans=[38,41,33,46,34,45,35,44,32,47,36,43,37,42,39,40];
HPCOrderChans=[38,41,33,46,34,45,35,44,32,47,36];
DoCoh=0;
DoDiff=0;
LookAtRipProfile=1;
MakeCohFigs=1;
DoRandCoh=0;
DoRandCohCSD=0;
TriggerOnBreathing=0;
TriggerOnTheta=1;
GetOBPhase=0;
DoRandCohDiff=0;
DoRandCohFigs=0;
DoMNCoupling=0;
DoMNCouplingBelluscioMethod=0;
TriggerOnBreathingMov=0;
cols=parula(18);
% Get FreezeEpoch
load('behavResources.mat')
MovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),100));
FreezeEpoch=thresholdIntervals(MovAcctsd,1.5*1E7,'Direction','Below');
FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1E4);
RunEpoch=thresholdIntervals(MovAcctsd,2*1E7,'Direction','Above');
RunEpoch=dropShortIntervals(RunEpoch,3*1E4);



%% Do same but with spectra


for i=1:MakeSpecFigs
    for c=1:length(HPCOrderChans)
        load(['AllSpecHPCProbe/HPCProbe',num2str(HPCOrderChans(c)),'_Low_Spectrum.mat'])
        Sptsd=tsd(Spectro{2}*1E4,log(Spectro{1}));
        AllSpec(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllSpecMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
        
    end
    
    for c=1:length(HPCOrderChans)-1
        load(['AllSpecHPCProbe/SpectroHPCDiff',num2str((c)),'.mat'])
        Sptsd=tsd(Spectro{2}*1E4,log(Spectro{1}));
        AllSpecDiff(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllSpecMovDiff(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
        
    end
    
     for c=1:length(HPCOrderChans)-2
        load(['AllSpecHPCProbe/SpectroHPCCSD',num2str((c)),'.mat'])
        Sptsd=tsd(Spectro{2}*1E4,log(Spectro{1}));
        AllSpecCSD(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllSpecMovCSD(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
        
    end
    
    
    
    figure
    subplot(231)
    imagesc(f,[1:size(AllSpec,1)],AllSpec)
    title('LFP')
    xlabel('Frequency (Hz)')
    xlim([1 20])
    subplot(232)
    imagesc(f,[1:size(AllSpecDiff,1)],AllSpecDiff)
    title('Current')
    xlabel('Frequency (Hz)')
    xlim([1 20])
    subplot(233)
    imagesc(f,[1:size(AllSpecCSD,1)],AllSpecCSD)
    title('CSD')
    xlabel('Frequency (Hz)')
    xlim([1 20])

    subplot(234)
    imagesc(f,[1:size(AllSpec,1)],AllSpecMov)
    title('LFP')
    xlabel('Frequency (Hz)')
    xlim([1 20]), clim([5 13])
    subplot(235)
    imagesc(f,[1:size(AllSpecDiff,1)],AllSpecMovDiff)
    title('Current')
    xlabel('Frequency (Hz)')
    xlim([1 20]), clim([5 13])
    subplot(236)
    imagesc(f,[1:size(AllSpecCSD,1)],AllSpecMovCSD)
    title('CSD')
    xlabel('Frequency (Hz)')
    xlim([1 20]), clim([5 13])
    
end
