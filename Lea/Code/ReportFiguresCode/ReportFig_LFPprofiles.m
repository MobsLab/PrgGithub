%% ReportFig_LFPprofiles
%
% 05/06/2020
%
% To plot mean LFP profiles across mice for all slow wave types. 



% ------------------------------------------ Load Data ------------------------------------------ :

clear
load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourInfo_AllSlowWaveTypes.mat
PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/M2ReportFigures/' ; 
set(0,'DefaultFigureWindowStyle','normal')
tosave = 0;


% Subplots organization : 
subplots_order = [1 3 7 9 2 8 4 6] ; 

% LFP plot info : 
LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1]} ; 
LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;



% --------------------------------------------- MEAN PLOTS ACROSS MICE ---------------------------------------------- :


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


% ------------------------------ Mean LFP Profiles ------------------------------ :

figure,
yl = [-190 240] ; 

for type = 1:8      %for each slow wave type
    
    subplot(3,3,subplots_order(type));
    hold on,
    
    % Get data : 
    eval(['Data = MiceSlowWaves' num2str(type) '.LFPprofiles ;']) ; 
    
    % Plot all LFP :
    
    mean_PFCdeep = mean(cell2mat(Data.PFCdeep),2);
    plot(Data.t{1},mean_PFCdeep/10,'Color',LFP_colors{1},'LineWidth',2.1)
    mean_PFCsup = mean(cell2mat(Data.PFCsup),2);
    plot(Data.t{1},mean_PFCsup/10,'Color',LFP_colors{2},'LineWidth',2.2)
    mean_OBdeep = mean(cell2mat(Data.OBdeep),2);
    b = plot(Data.t{1},mean_OBdeep/10,'Color',LFP_colors{3},'LineWidth',1.3) ; 
    
    
    
    % Legend & Labels : 
    set(gca,'FontSize',10.5)
    xlabel(['Time from slow wave peak (ms)']) ;  ylabel('Mean LFP amplitude (\muV)') ; 
    ylim(yl) ; title(['Type ' num2str(type)],'Fontsize',12) ;
    xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
    yline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
    legend(LFP_legend,'Orientation','vertical','Location','northeast') ; legend boxoff ;
    xticks([-500 -250 0 250 500]) ;  yticks([-100 0 100 200]) ;
    uistack(b,'bottom');
end


set(gcf, 'Position',  [1, 1, 1270, 635])


% Save figure : 
if tosave
    print([PathToSave 'Final_LFPprofiles'], '-dpng', '-r300') ; 
end
% close(gcf)




% ------------------------------ Mean LFP Profiles ------------------------------ :

figure,
yl = [-190 240] ; 

for type = 1:8      %for each slow wave type
    
    subplot(3,3,subplots_order(type));
    hold on,
    
    % Get data : 
    eval(['Data = MiceSlowWaves' num2str(type) '.LFPprofiles ;']) ; 
    
    % Plot all LFP :
    stdshade((cell2mat(Data.PFCdeep)/10)',0.3,LFP_colors{1},Data.t{1},1,1.7) ;
    stdshade((cell2mat(Data.PFCsup)/10)',0.3,LFP_colors{2},Data.t{1},1,1.8) ;
    b = stdshade((cell2mat(Data.OBdeep)/10)',0.2,LFP_colors{3},Data.t{1},1,1) ;
    
    % Legend & Labels : 
    set(gca,'FontSize',10.5)
    xlabel(['Time from slow wave peak (ms)']) ; ylabel('Mean LFP amplitude (\muV)') ; 
    ylim(yl) ; title(['Type ' num2str(type)],'Fontsize',12) ;
    xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
    yline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
    legend(LFP_legend,'Orientation','vertical','Location','northeast') ; legend boxoff ;
    xticks([-500 -250 0 250 500]) ; yticks([-100 0 100 200]) ;
    uistack(b,'bottom'); 
end


set(gcf, 'Position',  [1, 1, 1270, 635])


% Save figure : 
if tosave
    print([PathToSave 'Final_LFPprofiles2'], '-dpng', '-r300') ; 
end
% close(gcf)

