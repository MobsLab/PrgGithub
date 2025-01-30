%% SPECTRAL POWER & SLOW OSCILLATIONS / EVENTS :

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




% ------------------------------------------ Parameters ------------------------------------------ :

windowsize = 30 ; % duration of sliding window, in seconds
step = 15 ; % time step between starts of 2 successive sliding windows, in seconds
freqband = [1 4] ; % beginning and end of frequency band, in Hz

%events = deltas_deep ; % IntervalSet of events to analyse
%events = down_PFCx ;
events = deltas_PFCx ;

% ------------------------------------------ Analyse Data ------------------------------------------ :

% SPECTRAL POWER

[Sp, t, f] = LoadSpectrumML(ChannelSup, pwd, 'low');
% Stsd=tsd(t*1E4,Sp);

% figure, imagesc(Range(Stsd,'s'),f,10*log10(Data(Stsd)')), axis xy % Spectrogram
% figure, plot(f,mean(Data(Restrict(Stsd,REMEpoch)))) % Spectral Power Distribution during REM

intervals_start = t(1):step:(t(end)-windowsize) ; %starting times for all successive windows
event_start = Start(events)/(1E4) ; % Starting time of events, in s

spectral_power_all = [] ;
event_freq_all = [] ;


for window_start = intervals_start
    
    % Spectral Power
    window_idx = find(t>window_start & t<(window_start+windowsize)); % idx of time points for this timewindow
    pow=mean(Sp(window_idx,find(f>freqband(1) & f<freqband(2))),'all'); % band-freq spectral power, averaged over sliding timewindow
    spectral_power_all = [spectral_power_all, pow];

    % Events Density within same timewindow 
    
    event_nb = sum(event_start>window_start & event_start<(window_start+windowsize)) ;
    event_freq_all = [event_freq_all, event_nb/windowsize] ; % number of events per second within this timewindow (occurrence frequency)
    
    
end

figure, plot(intervals_start, spectral_power_all)
figure, plot(intervals_start, event_freq_all)





%
R = corrcoef(spectral_power_all, down_freq_all)
R = corrcoef(spectral_power_all, delta_freq_all)
R = corrcoef(spectral_power_all, deltadeep_freq_all)
R = corrcoef(delta_freq_all, down_freq_all)






% -------------------------------------------- PLOTS ------------------------------------------------ :

% PARAM :
windowsize = 30 ; % duration of sliding window, in seconds
step = windowsize/2 ; % time step between starts of 2 successive sliding windows, in seconds
freqband_list = {[1 4],[1 2],[2 3],[3 4]};
spectr_channel = ChannelDeep ;




% DATA :
[Sp, t, f] = LoadSpectrumML(spectr_channel , pwd, 'low');
intervals_start = t(1):step:(t(end)-windowsize) ; %starting times for all successive windows

down_starts = Start(alldown_PFCx)/(1E4);
delta_starts = Start(alldeltas_PFCx)/(1E4);
deltadeep_starts = Start(deltas_deep)/(1E4);
deltasup_starts = Start(deltas_sup)/(1E4);



%------- PLOT ------ :

clearvars eventfreq
freqband = freqband_list{2};
spectral_power_all = [] ;


for start = 1:length(intervals_start)

% Band Power
    window_start = intervals_start(start) ;
    eventfreq.window{start} = [window_start, window_start+windowsize];
    window_idx = find(t>window_start & t<(window_start+windowsize)); % idx of time points for this timewindow
    pow=mean(Sp(window_idx,find(f>freqband(1) & f<freqband(2))),'all'); % band-freq spectral power, averaged over sliding timewindow
    spectral_power_all = [spectral_power_all, pow];

% Events Density within same timewindow :
% ie. number of events per second within this timewindow (occurrence frequency)
    eventfreq.down{start} = sum(down_starts>window_start & down_starts<(window_start+windowsize)) / windowsize ;
    eventfreq.delta{start} = sum(delta_starts>window_start & delta_starts<(window_start+windowsize)) / windowsize ;
    eventfreq.deltadeep{start} = sum(deltadeep_starts>window_start & deltadeep_starts<(window_start+windowsize)) / windowsize ;
    eventfreq.deltasup{start} = sum(deltasup_starts>window_start & deltasup_starts<(window_start+windowsize)) / windowsize ;
    
end
    

% PLOT : 
figure,
plotcolors = {[0 0.4 0.7],[0.8 0.1 0.1],[0.8 0.4 0.2],[0.8 0.5 0.1]};


% Band Power
subplot(4,2,[1 3]), plot(intervals_start,spectral_power_all,'color',[0.2 0.2 0.2]), title(['Band Power (' num2str(freqband(1)) '-' num2str(freqband(2)) 'Hz)']),
legend(['averaging window = ' num2str(windowsize) ' s']);

% Events Freq
ylim_freq = [0 2.5] ;
subplot(4,2,2), plot(intervals_start,cell2mat(eventfreq.down),'color', plotcolors{1}), ylim(ylim_freq), legend('down'), title('Occurrence Frequency');
subplot(4,2,4), plot(intervals_start,cell2mat(eventfreq.delta),'color', plotcolors{2}), ylim(ylim_freq), legend('delta');
subplot(4,2,6), plot(intervals_start,cell2mat(eventfreq.deltadeep),'color', plotcolors{3}), ylim(ylim_freq), legend('delta deep');
subplot(4,2,8), plot(intervals_start,cell2mat(eventfreq.deltasup),'color', plotcolors{4}), ylim(ylim_freq), legend('delta sup'), xlabel('time (s)');

% Correlation Coeff

subplot(4,2,[5 7]), hold on,
fields = fieldnames(eventfreq);
for i = 1:4 
    event_freq = cell2mat(eventfreq.(fields{i+1}));
    R = corrcoef(spectral_power_all,event_freq) ;
    bar(i, R(2), 'FaceColor', plotcolors{i}), ylim([-1.2 1.2]);
    text(i,R(2)+sign(R(2))*0.08,num2str(R(2)),'Color',plotcolors{i},'HorizontalAlignment','center') ;
end
%legend({'down','delta','delta deep','delta sup'},'Orientation','horizontal','Location','southeast')
set(gca, 'XTickLabel',{'down','delta','delta deep','delta sup'}, 'XTick',1:4)
title(['Correlation Coefficient Bandpower x EventFreq']);






%% MEASURES (WITHIN intervalSet TIME WINDOWS) : 


% PARAM : 
windowsize = 30 ; % duration of sliding window, in seconds
step = windowsize/2 ; % time step between starts of 2 successive sliding windows, in seconds

% SPECTRO :
[Sp, t, f] = LoadSpectrumML(ChannelDeep, pwd, 'low');
Stsd=tsd(t*1E4,Sp);
% figure, imagesc(Range(Stsd,'s'),f,10*log10(Data(Stsd)')), axis xy


% IntervalSet with time windows for the analysis :
intervals_start = t(1):step:(t(end)-windowsize) ; %starting times for all successive windows
intervals_end = intervals_start + windowsize ; % end times for all successive windows
timewindows_is = intervalSet(intervals_start*1E4, intervals_end*1E4) ;




    % MEASURES :
    
% ------ Mean BandPower for each time window ------ :
meanspec_tsd = intervalMean(Stsd, timewindows_is);
meanspec = Data(meanspec_tsd);
bandpower = mean(meanspec(:,find(f>freqband(1) & f<freqband(2)))',1) ;
    % figure, plot(Range(meanspec_tsd)/1E4,bandpower) ; % Plot of mean bandpower

    
% ------ Density (Occurrence Frequency) ------ :
freq_delta_tsd = intervalRate(ts(Start(deltas_PFCx)), timewindows_is, 'ts', 'time', 'middle') ;
freq_delta = Data(freq_delta_tsd)' ;

% EventsDensity_LP(ts(Start(deltas_PFCx)),t,windowsize)

    
% ------ Occupancy (Proportion in duration) ------ :
delta_occupancy = [] ;
for i=1:length(intervals_start)
    intv = intervalSet(intervals_start(i)*1E4,intervals_start(i)*1E4 + windowsize*1E4);
    delta_occupancy(i) = tot_length(and(deltas_PFCx,intv)) / (windowsize*1E4);
end  
    % figure, plot(intervals_start,delta_occupancy) ; % Plot of occupancy

    

% ------ Mean UP or DOWN durations ------ :
down_length_all = length(down_PFCx,'ts','time','start');
down_length = intervalMean(down_length_all,timewindows_is) ; % tsd with mean length of down states, for each window it starts in
    % a=Data(down_length); a(isnan(a))=0; down_length = tsd(Range(down_length),a), clear a;
    % figure, plot(intervals_start, Data(down_length)/10), ylabel('mean event duration (ms)'), xlabel('time (s)') ; % Plot

     
% ------ Inter-event durations ------ :
    % event_length_all = length(deltas_PFCx,'ts','time','start');
    % event_length = intervalMean(event_length_all,timewindows_is) ; 
    % interevent_length = tsd(Range(event_length),windowsize*1E4 - Data(event_length));

interevents = diff(timeSpan(timewindows_is),deltas_PFCx);
interevent_length_all = length(interevents,'ts','time','start');
interevent_length = intervalMean(interevent_length_all,timewindows_is) ;
    % figure, plot(Range(interevent_length), Data(interevent_length)/10), ylabel('mean inter-event duration (ms)'), xlabel('time (s)') ; % Plot

   
% ------ Regularity of occurrence / of duration ------ ?
    % var of length within each timewindow?

 % use intervalFun with timewindows as intervals

end 