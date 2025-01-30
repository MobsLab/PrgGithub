% FigureSuccessDeltaDown
% 16.02.2017 KJ
%
% quantify the number of tones evoking down states
%
% 
%   see FigurePercentageSuccess NumberPercentageSuccessDelta NumberPercentageSuccessDown
%
%


%% S2 vs S4 : Success comparaison
clear
eval(['load ' FolderProjetDelta 'Data/NumberPercentageSuccessDelta.mat'])
eval(['load ' FolderProjetDelta 'Data/NumberPercentageSuccessDown.mat'])

conditions = unique(successdelta_res.manipe);


%create data for each conditions (Random - DeltaTone)
%delta
for cond = 1:length(conditions)
    idx_path = ismember(successdelta_res.manipe,conditions{cond});
    
    nb_tones_per_session = cell2mat(successdelta_res.nb_session(idx_path)');
    nb_delta_evoked = cell2mat(successdelta_res.nb_success(idx_path)');
    
    success_delta.s2{cond} = nb_delta_evoked(:,1) ./ nb_tones_per_session(:,1);
    success_delta.s4{cond} = nb_delta_evoked(:,2) ./ nb_tones_per_session(:,1);
    
     success_delta.s2{cond}(success_delta.s2{cond}==0) = [];
%     success_delta.s2{cond}(success_delta.s2{cond}>1) = [];
     success_delta.s4{cond}(success_delta.s4{cond}==0) = [];
%     success_delta.s4{cond}(success_delta.s4{cond}>1) = [];
    
end

%down
for cond = 1:length(conditions)
    idx_path = ismember(successdown_res.manipe,conditions{cond});
    
    nb_tones_per_session= cell2mat(successdown_res.nb_session(idx_path)');
    nb_down_evoked = cell2mat(successdown_res.nb_success(idx_path)');
    
    success_down.s2{cond} = nb_down_evoked(:,1) ./ nb_tones_per_session(:,1);
    success_down.s4{cond} = nb_down_evoked(:,2) ./ nb_tones_per_session(:,1);
    
     success_down.s2{cond}(success_down.s2{cond}==0) = [];
%     success_down.s2{cond}(success_down.s2{cond}>1) = [];
     success_down.s4{cond}(success_down.s4{cond}==0) = [];
%     success_down.s4{cond}(success_down.s4{cond}>1) = [];
    
end


%% Plot
barcolors = {'k',[0.75 0.75 0.75]};
barcolors = [barcolors barcolors];
show_signif_star = 'all';
column_test = [1 2 ; 3 4];
labels = {'S2', 'S4', 'S2', 'S4'};
titles_plot = {'Delta triggered Tone', 'Random Tone'};

figure, hold on
for cond = 1:length(conditions)
    
    subplot(1,2,cond), hold on
    data = {success_down.s2{cond}*100,success_down.s4{cond}*100,success_delta.s2{cond}*100,success_delta.s4{cond}*100};
    PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',barcolors,'ColumnTest',column_test);
    ylabel('Percentage of tone evoking Delta/Down'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',20), hold on,
    title(titles_plot{cond}, 'FontSize', 25);
    
end



