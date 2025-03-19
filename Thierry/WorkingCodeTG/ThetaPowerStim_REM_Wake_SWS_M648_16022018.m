
pathname='Figures'
pathname2='Figures/Average_Spectrums'
mkdir Figures
mkdir(fullfile(pathname,'Average_Spectrums'))

load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')
load('H_Low_Spectrum')
SpectroH=Spectro;
load('Bulb_deep_Low_Spectrum')
SpectroB=Spectro;
load('VLPO_Low_Spectrum')
SpectroV=Spectro;
load('PFCx_deep_Low_Spectrum')
SpectroP=Spectro;

switch ExpeInfo.OptoStimulation
    
    case 'yes'
        disp('loading stim times')
        % Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
        load('LFPData/DigInfo2.mat')
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

sptsd = tsd(Spectro{2}*1e4, Spectro{1})

ev=ts(events*1E4);
NevREM=length(Range(Restrict(ev,REMEpoch)))
NevSWS=length(Range(Restrict(ev,SWSEpoch)))
NevWake=length(Range(Restrict(ev,Wake)))
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
evW=Range(Restrict(ev,Wake),'s');

%%%%%%%%%%%%%
%%%theta power pendant le wake
%%%%%%%%%%%%%%%%
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
events=ts(events*1e4);
events=Restrict(events,Wake);
events = Range(events);

clear M S
for i=1:length(Spectro{3})
    for  k =1:length(events)
 
    [M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),1000,1000);
    end
end

%figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on 
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)

figure
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t/1e4,Data_Mat,{@mean,@stdError},'-b',1);
hold on
filename='Theta_Stim-Wake.fig'
savefig(fullfile(pathname,filename))



%%%%%%%%%%%%%
%%%theta power pendant le SWS
%%%%%%%%%%%%%
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
events=ts(events*1e4);
events=Restrict(events,SWSEpoch);
events = Range(events);

clear M S
for i=1:length(Spectro{3})
    for  k =1:length(events)
 
    [M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),1000,1000);
    end
end

%figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on 
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)

Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t/1e4,Data_Mat,{@mean,@stdError},'-r',1); 
hold on
filename='Theta_Stim-SWS.fig'
savefig(fullfile(pathname,filename))


%%%%%%%%%%%%%%%
%%%theta power pendant le rem
%%%%%%%%%%%%%%%%%%
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
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);

clear M S
for i=1:length(Spectro{3})
    for  k =1:length(events)
 
    [M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),1000,1000);
    end
end

%figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on 
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)

Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t/1e4,Data_Mat,{@mean,@stdError},'-g',1); 
hold on
filename='Theta_Stim-Wake.fig'
savefig(fullfile(pathname,filename))

xlabel(time (s))
xlim([-30 +20])

