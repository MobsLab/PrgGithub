%% %% Bandpower and Slow Rythms : EVENT / INTEREVENT DURATIONS 

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

windowsize = 20 ; % duration of sliding window, in seconds
step = windowsize/2 ; % time step between starts of 2 successive sliding windows, in seconds
restrict_to_sleep = 0 ;

% --- Sliding timeWindows --- :
window_starts = t(1):step:(t(end)-windowsize) ;
all_timewindows = intervalSet(window_starts*1E4, (window_starts+windowsize)*1E4) ;


% --- Get info about events --- :

evt_duration = EventsDuration_LP(events, all_timewindows, 'union', 0, 'function','mean') ;
interevt_duration = IntereventsDuration_LP(events, all_timewindows, 'union', 0, 'function','mean') ;
evt_duration_var = EventsDuration_LP(events, all_timewindows, 'union', 0, 'function','var') ; 

plot_colors = {[0.1 0.1 0.45], [0.8 0.2 0.3], [0.4 0.0 0.1] };
mean_quantif = {evt_duration, interevt_duration, evt_duration_var} ;
Quantif_Names = {'Evt', 'InterEvt', 'Var of Evt'} ;
mean_bandpow = intervalMean(bandpow_tsd,all_timewindows,'Time','middle');


% RESTRICT TO SLEEP only :
if restrict_to_sleep
    evt_duration = replaceinTSD(evt_duration,WAKE,NaN);   
    interevt_duration = replaceinTSD(interevt_duration,WAKE,NaN);  
    evt_duration_var = replaceinTSD(evt_duration_var,WAKE,NaN);  
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
    title(Quantif_Names{k},'Color',plot_colors{k})
    ylabel('duration (ms)'), xlabel('time (hours)'), xlim([-inf inf]);
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



%%  ------------------------------------------ Analyses : substages ------------------------------------------ :



subst_colors = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage colors
plot_colors = {[0.1 0.1 0.45], [0.8 0.2 0.3], [0.4 0.0 0.1] };

% Get occupancy of different events, for different substages : 


for i = 1:length(substages_list)
    
    evt_duration_subst{i} = EventsDuration_LP(events, substages_list{i}, 'union', 1, 'function','mean') ;
    evt_duration_subst_sem{i} = EventsDuration_LP(events, substages_list{i}, 'union', 1, 'function','sem') ;
    interevt_duration_subst{i} = IntereventsDuration_LP(events, substages_list{i}, 'union', 1, 'function','mean') ;
    interevt_duration_subst_sem{i} = IntereventsDuration_LP(events, substages_list{i}, 'union', 1, 'function','sem') ;
    evt_duration_var_subst{i} = EventsDuration_LP(events, substages_list{i}, 'union', 1, 'function','var') ; 
    
    bandpow_substage{i} = mean(Data(Restrict(bandpow_tsd,substages_list{i})));
    
end



% --- Plot --- :

figure,

% Bandpower
subplot(5,4,[5 6 9 10]), plot(t/3600,bandpow,'color', [0.1 0.1 0.1]);
xlim([-inf inf]), xl=xlim; xlabel('time (hours)');
title(sprintf('Bandpower (%d - %d Hz)',freqband(1),freqband(2)));

% plot substages :
subplot(5,4,[1 2]),
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


% Mean Bandpower :
subplot(5,4,[13 17]), 
for i =1:length(bandpow_substage)
    b = bar(i,bandpow_substage{i});
    set(b,'FaceColor',subst_colors{i}), hold on;
end
ymax = max(cell2mat(bandpow_substage)); ylim([0,ymax+ymax/7]);
set(gca, 'XTickLabel',{'N1','N2','N3','REM','Wake'}, 'XTick',1:5), hold on;
title('Mean Bandpower');


% Mean quantif :

mean_quantif = {evt_duration_subst, interevt_duration_subst} ;
sem = {evt_duration_subst_sem, interevt_duration_subst_sem} ;
Quantif_Names = {'Evt', 'InterEvt', 'Var of Evt'} ;

for k = 1:length(mean_quantif) 
    quantif = mean_quantif{k};
    subplot(5,4,[13+k 17+k]),
    
    for i =1:length(quantif)
        b = bar(i,quantif{i}/10); % in ms
        set(b,'FaceColor',subst_colors{i}), hold on;
    end
    
    set(gca, 'XTickLabel',{'N1','N2','N3','REM','Wake'}, 'XTick',1:5), hold on;
    title([Quantif_Names{k} ' Duration'],'Color',plot_colors{k})
    ylabel('duration (ms)');
    
    hold on,
    if k <= length(sem)
        errorbar(1:length(quantif),cell2mat(quantif)/10,cell2mat(sem{k})/10,cell2mat(sem{k})/10, 'Color',[0 0 0], 'LineStyle','none') 
    end
    %ymax = max(cell2mat(quantif)); ylim([0,ymax+ymax/7]);
end


% Event Duration Variance : 

subplot(5,4,[16 20]),
for i =1:length(evt_duration_var_subst)
        b = bar(i,evt_duration_var_subst{i}/100); % in ms
        set(b,'FaceColor',subst_colors{i}), hold on;
end
set(gca, 'XTickLabel',{'N1','N2','N3','REM','Wake'}, 'XTick',1:5), hold on;
title('Var of Evt Duration','Color',plot_colors{3})
ymax = max(cell2mat(evt_duration_var_subst)/100); ylim([0,ymax+ymax/7]);
    



% Correlation Plot :
all_quantif = mean_quantif ;
all_quantif{end+1} = evt_duration_var_subst ;

subplot(5,4,[7 8 11 12]),
for k = 1:length(all_quantif) 
    quantif = all_quantif{k};
    r = corrcoef(cell2mat(bandpow_substage), cell2mat(quantif));
    CorrCoeff(k) = r(2) ;
    b = bar(k,r(2));
    text(k,r(2)+sign(r(2))*0.08,num2str(r(2)),'Color',plot_colors{k},'HorizontalAlignment','center') ;
    set(b,'FaceColor', plot_colors{k}), hold on;
end
ymax = max(CorrCoeff); ymin = min(CorrCoeff); ylim([min(0,ymin+ymin/2), max(0.2,ymax+ymax/2)]);
%legend(Event_Names,'location','eastoutside','orientation','vertical','Box','on');
legend(Quantif_Names,'location','south','orientation','horizontal','Box','off');
set(gca,'XTick',[]), hold on;
title(['Correlation between Mean Bandpower' newline 'and event/inter-event Duration'])

set(findall(gcf,'-property','FontSize'),'FontSize',9);

subplot(5,4,[3 4]),
text(0.5,0.7,sprintf('Frequency Band : %d - %d Hz',freqband(1),freqband(2)), 'FontSize', 15, 'HorizontalAlignment','center'), axis off ;
text(0.5,0.45,['Events : ' events_name], 'FontSize', 15, 'HorizontalAlignment','center'), axis off ;
text(0.5,0.20,['Bandpower Channel : ' spect_channel_name], 'FontSize', 12, 'HorizontalAlignment','center'), axis off ;
