

Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
% Dir{2}=PathForExperiments_Opto('Stim_20Hz');

number=1;
for i=1:length(Dir{1}.path)     % each mouse / recording
    cd(Dir{1}.path{i}{1});

    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    REMTime{i}=REMEpoch;
    wakeTime{i}=Wake;
    SWSTime{i}=SWSEpoch;
    load H_Low_Spectrum
    SpectroH{i}=Spectro;
    fP=Spectro{3};
    
    sptsdH(i)= tsd(SpectroH{i}{2}*1e4, SpectroH{i}{1});

%     [Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch); % to find optogenetic stimulations
%     events{i}=Stim;
    
    load SimulatedStims RemStim SwsStim WakeStim % for baseline recording (get SIMULATED stims)
StimRem{i}=RemStim;
StimSws{i}=SwsStim;
StimWake{i}=WakeStim;
    
    % PFC average spectro during wake and REM sleep
    [MH_wake{i},SH_wake{i},tps]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(StimWake{i},wakeTime{i}),500,500,0);
    [MH_REM{i},SH_REM{i},tps]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(StimRem{i},REMTime{i}),500,500,0);
    [MH_SWS{i},SH_SWS{i},tps]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(StimSws{i},SWSTime{i}),500,500,0);
    
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end


data_MH_wake=cat(3,MH_wake{:});                 % for PFC
data_MH_REM=cat(3,MH_REM{:});
data_MH_SWS=cat(3,MH_SWS{:});

avdata_MH_wake=nanmean(data_MH_wake,3);
avdata_MH_REM=nanmean(data_MH_REM,3);
avdata_MH_SWS=nanmean(data_MH_SWS,3);


%%

figure, subplot(311), imagesc(tps/1E3,fP,avdata_MH_REM), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tP_REM(2) tP_REM(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fP(1) fP(end)])
title('HPC REM')
colormap(jet)
% caxis([23 41])

subplot(312), imagesc(tps/1E3,fP,avdata_MH_SWS), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tP_REM(2) tP_REM(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fP(1) fP(end)])
title('HPC NREM')
colormap(jet)
% caxis([23 41])

subplot(313), imagesc(tps/1E3,fP,avdata_MH_wake), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tP_wake(2) tP_wake(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fP(1) fP(end)])
title('HPC Wake')
colormap(jet)
% caxis([23 41])