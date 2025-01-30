
%% QuantifEventsDuration_simple : EVENT DURATION ANALYSIS across sleep session
%
% 27/04/2020 LP
%
% Script to quantif and plot delta waves duration across one
% sleeping session. Plot delta wave shapes across session too.
%
% SEE : QuantifEventsDuration (delta waves and down states)


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
% Clean SWS Epoch
load('SleepSubstages.mat')
SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
load NoiseHomeostasisLP TotalNoiseEpoch % noise
cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
% REM & Wake Epochs
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
% Zeitgeber time
load('behavResources.mat', 'NewtsdZT')    


%% ------------------------------------------ Duration Analysis ------------------------------------------ :

events = alldeltas_PFCx ; 
quantif_color = [1 0.7 0.1] ; 
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65]} ;

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
        evt_duration_timecourse(end+1) = evt_duration / 10 ; % duration in ms
    else
        evt_duration_timecourse(end+1) = NaN ;
    end
end


figure, 

subplot(3,1,1),
window_starts_ZT = (getfield(Data(NewtsdZT),{1}) + window_starts) /(3600e4) ; 
plot(window_starts_ZT,evt_duration_timecourse,'Color',quantif_color)
%xlim([window_starts_ZT(1),window_starts_ZT(end)+windowsize/60]) ; % extend plot to whole session (even if NaN)
xl = xlim(); ylabel('Mean Event Duration (ms)') ; xlabel('ZT Time (hour)') ;
nonan_starts = window_starts(~isnan(evt_duration_timecourse)) ; % times of the window_start with duration value (not NaN)
title(['Mean Event Duration' newline],'Fontsize',14) ; 


% --------------------------- Mean Duration Bar Plots --------------------------- :


% Divide time of quantification (NaN excluded) in begin/middle/end : 

periods_names = {'begin','middle','end'} ; 
all_periods_duration = [] ; 
all_periods_duration_sem = [] ; 

quantif_totalduration = (nonan_starts(end)+windowsize*60e4) - nonan_starts(1) ; 
quantif_duration = quantif_totalduration / 3 ; % duration of begin/middle/end periods
quantif_starts = nonan_starts(1):quantif_duration:nonan_starts(end) ; 



% For each period (begin/middle/end) :

for i = 1:length(periods_names) 
    
    % Plot time limits for periods on timecourse above : 
    hold on,
    xline((getfield(Data(NewtsdZT),{1})+quantif_starts(i)) /(3600e4),'--','Color',[0 0 0]);
    xline((getfield(Data(NewtsdZT),{1})+quantif_starts(i)+quantif_duration) /(3600e4),'--','Color',[0 0 0]);
    
    % Timewindow :
    period_window = intervalSet(quantif_starts(i),quantif_starts(i)+quantif_duration) ;
    SWS_period_window = intersect(period_window,cleanSWS) ; % restrict to SWS
    
    % Get event duration :
    evt_duration = EventsDuration_LP(events, SWS_period_window, 'union', 1) ; % mean duration
    evt_duration_sem = EventsDuration_LP(events, SWS_period_window, 'union', 1, 'function', 'sem') ; % sem on duration
    all_periods_duration(i) = evt_duration /10 ; %in ms
    all_periods_duration_sem(i) = evt_duration_sem /10 ;
    
end    
  

% Bar Plot :
subplot(3,1,2),
x_bar = (quantif_starts+quantif_duration/2+getfield(Data(NewtsdZT),{1}))/(3600e4) ;
x_bar = categorical(periods_names); x_bar = reordercats(x_bar,periods_names) ;
b = bar(x_bar,all_periods_duration,0.5,'LineStyle','none'); ylabel('Mean Event Duration (ms)') ; ylim([min(all_periods_duration)-5,max(all_periods_duration)+5]) ;
b.FaceColor = quantif_color ; 
%set(gca,'XtickLabels',periods_names); xlim(xl) ;
hold on, errorbar(x_bar,all_periods_duration,all_periods_duration_sem,all_periods_duration_sem,'Color',[0 0 0], 'LineStyle','none') ;  




% --------------------------- Mean LFP shape of delta waves --------------------------- :


% For each period (begin/middle/end) :
all_event_starts = Start(events) ; 

for i = 1:length(periods_names)
    
    % Get events from SWS for this period 
    period_window = intervalSet(quantif_starts(i),quantif_starts(i)+quantif_duration) ;
    SWS_period_window = intersect(period_window,cleanSWS) ; % restrict to SWS
    period_events = all_event_starts(belong(SWS_period_window,all_event_starts)) ;
    
    [mdeep,sdeep,tdeep]=mETAverage(period_events,Range(LFPdeep),Data(LFPdeep),1,1000);
    [msup,ssup,tsup]=mETAverage(period_events,Range(LFPsup),Data(LFPsup),1,1000);
    
    % Plot LFP shape
    subplot(3,3,6+i),
    plot(tdeep,mdeep,'Color',LFP_colors{2}) 
    hold on, plot(tsup,msup,'Color',LFP_colors{1});
    
    %legend({'LFP sup','LFP deep'},'location','southoutside','orientation','horizontal') ;  
    legend({'LFP deep','LFP sup'},'location','northwest') ; xlabel('Time around delta wave start (ms)') ;
    %title('LFP around delta waves') ;  
end    
    


