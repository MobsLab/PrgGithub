%% CHECKCOOCCURRENCEWINDOW
%
% 28/04/2020 LP
%
% Check timewindow used for co-occurrence detection, ie. duration of
% timewindow around down state start to detect start of co-occurring events
%  (ex. delta waves, slow waves...)
% For one session.
%

% ------------------------------------- Choose Sleep Session ------------------------------------- :

%clear
% session = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243' ;
% cd(session)


% ------------------------------------------ Load Data ------------------------------------------ :

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


% EVENTS
load("DownState.mat", 'alldown_PFCx')
load("DeltaWaves.mat", 'alldeltas_PFCx')
load("DeltaWavesChannels.mat", ['delta_ch_', num2str(ChannelDeep)],['delta_ch_', num2str(ChannelSup)] ) 
    deltas_deep = eval(['delta_ch_', num2str(ChannelDeep)]);
    deltas_sup = eval(['delta_ch_', num2str(ChannelSup)]);
SW_sup = diff(deltas_sup,alldeltas_PFCx); % Sup Slow Waves (strict -> NO real delta)
SW_deep = diff(deltas_deep,alldeltas_PFCx); % Deep Slow Waves (strict -> NO real delta)  
% Clean slow waves : 
% Remove filter artefacts around delta detected as slow waves
[co,cot] = EventsCooccurrence(ts(Start(SW_sup)),ts(Start(alldeltas_PFCx)),[300 300]); % slow waves occuring within 300ms pre or post delta start
SW_sup_clean = subset(SW_sup,find(~co)); % Remove those slow waves
[co,cot] = EventsCooccurrence(ts(Start(SW_deep)),ts(Start(alldeltas_PFCx)),[300 300]); % idem for deep slow waves
SW_deep_clean = subset(SW_deep,find(~co)); % idem    
    

% SUBSTAGES :
% Clean SWS Epoch
load('SleepSubstages.mat')
SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
load NoiseHomeostasisLP TotalNoiseEpoch % noise
cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
% REM & Wake Epochs
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;


% ------------------------------------------ Restrict events to cleanSWS epoch ------------------------------------------ :

delta_start = Start(alldeltas_PFCx) ; 
SWS_delta_start = delta_start(belong(cleanSWS,delta_start));

SWsup_start = Start(SW_sup_clean) ; 
SWS_SWsup_start = SWsup_start(belong(cleanSWS,SWsup_start));

SWdeep_start = Start(SW_deep_clean) ; 
SWS_SWdeep_start = SWdeep_start(belong(cleanSWS,SWdeep_start));

down_start = Start(alldown_PFCx) ; 
SWS_down_start = down_start(belong(cleanSWS,down_start));


% All events starts : 
events_names = {'Delta Waves', 'Deep Slow Waves', 'Sup Slow Waves'} ; 
events_colors = {[1 0.7 0.1],[0 0.25 0.65],[0.25 0.7 0.9]} ; 
%events_starts = {delta_start, SWdeep_start, SWsup_start} ; % during whole sleep session
events_starts = {SWS_delta_start, SWS_SWdeep_start, SWS_SWsup_start} ; % during SWS only



% ------------------------------------------ Co-occurrence proportion as a function of delay ------------------------------------------ :

figure,

subplot(3,1,1),
all_co_delay = 10:10:300 ; 

disp('computing co-occurrence proportion...') ; 

for i = 1:length(events_starts)
    evt_starts = events_starts{i} ;
    all_prop = [] ; 
    
    for co_delay = all_co_delay
        [co, cot] = EventsCooccurrence(ts(evt_starts),ts(Start(alldown_PFCx)), [co_delay co_delay]) ; 
        all_prop = [all_prop sum(co)/length(co)];
    end
    
    hold on, plot(all_co_delay,all_prop,'Color',events_colors{i},'LineWidth',1.5) ;   
end 

legend(events_names,'location','southeast');
xlabel('time around down state start for co-occurrence detection (ms)') ; ylabel('proportion of events') ; title(['Events x Down States co-occurrence proportion'],'FontSize',15) ;


 

% ------------------------------------------ Barplots of co-occurring proportion ------------------------------------------ :


for i = 1:length(events_starts)
    evt_starts = events_starts{i} ; 
    
    [co50, cot50] = EventsCooccurrence(ts(evt_starts),ts(Start(alldown_PFCx)), [50 50]) ;
    [co100, cot100] = EventsCooccurrence(ts(evt_starts),ts(Start(alldown_PFCx)), [100 100]) ;
    
    subplot(3,3,3+i),
    b = bar([50,100],[sum(co50)/length(co50), sum(co100)/length(co100)],'LineStyle','none') ;
    if i == 1
        yl_bar=ylim ; % use ylim for delta waves as ylim for all 
    end 
    b.FaceColor = events_colors{i} ; 
    ylim(yl_bar), ylabel(['Proportion of' newline ' co-occurring events']) ; 
    set(gca,'XtickLabels',{'50 ms','100 ms'}) ; xlabel('Co-occurring detection delay') ; 
    title(events_names{i});

end



% ------------------------------------------ Cross-Correlograms ------------------------------------------ :


for i = 1:length(events_starts)
    evt_starts = events_starts{i} ; 
    [C,B]=CrossCorr(evt_starts,Start(alldown_PFCx),10,100);
    
    subplot(3,3,6+i)
    plot(B,C,'k') ;
    if i == 1
        yl=ylim ; % use ylim for delta waves as ylim for all 
    end    
    xticks([-400 -200 0 200 400]); xticklabels({'-400','-200','0','200','400'}); ylim(yl) ; 
    ylabel('Correlation Index'); xlabel('Time from down state start (ms)'); title(['Cross-correlogram ' events_names{i} ' x Down States']);
end



