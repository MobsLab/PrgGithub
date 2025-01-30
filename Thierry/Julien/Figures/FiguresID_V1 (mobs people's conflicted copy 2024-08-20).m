%%%%% Output: Average Spectrum around stimulation for each region per state
%%%%%         (VLPO,OB,PFC,HPC)+ Panel of 4 regions per state
%%%%%         +HPC theta REM vs Baseline + Plotripraw EMG stim REM

%%%% Option average spectrum :  colorbar   caxis([A B])

%%%%load des spectrums et variables (avoir fait les spectres avant)
clear all
pathname='Figures'
pathname2='Figures/Average_Spectrums'
mkdir Figures
mkdir(fullfile(pathname,'Average_Spectrums'))

load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')

switch ExpeInfo.OptoStimulation
    
    case 'yes'
        disp('loading stim times')
        % Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
        load('LFPData/DigInfo6.mat')
        TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
        % TTL = colonne de temps au dessus de 0.99 pour avoir les 1 = stim ON
        
        TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
        % merge tous les temps des tim plus proche de 1 sec pour éviter les créneaux et le remplacer par un step entier d'une min
        
        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;
        
    case 'no'
        disp('no stims - simulating')
        if exist('SimulatedStims.mat')==0
        StimulateStimsWithTheta_VLPO
        end
        load('SimulatedStims.mat')
        events = sort([Range(RemStim,'s');Range(WakeStim,'s')]);
        Freq_Stim = ones(1,length(events))*20;
        TTLEpoch_merged = intervalSet(events*1e4,events*1e4+30*1e4);
end

StartStim_dansREM=Range(Restrict(ts(events*1E4),REMEpoch));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Pour checker combien de Stim par période
%Nb de stim
Stim=size(Start(TTLEpoch_merged),1)
%Nb de stim pendant le REM
StimREM=size(Start(and(TTLEpoch_merged,REMEpoch)),1)
%Nb de stim pendant le SWS
StimSWS=size(Start(and(TTLEpoch_merged,SWSEpoch)),1)
%Nb de stim pendant Wake
StimWAKE=size(Start(and(TTLEpoch_merged,Wake)),1)
%Matrice contenant les 4 valeurs précédentes 
MStim=[Stim StimREM StimSWS StimWAKE]

close all
fig = figure;
%%%Pour le VLPO
load('VLPO_Low_Spectrum')
SpectroV=Spectro
%%AveargeSpectre Stim REM (début stim en 0)
% [MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('VLPO REM')
% savefig(fullfile(pathname2,'VLPO_REM'))
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title({'VLPO REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'VLPO_REM'))

%%AverageSpectre Stim SWS 
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('VLPO SWS')
title({'VLPO SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'VLPO_SWS'))

%%AverageSpectre Stim Wake
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),Wake),500,300);
% title('VLPO Wake')
title({'VLPO Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'VLPO_Wake'))


%%%Pour le bulbe
load('Bulb_deep_Low_Spectrum.mat')
SpectroBl=Spectro;
%%AveargeSpectre Stim REM 
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('Bulb REM')
title({'Bulb REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'Bulb_REM'))

%%AverageSpectre Stim SWS 
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('Bulb SWS')
title({'Bulb SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'Bulb_SWS'))

%%AverageSpectre Stim Wake
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),Wake),500,300);
% title('Bulb Wake')
title({'Bulb Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'Bulb_Wake'))


%%%Pour le PFc
load('PFCx_deep_Low_Spectrum.mat')
SpectroP=Spectro;
%%AveargeSpectre Stim REM (0)
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('PFC REM')
title({'PFC REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'PFC_REM'))

%%AverageSpectre Stim SWS 
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('PFC SWS')
title({'PFC SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'PFC_SWS'))

%%AverageSpectre Stim Wake
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),Wake),500,300);
% title('PFC Wake')
title({'PFC Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'PFC_Wake'))


%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_sup_Low_Spectrum')
SpectroH=Spectro;
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('HPC REM')
title({'HPC REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC_REM'))

%%AverageSpectre Stim SWS 
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('HPC SWS')
title({'HPC SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC_SWS'))

%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),Wake),500,300);
% title('HPC Wake')
title({'HPC Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC_Wake'))


%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('HPC2 REM')
title({'HPC2 REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC2_REM'))

%%AverageSpectre Stim SWS 
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('HPC2 SWS')
title({'HPC2 SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC2_SWS'))

%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),Wake),500,300);
% title('HPC2 Wake')
title({'HPC2 Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC2_Wake'))




Panel_4spectres_par_region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
%%%%Bande Theta REM et SWS
clear all
pathname='Figures'
pathname2='Figures/Average_Spectrums'
load('LFPData/DigInfo6.mat')
load('SleepScoring_OBGamma.mat')
load('dHPC_deep_Low_Spectrum.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
sptsd = tsd(Spectro{2}*1e4, Spectro{1})

load('dHPC_sup_Low_Spectrum')
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);
clear M S
for i=1:length(Spectro{3})
    for  k =1:length(events)
 
    [M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
    end
end

figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on 
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)

Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-g',1); 
hold on

%%%%Plot pour la meme nuit la bande theta Stim SWS

events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,SWSEpoch);
events = Range(events);
clear M S
for i=1:length(Spectro{3})
    for  k =1:length(events)
 
    [M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
    end
end

%figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on 
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)

Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-r',1); 
hold on
filename='Theta_Stim-REM_SWS.fig'
savefig(fullfile(pathname,filename))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
%%%%%PlotRipRaw EMG REM

load('SleepScoring_OBGamma.mat')
load('dHPC_sup_Low_Spectrum')
SpectroH=Spectro

% Attention LFP5 pour ancien protocoles EIB16 et LFP13 pour BCI protocolEIB16 et LFP9
% pour pour BCI protocol EI32
load('LFPData/LFP9')
LFPemg=LFP
load('LFPData/DigInfo6.mat')
events=Start(TTLEpoch_merged)/1E4;
EVENTS=(Start(and(TTLEpoch_merged,REMEpoch)))/1E4

%figure
[M,T] = PlotRipRaw(LFPemg, EVENTS, 40000, 0, 1);
filename='Stim-EMG'
savefig(fullfile(pathname,filename))
