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
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim SWS 
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('VLPO SWS')
title({'VLPO SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'VLPO_SWS'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim Wake
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),Wake),500,300);
% title('VLPO Wake')
title({'VLPO Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'VLPO_Wake'))
colormap(jet)
caxis([20 48])


%%%Pour le bulbe
load('Bulb_deep_Low_Spectrum.mat')
SpectroBl=Spectro;
%%AveargeSpectre Stim REM 
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('Bulb REM')
title({'Bulb REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'Bulb_REM'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim SWS 
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('Bulb SWS')
title({'Bulb SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'Bulb_SWS'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim Wake
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),Wake),500,300);
% title('Bulb Wake')
title({'Bulb Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'Bulb_Wake'))
colormap(jet)
caxis([20 48])


%%%Pour le PFc
load('PFCx_deep_Low_Spectrum.mat')
SpectroP=Spectro;
%%AveargeSpectre Stim REM (0)
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('PFC REM')
title({'PFC REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'PFC_REM'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim SWS 
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('PFC SWS')
title({'PFC SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'PFC_SWS'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim Wake
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),Wake),500,300);
% title('PFC Wake')
title({'PFC Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'PFC_Wake'))
colormap(jet)
caxis([20 48])


%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_sup_Low_Spectrum')
SpectroH=Spectro;
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('HPC REM')
title({'HPC REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC_REM'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim SWS 
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
% title('HPC SWS')
title({'HPC SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC_SWS'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),Wake),500,300);
% title('HPC Wake')
title({'HPC Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC_Wake'))
colormap(jet)
caxis([20 48])


%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
% title('HPC2 REM')
title({'HPC2 REM ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC2_REM'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim SWS 
function [SpectroBrem,SpectroBsws,SpectroBwake,facREM,facSWS,facWake,valBetaREM,valBetaSWS,valBetaWake,freqB,temps] = PlotBETAPowerOverTime_SingleMouse_MC(plo)

try
    plo;
catch
    plo=0;
end

load SleepScoring_OBGamma REMEpoch SWSEpoch Wake 
load Bulb_deep_High_Spectrum
SpectroB=Spectro;
freqB=Spectro{3};

clear datOBnew
datOB = Spectro{1};
for k = 1:size(datOB,2)
    datOBnew(:,k) = runmean(datOB(:,k),500); % to smooth the high freq spectro
end

sptsdB=tsd(SpectroB{2}*1e4, datOBnew); % make tsd
% sptsdB= tsd(SpectroB{2}*1e4, SpectroB{1});


[Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch); % to find optogenetic stimulations
events=Stim;


[MB_wake,SB_wake,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),WakeWiNoise),500,500,0);
[MB_REM,SB_REM,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),REMEpochWiNoise),500,500,0);
[MB_SWS,SB_SWS,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),SWSEpochWiNoise),500,500,0);


SpectroBrem=MB_REM;
SpectroBsws=MB_SWS;
SpectroBwake=MB_wake;

% SpectroBrem=MB_REM/median(MB_REM(:));
% SpectroBsws=MB_SWS/median(MB_SWS(:));
% SpectroBwake=MB_wake/median(MB_wake(:));


% SpectroBrem=MB_REM/mean(MB_REM(1:floor(length(MB_REM))/2))*100;
% SpectroBsws=MB_SWS/mean(MB_SWS(1:floor(length(MB_SWS))/2))*100;
% SpectroBwake=MB_wake/mean(MB_wake(1:floor(length(MB_wake))/2))*100;


runfac=4;
temps=tps/1E3;

% freqS=[1:size(SpectroSWS,1)]/size(SpectroSWS,1)*20;
% freqW=[1:size(SpectroWake,1)]/size(SpectroWake,1)*20;


% freqB=[1:size(SpectroBrem,1)]/size(SpectroBrem,1)*20;

idx1=find(freqB>21&freqB<25);
tpsidx=find(temps>-30&temps<0);



% ratio=mean(SpectroREM(idx1,:),1)./mean(SpectroREM(idx2,:),1);
valBetaREM=mean(SpectroBrem(idx1,:),1);
valBetaSWS=mean(SpectroBsws(idx1,:),1);
valBetaWake=mean(SpectroBwake(idx1,:),1);

facREM=mean(valBetaREM(tpsidx));
facSWS=mean(valBetaSWS(tpsidx));
facWake=mean(valBetaWake(tpsidx));

stdfacREM=std(valBetaREM(tpsidx));
stdfacSWS=std(valBetaSWS(tpsidx));
stdfacWake=std(valBetaWake(tpsidx));

if plo
    
    figure('color',[1 1 1]),
    subplot(231), imagesc(temps,freqB, SpectroBrem), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([200 7000])
    title('OB REM')
    subplot(232), imagesc(temps,freqB, SpectroBsws), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([200 7000])
    title('OB NREM')
    subplot(233), imagesc(temps,freqB, SpectroBwake), axis xy,colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([200 7000])
    title('OB Wake')
    
    
    subplot(234),plot(temps,mean(SpectroBrem(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBrem(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-60 +60])
    xlabel('time (s)')
%     ylim([0.4 1.2])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(235),plot(temps,mean(SpectroBsws(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBsws(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
    line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
%     ylim([0.4 1.2])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(236),plot(temps,mean(SpectroBwake(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBwake(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
    line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
%     ylim([0.4 1.2])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
end% title('HPC2 SWS')
title({'HPC2 SWS ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC2_SWS'))
colormap(jet)
caxis([20 48])

%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),Wake),500,300);
% title('HPC2 Wake')
title({'HPC2 Wake ',num2str(ExpeInfo.Date),'M',num2str(ExpeInfo.nmouse)})
savefig(fullfile(pathname2,'HPC2_Wake'))
colormap(jet)
caxis([20 48])




Panel_4spectres_par_region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
%%%%Bande Theta REM et SWS
clear all
pathname='Figures'
pathname2='Figures/Average_Spectrums'
load('LFPData/DigInfo2.mat')
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

%%%%Plot pour la meme nuit la bande theta Stim Wake

events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,Wake);
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
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-b',1); 
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
load('LFPData/LFP5')
LFPemg=LFP
load('LFPData/DigInfo2.mat')
events=Start(TTLEpoch_merged)/1E4;
EVENTS=(Start(and(TTLEpoch_merged,REMEpoch)))/1E4

%figure
[M,T] = PlotRipRaw(LFPemg, EVENTS, 40000, 0, 1);
filename='Stim-EMG'
savefig(fullfile(pathname,filename))
