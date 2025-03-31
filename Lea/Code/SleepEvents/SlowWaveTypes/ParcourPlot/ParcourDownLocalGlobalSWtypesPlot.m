%% ParcourDownLocalGlobalSWtypesPlot
%
% 03/07/2020  LP 
%
% -> Script to plot index of down state "globality" (global vs local
% down state) associated to different types of SW. Computes the mean proportion
% of tetrodes with a local down state detected during sw associated to
% global down states (during NREM only). 
%
% -> Barplots comparing the different SW types.


clear

mean_across_mice = true ; % -> computes the mean across mice if true, across sessions if false. 
tosave = true ; % -> if true, saves the plots


% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourDownLocalGlobalSWtypes.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourDownLocalGlobalSWtypesPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourDownLocalGlobalSWtypesPlots'])
end

% Data for different slow wave types :
all_sw = {LocalDownSW3, LocalDownSW4, LocalDownSW6} ; 
all_sw_names = {'SW3','SW4','SW6'} ; 
all_sw_colors = {[1 0 0.4],[0.6 0.2 0.6],[0 0.6 0.4]} ;




%% ----------------------------------------- PLOT MEAN results across mice ----------------------------------------- :

struct_names = {'LocalDownSW3', 'LocalDownSW4', 'LocalDownSW6'} ;

% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 
[mice_list, ~, ix] = unique(Info_res.name) ; 

% ------------------------------- Get mice-averaged structures with mean tetrode proportions ------------------------------- :
 
% For each structure : 

for k = 1:length(struct_names) 
    
    eval(['struct = ' struct_names{k} ';']) ; 
        
    for m = 1:length(mice_list) % for each mice
        MeanTetrodeProp = cell2mat(struct.MeanTetrodeProp) ; 
        eval(['Mice' struct_names{k} '.MeanTetrodeProp{m} = nanmean(MeanTetrodeProp(:,ix==m)) ;'])
    end
    
end


% ------------------------------- Barplot ------------------------------- :

figure,
hold on,

for type = 1:length(all_sw)
    
    eval(['allprop = cell2mat(Mice' struct_names{type} '.MeanTetrodeProp);'])
    meanprop = nanmean(allprop);
    semprop = std(allprop) / sqrt(length(allprop)) ;
    bar(type,meanprop,'FaceColor',all_sw_colors{type},'FaceAlpha',0.7)  ;
    errorbar(type,meanprop,semprop,semprop,'Color',[0 0 0], 'LineStyle','none') ;
end

ylim([0 1]) ; 
set(gca,'Xtick',1:3, 'XTickLabel',all_sw_names,'FontSize',12) ; box on ; 
ylabel(['Index of down state "globality"' newline '(mean prop of tetrodes with a detected local down state)']) ; 
xlabel(['associated to global down states']) 



% -------------- SAVE MEAN PLOT -------------- : 
if tosave
    if mean_across_mice
        sgtitle(['Down state "globality" : Mean across mice (N=' num2str(n_mice) ')' newline ]); 
        print(['ParcourDownLocalGlobalSWtypesPlot_MiceMean'], '-dpng', '-r300') ;
    else
        sgtitle(['Down state "globality" : Mean across sessions (n=' num2str(n_sessions) ')' newline ]); 
        print(['ParcourDownLocalGlobalSWtypesPlot_SessionsMean'], '-dpng', '-r300') ;
    end
end

