%%MeancurvesLocalDownStatePlot
% 08.09.2019 KJ
%
% Infos
%   meancurves on local down states
%
% see
%    MeancurvesLocalDownState
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'MeancurvesLocalDownState.mat'))

animals = unique(curves_res.name);

% local global sync
for p=1%:length(curves_res.path)
    
    for tt=1:curves_res.nb.tetrodes{p}
        figure, hold on

        
        %% 
        
        
        
        
        %% MUA local
        % mean pfc on local down
        subplot(2,4,4), hold on
        plot(curves_res.down.local.mua_ext{p,tt}(:,1),curves_res.down.local.mua_ext{p,tt}(:,2),'k','linewidth',2)
        xlabel('time from local down (ms)'), ylabel('Mean MUA extra tetrode'),
        xlim([-600 600]),
        
        % mean Mua ext on local down
        subplot(2,4,8), hold on
        for i=1:length(curves_res.down.local.pfc{p})
            if i==tt
                h(i) = plot(curves_res.down.local.pfc{p}{tt,i}(:,1),curves_res.down.local.pfc{p}{tt,i}(:,2),'k','linewidth',2);
                lgd{i} = 'tetrode channel';
            else
                h(i) = plot(curves_res.down.local.pfc{p}{tt,i}(:,1),curves_res.down.local.pfc{p}{tt,i}(:,2),'linewidth',1);
                lgd{i} = ['channel tt ' num2str(i)];
            end
            
        end
        line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
        legend(h,lgd)
        xlabel('time from local down (ms)'), ylabel('mean LFP'),
        xlim([-600 600]),
        
        
    end
end






%% Plot