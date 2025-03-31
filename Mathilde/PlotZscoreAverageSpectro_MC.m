% Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
Dir{2}=PathForExperiments_Opto('Stim_20Hz');

number=1;
AVdata_MH_wake=[];

for i=1:length(Dir{2}.path)     % each mouse / recording
    cd(Dir{2}.path{i}{1});
    load LFPData/DigInfo2
    digTSD(i)=DigTSD;
    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    REMTime{i}=REMEpoch;
    wakeTime{i}=Wake;
    SWSTime{i}=SWSEpoch;
    load H_Low_Spectrum
    SpectroH{i} = Spectro;
    fH=Spectro{3};
    load VLPO_Low_Spectrum
    SpectroV{i} = Spectro;
    fV=Spectro{3};
    load PFCx_deep_Low_Spectrum
    SpectroP{i}=Spectro;
    fP=Spectro{3};
    load Bulb_deep_Low_Spectrum
    SpectroB_low{i}=Spectro;
    fOB_low=Spectro{3};
    
    load Bulb_deep_High_Spectrum
    SpectroB_high{i}=Spectro;
    % to smooth the high freq spectro
    clear datOBnew
    datOB = Spectro{1};
    for k = 1:size(datOB,2)
        datOBnew(:,k) = runmean(datOB(:,k),650);
    end
    % make tsd
    sptsdB(i) = tsd(SpectroB_high{i}{2}*1e4,datOBnew);
    
    fOB_high=Spectro{3};
    
    
    TTLEpoch(i) = thresholdIntervals(digTSD(i),0.99,'Direction','Above');   % column of time above .99 to get ON stim
    TTLEpoch_merged(i) = mergeCloseIntervals(TTLEpoch(i),1e4);              % merge all stims times closer to 1s to avoid slots and replace it with an entire step of 1 min
    
    for j = 1:length(Start(TTLEpoch_merged(i)))
        LittleEpoch(i) = subset(TTLEpoch_merged(i),j);
        Freq_Stim(i,j) = round(1./(median(diff(Start(and(TTLEpoch(i),LittleEpoch(i)),'s')))));
        Time_Stim(i,j) = min(Start(and(TTLEpoch(i),LittleEpoch(i))));
    end
    
    events{i}=Start(TTLEpoch_merged(i))/1E4;                                 % to find opto stimulations
    ev{i}=ts(events{i}*1e4);
  
    
    % HPC average spectro during wake and REM sleep
    [MH_wake{i},SH_wake{i},tH_wake]=AverageSpectrogram(tsd(SpectroH{i}{2}*1E4,10*log10(SpectroH{i}{1})),SpectroH{i}{3},Restrict(ts(events{i}*1E4),wakeTime{i}),500,300);
    [MH_REM{i},SH_REM{i},tH_REM]=AverageSpectrogram(tsd(SpectroH{i}{2}*1E4,10*log10(SpectroH{i}{1})),SpectroH{i}{3},Restrict(ts(events{i}*1E4),REMTime{i}),500,300);
    % VLPO average spectro during wake and REM sleep
    [MV_wake{i},SV_wake{i},tV_wake]=AverageSpectrogram(tsd(SpectroV{i}{2}*1E4,10*log10(SpectroV{i}{1})),SpectroV{i}{3},Restrict(ts(events{i}*1E4),wakeTime{i}),500,300);
    [MV_REM{i},SV_REM{i},tV_REM]=AverageSpectrogram(tsd(SpectroV{i}{2}*1E4,10*log10(SpectroV{i}{1})),SpectroV{i}{3},Restrict(ts(events{i}*1E4),REMTime{i}),500,300);
    % PFC average spectro during wake and REM sleep
    [MP_wake{i},SP_wake{i},tP_wake]=AverageSpectrogram(tsd(SpectroP{i}{2}*1E4,10*log10(SpectroP{i}{1})),SpectroP{i}{3},Restrict(ts(events{i}*1E4),wakeTime{i}),500,300);
    [MP_REM{i},SP_REM{i},tP_REM]=AverageSpectrogram(tsd(SpectroP{i}{2}*1E4,10*log10(SpectroP{i}{1})),SpectroP{i}{3},Restrict(ts(events{i}*1E4),REMTime{i}),500,300);
    % OB LOW average spectro during wake and REM sleep
    [MB_low_wake{i},SB_low_wake{i},tB_low_wake]=AverageSpectrogram(tsd(SpectroB_low{i}{2}*1E4,10*log10(SpectroB_low{i}{1})),SpectroB_low{i}{3},Restrict(ts(events{i}*1E4),wakeTime{i}),500,300);
    [MB_low_REM{i},SB_low_REM{i},tB_low_REM]=AverageSpectrogram(tsd(SpectroB_low{i}{2}*1E4,10*log10(SpectroB_low{i}{1})),SpectroB_low{i}{3},Restrict(ts(events{i}*1E4),REMTime{i}),500,300);
    % OB HIGH average spectro during wake and REM sleep
    [MB_high_wake{i},SB_high_wake{i},tB_high_wake]=AverageSpectrogram(sptsdB(i),SpectroB_high{i}{3},Restrict(ts(events{i}*1E4),wakeTime{i}),500,300);
    [MB_high_REM{i},SB_high_REM{i},tB_high_REM]=AverageSpectrogram(sptsdB(i),SpectroB_high{i}{3},Restrict(ts(events{i}*1E4),REMTime{i}),500,300);

    
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end


%% mean         

% convert cell arrays in 3D arrays (third dimension being mice)
data_MH_wake=cat(3,MH_wake{:});                 % for HPH
data_MH_REM=cat(3,MH_REM{:});
data_MV_wake=cat(3,MV_wake{:});                 % for VLPO
data_MV_REM=cat(3,MV_REM{:});
data_MP_wake=cat(3,MP_wake{:});                 % for PFC
data_MP_REM=cat(3,MP_REM{:});
data_MB_low_wake=cat(3,MB_low_wake{:});         % for OB low freq
data_MB_low_REM=cat(3,MB_low_REM{:});
data_MB_high_wake=cat(3,MB_high_wake{:});       % for OB high freq
data_MB_high_REM=cat(3,MB_high_REM{:});
% compute average spectro across the third dimension
avdata_MH_wake=nanmean(data_MH_wake,3);
avdata_MH_REM=nanmean(data_MH_REM,3);
avdata_MV_wake=nanmean(data_MV_wake,3);
avdata_MV_REM=nanmean(data_MV_REM,3);
avdata_MP_wake=nanmean(data_MP_wake,3);
avdata_MP_REM=nanmean(data_MP_REM,3);
avdata_MB_low_wake=nanmean(data_MB_low_wake,3);
avdata_MB_low_REM=nanmean(data_MB_low_REM,3);
avdata_MB_high_wake=nanmean(data_MB_high_wake,3);
avdata_MB_high_REM=nanmean(data_MB_high_REM,3);

%% plot Zscore average spectro REM vs Wake for all structures 

figure, subplot(5,2,1), imagesc(tP_REM/1E3,fP,zscore(avdata_MP_REM')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tP_REM(2) tP_REM(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fP(1) fP(end)])
title('PFC REM')
colormap(jet)
caxis([-2 1.5])

subplot(5,2,2), imagesc(tP_wake/1E3,fP,zscore(avdata_MP_wake')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tP_wake(2) tP_wake(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fP(1) fP(end)])
title('PFC Wake')
colormap(jet)
caxis([-2 1.5])

subplot(5,2,3), imagesc(tB_high_REM/1E3,fOB_high,zscore(avdata_MB_high_REM')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tB_high_REM(2) tB_high_REM(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fOB_high(1) fOB_high(end)])
title('OB high REM')
colormap(jet)
caxis([-2.5 2])

subplot(5,2,4), imagesc(tB_high_wake/1E3,fOB_high,zscore(avdata_MB_high_wake')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tB_high_wake(2) tB_high_wake(end-1)]/1E3)
xlim([-60 +60]) 
ylim([fOB_high(1) fOB_high(end)])
title('OB high Wake')
colormap(jet)
caxis([-2.5 2])

subplot(5,2,5), imagesc(tB_low_REM/1E3,fOB_low,zscore(avdata_MB_low_REM')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tB_low_REM(2) tB_low_REM(end-1)]/1E3)
xlim([-60 +60])
ylim([fOB_low(1) fOB_low(end)])
title('OB low REM')
colormap(jet)
caxis([-2 2])

subplot(5,2,6), imagesc(tB_low_wake/1E3,fOB_low,zscore(avdata_MB_low_wake')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tB_low_wake(2) tB_low_wake(end-1)]/1E3)
xlim([-60 +60])
ylim([fOB_low(1) fOB_low(end)])
title('OB low Wake')
colormap(jet)
caxis([-2 2])

subplot(5,2,7), imagesc(tV_REM/1E3,fV,zscore(avdata_MV_REM')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tV_REM(2) tV_REM(end-1)]/1E3)
xlim([-60 +60])
ylim([fV(1) fV(end)])
title('VLPO REM')
colormap(jet)
caxis([-2.5 1.8])

subplot(5,2,8), imagesc(tV_wake/1E3,fV,zscore(avdata_MV_wake')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
% xlabel('Times (s)')
% xlim([tV_wake(2) tV_wake(end-1)]/1E3)
xlim([-60 +60])
ylim([fV(1) fV(end)])
title('VLPO wake')
colormap(jet)
caxis([-2.5 1.8])

subplot(5,2,9), imagesc(tH_REM/1E3,fH,zscore(avdata_MH_REM')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
xlabel('Times (s)')
% xlim([tH_REM(2) tH_REM(end-1)]/1E3)
xlim([-60 +60])
ylim([fH(1) fH(end)])
title('HPC REM')
colormap(jet)
caxis([-2.5 1.7])

subplot(5,2,10), imagesc(tH_wake/1E3,fH,zscore(avdata_MH_wake')'), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
xlabel('Times (s)')
% xlim([tH_wake(2) tH_wake(end-1)]/1E3)
xlim([-60 +60])
ylim([fH(1) fH(end)])
title('HPC wake')
colormap(jet)
caxis([-2.5 1.7])

suptitle('Zscore average spectrograms (n = 3)')