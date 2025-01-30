%% QuantifStagesOccurrence_AllSlowWaveTypes
% 
% 25/05/2020  LP
%
% Script to stage occurence + associated LFP profiles and down states crosscorr/co-occurrence, for all slow wave types.
% -> for one session

%Dir = PathForExperimentsSlowWavesLP_HardDrive ;
% clearvars -except Dir
%cd(Dir.path{16})

% ------------------------------------------ Load Data ------------------------------------------ :

% LOAD EVENTS :
load('SlowWaves2Channels_LP.mat')
load('DownState.mat','alldown_PFCx')
load('DeltaWaves.mat','alldeltas_PFCx')
downstates_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; % convert to ts with mid time
diffdelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; % convert to ts with mid time (differential Delta = as computed by KJ)


% LOAD SUBSTAGES : 
load('SleepSubstages.mat') ; 
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;
substages_list = {WAKE,SWS,REM} ; 
substages_names = {'Wake', 'NREM', 'REM'} ;

% LOAD LFP : 
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
LFPob = LFP;
ChannelOb = channel ;
clear LFP channel


%% --------------------------- Stage Occurrence (Wake/REM/NREM) : EventsStages structure --------------------------- :

% For 3 separate plots : 
events1 = {slowwave_type3.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type4.deep_peaktimes,downstates_ts} ; 
events1_names = {'Slow Waves 3', 'Slow Waves 6', 'Slow Waves 4','Down States'} ; 

events2 = {slowwave_type2.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type1.deep_peaktimes,downstates_ts} ; 
events2_names = {'Slow Waves 2', 'Slow Waves 5', 'Slow Waves 1','Down States'} ; 

events3 = {slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes,diffdelta_ts,downstates_ts} ; 
events3_names = {'Slow Waves 7', 'Slow Waves 8','Diff Delta Waves', 'Down States'} ; 

% Plot organization & info : 

allplots_events = {events1,events2,events3} ;
allplots_names = {events1_names,events2_names,events3_names} ;
stages_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ;
LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1]} ; 
LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;


% -------------- Plots -------------- : 

% FOR EACH FIGURE : 

for f = 1:length(allplots_events) 
    
    events = allplots_events{f} ; 
    events_names = allplots_names{f} ;
    
    
    % FOR EACH TYPE OF EVENTS : 

    figure,
    sgtitle('Slow Wave Types : Stages Occurrence')

    for q = 1:length(events)
        
        addlegend = [] ; 
        all_events_times = Range(events{q}) ;
        
        % Get proportions of occurrence in each stage :
        
        for k = 1:length(substages_list)

            stage_events = belong(substages_list{k},all_events_times) ; 
            stage_prop = sum(stage_events) / length(stage_events) *100 ; % proportion 
            % Get mean LFP around events : 
            nb_events = sum(stage_events) ; 
            stage_events_times = all_events_times(stage_events) ; 
            [mdeep,s,t]=mETAverage(stage_events_times,Range(LFPdeep),Data(LFPdeep),1,1000);
            [msup,s,t]=mETAverage(stage_events_times,Range(LFPsup),Data(LFPsup),1,1000);
            [mob,s,t]=mETAverage(stage_events_times,Range(LFPob),Data(LFPob),1,1000);
             
            % --- Plots --- : 
            
            % Stage Occurrence - barplot : 
            subplot(5,4,q),
            title(events_names{q},'FontSize',12)
            hold on,
            bar(k,stage_prop,'LineStyle','none','FaceColor',stages_colors{k}) ;
            text(k,stage_prop + 8,[sprintf(' %.3g',stage_prop) ' %'],'Color',stages_colors{k},'HorizontalAlignment','center','FontSize',11) ;
            ylim([0 120]) ; set(gca,'XTick',[1 2 3],'XTickLabel',stages_names) ; 
            %yline(100,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ; 
            
            % LFP profile : 
            subplot(5,4,4*k + q),
            hold on,
            plot(t,mdeep,'Color',LFP_colors{1},'LineWidth',2) ; 
            plot(t,msup,'Color',LFP_colors{2},'LineWidth',2) ;
            ylim([-2200 2200]) ; title([substages_names{k} sprintf('  (%.2g events)',nb_events)],'Color',stages_colors{k}) ; 
            xlabel(['time from event peak (ms)' newline '']) ; ylabel('mean LFP') ; 
            legend({'PFCdeep','PFCsup'},'Location','northeast') ; 
            
            % Down State CrossCorr (only if enough events, >100) :
            if length(stage_events_times) > 100 
                subplot(5,4,4*4 + q),
                hold on,
                [C,B]=CrossCorr(stage_events_times,Range(downstates_ts),10,100); 
                [co, cot] = EventsCooccurrence(ts(stage_events_times),downstates_ts, [300 300]) ; 
                prop_co_down = sum(co)/length(co) ; % proportion of slow waves of this type and stage which co-occur with down states 
                
                h(k) = area(B,C,'FaceColor',stages_colors{k},'EdgeColor',stages_colors{k},'FaceAlpha',0.4) ;
                text(-450,15-2*k,[sprintf('%.2g',prop_co_down*100) '%'],'Color',stages_colors{k}) ; 
                
                xlabel(['time from event peak (ms)']) ; ylabel('Correlation index') ;
                title(['Cross-Correlogram with Down States']) ; 
                addlegend = [addlegend k] ;
                legend({substages_names{addlegend}}) ; legend boxoff ; 
                ylim([0 17]) ; 
                
                
            end  
                  
        end
        
        subplot(5,4,4*4 + q),
        [co, cot] = EventsCooccurrence(ts(all_events_times),downstates_ts, [300 300]) ; % proportion of down state co-occurrence for all stages
        prop_co_down = sum(co)/length(co) ;
        text(-450,15,['% of cooc. SW : ' sprintf('%.2g',prop_co_down*100) '%']) ;
        try uistack(h(1),'top'); end
         
    end
    
    
end

    
    
    
    
    
    
