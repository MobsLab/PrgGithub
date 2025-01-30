

clear all
%M648

%07122017
clear all
cd /media/nas5/Thierry_DATA/M648_processed/20171207/M648-Stimopto-day2_171207_101708
load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')
load('LFPData/DigInfo2.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;
ev=ts(events*1E4);
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
evW=Range(Restrict(ev,Wake),'s');
NevREM=length(Range(Restrict(ev,REMEpoch)))
NevSWS=length(Range(Restrict(ev,SWSEpoch)))
NevWake=length(Range(Restrict(ev,Wake)))
openfig('Panel REM.fig','reuse'); 
suptitle({'REM',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevREM})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
savefig(fullfile(pathname2,'Panel_REM'))
openfig('Panel Wake.fig','reuse'); 
suptitle({'Wake',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevWake})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
savefig(fullfile(pathname2,'Panel_Wake'))

%14122017
cd /media/nas5/Thierry_DATA/M648_processed/20171214/M648-optostim-day3_171214_093218
load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')
load('LFPData/DigInfo2.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;
ev=ts(events*1E4);
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
evW=Range(Restrict(ev,Wake),'s');
NevREM=length(Range(Restrict(ev,REMEpoch)))
NevSWS=length(Range(Restrict(ev,SWSEpoch)))
NevWake=length(Range(Restrict(ev,Wake)))
openfig('Panel REM.fig','reuse'); 
suptitle({'REM',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevREM})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
openfig('Panel Wake.fig','reuse'); 
suptitle({'Wake',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevWake})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])


%06022018
clear all
cd /media/nas5/Thierry_DATA/M648_processed/20180206/M648-Opto20Hz_180206_095603
load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')
load('LFPData/DigInfo2.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;
ev=ts(events*1E4);
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
evW=Range(Restrict(ev,Wake),'s');
NevREM=length(Range(Restrict(ev,REMEpoch)))
NevSWS=length(Range(Restrict(ev,SWSEpoch)))
NevWake=length(Range(Restrict(ev,Wake)))
openfig('Panel REM.fig','reuse'); 
suptitle({'REM',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevREM})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
savefig(fullfile(pathname2,'Panel_REM'))
openfig('Panel Wake.fig','reuse'); 
suptitle({'Wake',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevWake})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
savefig(fullfile(pathname2,'Panel_Wake'))

%07022018
clear all
cd /media/nas5/Thierry_DATA/M648_processed/20180207/M648-Opto20Hz_180207_100736
load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')
load('LFPData/DigInfo2.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;
ev=ts(events*1E4);
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
evW=Range(Restrict(ev,Wake),'s');
NevREM=length(Range(Restrict(ev,REMEpoch)))
NevSWS=length(Range(Restrict(ev,SWSEpoch)))
NevWake=length(Range(Restrict(ev,Wake)))
openfig('Panel REM.fig','reuse'); 
suptitle({'REM',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevREM})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
pathname='Figures'
pathname2='Figures/Average_Spectrums'
savefig(fullfile(pathname,'Panel_REM'))
openfig('Panel Wake.fig','reuse'); 
suptitle({'Wake',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevWake})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
savefig(fullfile(pathname2,'Panel_Wake'))



%%%%%%%%%%Panel 2 spectres REM - Wake
hR1=openfig('Figures/Average_Spectrums/VLPO_REM')
axR1=gca
hR2=openfig('Figures/Average_Spectrums/VLPO_Wake')
axR2=gca
hR3=openfig('Figures/Average_Spectrums/HPC_REM')
axR3=gca
hR4=openfig('Figures/Average_Spectrums/HPC_Wake')
axR4=gca

hR3=figure
sR1=subplot(2,2,1)
title('VLPO REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR2=subplot(2,2,2)
title('VLPO Wake')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR3=subplot(2,2,3)
title('HPC REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR4=subplot(2,2,4)
title('HPC Wake')
xlabel('time (s)')
ylabel('Frequency (Hz)')

fig1=get(axR1,'children')
fig2=get(axR2,'children')
fig3=get(axR3,'children')
fig4=get(axR4,'children')

copyobj(fig1,sR1)
copyobj(fig2,sR2)
copyobj(fig3,sR3)
copyobj(fig4,sR4)

colormap(jet)
caxis([20 48])

savefig(fullfile(pathname2,'REM_vs_Wake'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%16022018
clear all
cd /media/nas5/Thierry_DATA/M648_processed/20180216/M648-opto20Hz_180216_094032
load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')
load('LFPData/DigInfo2.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;
ev=ts(events*1E4);
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
evW=Range(Restrict(ev,Wake),'s');
NevREM=length(Range(Restrict(ev,REMEpoch)))
NevSWS=length(Range(Restrict(ev,SWSEpoch)))
NevWake=length(Range(Restrict(ev,Wake)))
openfig('Panel REM.fig','reuse'); 
suptitle({'REM',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevREM})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
pathname='Figures'
pathname2='Figures/Average_Spectrums'
savefig(fullfile(pathname,'Panel_REM'))
openfig('Panel Wake.fig','reuse'); 
suptitle({'Wake',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse),'stim =',NevWake})
ylabel('Frequency (Hz)'), xlabel('time (s)')
colormap(jet)
caxis([20 48])
savefig(fullfile(pathname2,'Panel_Wake'))



%%%%%%%%%%Panel 2 spectres REM - Wake
hR1=openfig('Figures/Average_Spectrums/VLPO_REM')
axR1=gca
hR2=openfig('Figures/Average_Spectrums/VLPO_Wake')
axR2=gca
hR3=openfig('Figures/Average_Spectrums/HPC_REM')
axR3=gca
hR4=openfig('Figures/Average_Spectrums/HPC_Wake')
axR4=gca

hR3=figure
sR1=subplot(2,2,1)
title('VLPO REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR2=subplot(2,2,2)
title('VLPO Wake')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR3=subplot(2,2,3)
title('HPC REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR4=subplot(2,2,4)
title('HPC Wake')
xlabel('time (s)')
ylabel('Frequency (Hz)')

fig1=get(axR1,'children')
fig2=get(axR2,'children')
fig3=get(axR3,'children')
fig4=get(axR4,'children')

copyobj(fig1,sR1)
copyobj(fig2,sR2)
copyobj(fig3,sR3)
copyobj(fig4,sR4)

colormap(jet)
caxis([20 48])
suptitle({'REM_vs_Wake',num2str(ExpeInfo.Date),num2str(ExpeInfo.nmouse)})

savefig(fullfile(pathname2,'REM_vs_Wake'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
