%% ParcourSlowWaveProportionsMeanPlot
%
% 29/05/2020
%
% -> Script to quantify the proportions of all slow wave types, for all
% stages / NREM only / Wake only.
% -> mean plot on all sessions


clear
Dir = PathForExperimentsSlowWavesLP_HardDrive ;

% For each session :

for p=1:length(Dir.path)

    eval(['cd(Dir.path{',num2str(p),'}'')'])
    
    
    % Store Session Info :
    Info_res.path{p}   = Dir.path{p};
    Info_res.manipe{p} = Dir.manipe{p};
    Info_res.name{p}   = Dir.name{p};
    

    % --------------- Load Data --------------- :

    % LOAD EPOCHS :
    load('SleepSubstages.mat')
    SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
    load NoiseHomeostasisLP TotalNoiseEpoch % noise
    cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;

    % LOAD SW :
    load('SlowWaves2Channels_LP.mat')
    all_slowwaves_ts = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
    

    % --------------- Get proportions --------------- :

    all_nb_slowwaves = [] ; 
    NREM_nb_slowwaves = [] ; 
    Wake_nb_slowwaves = [] ;
    all_rate_slowwaves = [] ; 
    NREM_rate_slowwaves = [] ; 
    Wake_rate_slowwaves = [] ; 
    

    for type = 1:length(all_slowwaves_ts)
        all_nb_slowwaves(type) = length(Range(all_slowwaves_ts{type})) ; 
        NREM_nb_slowwaves(type) = length(Range(Restrict(all_slowwaves_ts{type},SWS))) ; 
        Wake_nb_slowwaves(type) = length(Range(Restrict(all_slowwaves_ts{type},WAKE))) ;
    
        % Get occurrence rate : 
        all_rate_slowwaves(type) = nanmean(Data(instantRate(all_slowwaves_ts{type}))) ;
        NREM_rate_slowwaves(type) = nanmean(Data(instantRate(Restrict(all_slowwaves_ts{type},SWS)))) ; 
        Wake_rate_slowwaves(type) = nanmean(Data(instantRate(Restrict(all_slowwaves_ts{type},WAKE)))) ;
    
    end
    
    % --------------- Store in cell arrays --------------- :
    
    all_nb{p} = all_nb_slowwaves ; 
    NREM_nb{p} = NREM_nb_slowwaves ; 
    Wake_nb{p} = Wake_nb_slowwaves ; 
    NREMprop{p} = sum(NREM_nb_slowwaves)/(sum(all_nb_slowwaves)) ; % proportion of all slow waves occurring during NREM sleep

    all_rate{p} = all_rate_slowwaves ; 
    NREM_rate{p} = NREM_rate_slowwaves ; 
    Wake_rate{p} = Wake_rate_slowwaves ;
    
end 




% --------------- Plot Mean Pie Charts and save them --------------- :

PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourSlowWaveProportionsMeanPlot/' ; 
all_colors = {[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 

figure,

% Plot All slow waves
subplot(1,3,1),
h=pie(mean(cell2mat(all_nb')),[0 0 1 0 0 0 0 0]);
colormap(cat(1,all_colors{:})); set(h,'EdgeColor', [1 1 1]);
set(findobj(h, '-property', 'FaceAlpha'), 'FaceAlpha', 0.7);
legend({'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'},'Location','northeastoutside') ; legend boxoff ; 
title(['Mean proportions of Slow Wave Types (all stages)' newline '(n = ' num2str(length(all_nb)) ' sessions)'],'FontSize',12)



% Plot Slow Waves during NREM
subplot(1,3,2),
h=pie(mean(cell2mat(NREM_nb')),[0 0 1 0 0 0 0 0]) ; set(h,'EdgeColor', [1 1 1]);
set(findobj(h, '-property', 'FaceAlpha'), 'FaceAlpha', 0.7);
colormap(cat(1,all_colors{:})); set(findobj(h, '-property', 'EdgeColor'), 'EdgeColor', [1 1 1]);
title(['Mean proportions of Slow Wave Types in NREM sleep ' sprintf('(~%.2g',mean(cell2mat(NREMprop)*100)) '% of all)' newline '(n = ' num2str(length(all_nb)) ' sessions)'],'FontSize',12)
legend({'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'},'Location','northeastoutside') ; legend boxoff ; 



% Plot Slow Waves during Wake 
subplot(1,3,3),
h=pie(mean(cell2mat(Wake_nb')),[0 0 1 0 0 0 0 0]) ; 
colormap(cat(1,all_colors{:})); set(h,'EdgeColor', [1 1 1]);
set(findobj(h, '-property', 'FaceAlpha'), 'FaceAlpha', 0.7);
title(['Mean proportions of Slow Wave Types in Wake ' sprintf('(~%.2g',100-mean(cell2mat(NREMprop)*100)) '% of all)' newline '(n = ' num2str(length(all_nb)) ' sessions)'],'FontSize',12)
legend({'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'},'Location','northeastoutside') ; legend boxoff ; 


% Save Plot :
% set(gcf,'color','w'); % change figure background to white
% set(gcf, 'InvertHardcopy', 'off') % to prevent the edges from going black again when saving figures
% print([PathToSave 'SlowWaveProportionsMeanPlot'], '-dpng', '-r300') ; 
% print([PathToSave 'SlowWaveProportionsMeanPlot'], '-depsc') ;


