%%Pour les plots Spectre du PFCx_deep (à modifier si autres channels)
clear all
load('LFPData/DigInfo2.mat')
load('ChannelsToAnalyse/PFCx_deep.mat')
load('SleepScoring_OBGamma.mat')
%Calcul du spectre PFCx
LowSpectrumSB([cd filesep],channel,'PFCx_deep');
load('PFCx_deep_Low_Spectrum.mat')

%%Définition des Variables
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
    LittleEpoch = subset(TTLEpoch_merged,k);
    
    Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


%%Plot spectre PFCx-deep 2-4-10Hz ou20Hz (h à changer)
for h = [2 4 10]
    LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
     LittleEpoch=LittleEpoch-TotalNoiseEpoch;
    plot(Spectro{3},log(nanmean(Data(Restrict(Sptsd,LittleEpoch)))),'r'), hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Pour les plots Spectre du Bulb_deep (à modifier si autres channels)
load('ChannelsToAnalyse/Bulb_deep.mat')
load('SleepScoring_OBGamma.mat')
%Calcul du spectre PFCx
LowSpectrumSB([cd filesep],channel,'Bulb_deep');
load('Bulb_deep_Low_Spectrum.mat')

%%Définition des Variables
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
    LittleEpoch = subset(TTLEpoch_merged,k);
    
    Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


%%Plot spectre PFCx-deep 2-4-10Hz ou20Hz (h à changer)
for h = [2 4 10]
    LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
     LittleEpoch=LittleEpoch-TotalNoiseEpoch;
    plot(Spectro{3},log(nanmean(Data(Restrict(Sptsd,LittleEpoch)))),'b'), hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
%%Pour les plots Spectre du dHPC_sup (à modifier si autres channels)
load('ChannelsToAnalyse/dHPC_sup.mat')
%Calcul du spectre PFCx
LowSpectrumSB([cd filesep],channel,'dHPC_sup');
load('dHPC_sup_Low_Spectrum.mat')

%%Définition des Variables
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
    LittleEpoch = subset(TTLEpoch_merged,k);
    
    Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


%%Plot spectre PFCx-deep 2-4-10Hz ou20Hz (h à changer)
for h = [2 4 10]
    LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
     LittleEpoch=LittleEpoch-TotalNoiseEpoch;
    plot(Spectro{3},log(nanmean(Data(Restrict(Sptsd,LittleEpoch)))),'g'), hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Pour les plots Spectre du dHPC_sup (à modifier si autres channels)
load('ChannelsToAnalyse/VLPO.mat')
%Calcul du spectre PFCx
LowSpectrumSB([cd filesep],channel,'VLPO');
load('VLPO_Low_Spectrum.mat')

%%Définition des Variables
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
    LittleEpoch = subset(TTLEpoch_merged,k);
    
    Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


%%Plot spectre PFCx-deep 2-4-10Hz ou20Hz (h à changer)
for h = [2 4 10]
    LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
     LittleEpoch=LittleEpoch-TotalNoiseEpoch;
    plot(Spectro{3},log(nanmean(Data(Restrict(Sptsd,LittleEpoch)))),'k'), hold on
end