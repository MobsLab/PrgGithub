

% Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
Dir{2}=PathForExperiments_Opto('Stim_20Hz');

number=1;
for i=1:length(Dir{2}.path)     % each mouse / recording
    cd(Dir{2}.path{i}{1});

    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    REMTime{i}=REMEpoch;
    wakeTime{i}=Wake;
    SWSTime{i}=SWSEpoch;
    
    load PFCx_deep_Low_Spectrum
    SpectroP{i}=Spectro;
    fP=Spectro{3};
    
sptsd(i)= tsd(SpectroP{i}{2}*1e4, SpectroP{i}{1});
    
    [Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch); % to find optogenetic stimulations
    events{i}=Stim;
    
    % PFC average spectro during wake and REM sleep
    [MP_wake{i},SP_wake{i},tps]=AverageSpectrogram(sptsd(i),SpectroP{i}{3},Restrict(ts(events{i}*1E4),wakeTime{i}),500,500,0);
    [MP_REM{i},SP_REM{i},tps]=AverageSpectrogram(tsptsd(i),SpectroP{i}{3},Restrict(ts(events{i}*1E4),REMTime{i}),500,500,0);
    [MP_SWS{i},SP_SWS{i},tps]=AverageSpectrogram(sptsd(i),SpectroP{i}{3},Restrict(ts(events{i}*1E4),SWSTime{i}),500,500,0);

    
    SpMed{i}=MP_SWS{i}/median(MP_SWS{i}(:));%median
    
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end


data_MP_wake=cat(3,MP_wake{:});                 % for PFC
data_MP_REM=cat(3,MP_REM{:});
data_MP_SWS=cat(3,MP_SWS{:});

avdata_MP_wake=nanmean(data_MP_wake,3);
avdata_MP_REM=nanmean(data_MP_REM,3);
avdata_MP_SWS=nanmean(data_MP_SWS,3);

% median
data_MPmed_SWS=cat(3,SpMed{:});
avdata_MPmed_SWS=nanmean(data_MPmed_SWS,3);
%%


%median
 imagesc(tps/1E3,fP,avdata_MPmed_SWS),axis xy
 
 %
figure, subplot(311), imagesc(tps/1E3,fP,avdata_MP_REM), axis xy
yl=ylim;
line([0 0],ylim,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tP_REM(2) tP_REM(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fP(1) fP(end)])
title('PFC REM')
colormap(jet)
caxis([23 41])

subplot(312), imagesc(tps/1E3,fP,avdata_MP_SWS), axis xy
yl=ylim;
line([0 0],ylim,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tP_REM(2) tP_REM(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fP(1) fP(end)])
title('PFC NREM')
colormap(jet)
caxis([23 41])

subplot(313), imagesc(tps/1E3,fP,avdata_MP_wake), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tP_wake(2) tP_wake(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fP(1) fP(end)])
title('PFC Wake')
colormap(jet)
caxis([23 41])