%% ReportFig_CrossCorrRipples
%
% 05/06/2020
%
% To plot mean Cross-correlogram with ripples, across mice for all slow wave types. 


% ------------------------------------------ Load Data ------------------------------------------ :

clear
load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourInfo_AllSlowWaveTypes.mat
PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/M2ReportFigures/' ; 
%set(gcf,'DefaultFigureWindowStyle','normal')


% Subplots organization : 
subplots_order = [1 3 7 9 2 8 4 6] ; 

% LFP colors : 

LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1]} ; 
LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;

stages_names = {'Wake', 'NREM', 'REM'} ;
stages_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ;
% Label colors : 
label_colors = {[0 0.3 0],[0.4 0.8 0.2],[1 0.6 0],[1 0 0.2]} ; 
all_colors = {[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 

%% --------------------------------------------- MEAN PLOTS ACROSS MICE ---------------------------------------------- :

% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 

% ------------------------------- Get mice-averaged structures ------------------------------- :

[mice_list, ~, ix] = unique(Info_res.name) ; 


% For each structure : 

for type = 1:8
    
    eval(['struct = SlowWaves' num2str(type) ';']) ; 
    fieldnames = fields(struct) ;
    
    for field = 1:length(fieldnames)
        eval(['struct2 = struct.' fieldnames{field} ';'])
        fieldnames2 = fields(struct2) ;
        
        for field2 = 1:length(fieldnames2)
            eval(['data = cell2mat(struct2.' fieldnames2{field2} ') ;'])
            
            for m = 1:length(mice_list) 
                mice_data{m} = nanmean(data(:,ix==m),2) ; 
            end 

            eval(['MiceSlowWaves' num2str(type) '.' fieldnames{field} '.' fieldnames2{field2} ' = mice_data;']) 
            
        end
    end
end


% ------------------------------ Mean CrossCorrelogram with Ripples ------------------------------ :


figure,
yl = [0 1] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = MiceSlowWaves' num2str(type) '.CrossCorrRipples ;']) ;
    y = cell2mat(Data.crosscorr) ; 
    mean_crosscorr = mean(y,2);
    
    % Color depending on max values : 
    if any (mean_crosscorr>0.8)
        plot_color = label_colors{4} ;
    elseif any (mean_crosscorr>0.6)
        plot_color = label_colors{3} ;
    elseif any (mean_crosscorr>0.4)
        plot_color = label_colors{2} ; 
    else
        plot_color = label_colors{1} ; 
    end
    
    % Get and plot mean spiking rate : 
    t = Data.t{1} ; 
    sem = std(y,0,2) / sqrt(size(y,2)) ; 
    hold on,
    area(t,mean(y,2)-sem,'LineStyle','none','HandleVisibility','off','FaceColor',all_colors{type},'FaceAlpha',0.5);
    stdshade(y',0.7,all_colors{type},t) ; % plot mean data +/- SEM (shaded area)
    
    % Legend / Labels : 
    ylim(yl) ; 
    xline(0,'--','Color',[0.3 0.3 0.3]) ;
    ylabel('Mean correlation index') ; xlabel('Time from slow wave peak (ms)') ; 
    %legend('± SEM','Mean') ; legend boxoff ; 
    set(gca,'FontSize',10.5) ; 
    title(['Type ' num2str(type)],'FontSize',12) ;
    xticks([-500:250:500]);
    
end

% subplot(3,3,5),
% text(0.5,0.95,'2-Channel Slow Waves','FontSize',24,'HorizontalALignment','center'), axis off
% text(0.5,0.7,['Cross-corr. with Ripples' newline 'Mean across mice (N = ' num2str(n_mice) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
% text(0.5,0.45,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
% text(0.5,0.3,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
% text(0.5,0.15,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
% % Color Legend : 
% text(0.25,0,'> 0.8','FontSize',15,'HorizontalAlignment','center','Color',label_colors{4}), axis off
% text(0.4,0,'> 0.6','FontSize',15,'HorizontalAlignment','center','Color',label_colors{3}), axis off
% text(0.55,0,'> 0.4','FontSize',15,'HorizontalAlignment','center','Color',label_colors{2}), axis off
% text(0.7,0,'< 0.4','FontSize',15,'HorizontalAlignment','center','Color',label_colors{1}), axis off

% Save figure : 
% print([PathToSave 'MiceMeanCrossCorrRipples'], '-dpng', '-r300') ; 



