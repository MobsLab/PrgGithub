
%% QuantifEventsDuration : EVENT DURATION ANALYSIS across sleep session
%
% 27/04/2020 LP
%
% Script to quantif and plot delta waves and down states duration across one
% sleeping session. Plot delta wave shapes across session too.
%
% SEE : QuantifEventsDuration_simple (delta waves only)


% ------------------------------------- Choose Sleep Session ------------------------------------- :

%clear
% session = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243' ;
% cd(session)



%% ------------------------------------------ Load Data ------------------------------------------ :

% CHANNELS
load('ChannelsToAnalyse/PFCx_deep')
ChannelDeep = channel ;
load(['LFPData/LFP',num2str(channel)])
LFPdeep = LFP;

load('ChannelsToAnalyse/PFCx_sup')
ChannelSup = channel ;
load(['LFPData/LFP',num2str(channel)])
LFPsup = LFP;
clear channel LFP

% EVENTS
load("DownState.mat", 'alldown_PFCx')
load("DeltaWaves.mat", 'alldeltas_PFCx')
load("DeltaWavesChannels.mat", ['delta_ch_', num2str(ChannelDeep)],['delta_ch_', num2str(ChannelSup)] ) 
    deltas_deep = eval(['delta_ch_', num2str(ChannelDeep)]);
    deltas_sup = eval(['delta_ch_', num2str(ChannelSup)]);
    
% SUBSTAGES :
load('SleepSubstages.mat')

% REM & Wake Epochs
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;

% Clean SWS Epoch
SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
load NoiseHomeostasisLP TotalNoiseEpoch % noise
cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
% remove time before 1st REM episode from analysis epoch : 
cleanSWS = diff(cleanSWS,intervalSet(0,getfield(Start(REM),{1}))) ; 

% Zeitgeber time
load('behavResources.mat', 'NewtsdZT')    


%% ------------------------------------------ Duration Analysis ------------------------------------------ :

events = alldeltas_PFCx ; 
events_name = 'Delta Waves' ;

down_colors = {[0.25 0.7 0.9],[0.1 0.5 0.7],[0 0.25 0.65]} ; 
evt_colors = {[0.9 0.6 0.1],[0.75 0.3 0.1],[0.5 0.05 0.02]} ; 

% --------------------------- Duration Timecourse --------------------------- :

windowsize = 3 ; % window size for timecourse of mean events duration, in minutes

% Timewindows : 
events_ends = End(events) ; 
window_starts = 0:windowsize*60e4:events_ends(end) ; 

% Get mean duration of events and down states for each timewindow : 
evt_duration_timecourse = [] ; % in ms
down_duration_timecourse = [] ; % in ms

for start = window_starts
    window = intervalSet(start,start+windowsize*60e4) ; 
    SWS_window = intersect(window,cleanSWS) ; % restrict to SWS
    if tot_length(SWS_window) > 30e4 % keep mean duration only if total SWS window > 30s
        evt_duration = EventsDuration_LP(events, SWS_window, 'union', 1) ;
        down_duration = EventsDuration_LP(alldown_PFCx, SWS_window, 'union', 1) ;
        evt_duration_timecourse(end+1) = evt_duration / 10 ; % duration in ms
        down_duration_timecourse(end+1) = down_duration / 10 ; % duration in ms
    else
        evt_duration_timecourse(end+1) = NaN ;
        down_duration_timecourse(end+1) = NaN ;
    end
end


figure, 

subplot(3,1,1),
window_starts_ZT = (getfield(Data(NewtsdZT),{1}) + window_starts) /(3600e4) ; 
l1 = plot(window_starts_ZT,evt_duration_timecourse,'Color',evt_colors{2}) ;
hold on, l2 = plot(window_starts_ZT,down_duration_timecourse,'Color',down_colors{2}) ;
legend([l1,l2],{events_name,'Down States'}) ;
%xlim([window_starts_ZT(1),window_starts_ZT(end)+windowsize/60]) ; % extend plot to whole session (even if NaN)
xl = xlim(); ylabel('Mean Event Duration (ms)') ; xlabel('ZT Time (hour)') ;
nonan_starts = window_starts(~isnan(evt_duration_timecourse)) ; % times of the window_start with duration value (not NaN) -> used to divide data in begin/middle/end
title(['Mean Event Duration' newline],'Fontsize',14) ; 


% --------------------------- Mean Duration Bar Plots --------------------------- :


% Divide time of quantification (NaN excluded) in begin/middle/end : 

periods_names = {'begin','middle','end'} ; 
all_periods_duration = [] ; 
all_periods_duration_sem = [] ; 
all_periods_down_duration = [] ; 
all_periods_down_duration_sem = [] ; 

quantif_totalduration = (nonan_starts(end)+windowsize*60e4) - nonan_starts(1) ; 
quantif_duration = quantif_totalduration / 3 ; % duration of begin/middle/end periods
quantif_starts = nonan_starts(1):quantif_duration:nonan_starts(end) ; 



% For each period (begin/middle/end) :

for i = 1:length(periods_names) 
    
    % Plot time limits for periods on timecourse above : 
    hold on,
    xline((getfield(Data(NewtsdZT),{1})+quantif_starts(i)) /(3600e4),'--','Color',[0 0 0],'HandleVisibility','off');
    xline((getfield(Data(NewtsdZT),{1})+quantif_starts(i)+quantif_duration) /(3600e4),'--','Color',[0 0 0],'HandleVisibility','off');
    
    % Timewindow :
    period_window = intervalSet(quantif_starts(i),quantif_starts(i)+quantif_duration) ;
    SWS_period_window = intersect(period_window,cleanSWS) ; % restrict to SWS
    
    % Get event duration :
    evt_duration = EventsDuration_LP(events, SWS_period_window, 'union', 1) ; % mean duration
    evt_duration_sem = EventsDuration_LP(events, SWS_period_window, 'union', 1, 'function', 'sem') ; % sem on duration
    all_periods_duration(i) = evt_duration /10 ; %in ms
    all_periods_duration_sem(i) = evt_duration_sem /10 ;
    
    % Get down duration :
    down_duration = EventsDuration_LP(alldown_PFCx, SWS_period_window, 'union', 1) ; % mean duration
    down_duration_sem = EventsDuration_LP(alldown_PFCx, SWS_period_window, 'union', 1, 'function', 'sem') ; % sem on duration
    all_periods_down_duration(i) = down_duration /10 ; %in ms
    all_periods_down_duration_sem(i) = down_duration_sem /10 ;
    
end    
  

% Bar Plot :

% Delta Waves :
subplot(3,2,3),
x_bar = [1 2 3] ;
for i = 1:length(all_periods_duration)
    hold on,
    b = bar(x_bar(i),all_periods_duration(i),'LineStyle','none'); ylabel('Mean Event Duration (ms)') ; 
    set(b,'FaceColor',evt_colors{i})
end    
%ylim([min(all_periods_duration(:))-5,max(all_periods_duration(:))+5]) ;
ylim([0,max(all_periods_duration(:))+5]) ;

set(gca,'XTick',x_bar,'XtickLabels',periods_names); title([events_name ' Duration']) ;
hold on, errorbar(x_bar,all_periods_duration,all_periods_duration_sem,all_periods_duration_sem,'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;  
title('Delta Waves') ; 

% Down States :
subplot(3,2,5),
x_bar = [1 2 3] ;
for i = 1:length(all_periods_down_duration)
    hold on,
    b = bar(x_bar(i),all_periods_down_duration(i),'LineStyle','none'); ylabel('Mean Event Duration (ms)') ; 
    set(b,'FaceColor',down_colors{i})
end    
%ylim([min(all_periods_down_duration(:))-5,max(all_periods_down_duration(:))+5]) ;
ylim([0,max(all_periods_down_duration(:))+5]) ;
set(gca,'XTick',x_bar,'XtickLabels',periods_names); title([events_name ' Duration']) ;
hold on, errorbar(x_bar,all_periods_down_duration,all_periods_down_duration_sem,all_periods_down_duration_sem,'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;  
title('Down States') ;






% --------------------------- Mean LFP shape of delta waves --------------------------- :


% For each period (begin/middle/end) :
all_event_starts = Start(events) ; 

% LFP sup :
subplot(3,2,4),   
title('Sup LFP around Delta Wave') ;
for i = 1:length(periods_names)
    % Get events from SWS for this period 
    period_window = intervalSet(quantif_starts(i),quantif_starts(i)+quantif_duration) ;
    SWS_period_window = intersect(period_window,cleanSWS) ; % restrict to SWS
    period_events = all_event_starts(belong(SWS_period_window,all_event_starts)) ;
    % Plot LFP shape
    [msup,ssup,tsup]=mETAverage(period_events,Range(LFPsup),Data(LFPsup),1,1000);
    hold on, plot(tsup,msup,'Color',evt_colors{i}); ylim([-1000 1000]) ; xlim([-300,400]) ;
     
end    
legend(periods_names) ; %xlabel('Time around delta wave start (ms)') ;  


% LFP deep :
subplot(3,2,6),
title('Deep LFP around Delta Wave') ;
for i = 1:length(periods_names)
    % Get events from SWS for this period 
    period_window = intervalSet(quantif_starts(i),quantif_starts(i)+quantif_duration) ;
    SWS_period_window = intersect(period_window,cleanSWS) ; % restrict to SWS
    period_events = all_event_starts(belong(SWS_period_window,all_event_starts)) ;
    % Plot LFP shape
    [mdeep,sdeep,tdeep]=mETAverage(period_events,Range(LFPdeep),Data(LFPdeep),1,1000);  
    hold on, plot(tdeep,mdeep,'Color',evt_colors{i}); ylim([-1000 2000]) ; xlim([-300,400]) ;
end    
legend(periods_names) ; xlabel('Time around delta wave start (ms)') ;    


