
%Code to scroll through spectrogram windows focused on optogenetic stimulation

set(0,'DefaultFigureWindowStyle','docked') %integrate figures in the matlab window

load('SleepScoring_OBGamma')
load('dHPC_deep_Low_Spectrum')
% load('H_Low_Spectrum')
% load('dHPC_rip_Low_Spectrum')
SpectroH=Spectro;
load('Bulb_deep_Low_Spectrum')
SpectroB=Spectro;
load('VLPO_Low_Spectrum')
SpectroV=Spectro;
load('PFCx_deep_Low_Spectrum')
SpectroP=Spectro;

%define events = stimulations
load('LFPData/DigInfo6.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;

% number of stimulations
length(events)

%plot spectro VLPO, HPC, OB over the total recording time
figure, 
subplot(4,1,1), imagesc(SpectroP{2},SpectroP{3},10*log10(SpectroP{1}')), axis xy
title('PFC')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,2), imagesc(SpectroV{2},SpectroV{3},10*log10(SpectroV{1}')), axis xy
title('VLPO')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,3), imagesc(SpectroH{2},SpectroH{3},10*log10(SpectroH{1}')), axis xy
title('HPC')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,4), imagesc(SpectroB{2},SpectroB{3},10*log10(SpectroB{1}')), axis xy
title('OB')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
colormap(jet)
caxis([10 70])

%plot spectro VLPO, HPC, OB on a 150 s window focused on stimulation (60 s before and 80 safter)
figure, 
subplot(4,1,1), imagesc(SpectroP{2},SpectroP{3},10*log10(SpectroP{1}')), axis xy
title('PFC')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,2), imagesc(SpectroV{2},SpectroV{3},10*log10(SpectroV{1}')), axis xy
title('VLPO')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,3), imagesc(SpectroH{2},SpectroH{3},10*log10(SpectroH{1}')), axis xy
title('HPC')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,4), imagesc(SpectroB{2},SpectroB{3},10*log10(SpectroB{1}')), axis xy
title('OB')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
colormap(jet)
caxis([10 70])

%plot spectro VLPO, HPC, OB on a 150 s window focused on stimulation (60 s
%before and 80 after) restricted to REM, SWS and Wake
ev=ts(events*1E4);
% length(Range(Restrict(ev,REMEpoch)))
% length(Range(Restrict(ev,SWSEpoch)))
% length(Range(Restrict(ev,Wake)))
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
evW=Range(Restrict(ev,Wake),'s');

n=0, n=n+1;
subplot(4,1,1),
xlim([events(n)-30 events(n)+50]), caxis([10 70]),
title('PFC')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,2),
xlim([events(n)-30 events(n)+50]), caxis([10 70]),
title('VLPO')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,3),
xlim([events(n)-30 events(n)+50]), caxis([10 70]),
title('HPC')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,4),
xlim([events(n)-30 events(n)+50]), caxis([10 70]),
title('OB')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
colormap(jet)

n=0
% copy and paste these lines of code to scroll through the 150-second
% windows
% REM
n=n+1;
subplot(4,1,1),xlim([evR(n)-30 evR(n)+50]), caxis([10 60]),
subplot(4,1,2),xlim([evR(n)-30 evR(n)+50]), caxis([10 60]),
subplot(4,1,3),xlim([evR(n)-30 evR(n)+50]), caxis([10 60]),
subplot(4,1,4),xlim([evR(n)-30 evR(n)+50]), caxis([10 60])

% Wake
% n=n+1;
% subplot(4,1,1),xlim([evW(n)-30 evW(n)+50]), caxis([10 60]),
% subplot(4,1,2),xlim([evW(n)-30 evW(n)+50]), caxis([10 60]),
% subplot(4,1,3),xlim([evW(n)-30 evW(n)+50]), caxis([10 60]),
% subplot(4,1,4),xlim([evW(n)-30 evW(n)+50]), caxis([10 60])


