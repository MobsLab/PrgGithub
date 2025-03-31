%%ScriptOccurenceRipplesFakeDeltaDeepPlot
% 09.09.2019 KJ
%
% Infos
%   graph for each ripples
%
% see
%     ScriptOccurenceRipplesFakeDeltaDeep
%    


% load
clear
load(fullfile(FolderDeltaDataKJ,'ScriptOccurenceRipplesFakeDeltaDeep.mat'))

for p=1:length(crosscorr_res.path)
    
    for tt=1:length(crosscorr_res.tetrodes{p})
        
        %% Plot
        fontsize = 18;
        col_down = 'k';

        figure, hold on

        %down global
        subplot(2,3,1), hold on
        plot(crosscorr_res.down.global{p}(:,1), crosscorr_res.down.global{p}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of down states'), 
        title('Global Down'),

        %down local
        subplot(2,3,2), hold on
        plot(crosscorr_res.down.local{p,tt}(:,1), crosscorr_res.down.local{p,tt}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of local down'), 
        title('Local Down'),

        %delta global
        subplot(2,3,4), hold on
        plot(crosscorr_res.delta.global{p,tt}(:,1), crosscorr_res.delta.global{p,tt}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of delta waves'), 
        title('Global Delta (occurs global down)'),
        
        %delta other
        subplot(2,3,5), hold on
        plot(crosscorr_res.delta.other{p,tt}(:,1), crosscorr_res.delta.other{p,tt}(:,2), 'color', col_down, 'linewidth',2);
        line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
        xlabel('time from ripples (ms)'),
        ylabel('occurence of delta'), 
        title('Other delta'),        


        %table
        subplot(2,3,3), hold on
        textbox_dim = get(subplot(2,3,6),'position');
        delete(subplot(2,3,6))

        annotation(gcf,'textbox',...
        textbox_dim,...
        'String',crosscorr_res.textbox_str{p,tt},...
        'LineWidth',1,...
        'HorizontalAlignment','center',...
        'FontWeight','bold',...
        'FitBoxToText','off');

    end

end




