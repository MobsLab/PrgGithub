%% ParcourInfo_EventsStagesPlot
% 
% 25/05/2020  LP
%
% Script to plot stage occurrence of sleep events (ripples, down states, delta waves). Mean plot across mice.
% -> LFP/MUA profiles of event for each stage


clear 
Dir = PathForExperimentsSlowWavesLP_HardDrive ; 
stages_names = {'Wake', 'NREM', 'REM'} ;
stages_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ;
LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1]} ; 
LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])

    disp(pwd)
    
    
    % Store Session Info :
    Info_res.path{p}   = Dir.path{p};
    Info_res.manipe{p} = Dir.manipe{p};
    Info_res.name{p}   = Dir.name{p};
    
    

% ------------------------------------------ Load Data ------------------------------------------ :

    % LOAD EVENTS :
    load('DownState.mat','alldown_PFCx')
    load('DeltaWaves.mat','alldeltas_PFCx')
    try 
        load('Ripples.mat','tRipples')
    catch 
        load('Ripples.mat','Ripples')
        tRipples = ts(Ripples) ; 
    end
    
    
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
    load('ChannelsToAnalyse/dHPC_rip')
    load(['LFPData/LFP',num2str(channel)])
    LFPrip = LFP;
    ChannelRip = channel ;
    clear LFP channel

    
    % LOAD SPIKE DATA :
    load('SpikeData.mat')
    num=GetSpikesFromStructure('PFCx');
    S=S(num); % S tsdArray des spikes des neurones du PFC uniquement 
    Q=MakeQfromS(tsdArray(PoolNeurons(S,1:length(S))),20);
    q=full(Data(Q)); Qs=tsd(Range(Q),q(:,1));
    
    
%% --------------------------- Stage Occurrence (Wake/REM/NREM) : EventsStages structure --------------------------- :

    % for each stage :
    for k = 1:length(substages_list) 
        
        % --- Ripples --- : 
        all_events_times = Range(tRipples) ; 
        stage_events = belong(substages_list{k},all_events_times) ; 
        stage_prop = sum(stage_events) / length(stage_events) *100 ; % proportion of events during this stage
        eval(['EventsStages.Ripples.prop_' substages_names{k} '{p}= stage_prop ;']) ; % store proportion
        
        % Get mean LFP around ripples, for this stage: 
        nb_events = sum(stage_events) ; 
        stage_events_times = all_events_times(stage_events) ; 
        [mrip,s,t]=mETAverage(stage_events_times,Range(LFPrip),Data(LFPrip),1,600);
        eval(['EventsStages.Ripples.nb_' substages_names{k} '{p}= nb_events ;']) ; % store number of events
        eval(['EventsStages.Ripples.LFPrip_' substages_names{k} '{p}= mrip ;']) ; % store mean LFP deep 
        eval(['EventsStages.Ripples.LFPt_' substages_names{k} '{p}= t ;']) ; % store LFP time array
        
        
        
        % --- Down States --- : 
        all_events_times = (Start(alldown_PFCx)+End(alldown_PFCx))/2 ; 
        stage_events = belong(substages_list{k},all_events_times) ; 
        stage_prop = sum(stage_events) / length(stage_events) *100 ; % proportion of events starting during this stage
        eval(['EventsStages.DownStates.prop_' substages_names{k} '{p}= stage_prop ;']) ; % store proportion
        
        % Get mean LFP around ripples, for this stage: 
        nb_events = sum(stage_events) ; 
        stage_events_times = all_events_times(stage_events) ; 
        [mQ,s,t]=mETAverage(stage_events_times,Range(Qs),Data(Qs),1,1000);
        eval(['EventsStages.DownStates.nb_' substages_names{k} '{p}= nb_events ;']) ; % store number of events
        eval(['EventsStages.DownStates.MUA_' substages_names{k} '{p}= mQ ;']) ; % store mean LFP deep 
        eval(['EventsStages.DownStates.MUAt_' substages_names{k} '{p}= t ;']) ; % store LFP time array
        
        
        
        % --- Delta KJ --- : 
        all_events_times = (Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2 ; 
        stage_events = belong(substages_list{k},all_events_times) ; 
        stage_prop = sum(stage_events) / length(stage_events) *100 ; % proportion of events starting during this stage
        eval(['EventsStages.DeltaKJ.prop_' substages_names{k} '{p}= stage_prop ;']) ; % store proportion
        
        % Get mean LFP around ripples, for this stage: 
        nb_events = sum(stage_events) ; 
        stage_events_times = all_events_times(stage_events) ; 
        [mdeep,s,t]=mETAverage(stage_events_times,Range(LFPdeep),Data(LFPdeep),1,1000);
        [msup,s,t]=mETAverage(stage_events_times,Range(LFPsup),Data(LFPsup),1,1000);
        eval(['EventsStages.DeltaKJ.nb_' substages_names{k} '{p}= nb_events ;']) ; % store number of events
        eval(['EventsStages.DeltaKJ.LFPdeep_' substages_names{k} '{p}= mdeep ;']) ; % store mean LFP deep 
        eval(['EventsStages.DeltaKJ.LFPsup_' substages_names{k} '{p}= msup ;']) ; % store mean LFP sup
        eval(['EventsStages.DeltaKJ.LFPt_' substages_names{k} '{p}= t ;']) ; % store LFP time array
        
    end
          
end    


%% --------------------------- Stage Occurrence (Wake/REM/NREM) : EventsStagesMice structure --------------------------- :

[mice_list,~,ix] = unique(Info_res.name);
n_mice = length(mice_list) ; 

struct = EventsStages ; 
fieldnames = fields(struct) ;
    
    for field = 1:length(fieldnames)
        eval(['struct2 = struct.' fieldnames{field} ';'])
        fieldnames2 = fields(struct2) ;
        
        for field2 = 1:length(fieldnames2)
            eval(['data = cell2mat(struct2.' fieldnames2{field2} ') ;'])
            
            for m = 1:n_mice 
                mice_data{m} = nanmean(data(:,ix==m),2) ; 
            end 

            eval(['EventsStagesMice.' fieldnames{field} '.' fieldnames2{field2} ' = mice_data;']) 
            
        end
    end
    

  
    
%% --------------------------- Mean Plot of Stage Occurrence (Wake/REM/NREM) --------------------------- :

events_list = {EventsStagesMice.Ripples, EventsStagesMice.DownStates, EventsStagesMice.DeltaKJ} ;
events_names = {'Ripples', 'Down States','Delta Waves KJ'};
activity_plot = {'LFP','MUA','LFP'} ; 

figure,
sgtitle(['Mean Stage Occurrence (N = ' num2str(n_mice) ' mice)'])


for i = 1:length(events_list)      %for each type of events : 

    subplot(4,length(events_list),i),
    
    % Get data : 
    Data = events_list{i} ; 
    stages_prop = {cell2mat(Data.prop_Wake), cell2mat(Data.prop_NREM),cell2mat(Data.prop_REM)} ; 
    
    % Plot Stage Co-occurrence : 
    yl = [0 120] ;
    for k = 1:length(stages_prop) 
        hold on,
        bar(k,mean(stages_prop{k}),'LineStyle','none','FaceColor',stages_colors{k}) ;  
        text(k,mean(stages_prop{k}) + 12,[sprintf(' %.3g',mean(stages_prop{k})) ' %'],'Color',stages_colors{k},'HorizontalAlignment','center','FontSize',11) ; 
        sem = std(stages_prop{k}) / sqrt(length(stages_prop{k})) ; 
        errorbar(k,mean(stages_prop{k}),sem,sem,'Color',[0 0 0], 'LineStyle','none') ; 
    end
    set(gca,'Xtick',1:length(stages_prop), 'XTickLabel',stages_names,'FontSize',12) ; box on ; 
    ylabel('% of events in each stage') ; title('Stage repartition') ;  
    ylim(yl) ; title(events_names{i}) ; 
    yline(100,'--','Color',[0.5 0.5 0.5]) ;
    
    
    % ---- Plot mean profiles around events ---- :   
    
    % LFP plot : 
    
    if activity_plot{i} == 'LFP'  
  
        % Plot Wake LFP
        a1 = subplot(4,length(events_list),length(events_list)+i); hold on,
        try
            plot(Data.LFPt_Wake{1},mean(cell2mat(Data.LFPdeep_Wake),2),'Color',LFP_colors{1})
            plot(Data.LFPt_Wake{1},mean(cell2mat(Data.LFPsup_Wake),2),'Color',LFP_colors{2})
            legend({'Deep PFC','Sup PFC'},'Location','northwest');
        catch
            plot(Data.LFPt_Wake{1},mean(cell2mat(Data.LFPrip_Wake),2),'Color',LFP_colors{1})
            legend({'HPC'},'Location','northwest');
        end    
        xlabel('Time from event (ms)')  ; ylabel('mean LFP') ; 
        title(sprintf('WAKE (mean nb of events : %.2g)', mean(cell2mat(Data.nb_Wake))),'Color',stages_colors{1}) ; 
        
        % Plot NREM LFP
        a2 = subplot(4,length(events_list),length(events_list)*2+i); hold on,
        try
            plot(Data.LFPt_NREM{1},mean(cell2mat(Data.LFPdeep_NREM),2),'Color',LFP_colors{1})
            plot(Data.LFPt_NREM{1},mean(cell2mat(Data.LFPsup_NREM),2),'Color',LFP_colors{2})
        catch
            plot(Data.LFPt_NREM{1},mean(cell2mat(Data.LFPrip_NREM),2),'Color',LFP_colors{1})
            legend({'HPC'},'Location','northwest');
        end      
        xlabel('Time from event (ms)')  ; ylabel('mean LFP') ; 
        title(sprintf('NREM (mean nb of events : %.2g)', mean(cell2mat(Data.nb_NREM))),'Color',stages_colors{2}) ; 
        
        % Plot REM LFP
        a3 = subplot(4,length(events_list),length(events_list)*3+i); hold on,
        try
            plot(Data.LFPt_REM{1},mean(cell2mat(Data.LFPdeep_REM),2),'Color',LFP_colors{1})
            plot(Data.LFPt_REM{1},mean(cell2mat(Data.LFPsup_REM),2),'Color',LFP_colors{2})
        catch
            plot(Data.LFPt_REM{1},mean(cell2mat(Data.LFPrip_REM),2),'Color',LFP_colors{1})
            legend({'HPC'},'Location','northwest');
        end  
        xlabel('Time from event (ms)')  ; ylabel('mean LFP') ; 
        title(sprintf('REM (mean nb of events : %.2g)', mean(cell2mat(Data.nb_REM))),'Color',stages_colors{3}) ; 
        
        linkaxes([a1,a2,a3]) ; 
        
        
    elseif activity_plot{i} == 'MUA' % MUA plot
        yl = [0 0.6] ; 
        
        % Plot Wake MUA
        subplot(4,length(events_list),length(events_list)+i), hold on,
        plot(Data.MUAt_Wake{1},mean(cell2mat(Data.MUA_Wake),2),'Color',[0.2 0.2 0.2])
        xlabel('Time from event (ms)')  ; ylabel('mean MUA') ; ylim(yl) ; 
        title(sprintf('WAKE (mean nb of events : %.2g)', mean(cell2mat(Data.nb_Wake))),'Color',stages_colors{1}) ; 
        
        % Plot NREM MUA
        subplot(4,length(events_list),length(events_list)*2+i), hold on,
        plot(Data.MUAt_NREM{1},mean(cell2mat(Data.MUA_NREM),2),'Color',[0.2 0.2 0.2])
        xlabel('Time from event (ms)')  ; ylabel('mean MUA') ; ylim(yl) ;
        title(sprintf('NREM (mean nb of events : %.2g)', mean(cell2mat(Data.nb_NREM))),'Color',stages_colors{2}) ;
        
        % Plot REM MUA
        subplot(4,length(events_list),length(events_list)*3+i), hold on,
        plot(Data.MUAt_REM{1},mean(cell2mat(Data.MUA_REM),2),'Color',[0.2 0.2 0.2])
        xlabel('Time from event (ms)')  ; ylabel('mean MUA') ; ylim(yl) ;
        title(sprintf('REM (mean nb of events : %.2g)', mean(cell2mat(Data.nb_REM))),'Color',stages_colors{3}) ;
        
    end 
        
 
end


% Save figure : 
FigToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/ParcourInfo_EventsStages' ;
print(FigToSave, '-dpng', '-r300') ; 

