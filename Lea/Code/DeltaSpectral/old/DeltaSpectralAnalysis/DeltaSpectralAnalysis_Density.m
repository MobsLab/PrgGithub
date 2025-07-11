%% Bandpower and Slow Rythms : DENSITY

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
REM = Epoch{strcmpi(NameEpoch,'REM')} ; WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ; TOTSleep = Epoch{strcmpi(NameEpoch,'TOTSleep')};
substages_list = {N1, N2, N3, REM, WAKE} ;


%% BANDPOWER & EVENTS DENSITY

% ------------------------------------------ Parameters ? ------------------------------------------ :

freqband = [10 20] ; % beginning and end of frequency band, in Hz
spect_channel_name = 'ChannelDeep' ;
%spect_channel_name = 'ChannelSup' ;
spect_channel = eval(spect_channel_name) ;

% Sliding window parameters : Cf. below


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

down_density = EventsDensity_LP(ts(Start(alldown_PFCx)), all_timewindows, 'union', 0); % average number of events per ts, for each timewindow
delta_density = EventsDensity_LP(ts(Start(alldeltas_PFCx)), all_timewindows, 'union', 0); 
deltadeep_density = EventsDensity_LP(ts(Start(deltas_deep)), all_timewindows, 'union', 0);
deltasup_density = EventsDensity_LP(ts(Start(deltas_sup)), all_timewindows, 'union', 0);
mean_bandpow = intervalMean(bandpow_tsd,all_timewindows,'Time','middle');

event_colors = {[0.1 0.1 0.45], [0.8 0.2 0.3], [0.4 0.0 0.1] };

% Sup or Deep Deltas (same as bandpower channel) : 
if strcmpi(spect_channel_name,'ChannelDeep')
    Events = {down_density, delta_density, deltadeep_density} ;
    Event_Names = {'Down', 'Delta', 'Deep "Delta"'} ;
elseif strcmpi(spect_channel_name,'ChannelSup')
    Events = {down_density, delta_density, deltasup_density} ;
    Event_Names = {'Down', 'Delta', 'Sup "Delta"'} ;   
end

% RESTRICT TO SLEEP only :
if restrict_to_sleep
    down_density = replaceinTSD(down_density,WAKE,NaN);   
    delta_density = replaceinTSD(delta_density,WAKE,NaN);  
    deltadeep_density = replaceinTSD(deltadeep_density,WAKE,NaN);  
    deltasup_density = replaceinTSD(deltasup_density,WAKE,NaN);
    mean_bandpow = replaceinTSD(mean_bandpow,WAKE,NaN);  
end
    


% --- Plot --- :
figure,

% mean BandPower timecourse :

subplot(4,3,[4 5 7 8]),
t_bandpow = Range(mean_bandpow)/(3600*1E4) ;
plot(t_bandpow,Data(mean_bandpow)), xlim([t_bandpow(1) t_bandpow(end)]); xl=xlim;;
title('Mean Bandpower');


% Substages :
subplot(4,3,[1 2]),
subst_colors = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage colors
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



% Mean event density timecourse :
for k = 1:length(Events) 
    ev = Events{k};
    subplot(4,3,[9+k]),
    plot(Range(ev)/(3600*1E4), Data(ev)*1E4, 'Color', event_colors{k})
    title(['Mean ' Event_Names{k} ' density'],'Color',event_colors{k})
    ylabel('nb events / second'), xlabel('time (hours)'), xlim([-inf inf]);
end

%CorrCoeff
subplot(4,3,[6 9])
for k = 1:length(Events) 
    ev = Events{k};
    r = corrcoef(Data(mean_bandpow), Data(ev),'Rows','complete');
    CorrCoeff(k) = r(2) ;
    b = bar(k,r(2));
    text(k,r(2)+sign(r(2))*0.08,num2str(r(2)),'Color',event_colors{k},'HorizontalAlignment','center') ;
    set(b,'FaceColor', event_colors{k}), hold on;
end
ymax = max(CorrCoeff); ylim([0,ymax+ymax/3]);
%legend(Event_Names,'location','eastoutside','orientation','vertical','Box','on');
set(gca,'XTick',[]), hold on;
title(['Correlation between Mean Bandpower' newline 'and Density of Events'])

set(findall(gcf,'-property','FontSize'),'FontSize',10);
legend(Event_Names,'location','northeast','orientation','horizontal','Box','off','FontSize',8.5);


% TEXT
subplot(4,3,3),
text(0.5,0.85,sprintf('Frequency Band : %d - %d Hz',freqband(1),freqband(2)), 'FontSize', 15, 'HorizontalAlignment','center'), axis off ;
text(0.5,0.60,sprintf(['Bandpower Channel : ' spect_channel_name],freqband(1),freqband(2)), 'FontSize', 10, 'HorizontalAlignment','center'), axis off ;
text(0.5,0.45,['Windowsize: ' num2str(windowsize) ' s, step: ' num2str(step) ' s'], 'FontSize', 10, 'HorizontalAlignment','center'), axis off ;



%%  ------------------------------------------ Analyses : substages ------------------------------------------ :



subst_colors = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage colors
event_colors = {[0.1 0.1 0.45], [0.8 0.2 0.3], [0.4 0.0 0.1] };

% Get density of different events, for different substages : 


for i = 1:length(substages_list)
    down_density_subst{i} = EventsDensity_LP(ts(Start(alldown_PFCx)), substages_list{i}, 'union', 1)*1E4 ; % average number per second
    delta_density_subst{i} = EventsDensity_LP(ts(Start(alldeltas_PFCx)), substages_list{i}, 'union', 1)*1E4 ; 
    deltadeep_density_subst{i} = EventsDensity_LP(ts(Start(deltas_deep)), substages_list{i}, 'union', 1)*1E4 ;
    deltasup_density_subst{i} = EventsDensity_LP(ts(Start(deltas_sup)), substages_list{i}, 'union', 1)*1E4 ;
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


% Mean Event Densities :

Events = {down_density_subst, delta_density_subst, deltadeep_density_subst} ;
Event_Names = {'Down', 'Delta', 'Deep "Delta"'} ;


for k = 1:length(Events) 
    ev = Events{k};
    subplot(5,4,[13+k 17+k]),
    for i =1:length(ev)
        b = bar(i,ev{i});
        set(b,'FaceColor',subst_colors{i}), hold on;
    end
    ylim([0 2]);
    %ymax = max(cell2mat(ev)); ylim([0,ymax+ymax/7]);
    set(gca, 'XTickLabel',{'N1','N2','N3','REM','Wake'}, 'XTick',1:5), hold on;
    title([Event_Names{k} ' density'],'Color',event_colors{k})
    ylabel('number of events / second');
    
end


% Correlation Plot :

subplot(5,4,[7 8 11 12]),
for k = 1:length(Events) 
    ev = Events{k};
    r = corrcoef(cell2mat(bandpow_substage), cell2mat(ev));
    CorrCoeff(k) = r(2) ;
    b = bar(k,r(2));
    text(k,r(2)+sign(r(2))*0.08,num2str(r(2)),'Color',event_colors{k},'HorizontalAlignment','center') ;
    set(b,'FaceColor', event_colors{k}), hold on;
end
ymax = max(CorrCoeff); ylim([0,ymax+ymax/3]);
%legend(Event_Names,'location','eastoutside','orientation','vertical','Box','on');
legend(Event_Names,'location','northeast','orientation','horizontal','Box','off');
set(gca,'XTick',[]), hold on;
title(['Correlation between Mean Bandpower' newline 'and Density of Events'])

set(findall(gcf,'-property','FontSize'),'FontSize',9);

subplot(5,4,[3 4]),
text(0.5,0.7,sprintf('Frequency Band : %d - %d Hz',freqband(1),freqband(2)), 'FontSize', 15, 'HorizontalAlignment','center'), axis off ;
text(0.5,0.45,sprintf(['Bandpower Channel : ' spect_channel_name],freqband(1),freqband(2)), 'FontSize', 12, 'HorizontalAlignment','center'), axis off ;


