%%OccurenceRipplesFakeDeltaDeepPlotAll
% 09.09.2019 KJ
%
% Infos
%   script about real and fake slow waves : MUA and down
%
% see
%    OccurenceRipplesFakeDeltaDeepPlot OccurenceRipplesFakeDeltaDeepPlot2
%
%

% load
clear
load(fullfile(FolderDeltaDataKJ,'OccurenceRipplesFakeDeltaDeep.mat'))

clustermin = 3;

for p=1:length(ripples_res.path)
    
    for ch=1:length(ripples_res.channels{p})
        
        if ripples_res.clusters{p}(ch)<clustermin
            continue
        end
        
        %% Plot
        fontsize = 15;
        col_down = 'k';

        figure, hold on

        %down global
        subplot(2,3,1), hold on
        plot(ripples_res.down1.global{p}(:,1), ripples_res.down1.global{p}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of down states'), 
        title(['Down (n='  num2str(ripples_res.nb.down1{p}) ') - ' ripples_res.name{p} ' - ' ripples_res.date{p}]),
        
        %delta diff
        subplot(2,3,4), hold on
        plot(ripples_res.diff.global{p}(:,1), ripples_res.diff.global{p}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of down states'), 
        title(['Delta Diff (n='  num2str(ripples_res.nb.diff{p}) ')']),
        
        
        %delta global 1
        subplot(2,3,2), hold on
        plot(ripples_res.delta1.global{p,ch}(:,1), ripples_res.delta1.global{p,ch}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of delta'), 
        title(['Global Delta 1 (n='  num2str(ripples_res.nb.delta1{p}) ') - ch ' num2str(ripples_res.channels{p}(ch)) ' (cl ' num2str(ripples_res.clusters{p}(ch)) ')']),
        
        %delta other 1
        subplot(2,3,3), hold on
        plot(ripples_res.delta1.other{p,ch}(:,1), ripples_res.delta1.other{p,ch}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of delta'), 
        title(['Fake Delta 1 (n='  num2str(ripples_res.nb.other1{p}) ')']),
        
        %delta global 2
        subplot(2,3,5), hold on
        plot(ripples_res.delta2.global{p,ch}(:,1), ripples_res.delta2.global{p,ch}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of delta'), 
        title(['Global Delta 2 (n='  num2str(ripples_res.nb.delta2{p}) ')']),
        
        %delta other 2
        subplot(2,3,6), hold on
        plot(ripples_res.delta2.other{p,ch}(:,1), ripples_res.delta2.other{p,ch}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of delta'), 
        title(['Fake Delta 2  (n='  num2str(ripples_res.nb.other2{p}) ')']),
        

    end

end

