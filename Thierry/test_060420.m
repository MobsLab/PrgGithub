

set(0,'DefaultFigureWindowStyle','docked') %integrate figures in the matlab window

load('SleepScoring_OBGamma')
load('dHPC_deep_Low_Spectrum')
SpectroH=Spectro;
load('Bulb_deep_Low_Spectrum')
SpectroV=Spectro;
load('VLPO_Low_Spectrum')
SpectroB=Spectro;
load('PFCx_deep_Low_Spectrum')
SpectroP=Spectro;

load('LFPData/DigInfo2.mat')
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%AverageSpectre Stim REM 
load('ExpeInfo.mat')
figure,
subplot(4,2,1),
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title({'VLPO REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
subplot(4,2,2),[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title({'PFC REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
subplot(4,2,3),[MB,SB,tB]=AverageSpectrogram(tsd(SpectroB{2}*1E4,10*log10(SpectroB{1})),SpectroB{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title({'Bulb REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
subplot(4,2,4),[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title({'HPC REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
colormap(jet)
caxis([10 70])
%%AverageSpectre Stim SWS 
subplot(3,1,1)figure
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title({'VLPO SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title({'PFC SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title({'HPC SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
[MB,SB,tB]=AverageSpectrogram(tsd(SpectroB{2}*1E4,10*log10(SpectroB{1})),SpectroB{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title({'Bulb SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
colormap(jet)
caxis([10 70])
%%AverageSpectre Stim Wake
figure
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),Wake),500,300);
title({'VLPO Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),Wake),500,300);
title({'PFC Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
[MB,SB,tB]=AverageSpectrogram(tsd(SpectroB{2}*1E4,10*log10(SpectroB{1})),SpectroB{3},Restrict(ts(events*1E4),Wake),500,300);
title({'Bulb Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),Wake),500,300);
title({'HPC Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
colormap(jet)
caxis([10 70])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot spectro VLPO, HPC, OB on a 150 s window focused on stimulation (60 s before and 80 safter)
figure, 
subplot(4,2,1), imagesc(SpectroV{2},SpectroV{3},10*log10(SpectroV{1}')), axis xy
title('VLPO')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,2,2), imagesc(SpectroP{2},SpectroP{3},10*log10(SpectroP{1}')), axis xy
title('PFC')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,2,3), imagesc(SpectroH{2},SpectroH{3},10*log10(SpectroH{1}')), axis xy
title('HPC')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
subplot(4,2,4), imagesc(SpectroB{2},SpectroB{3},10*log10(SpectroB{1}')), axis xy
title('OB')
ylabel('Frequency (Hz)')
xlabel('Time (s)')
colormap(jet)
caxis([10 70])

%%%%%%%%%%%%%%
events=Start(TTLEpoch_merged)/1E4;

Stim=size(Start(TTLEpoch_merged),1)
%Nb de stim pendant le REM
StimREM=size(Start(and(TTLEpoch_merged,REMEpoch)),1)
%Nb de stim pendant le SWS
StimSWS=size(Start(and(TTLEpoch_merged,SWSEpoch)),1)
%Nb de stim pendant Wake
StimWAKE=size(Start(and(TTLEpoch_merged,Wake)),1)
%Matrice contenant les 4 valeurs précédentes 
MStim=[Stim StimREM StimSWS StimWAKE]

%%%%%%%%%%%%%%
%plot spectro VLPO, HPC, OB on a 150 s window focused on stimulation (60 s
%before and 80 after) restricted to REM, SWS and Wake
ev=ts(events*1E4);
NevREM=length(Range(Restrict(ev,REMEpoch)))
NevSWS=length(Range(Restrict(ev,SWSEpoch)))
NevWake=length(Range(Restrict(ev,Wake)))
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
evW=Range(Restrict(ev,Wake),'s');



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
subplot(4,1,1),xlim([StimREM(n)-30 StimREM(n)+50]), caxis([10 60]),
subplot(4,1,2),xlim([StimREM(n)-30 StimREM(n)+50]), caxis([10 60]),
subplot(4,1,3),xlim([StimREM(n)-30 StimREM(n)+50]), caxis([10 60])
subplot(4,1,4),xlim([StimREM(n)-30 StimREM(n)+50]), caxis([10 60])

Stim=size(Start(TTLEpoch_merged),1)
%Nb de stim pendant le REM
NStimREM=size(Start(and(TTLEpoch_merged,REMEpoch)),1)
StimREM=(Start(and(TTLEpoch_merged,REMEpoch),'s'))
%Nb de stim pendant le SWS
NStimSWS=size(Start(and(TTLEpoch_merged,SWSEpoch)),1)
StimSWS=(Start(and(TTLEpoch_merged,SWSEpoch),'s'))
%Nb de stim pendant Wake
NStimWAKE=size(Start(and(TTLEpoch_merged,Wake)),1)
StimWAKE=(Start(and(TTLEpoch_merged,Wake),'s'))

%Matrice contenant les 4 valeurs précédentes 
MStim=[Stim StimREM StimSWS StimWAKE]

n=n+1;
subplot(4,1,1),xlim([evW(n)-30 evW(n)+50]), caxis([10 60]),
subplot(4,1,2),xlim([evW(n)-30 evW(n)+50]), caxis([10 60]),
subplot(4,1,3),xlim([evW(n)-30 evW(n)+50]), caxis([10 60])
subplot(4,1,4),xlim([evW(n)-30 evW(n)+50]), caxis([10 60])


n=n+1;
subplot(4,1,1),xlim([evS(n)-30 evS(n)+50]), caxis([10 60]),
subplot(4,1,2),xlim([evS(n)-30 evS(n)+50]), caxis([10 60]),
subplot(4,1,3),xlim([evS(n)-30 evS(n)+50]), caxis([10 60])
subplot(4,1,4),xlim([evS(n)-30 evS(n)+50]), caxis([10 60])


SpectroTsd=tsd(Spectro{2}*1E4,10*log10(Spectro{1}')); 
f=Spectro{3};
ev=ts(events*1E4);
evR=Range(Restrict(ev,REMEpoch),'s');
Epoch=intervalSet((events(n)-30)*1E4,(events(n)+50)*1E4);
clf, imagesc(Range(Restrict(SpectroTsd,Epoch),'s'), f, Data(Restrict(SpectroTsd,Epoch))), caxis([10 50])

