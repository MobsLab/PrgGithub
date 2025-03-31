
%Code to scroll through spectrogram windows focused on optogenetic stimulation

set(0,'DefaultFigureWindowStyle','docked') %integrate figures in the matlab window

load('SleepScoring_OBGamma')
load('dHPC_deep_Low_Spectrum')
SpectroH=Spectro;
load('Bulb_deep_Low_Spectrum')
SpectroB=Spectro;
% load('B_High_Spectrum')
% SpectroBh=Spectro;
load('VLPO_Low_Spectrum')
SpectroV=Spectro;
load('PFCx_deep_Low_Spectrum')
SpectroP=Spectro;

%define events = stimulations
load('LFPData/DigInfo4.mat')
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
subplot(4,1,1), imagesc(SpectroV{2},SpectroV{3},10*log10(SpectroV{1}')), axis xy
title('VLPO')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,2), imagesc(SpectroP{2},SpectroP{3},10*log10(SpectroP{1}')), axis xy
title('PFC')
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
subplot(4,1,1), imagesc(SpectroV{2},SpectroV{3},10*log10(SpectroV{1}')), axis xy
title('VLPO')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,2), imagesc(SpectroP{2},SpectroP{3},10*log10(SpectroP{1}')), axis xy
title('PFC')
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
%NevREM=length(Range(Restrict(ev,REMEpoch)))
NevREM=length(Range(Restrict(ev,REMEpochWiNoise)))
%NevSWS=length(Range(Restrict(ev,SWSEpoch)))
NevSWS=length(Range(Restrict(ev,SWSEpochWiNoise)))
%NevWake=length(Range(Restrict(ev,Wake)))
NevWake=length(Range(Restrict(ev,WakeWiNoise)))
% evR=Range(Restrict(ev,REMEpoch),'s')
% evS=Range(Restrict(ev,SWSEpoch),'s')
% evW=Range(Restrict(ev,Wake),'s')
evR=Range(Restrict(ev,REMEpochWiNoise),'s');
evS=Range(Restrict(ev,SWSEpochWiNoise),'s');
evW=Range(Restrict(ev,WakeWiNoise),'s');
evR./60

n=0, 
n=n+1;
subplot(4,1,1),
xlim([events(n)-30 events(n)+50]), caxis([10 70]),
title('VLPO')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,1,2),
xlim([events(n)-30 events(n)+50]), caxis([10 70]),
title('PFC')
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
n=n+1;
subplot(4,1,1),xlim([evR(n)-30 evR(n)+50]), caxis([10 60]),
subplot(4,1,2),xlim([evR(n)-30 evR(n)+50]), caxis([10 60]),
subplot(4,1,3),xlim([evR(n)-30 evR(n)+50]), caxis([10 60])
subplot(4,1,4),xlim([evR(n)-30 evR(n)+50]), caxis([10 60])


n=n+1;
subplot(4,1,1),xlim([evW(n)-30 evW(n)+50]), caxis([10 55]),
subplot(4,1,2),xlim([evW(n)-30 evW(n)+50]), caxis([10 55]),
subplot(4,1,3),xlim([evW(n)-30 evW(n)+50]), caxis([10 55])
subplot(4,1,4),xlim([evW(n)-30 evW(n)+50]), caxis([10 55])


n=n+1;
subplot(4,1,1),xlim([evS(n)-30 evS(n)+50]), caxis([10 60]),
subplot(4,1,2),xlim([evS(n)-30 evS(n)+50]), caxis([10 60]),
subplot(4,1,3),xlim([evS(n)-30 evS(n)+50]), caxis([10 60])
subplot(4,1,4),xlim([evS(n)-30 evS(n)+50]), caxis([10 60])


% SpectroTsd=tsd(Spectro{2}*1E4,10*log10(Spectro{1}')); 
% f=Spectro{3};
% ev=ts(events*1E4);
% evR=Range(Restrict(ev,REMEpoch),'s');
% Epoch=intervalSet((events(n)-30)*1E4,(events(n)+50)*1E4);
% clf, imagesc(Range(Restrict(SpectroTsd,Epoch),'s'), f, Data(Restrict(SpectroTsd,Epoch))), caxis([10 50])
% 

xlim([-30 +50])
