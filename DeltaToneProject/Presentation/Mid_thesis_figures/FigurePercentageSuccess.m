% FigurePercentageSuccess
% 17.12.2016 KJ
%
% Plot the figures from the Figure6.pdf of Gaetan PhD
% - c
% 
%   see Figure6GeneratedDelta3 Figure6GeneratedDelta_bis
%




%% S2 vs S4 : Success comparaison
clear
eval(['load ' FolderProjetDelta 'Data/Figure6GeneratedDelta_bis.mat'])
conditions = unique(figure6_bis_res.manipe);

with_spike = zeros(1,length(figure6_bis_res.path));
for p=1:length(figure6_bis_res.path)
   if figure6_bis_res.with_spike{p}==1
       with_spike(p)=1;
   end
end

%create data for each conditions (Random - DeltaTone)
%down
for cond = 1:length(conditions)
    idx_path = ismember(figure6_bis_res.manipe,conditions{cond});
    idx_path = logical(idx_path .* with_spike);
    
    nb_tones_per_session= cell2mat(figure6_bis_res.tone.nb_session(idx_path)');
    nb_down_evoked = cell2mat(figure6_bis_res.tone.down.nb_success(idx_path)');
    
    success_down.s2{cond} = nb_down_evoked(:,1) ./ nb_tones_per_session(:,1);
    success_down.s4{cond} = nb_down_evoked(:,2) ./ nb_tones_per_session(:,1);
    
    success_down.s2{cond}(success_down.s2{cond}==0) = [];
%     success_down.s2{cond}(success_down.s2{cond}>1) = [];
    success_down.s4{cond}(success_down.s4{cond}==0) = [];
%     success_down.s4{cond}(success_down.s4{cond}>1) = [];
    
end
%delta
for cond = 1:length(conditions)
    idx_path = ismember(figure6_bis_res.manipe,conditions{cond});
    
    nb_tones_per_session = cell2mat(figure6_bis_res.tone.nb_session(idx_path)');
    nb_delta_evoked = cell2mat(figure6_bis_res.tone.delta.nb_success(idx_path)');
    
    success_delta.s2{cond} = nb_delta_evoked(:,1) ./ nb_tones_per_session(:,1);
    success_delta.s4{cond} = nb_delta_evoked(:,2) ./ nb_tones_per_session(:,1);
    
    success_delta.s2{cond}(success_delta.s2{cond}==0) = [];
%     success_delta.s2{cond}(success_delta.s2{cond}>1) = [];
    success_delta.s4{cond}(success_delta.s4{cond}==0) = [];
%     success_delta.s4{cond}(success_delta.s4{cond}>1) = [];
    
end


% plot
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





