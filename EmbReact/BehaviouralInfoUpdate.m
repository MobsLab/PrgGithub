% Change these two lines to check for all animals
clear all
SleepFiles=PathForExperimentsEmbReact('SleepPreSound');
ActiveFiles=PathForExperimentsEmbReact('SoundTest');
m=length(SleepFiles.path);

% Don't change these parameters
smootime=3;

for mm=1:m
    clear gamma_thresh
    cd(SleepFiles.path{mm}{1})
    MouseNum=SleepFiles.ExpeInfo{mm}.nmouse;
    if exist('StateEpochSB.mat')
    else
        BulbSleepScript
    end
    load('StateEpochSB.mat','gamma_thresh')
    
    cd(ActiveFiles.path{mm}{1})
    % Make some checks
    %% Stim Info
    clear StimEpoch
    load('behavResources.mat','StimEpoch');
    try StimEpoch
    catch
        load('LFPData/DigInfo.mat')
        StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
        save('behavResources.mat','StimEpoch','-append');
    end
    %% Noise
    clear TotalNoiseEpoch
    try, load('StateEpochSB.mat','TotalNoiseEpoch'), end
    try TotalNoiseEpoch
    catch
        try, load('ChannelsToAnalyse/dHPC_rip.mat'), catch,load('ChannelsToAnalyse/dHPC_deep.mat') ,end
        FindNoiseEpoch(ActiveFiles.path{mm}{1},channel);
        close all
    end
    
    
    
    %% check its the same mouse then get sleep times
    if ActiveFiles.ExpeInfo{mm}.nmouse==MouseNum
        load('ChannelsToAnalyse/Bulb_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        FilGamma=FilterLFP(LFP,[50 70],1024);
        HilGamma=hilbert(Data(FilGamma));
        H=abs(HilGamma);
        tot_ghi=tsd(Range(LFP),H);
        smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
        sm_ghi=Data(smooth_ghi);
        
        sleepper=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
        sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
        SleepyEpoch=dropShortIntervals(sleepper,mindur*1e4);
        figure
        hist(Data(smooth_ghi),100), hold on, line([gamma_thresh gamma_thresh],ylim,'color','k')
        pause
        save('behavResources.mat','SleepyEpoch','-append');
        
    else
        keyboard
    end
    
    
    
end



