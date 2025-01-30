%% %% Bandpower and Slow Rythms : EVENT / INTEREVENT duration ratio

% Etablir le lien entre la puissance (pour différentes bandes de fréquences : 1-4Hz ou bien 1-2Hz, 2-3Hz, et 3-4Hz)
% et 1) la densité de delta waves (2ch), slow waves (positives ou négatives) et down states
%    2) l'interval inter-delta/slow waves
%    3) durée des DOWN ou durée des UPs
%    4) régularité de la durée des DOWN ou des UPs


clear
cd('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243')



% ------------------------------------------ Load Data ------------------------------------------ :

% LFP
load('ChannelsToAnalyse/PFCx_deep')
load(['LFPData/LFP',num2str(channel)])
LFPdeep = LFP;
ChannelDeep = channel ;
clear LFP channel

load('ChannelsToAnalyse/PFCx_sup')
load(['LFPData/LFP',num2str(channel)])
LFPsup = LFP;
ChannelSup = channel ;
clear LFP channel


% Events
load("DownState.mat", 'alldown_PFCx')
load("DeltaWaves.mat", 'alldeltas_PFCx')
load("DeltaWavesChannels.mat", ['delta_ch_', num2str(ChannelDeep)],['delta_ch_', num2str(ChannelSup)] ) 
    deltas_deep = eval(['delta_ch_', num2str(ChannelDeep)]);
    deltas_sup = eval(['delta_ch_', num2str(ChannelSup)]);


% Substages
load('SleepSubstages.mat')
N1 = Epoch{strcmpi(NameEpoch,'N1')} ; N2 = Epoch{strcmpi(NameEpoch,'N2')} ; N3 = Epoch{strcmpi(NameEpoch,'N3')} ;  
REM = Epoch{strcmpi(NameEpoch,'REM')} ; WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
substages_list = {N1, N2, N3, REM, WAKE} ;


%% BANDPOWER & EVENTS / INTEREVENTS DURATION

% ------------------------------------------ Parameters ? ------------------------------------------ :

freqband = [1 4] ; % beginning and end of frequency band, in Hz
spect_channel_name = 'ChannelDeep' ;
spect_channel = eval(spect_channel_name) ;
events_name = 'Delta' ; % down/up or delta/interdelta
events = alldeltas_PFCx ;

% ------------------------------------------ Get Spectrum / Bandpower ------------------------------------------ :

[Sp,t,f] = LoadSpectrumML(spect_channel,pwd,'low') ;
bandpow = mean(Sp(:,find(f>freqband(1) & f<freqband(2))),2);
bandpow_tsd = tsd(t*1E4,bandpow);





%%  ------------------------------------------ Analyses : sliding window ------------------------------------------ :

% --- Parameters --- :

windowsize = 120 ; % duration of sliding window, in seconds
step = windowsize/2 ; % time step between starts of 2 successive sliding windows, in seconds
restrict_to_sleep = 0 ;

% --- Sliding timeWindows --- :
window_starts = t(1):step:(t(end)-windowsize) ;
all_timewindows = intervalSet(window_starts*1E4, (window_starts+windowsize)*1E4) ;


% --- Get info about events --- :

evt_duration = EventsDuration_LP(events, all_timewindows, 'union', 0, 'function','mean') ;
interevt_duration = IntereventsDuration_LP(events, all_timewindows, 'union', 0, 'function','mean') ;
ratio_duration = tsd(Range(evt_duration),Data(evt_duration)./Data(interevt_duration)); 

plot_colors = {[0.1 0.1 0.45], [0.8 0.2 0.3], [0.4 0.0 0.1] };
mean_quantif = {evt_duration, interevt_duration, ratio_duration} ;
Quantif_Names = {'Evt', 'InterEvt', 'Ratio Evt/InterEvt'} ;
mean_bandpow = intervalMean(bandpow_tsd,all_timewindows,'Time','middle');



% RESTRICT TO SLEEP only :
if restrict_to_sleep
    evt_duration = replaceinTSD(evt_duration,WAKE,NaN);   
    interevt_duration = replaceinTSD(interevt_duration,WAKE,NaN);  
    ratio_duration = replaceinTSD(ratio_duration,WAKE,NaN);  
    mean_bandpow = replaceinTSD(mean_bandpow,WAKE,NaN);  
end



% --- Plot --- :
figure,

% Substages :
subplot(4,3,[1 2]),
legendhandle = [];
yplot_list = [3 2 1 4 5] ; % order of the different substages on the plot
for i = 1:length(substages_list)
    s = Start(substages_list{i})/(3600*1E4);
    e = End(substages_list{i})/(3600*1E4);
    yplot = yplot_list(i)*0.5 ;
    hold on, c = plot([s,e],[yplot,yplot], 'color', subst_colors{i}, 'LineWidth', 4) ;
    legendhandle = [legendhandle, c(1)] ;
end
ylim([0,(length(substages_list)+1)*0.5]), xlim(xl), set(gca,'ytick',[]);
legend(legendhandle,{'N1','N2','N3','REM','Wake'}, 'Location', 'northoutside', 'Orientation', 'horizontal');

% mean BandPower timecourse :
subplot(4,3,[4 5 7 8]),
t_bandpow = Range(mean_bandpow)/(3600*1E4) ;
plot(t_bandpow,Data(mean_bandpow)), xlim([t_bandpow(1) t_bandpow(end)]); xl=xlim;;
title('Mean Bandpower');



% Mean quantif timecourse :
for k = 1:length(mean_quantif) 
    quantif = mean_quantif{k};
    subplot(4,3,[9+k]),
    plot(Range(quantif)/(3600*1E4), Data(quantif)/10, 'Color', plot_colors{k}) % duration in ms
    title(Quantif_Names{k},'Color',plot_colors{k}), xlabel('time (hours)'), xlim([-inf inf]);
    if k<3
        ylabel('duration (ms)');
    end
end

%CorrCoeff
subplot(4,3,[6 9])
for k = 1:length(mean_quantif) 
    quantif = mean_quantif{k};
    r = corrcoef(Data(mean_bandpow), Data(quantif),'Rows','complete'); % 'Rows' option to remove NaN values
    CorrCoeff(k) = r(2) ;
    b = bar(k,r(2));
    text(k,r(2)+sign(r(2))*0.06,num2str(r(2)),'Color',plot_colors{k},'HorizontalAlignment','center') ;
    set(b,'FaceColor', plot_colors{k}), hold on;
end
ymax = max(CorrCoeff); ymin = min(CorrCoeff); ylim([min(0,ymin+ymin/2), max(0.1,ymax+ymax/2)]);
%legend(Event_Names,'location','eastoutside','orientation','vertical','Box','on');
set(gca,'XTick',[]), hold on;
title(['Correlation between Mean Bandpower' newline 'and event/inter-event Durations'])

set(findall(gcf,'-property','FontSize'),'FontSize',10);
legend(Quantif_Names,'location','northeast','orientation','horizontal','Box','off','FontSize',8.5);


% TEXT
subplot(4,3,3),
text(0.5,0.85,sprintf('Frequency Band : %d - %d Hz',freqband(1),freqband(2)), 'FontSize', 15, 'HorizontalAlignment','center'), axis off ;
text(0.5,0.60,['Events : ' events_name], 'FontSize', 15, 'HorizontalAlignment','center'), axis off ;
text(0.5,0.35,sprintf(['Bandpower Channel : ' spect_channel_name],freqband(1),freqband(2)), 'FontSize', 10, 'HorizontalAlignment','center'), axis off ;
text(0.5,0.20,['Windowsize: ' num2str(windowsize) ' s, step: ' num2str(step) ' s'], 'FontSize', 10, 'HorizontalAlignment','center'), axis off ;