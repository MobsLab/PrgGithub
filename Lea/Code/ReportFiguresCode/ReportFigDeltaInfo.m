
% ------------------------------------------ Load Data ------------------------------------------ :

clear
load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourInfo_AllSlowWaveTypes.mat
PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/M2ReportFigures/' ; 


%% --------------------------------------------- MEAN PLOTS ACROSS MICE ---------------------------------------------- :

% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 

% ------------------------------- Get mice-averaged structures ------------------------------- :

[mice_list, ~, ix] = unique(Info_res.name) ; 

% For each structure : 

struct = DiffDeltaWaves ; 
fieldnames = fields(struct) ;

for field = 1:length(fieldnames)
    eval(['struct2 = struct.' fieldnames{field} ';'])
    fieldnames2 = fields(struct2) ;

    for field2 = 1:length(fieldnames2)
        eval(['data = cell2mat(struct2.' fieldnames2{field2} ') ;'])

        for m = 1:length(mice_list) 
            mice_data{m} = nanmean(data(:,ix==m),2) ; 
        end 

        eval(['MiceDiffDeltaWaves.' fieldnames{field} '.' fieldnames2{field2} ' = mice_data;']) 

    end
end


% ------------------------------ Mean LFP Profiles ------------------------------ :

% LFP plot info : 
LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1]} ; 
LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;
yl = [-130 220] ; 

figure,

hold on,
    
% Get data : 
data = MiceDiffDeltaWaves.LFPprofiles ; 

% Plot all LFP :

% Plot all LFP :
    stdshade((cell2mat(data.PFCdeep)/10)',0.3,LFP_colors{1},data.t{1},1,1.7) ;
    stdshade((cell2mat(data.PFCsup)/10)',0.3,LFP_colors{2},data.t{1},1,1.8) ;
    b = stdshade((cell2mat(data.OBdeep)/10)',0.2,LFP_colors{3},data.t{1},1,1) ;


% Legend & Labels : 
set(gca,'FontSize',12)
xlabel(['Time from slow wave peak (ms)']) ; ylabel('Mean LFP amplitude (\muV)')
ylim(yl) ; title(['Delta Wave'],'Fontsize',12) ;
xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
yline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
legend(LFP_legend,'Orientation','vertical','Location','northeast') ; legend boxoff ;
xticks([-500 -250 0 250 500]) ;  yticks([-100 0 100 200]) ;
uistack(b,'bottom');


% Save figure : 
% print([PathToSave 'Delta_LFPprofile'], '-dpng', '-r300') ; 




% ------------------------------ Mean Spiking Rate ------------------------------ :

figure,
yl = [0 2.4] ;

hold on,
    
% Get data : 
data = MiceDiffDeltaWaves.SpikingRate ; 
y = cell2mat(data.rate) ; 
y = y / mean(y(:)) ; 
sem = std(y')/sqrt(size(y,2)) ; 

% Get and plot mean spiking rate : 
t = data.t{1} ; 
hold on, 
a = area(t,mean(y,2)-sem','LineStyle','none','HandleVisibility','off','FaceColor',[0.45 0.45 0.45]);
l = stdshade(y',0.7,'k',t) ; % plot mean data +/- SEM (shaded area) 

% Legend / Labels : 
ylim(yl) ; 
xline(0,'--','Color',[0.1 0.1 0.1]) ;
ylabel('Normalized firing rate') ; xlabel('Time from slow wave peak (ms)') ; 
legend([a,l],{'± SEM','Mean'}) ; legend boxoff ; 
xticks([-500 -250 0 250 500]) ;  yticks([0 0.5 1 1.5 2]) ;
set(gca,'FontSize',12)
title(['Delta Wave'],'FontSize',12) ;

% Save figure : 
% print([PathToSave 'Delta_SpikingRate'], '-dpng', '-r300') ; 




%% ------------------------------ Co-occurrence of Delta with slow waves ------------------------------ :

clear 

cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
load('ParcourDeltaCooccur_AllSlowWaveTypes.mat')  ; 
PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/M2ReportFigures/' ; 


all_colors = {[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 



% ------------------------------- Get mice-averaged structures ------------------------------- :

% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 
[mice_list, ~, ix] = unique(Info_res.name) ; 
 
% For each structure : 

for k = 1:length(struct_names) 
    
    eval(['struct = ' struct_names{k} ';']) ; 
    fieldnames = fields(struct) ;
    
    for field = 1:length(fieldnames)
            eval(['data = cell2mat(struct.' fieldnames{field} ') ;'])
            
        for m = 1:length(mice_list) 
                mice_data{m} = nanmean(data(:,ix==m),2) ; 
        end 

        eval(['Mice' struct_names{k} '.' fieldnames{field} ' = mice_data;']) 
            
    end
end


% ------------------------------- Mean Plot NREM only ------------------------------- :


figure,
ylim([0 55]) ;

for type = 1:length(struct_names) 
    
    hold on,
    eval(['struct = MiceSlowWaves' num2str(type) ';']) ; 
    
    delta_cosw_prop = mean(cell2mat(struct.NREMdelta_cosw_prop)) ; % mean proportion
    delta_cosw_propsem = std(cell2mat(struct.NREMdelta_cosw_prop))/sqrt(n_mice) ; % sem
    
    % --- Barplot --- :
    
    % Proportion of Down States : 
    bar(type,delta_cosw_prop,'LineStyle','none','FaceColor',all_colors{type},'FaceAlpha',0.7) ;
    errorbar(type,delta_cosw_prop,delta_cosw_propsem,delta_cosw_propsem,'Color',[0 0 0], 'LineStyle','none') ;
    if delta_cosw_prop > 1 
        text(type,delta_cosw_prop + delta_cosw_propsem + 6 ,[sprintf(' %.2g',delta_cosw_prop) ' %'],'Color',all_colors{type},'HorizontalAlignment','center','FontSize',12) ; 
    else
        text(type,delta_cosw_prop + delta_cosw_propsem + 6 ,['< 1%'],'Color',all_colors{type},'HorizontalAlignment','center','FontSize',12) ; 
    end
end   

    % Labels and appearance
 set(gca,'FontSize',12)
 set(gca,'Xtick',1:8,'FontSize',12) ; box off ; 
 xlim([0.2,8.8]) ; 
 xlabel('Slow Wave Type'); ylabel(['% of Delta Waves' newline '']) ;
 title(['Mean Slow Wave Cooccurrence (N = ' num2str(n_mice) ' mice)'])  ; 
 
 % Save figure : 
% print([PathToSave 'Delta_SWCooccur'], '-dpng', '-r300') ; 

 