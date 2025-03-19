
%Stage Transitions after Stimulations 

clear all
pathname='Figures'
pathname2='Figures/Average_Spectrums'
mkdir Figures
mkdir(fullfile(pathname,'Average_Spectrums'))

load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')


 disp('loading stim times')
        % Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
        %load('LFPData/DigInfo4.mat')
        load('LFPData/DigInfo4.mat')

        TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
        % TTL = colonne de temps au dessus de 0.99 pour avoir les 1 = stim ON
        
        TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
        % merge tous les temps des stim plus proche de 1 sec pour éviter les créneaux et le remplacer par un step entier d'une min
        
        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;

stim=events

SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),REMEpochWiNoise),-60:1:60,2);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),SWSEpochWiNoise),-60:1:60,2);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),WakeWiNoise),-60:1:60,2);


