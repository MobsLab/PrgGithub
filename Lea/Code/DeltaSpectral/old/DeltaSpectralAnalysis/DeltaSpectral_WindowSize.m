%% Test Parameters Effect : 

%% LOAD DATA 

clear
cd('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243')
%cd('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/')
%cd('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/')


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

% ------------------------------------------ Parameters ? ------------------------------------------ :

freqband = [1 4] ; % beginning and end of frequency band, in Hz
spect_channel_name = 'ChannelDeep' ;
spect_channel = eval(spect_channel_name) ;

% Sliding window parameters : Cf. below


% ------------------------------------------ Get Spectrum / Bandpower ------------------------------------------ :

[Sp,t,f] = LoadSpectrumML(spect_channel,pwd,'low') ;
bandpow = mean(Sp(:,find(f>freqband(1) & f<freqband(2))),2);
bandpow_tsd = tsd(t*1E4,bandpow);




%% WINDOWSIZE EFFECT :

windowsize_list = [4 10 30 60 120 180 300 600 1200] ;
event_colors = {[0.1 0.1 0.45], [0.8 0.2 0.3], [0.4 0.0 0.1] };
Event_Names = {'Down', 'Delta', 'Deep "Delta"'} ;


for i = 1:length(windowsize_list)
    
    windowsize = windowsize_list(i) ;
    step = windowsize/2 ;
    window_starts = t(1):step:(t(end)-windowsize) ;
    all_timewindows = intervalSet(window_starts*1E4, (window_starts+windowsize)*1E4) ;
    
    mean_bandpow = intervalMean(bandpow_tsd,all_timewindows,'Time','middle');
    down_density = EventsDensity_LP(ts(Start(alldown_PFCx)), all_timewindows, 'union', 0); % average number of events per ts, for each timewindow
    delta_density = EventsDensity_LP(ts(Start(alldeltas_PFCx)), all_timewindows, 'union', 0); 
    deltadeep_density = EventsDensity_LP(ts(Start(deltas_deep)), all_timewindows, 'union', 0);
    
    corrcoeff.down{i} = getfield(corrcoef(Data(down_density),Data(mean_bandpow),'Rows','complete'),{2}) ;
    corrcoeff.delta{i} = getfield(corrcoef(Data(delta_density),Data(mean_bandpow),'Rows','complete'),{2}) ;
    corrcoeff.deltadeep{i} = getfield(corrcoef(Data(deltadeep_density),Data(mean_bandpow),'Rows','complete'),{2}) ;
    
end



figure,
hold on,
plot(cell2mat(corrcoeff.down),'.-','MarkerSize',10, 'Color', event_colors{1});
plot(cell2mat(corrcoeff.delta),'.-','MarkerSize',10, 'Color', event_colors{2});
plot(cell2mat(corrcoeff.deltadeep),'.-','MarkerSize',10, 'Color', event_colors{3});
xticklabels(windowsize_list);
xlabel('Windowsize (s)'); ylabel('Correlation Index'); legend({'Down','Delta','Deep Delta'},'Location','southeast');
title('Banpower x Event density Correlation : Effect of windowsize');