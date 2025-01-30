% Figure6GeneratedDelta3
% 10.12.2016 KJ
%
% Plot data from Figure6GeneratedDelta to plot the figures from the Figure6.pdf of Gaetan PhD
% - plot Graph b c
% 
%   see Figure6GeneratedDelta Figure6GeneratedDelta_bis Figure6GeneratedDelta2 Figure6GeneratedDelta4
%


%% Down duration -  BAR
clear
eval(['load ' FolderProjetDelta 'Data/Figure6GeneratedDelta_bis.mat'])
conditions = unique(figure6_bis_res.manipe);

%mean duration for each night
for p=1:length(figure6_bis_res.path)
    if figure6_bis_res.with_spike{p}==1
        durations.induced(p) = mean(figure6_bis_res.tone.down.duration{p});
        durations.endog(p) = mean(figure6_bis_res.endog.down.duration{p});
    else 
        durations.induced(p) = 0;
        durations.endog(p) = 0;
    end
end

%create data for each conditions (Random - DeltaTone)
for cond = 1:length(conditions)
    idx_path = ismember(figure6_bis_res.manipe,conditions{cond});
    
    dur_indu = durations.induced(idx_path)';
    dur_indu(dur_indu==0) = [];
    dur_endo = durations.endog(idx_path)';
    dur_endo(dur_endo==0) = [];
    
    duration_induced{cond} = dur_indu;
    duration_endog{cond} = dur_endo;
    
end

% plot
barcolors = {'b','k'};
show_signif_star = 'all';
labels = {'tone', 'no tone'};

figure, hold on
for cond = 1:length(conditions)
    
    subplot(1,2,cond), hold on
    data_dur = [duration_induced{cond}/10 duration_endog{cond}/10];
    
    PlotErrorBarN_KJ(data_dur, 'newfig',0,'paired',0,'barcolors',barcolors,'ShowSigstar',show_signif_star);
    ylabel('Down duration (ms)'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
    title(conditions{cond})
    
    
end


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
    success_down.s2{cond}(success_down.s2{cond}>1) = [];
    success_down.s4{cond}(success_down.s4{cond}==0) = [];
    success_down.s4{cond}(success_down.s4{cond}>1) = [];
    
end
%delta
for cond = 1:length(conditions)
    idx_path = ismember(figure6_bis_res.manipe,conditions{cond});
    
    nb_tones_per_session = cell2mat(figure6_bis_res.tone.nb_session(idx_path)');
    nb_delta_evoked = cell2mat(figure6_bis_res.tone.delta.nb_success(idx_path)');
    
    success_delta.s2{cond} = nb_delta_evoked(:,1) ./ nb_tones_per_session(:,1);
    success_delta.s4{cond} = nb_delta_evoked(:,2) ./ nb_tones_per_session(:,1);
    
    success_delta.s2{cond}(success_delta.s2{cond}==0) = [];
    success_delta.s2{cond}(success_delta.s2{cond}>1) = [];
    success_delta.s4{cond}(success_delta.s4{cond}==0) = [];
    success_delta.s4{cond}(success_delta.s4{cond}>1) = [];
    
end


% plot
barcolors = {'k',[0.75 0.75 0.75],'k',[0.75 0.75 0.75]};
show_signif_star = 'all';
column_test = [1 2 ; 3 4];
labels = {'S2-down', 'S4-down', 'S2-delta', 'S4-delta'};

figure, hold on
for cond = 1:length(conditions)
    
    subplot(1,2,cond), hold on
    data = {success_down.s2{cond},success_down.s4{cond},success_delta.s2{cond},success_delta.s4{cond}};
    
    PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',barcolors,'ColumnTest',column_test);
    ylabel('Percentage of tone evoking Delta/Down'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
    title(conditions{cond})
    
end










