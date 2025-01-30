%% ParcourInfo_AllSlowWaveTypesPlot
% 
% 18/05/2020  LP
%
% Script to get event info for all 2-channel slow wave types, 
% for all sessions. Save all plots in separate folders 
% (for the different analyses). 
%
% -> LFP
% -> mean spiking rate around slow waves
% -> cross-correlogram with down states, with ripples, with previous
% detection of delta waves (Karim Jr)
% -> Wake/NREM/REM repartition
%
% SEE : 
% ParcourMakeSlowWavesOn2Channels_LP() 
% PlotLFP_AllSlowWaveTypes
% PlotInfo_AllSlowWaveTypes
%
%

%% For each session : 

Dir = PathForExperimentsBasalSleepSpike2_HardDrive ;
PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/PlotInfo_AllSlowWaveTypes/' ; 

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])

    

%% ---------------------- Load Data ---------------------- : 

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
        % OB deep :
    load('ChannelsToAnalyse/Bulb_deep')
    load(['LFPData/LFP',num2str(channel)])
    LFPobdeep = LFP;
    ChannelOBdeep = channel ;

        % List with all LFP
    all_LFP = {LFPdeep,LFPsup,LFPobdeep} ; 
    all_LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;

        % OB sup (if exist) 
    try 
        load('ChannelsToAnalyse/Bulb_sup')
        load(['LFPData/LFP',num2str(channel)])
        LFPobsup = LFP;
        ChannelOBsup = channel ;

        % add to the list :
        all_LFP{end+1} = LFPobsup ;
        all_LFP_legend{end+1} = 'OB sup' ;

    end    
    clear LFP channel



    % LOAD EVENTS : 

    % 2-Channel Slow Waves : 
    load('SlowWaves2Channels_LP.mat')
    % Other events :
    try 
        load('Ripples.mat','tRipples')
    catch 
        load('Ripples.mat','Ripples')
        tRipples = ts(Ripples) ; 
    end
    load('DownState.mat')
    load('DeltaWaves.mat','alldeltas_PFCx')



    % LOAD SPIKE DATA :

    load('SpikeData.mat')
    num=GetSpikesFromStructure('PFCx');
    S=S(num); % S tsdArray des spikes des neurones du PFC uniquement 



    % LOAD SUBSTAGES : 
    load('SleepSubstages.mat') ; 
        REM = Epoch{strcmpi(NameEpoch,'REM')} ;
        WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
        SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;



    % ---------------------- Data and Plotting Info ---------------------- : 

    all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
    subplots_order = [1 3 7 9 2 8 4 6] ; 

    % LFP colors : 
    LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1],[0.8 0.5 0.1]} ;    
    % Label colors : 
    label_colors = {[0 0.3 0],[0.4 0.8 0.2],[1 0.6 0],[1 0 0.2]} ; 


%% ---------------------- Plot LFP on Slow Waves ---------------------- : 

    figure,

    % Plot All Types : 

    for type = 1:length(all_slowwaves) 
        all_subplots(type) = subplot(3,3,subplots_order(type));
        plot_LFPprofile(all_slowwaves{type},all_LFP,'LFPlegend',all_LFP_legend,'LFPcolor',LFP_colors,'newfig',0,'LineWidth',{2,2.1,1.3,1.3}) ;
        xlabel('Time from slow wave peak (ms)') ; 
        title(['Type ' num2str(type) sprintf('   (%.2e events)',length(Range(all_slowwaves{type})))]) ;
        xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
    end
    linkaxes(all_subplots) ; 

    % Title & Parameters 
    subplot(3,3,5),
    text(0.5,0.85,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
    text(0.5,0.6,'Mean LFP signals','FontSize',20,'HorizontalALignment','center'), axis off
    text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off


    % Save figure : 
    print([PathToSave 'LFPprofiles/AllSlowWaveTypes_LFPprofiles_' num2str(p)], '-dpng', '-r250') ; 
    close(gcf)
    

%% ---------------------- Plot spiking rate of PFCx neurons ---------------------- : 


    % Spiking Data :

    Q=MakeQfromS(tsdArray(PoolNeurons(S,1:length(S))),20); % MakeQfromS(S,bin) = Spike Train Binning (time histogram of firing rate, time bin in same unit as S)
    q=full(Data(Q));
    Qs=tsd(Range(Q),q(:,1));

    % Plot for all Types :

    figure,
    %yl = [0 0.7] ;

    for type = 1:length(all_slowwaves) 
        all_plots(type) = subplot(3,3,subplots_order(type)) ;
        [m,s,t]=mETAverage(Range(all_slowwaves{type}),Range(Qs),Data(Qs),1,1000);  
        area(t,m,'FaceColor',[0.3 0.3 0.3],'LineStyle','none')
        ylabel('Mean spiking rate') ; xlabel('Time from slow wave peak (ms)') ; title(['Type ' num2str(type)]) ;
        %ylim(yl) ;  
        xline(0,'--','Color',[0.3 0.3 0.3]) ;
    end
    linkaxes(all_plots) ;

    % Title & Parameters 
    subplot(3,3,5),
    text(0.5,0.85,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
    text(0.5,0.6,'Mean PFCx Spiking Rate','FontSize',20,'HorizontalALignment','center'), axis off
    text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

    % Save figure : 
    print([PathToSave 'SpikingRate/AllSlowWaveTypes_SpikingRate_' num2str(p)], '-dpng', '-r250') ; 
    close(gcf)


%% ---------------------- Plot Cross-Correlogram with down states ---------------------- : 


    % Plot for all Types :

    figure,
    yl = [0 18] ;

    for type = 1:length(all_slowwaves) 
        subplot(3,3,subplots_order(type)),

        %[C,B]=CrossCorr(Range(all_slowwaves{type}),Start(alldown_PFCx),10,100); % t1=t_ref, t2=t_obs, durée bin (ms), nombre bins

        % Cross-corr with Down state middle time
        [C,B]=CrossCorr(Range(all_slowwaves{type}),(Start(alldown_PFCx)+End(alldown_PFCx))/2,10,100); 

        % Color depending on max values : 
        if any (C>15)
            plot_color = label_colors{4} ;
        elseif any (C>10)
            plot_color = label_colors{3} ;
        elseif any (C>5)
            plot_color = label_colors{2} ; 
        else
            plot_color = label_colors{1} ; 
        end

        area(B,C,'FaceColor',plot_color,'LineStyle','none') 

        ylabel(['Correlation index :' newline 'Down States x Slow Waves']) ; xlabel('Time from slow wave peak (ms)') ; 
        title(['Type ' num2str(type)]) ; %ylim(yl) ; 
        xline(0,'--','Color',[0.3 0.3 0.3]) ;
    end

    % Title & Parameters 
    subplot(3,3,5),
    text(0.5,0.95,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
    text(0.5,0.7,['Cross-correlogram with Down States' newline '(mid-time)'],'FontSize',20,'HorizontalAlignment','center'), axis off
    text(0.5,0.45,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.3,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalAlignment','center'), axis off
    text(0.5,0.15,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
    % Color Legend : 
    text(0.25,0,'> 15','FontSize',15,'HorizontalALignment','center','Color',label_colors{4}), axis off
    text(0.4,0,'> 10','FontSize',15,'HorizontalALignment','center','Color',label_colors{3}), axis off
    text(0.55,0,'> 5','FontSize',15,'HorizontalALignment','center','Color',label_colors{2}), axis off
    text(0.7,0,'< 5','FontSize',15,'HorizontalALignment','center','Color',label_colors{1}), axis off



    % Save figure : 
    print([PathToSave 'CrossCorrDown/AllSlowWaveTypes_CrossCorrDown_' num2str(p)], '-dpng', '-r250') ; 
    close(gcf)



%% ---------------------- Plot Cross-Correlogram with ripples ---------------------- : 



    % Plot for all Types :

    figure,
    yl = [0 1.5] ;

    for type = 1:length(all_slowwaves) 
        subplot(3,3,subplots_order(type)),

        % Cross-corr with Down state middle time
        [C,B]=CrossCorr(Range(all_slowwaves{type}),Range(tRipples),10,100); 

        % Color depending on max values : 
        if any (C>5)
            plot_color = label_colors{4} ;
        elseif any (C>1)
            plot_color = label_colors{3} ;
        elseif any (C>0.5)
            plot_color = label_colors{2} ; 
        else
            plot_color = label_colors{1} ; 
        end

        area(B,C,'FaceColor',plot_color,'LineStyle','none')  


        ylabel(['Correlation index :' newline 'Ripples x Slow Waves']) ; xlabel('Time from slow wave peak (ms)') ; 
        title(['Type ' num2str(type)]) ; ylim(yl) ; 
        xline(0,'--','Color',[0.3 0.3 0.3]) ;
    end


    % Title & Parameters 
    subplot(3,3,5),
    text(0.5,0.95,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
    text(0.5,0.7,'Cross-correlogram with Ripples','FontSize',20,'HorizontalAlignment','center'), axis off
    text(0.5,0.5,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.35,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.2,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
    % Color Legend : 
    text(0.25,0,'> 5','FontSize',15,'HorizontalALignment','center','Color',label_colors{4}), axis off
    text(0.4,0,'> 1','FontSize',15,'HorizontalALignment','center','Color',label_colors{3}), axis off
    text(0.55,0,'> 0.5','FontSize',15,'HorizontalALignment','center','Color',label_colors{2}), axis off
    text(0.7,0,'< 0.5','FontSize',15,'HorizontalALignment','center','Color',label_colors{1}), axis off


    % Save figure : 
    print([PathToSave 'CrossCorrRipples/AllSlowWaveTypes_CrossCorrRipples_' num2str(p)], '-dpng', '-r250') ; 
    close(gcf)


%% ---------------------- Plot Cross-Correlogram with KJ detection of delta waves ---------------------- : 


    % Plot for all Types :

    figure,
    yl = [0 17] ;

    for type = 1:length(all_slowwaves) 
        subplot(3,3,subplots_order(type)),

        % Cross-corr with Down state middle time
        [C,B]=CrossCorr(Range(all_slowwaves{type}),(Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2,10,100); 

        % Color depending on max values : 
        if any (C>15)
            plot_color = label_colors{4} ;
        elseif any (C>10)
            plot_color = label_colors{3} ;
        elseif any (C>5)
            plot_color = label_colors{2} ; 
        else
            plot_color = label_colors{1} ; 
        end

        area(B,C,'FaceColor',plot_color,'LineStyle','none') 

        ylabel(['Correlation index :' newline 'Delta KJ x Slow Waves']) ; xlabel('Time from slow wave peak (ms)') ; 
        title(['Type ' num2str(type)]) ; % ylim(yl) ; 
        xline(0,'--','Color',[0.3 0.3 0.3]) ;
    end

    % Title & Parameters 
    subplot(3,3,5),
    text(0.5,0.95,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
    text(0.5,0.7,['Cross-correlogram with KJ Delta Waves' newline '(mid-time)'],'FontSize',20,'HorizontalAlignment','center'), axis off
    text(0.5,0.45,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.3,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.15,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
    % Color Legend : 
    text(0.25,0,'> 15','FontSize',15,'HorizontalALignment','center','Color',label_colors{4}), axis off
    text(0.4,0,'> 10','FontSize',15,'HorizontalALignment','center','Color',label_colors{3}), axis off
    text(0.55,0,'> 5','FontSize',15,'HorizontalALignment','center','Color',label_colors{2}), axis off
    text(0.7,0,'< 5','FontSize',15,'HorizontalALignment','center','Color',label_colors{1}), axis off


    % Save figure : 
    print([PathToSave 'CrossCorrDeltaKJ/AllSlowWaveTypes_CrossCorrDeltaKJ_' num2str(p)], '-dpng', '-r250') ; 
    close(gcf)


%% ---------------------- Plot Wake / NREM / REM occurrence repartition ---------------------- : 


    % Plot for all Types :

    substages_list = {WAKE,SWS,REM} ; 
    substages_names = {'Wake', 'NREM', 'REM'} ;
    stage_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ; 

    figure,
    yl = [0 110] ;

    for type = 1:length(all_slowwaves) 
        subplot(3,3,subplots_order(type)),

        hold on,
        for k = 1:length(substages_list) 
            stage_events = belong(substages_list{k},Range(all_slowwaves{type})) ; 
            stage_prop = sum(stage_events) / length(stage_events) *100 ; % proportion of events starting during this stage
            bar(k,stage_prop,'LineStyle','none','FaceColor',stage_colors{k}) ;  
            text(k,stage_prop + 5,[sprintf(' %.3g',stage_prop) ' %'],'Color',stage_colors{k},'HorizontalAlignment','center','FontSize',11) ; 
        end


        set(gca,'Xtick',1:length(substages_list), 'XTickLabel',substages_names,'FontSize',12) ; box on ; 
        ylabel('% of events in each stage') ; title('Stage repartition') ;  
        ylim(yl) ; title(['Type ' num2str(type)]) ; 
    end

    % Title & Parameters 
    subplot(3,3,5),
    text(0.5,0.85,'2-Channel Slow Waves','FontSize',25,'HorizontalAlignment','center'), axis off
    text(0.5,0.6,['Wake / NREM / REM Occurrence Repartition'],'FontSize',20,'HorizontalAlignment','center'), axis off
    text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
    text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

    
    % Save figure : 
    print([PathToSave 'StageOccurrence/AllSlowWaveTypes_StageOccurrence_' num2str(p)], '-dpng', '-r250') ; 
    close(gcf)

    
end