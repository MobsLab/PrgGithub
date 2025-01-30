%% ParcourDownDurationSWtypesPlot
%
% 29/06/2020  LP
%
% -> script to plot histograms of down state duration for down states
% associated to different SW types (SW3, 4, or 6)
% -> for whole session, for begin (1st half), and for end (2nd half)
%
% -> Plot for all sessions + Mean plot across mice or across sessions


clear

mean_across_mice = true ; % -> computes the mean across mice if true, across sessions if false. 
tosave = false ; % -> if true, saves the plots

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourDownDurationSWtypes.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourDownDurationSWtypesPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourDownDurationSWtypesPlots'])
end

% Data for different slow wave types :
sw_data = {DownDuration.sw3, DownDuration.sw4, DownDuration.sw6} ; 
sw_names = {'SW3','SW4','SW6'} ; 
sw_colors = {[1 0 0.4],[0.6 0.2 0.6],[0 0.6 0.4]} ;

%% ----------------------------------------- PLOT DATA separately for each session ----------------------------------------- :


for p=1:length(Info_res.name) % for each session 
    
    figure,
    
    for type = 1:length(sw_data)
        
        data = sw_data{type} ; 
        events_name = sw_names{type} ; 
    
        
        % ----------- Plot histogram of down duration for each group (all/begin/end) ------------ :

        all_dur = {data.duration_all, data.duration_begin, data.duration_end} ; 
        all_dur_names = {'all', 'begin', 'end'} ; 

        for k=1:length(all_dur)
            
            dur = all_dur{k} ; % data with down duration for this sw type and this time period
            subplot(length(sw_data),3,(type-1)*3+k),
            histogram(dur{p},data.histbins{p},'FaceColor',sw_colors{type},'FaceAlpha',0.7) ; % histogram
            mean_duration = nanmean(dur{p}) ; 
            l = xline(mean_duration,'-','Color',[0.8 0.05 0.2],'LineWidth',2) ; % mean duration line
            legend(l,sprintf('mean = %.2g ms', mean_duration)) ; legend boxoff ;
            xlabel('down state duration (ms)') ; title([events_name ' : ' all_dur_names{k} sprintf(' (%.2e events)',length(dur{p}))]) 
        
        end
    end
    
    sgtitle(['SW-Associated Down State Duration : ' Info_res.name{p} ', Plot ' num2str(p)]); 
    if tosave
        print(['ParcourDownDurationSWtypesPlot_' Info_res.name{p} '_Plot' num2str(p)], '-dpng', '-r300') ; 
    end
end




%% ----------------------------------------- PLOT MEAN results across mice ----------------------------------------- :

struct_names = {'DownDuration.sw3', 'DownDuration.sw4', 'DownDuration.sw6'} ;
all_dur_names = {'all', 'begin', 'end'} ; 

% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 
[mice_list, ~, ix] = unique(Info_res.name) ; 


% ------------------------------- Get mice-averaged structures ------------------------------- :
 
% For each structure : 

for k = 1:length(struct_names) 
    
    eval(['struct = ' struct_names{k} ';']) ; 
    
    for i=1:length(all_dur_names) % all/begin/end
        
        for m = 1:length(mice_list) % for each mice
            eval(['meandur = cell2mat(struct.meanduration_' all_dur_names{i} ') ; '])
            eval(['Mice' struct_names{k} '.meanduration_' all_dur_names{i} '{m} = nanmean(meandur(:,ix==m),2) ;'])
            eval(['histdur = transpose(cell2mat(transpose(struct.histduration_' all_dur_names{i} '))) ; '])
            eval(['Mice' struct_names{k} '.histduration_' all_dur_names{i} '{m} = nanmean(histdur(:,ix==m),2) ;'])
        end
    end
    
end
   


% ------------------------------- Plot mean histograms ------------------------------- :

if mean_across_mice % mean across mice
    sw_data = {MiceDownDuration.sw3, MiceDownDuration.sw4, MiceDownDuration.sw6} ; 
else % mean across sessions
    sw_data = {DownDuration.sw3, DownDuration.sw4, DownDuration.sw6} ;
end

histbins = DownDuration.sw3.histbins{1} ; 
yl = [0 25] ; 

figure,

% For each slow wave type :
for type = 1:length(sw_data)

    data = sw_data{type} ; 
    events_name = sw_names{type} ; 
    all_dur = {data.histduration_all, data.histduration_begin, data.histduration_end} ; 
    all_meandur = {data.meanduration_all, data.meanduration_begin, data.meanduration_end} ; 
    all_dur_names = {'all', 'begin', 'end'} ; 

    % For all/begin/end
    for k=1:length(all_dur)

        dur = all_dur{k} ; % data with histograms of down duration for this sw type and this time period
        
        subplot(length(sw_data),3,(type-1)*3+k),
        hold on,
        
        % HISTOGRAM :
        all_hist = cell2mat(dur) ; % double array with bins x experiments
        all_norm_hist = all_hist ./ sum(all_hist) *100 ; % hist in percentage of down states
        hist_mean = nanmean(all_norm_hist,2) ; 
        histogram('BinEdges',histbins,'BinCounts',hist_mean,'FaceColor',sw_colors{type},'FaceAlpha',0.7) ; % mean histogram
        
        % ERRORBARS on the histogram :
        x_bins = (histbins(2:end) + histbins(1:end-1)) / 2 ; % get middle of bars on x-axis
        hist_sem = nanstd(all_norm_hist') / sqrt(size(all_norm_hist,2)) ; 
        errorbar(x_bins,hist_mean,hist_sem,hist_sem,'Color',[0 0 0], 'LineStyle','none') ;
        
        % MEAN DURATION 
        mean_dur = all_meandur{k} ;
        meandur_mean = nanmean(cell2mat(mean_dur)) ;
        l = xline(meandur_mean,'-','Color',[0.25 0.25 0.25],'LineWidth',2) ; % line with mean (across mice or sessions) of mean duration
            % + SEM error area on mean duration : 
            meandur_sem = nanstd(cell2mat(mean_dur)) / sqrt(length(cell2mat(mean_dur))) ; 
            area([meandur_mean-meandur_sem, meandur_mean+meandur_sem],[yl(2) yl(2)],'LineStyle','none','FaceColor',[0.25 0.25 0.25],'FaceAlpha',0.3) ; 
        

        % LEGEND :
        ylim(yl) ; 
        legend(l,sprintf('mean duration = %.3g ms', meandur_mean),'FontSize',11) ; legend boxoff ;
        xlabel('down state duration (ms)') ; ylabel('% of SW-associated down states') ; title([events_name ' : ' all_dur_names{k}]) 

    end

end



% -------------- SAVE MEAN PLOT -------------- : 
if tosave
    if mean_across_mice
        sgtitle(['SW-Associated Down State Duration : Mean across mice (N=' num2str(n_mice) ')' newline ]); 
        print(['ParcourDownDurationSWtypesPlot_MiceMean'], '-dpng', '-r300') ;
    else
        sgtitle(['SW-Associated Down State Duration : Mean across sessions (n=' num2str(n_sessions) ')' newline ]); 
        print(['ParcourDownDurationSWtypesPlot_SessionsMean'], '-dpng', '-r300') ;
    end
end

