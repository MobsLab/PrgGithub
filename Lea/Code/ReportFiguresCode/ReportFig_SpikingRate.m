%% ReportFig_SpikingRate
%
% 05/06/2020
%
% To plot mean Spiking Rate across mice for all slow wave types. 


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


% ------------------------------ Mean Spiking Rate ------------------------------ :

figure,
yl = [0 2.4] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['data = MiceSlowWaves' num2str(type) '.SpikingRate ;']) ;
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
    set(gca,'FontSize',10.5)
    title(['Type ' num2str(type)],'FontSize',12) ;
    
end

set(gcf, 'Position',  [1, 1, 1270, 635])


% Save figure : 
print([PathToSave 'MiceMeanSpikingRate'], '-dpng', '-r300') ; 
%close(gcf)


% ------------------------------ Mean Spiking Rate for NREM-restricted slow waves only ------------------------------ :

figure,
yl = [0 2.4] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['data = MiceSlowWaves' num2str(type) '.nremSpikingRate ;']) ;
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
    set(gca,'FontSize',10.5)
    title(['Type ' num2str(type)],'FontSize',12) ;
    
end

set(gcf, 'Position',  [1, 1, 1270, 635])


% Save figure : 
print([PathToSave 'MiceMeanSpikingRate_NREM'], '-dpng', '-r300') ; 
%close(gcf)



