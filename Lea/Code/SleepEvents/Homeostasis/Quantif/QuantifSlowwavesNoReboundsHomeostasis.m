%% QuantifSlowwavesNoReboundsHomeostasis
%
% 08/06/2020
%
% Script to plot LFP profile and event density homeostasis for slow waves
% 1/2/5 which do not occur close to SW 3/4/6 events


% ------------------------------------------ Load Data ------------------------------------------ :

detection_delay = 300 ; 

% LFP :

load('ChannelsToAnalyse/PFCx_deep')
load(['LFPData/LFP',num2str(channel)])
LFPdeep = LFP;
ChannelDeep = channel ;

load('ChannelsToAnalyse/PFCx_sup')
load(['LFPData/LFP',num2str(channel)])
LFPsup = LFP;
ChannelSup = channel ;

load('ChannelsToAnalyse/Bulb_deep')
load(['LFPData/LFP',num2str(channel)])
LFPOBdeep = LFP;
ChannelOBdeep = channel ;
clear LFP channel

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65],[1 0.7 0.1]} ;

% EVENTS

load("DownState.mat", 'alldown_PFCx')
load("DeltaWaves.mat", 'alldeltas_PFCx')
load('Ripples.mat')
downstates_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; % convert to ts with mid time
diffdelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; % convert to ts with mid time (differential Delta = as computed by KJ)


% 2-Channel Slow Waves : 
load('SlowWaves2Channels_LP.mat')
    % Data : 
all_sw = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type5.deep_peaktimes} ;
all_sw_names = {'SW1','SW2','SW5'} ; 
ref_sw = ts(sort([Range(slowwave_type3.deep_peaktimes)',Range(slowwave_type4.deep_peaktimes)',Range(slowwave_type6.deep_peaktimes)'])) ;


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



%% Keep SW 1/2/5 which are NOT rebounds of ref SW (3/4/6) : 

norebound_prop = [] ; 

for i=1:length(all_sw)
    [obs_ts_subset, subset_ix, prop] = GetCloseEvents_LP(all_sw{i},ref_ts,detection_delay,'epoch',SWS,'keep_events',0) ;
    norebound_sw{i} = obs_ts_subset ; 
    norebound_prop(i) = prop ; 
end 


%% Plot LFP profiles

figure,

for i=1:length(all_sw)
    
    % Plot for all sw : 
    subplot(2,length(all_sw),i),
    epoch_events_t = Range(all_sw{i}) ; 
    
    [mdeep,sdeep,tdeep]=mETAverage(epoch_events_t,Range(LFPdeep),Data(LFPdeep),1,1000);
    [msup,ssup,tsup]=mETAverage(epoch_events_t,Range(LFPsup),Data(LFPsup),1,1000);
    [mOB,sOB,tOB]=mETAverage(epoch_events_t,Range(LFPOBdeep),Data(LFPOBdeep),1,1000);
    hold on, plot(tsup,msup,'Color',LFP_colors{1}), plot(tdeep,mdeep,'Color',LFP_colors{2}), plot(tOB,mOB,'Color',LFP_colors{3})
    legend({'Sup PFC','Deep PFC','Deep OB'},'Orientation','horizontal','Location','northoutside'), xlabel('Time around event (ms)'), ylabel('Mean LFP signal') ;
    title(['All ' all_sw_names{i}]) ; 
    ylim([-2200,2200]) ; 
    
    % Plot without rebounds : 
    subplot(2,length(all_sw),i+length(all_sw)),
    epoch_events_t = Range(norebound_sw{i}) ; 
    
    [mdeep,sdeep,tdeep]=mETAverage(epoch_events_t,Range(LFPdeep),Data(LFPdeep),1,1000);
    [msup,ssup,tsup]=mETAverage(epoch_events_t,Range(LFPsup),Data(LFPsup),1,1000);
    [mOB,sOB,tOB]=mETAverage(epoch_events_t,Range(LFPOBdeep),Data(LFPOBdeep),1,1000);
    hold on, plot(tsup,msup,'Color',LFP_colors{1}), plot(tdeep,mdeep,'Color',LFP_colors{2}), plot(tOB,mOB,'Color',LFP_colors{3})
    legend({'Sup PFC','Deep PFC','Deep OB'},'Orientation','horizontal','Location','northoutside'), xlabel('Time around event (ms)'), ylabel('Mean LFP signal') ;
    ylim([-2200,2200]) ; 
    title(['No rebound ' all_sw_names{i} ', prop = ' sprintf('%.2g',norebound_prop(i)*100) '%']) ; 

end



%% Get Homeostasis on Event density without rebounds : 

figure,

for i=1:length(all_sw)
    
    % Plot for all sw : 
    subplot(2,length(all_sw),i),
    HomeostasisEventDensity_LP(all_sw{i},'ZTtime',NewtsdZT,'windowsize',60, 'plot',1,'newfig',0,'epoch',cleanSWS) ;
    
    % Plot without rebounds : 
    subplot(2,length(all_sw),i+length(all_sw)),
    HomeostasisEventDensity_LP(norebound_sw{i},'ZTtime',NewtsdZT,'windowsize',60, 'plot',1,'newfig',0,'epoch',cleanSWS) ;
    
end
