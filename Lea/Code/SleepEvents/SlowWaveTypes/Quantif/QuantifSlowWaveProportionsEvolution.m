%% QuantifSlowWaveProportionsEvolution
%
% 17/06/2020
%
% -> Script to quantify the proportions of all slow wave types, for NREM,
% during begin / middle / end of each session (session divided in nb_periods = 3
% periods) + LFP begin vs end + MUA begin vs end

%clear
% 
% Dir = PathForExperimentsSlowWavesLP_HardDrive ;
% cd(Dir.path{1})


%% LOAD DATA 

% --------------- Load Data --------------- :

% LOAD EPOCHS :
load('SleepSubstages.mat')
SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
load NoiseHomeostasisLP TotalNoiseEpoch % noise
cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;

load('BehavResources.mat','NewtsdZT') ; 

% LOAD SW :
load('SlowWaves2Channels_LP.mat')
% all_slowwaves_ts = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
% all_colors = {[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 
all_slowwaves_ts = {slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type6.deep_peaktimes} ;
all_colors = {[1 0 0.4],[0.6 0.2 0.6],[0 0.6 0.4]} ; 
all_names = {'SW3','SW4','SW6'} ;


% LOAD LFP : 
    % PFCx deep :
load('ChannelsToAnalyse/PFCx_deep')
load(['LFPData/LFP',num2str(channel)])
LFPdeep = LFP;
ChannelDeep = channel ;
    % PFCx sup :
load('ChannelsToAnalyse/PFCx_sup')
load(['LFPData/LFP',num2str(channel)])
LFPsup = LFP;
ChannelSup = channel ;


% LOAD SPIKE DATA :

load('SpikeData.mat')
num=GetSpikesFromStructure('PFCx');
S=S(num); % S tsdArray des spikes des neurones du PFC uniquement 
Q=MakeQfromS(tsdArray(PoolNeurons(S,1:length(S))),20); % MakeQfromS(S,bin) = Spike Train Binning (time histogram of firing rate, time bin in same unit as S)
q=full(Data(Q));
Qs=tsd(Range(Q),q(:,1));





%% GET DATA AND PLOT

% --------------- Get proportions --------------- :

nb_periods = 18 ;
all_nb_events = repmat(NaN,length(all_slowwaves_ts),nb_periods) ; 
period_midtimes = [] ; 

for type = 1:length(all_slowwaves_ts)
    sw = all_slowwaves_ts{type} ; 
    sw = Restrict(sw,cleanSWS) ; 
    [periods_sw, periods_is] = SplitSessionEvents_LP(sw,nb_periods,cleanSWS) ; 
    for per = 1:nb_periods
        all_nb_events(type,per) = length(periods_sw{per}) ; 
        period_midtimes(per) = (Start(subset(periods_is,per)) + End(subset(periods_is,per))) / 2 ; 
    end 
    all_events_ts{type} = periods_sw ; 
end


% Get proportions : 
sum(all_nb_events) ; 
all_prop_events = all_nb_events ./ sum(all_nb_events) *100 ; 


% --------------- Stacked Proportions Barplot --------------- :

% figure,
% subplot(2,5,2:4)
% b = bar(all_prop_events','stacked') ; 
% for i = 1:length(all_colors)
%     b(i).FaceColor = all_colors{i} ; 
%     b(i).FaceAlpha = 0.7 ;
% end
% legend(all_names,'Location','northoutside','Orientation','horizontal'); legend boxoff ; 
% xlabel('time (period of the session)')
% ylabel('proportion (%)')
% ylim([0 110])


% --------------- Stacked Proportions Timecourse (areas) --------------- :

figure, 
subplot(3,2,1),

period_midtimes_ZT = (period_midtimes + min(Data(NewtsdZT)))/3600E4 ;  %convert time to ZT
a = area(period_midtimes_ZT, all_prop_events','FaceAlpha',0.7,'EdgeColor',[1 1 1]) ; 
% change color
for k = 1:length(a)
    a(k).FaceColor = all_colors{k} ;
end 
 
legend(all_names,'Location','northoutside','Orientation','horizontal'); legend boxoff ; 
xlabel('ZT time (h)') ; ylabel('Stacked occurrence proportions') ; 
axis tight ; 

% Add dashed lines delimiting begin / middle / end
xline((period_midtimes_ZT(nb_periods/3)+period_midtimes_ZT(nb_periods/3+1))/2,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
xline((period_midtimes_ZT(nb_periods*2/3)+period_midtimes_ZT(nb_periods*2/3+1))/2,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;


% --------------- Barplot with variations of proportions between end and begin --------------- :

subplot(3,2,2),

% Get mean proportion difference :
begin_prop_events = all_prop_events(:,1:nb_periods/3);
end_prop_events = all_prop_events(:,nb_periods*2/3+1:end);
mean_begin_prop = mean(begin_prop_events,2) ;
mean_end_prop = mean(end_prop_events,2) ;
mean_prop_diff = mean_end_prop - mean_begin_prop ; 

% Barplot :
hold on,
for k = 1:length(all_slowwaves_ts)
    b=bar(k,mean_prop_diff(k),'FaceColor',all_colors{k},'FaceAlpha',0.7,'LineStyle','none') ;
end 

% Legend and axes :
%ylim([-5,10]) ; 
xticks([]); box on ;
title('Proportion difference [end - begin]') 
ylabel('Proportion difference (% points)') 
set(b,'ShowBaseLine','off'); yline(0,'Color',[0.3 0.3 0.3],'HandleVisibility','off') ; % plot grey line at 0 instead of black line



% --------------- Overlayed LFP Profiles --------------- :

% One subplot for begin and end :
period_titles = {'begin period (1/3)','end period (3/3)'} ; 
% all_events_ts = cell with slowwaves ts for all periods, all sw types

for per = 1:2 % for begin and for end periods
    
    subplot(3,2,2+per),
    hold on,
    
    for type=1:length(all_events_ts) % for each type of events
        
        events_ts = all_events_ts{type} ; % cell with ts of slow waves for this type, for all periods
        events_ts_periodcell = events_ts(nb_periods*(per-1)/3+1:nb_periods*per/3) ; % cell with ts of slow waves for this type, for begin or end periods only
        
        % Get ts with all events for this period :
        events_t = [] ; 
        for k = 1:length(events_ts_periodcell)
            events_t = [events_t ; Range(events_ts_periodcell{k})] ; 
        end
        
        % Get LFP profile :
        [mdeep,s,t]=mETAverage(events_t,Range(LFPdeep),Data(LFPdeep),1,1000); % deep PFCx
        [msup,s,t]=mETAverage(events_t,Range(LFPsup),Data(LFPsup),1,1000); % sup PFCx
        
        % Plot LFP profile :
        plot(t,mdeep/10,'Color',all_colors{type})
        plot(t,msup/10,'--','Color',all_colors{type})
        xlabel('Time from slow wave peak (ms)'), ylabel('Mean LFP amplitude (microV)') ; 
        ylim([-160 230]) ; 
        
        title(['Mean LFP : ' period_titles{per}])
        
    end
end



% --------------- Overlayed Spiking Rate --------------- :



for per = 1:2 % for begin and for end periods
    
    subplot(3,2,4+per),
    hold on,
    
    for type=1:length(all_events_ts) % for each type of events
        
        events_ts = all_events_ts{type} ; % cell with ts of slow waves for this type, for all periods
        events_ts_periodcell = events_ts(nb_periods*(per-1)/3+1:nb_periods*per/3) ; % cell with ts of slow waves for this type, for begin or end periods only
        
        % Get ts with all events for this period :
        events_t = [] ; 
        for k = 1:length(events_ts_periodcell)
            events_t = [events_t ; Range(events_ts_periodcell{k})] ; 
        end
        
        % Get mean Firing Rate :
        [m,s,t]=mETAverage(events_t,Range(Qs),Data(Qs),2,500);  
        
        % Plot Firing Rate :
        area(t,m,'FaceColor',all_colors{type},'LineStyle','-','FaceAlpha',0.3,'EdgeColor',all_colors{type})
        ylabel('Mean firing rate') ; xlabel('Time from slow wave peak (ms)') ;
        
        title(['Mean MUA : ' period_titles{per}])
        
    end
end

