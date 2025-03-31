%%FigLocalDownOneNightExamplePlot
% 18.09.2019 KJ
%
% Infos
%   Examples figures :
%       - tones in Up states > Down
%
% see
%     PlotExampleRealFakeSlow
%
%


clear

% cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243
% load('FigLocalDownOneNightExample.mat')

load(fullfile(FolderDeltaDataKJ,'FigLocalDownOneNightExample.mat'))

factorLFP = 0.195;
tetrodesNames = {'A','B','C'};
fontsize = 18;


%% Figure

color_lfp1 = 'b';
color_lfp2 = [0.53 0.81 0.98];

color_tet{1} = 'r';
color_tet{2} = [0.5 0 0];
color_tet{3} = [1 0.55 0];

gap = [0.05 0.05];

figure, hold on

%Global down - neurons (cross corr)
subtightplot(3,4,[1 5],gap), hold on

clear h
plot(metmid_global(:,1), metmid_global(:,2)*factorLFP, 'color', color_lfp1, 'linewidth',2);
h(4)= plot(metsup_global(:,1), metsup_global(:,2)*factorLFP, 'color', color_lfp1, 'linewidth',2);
for tt=1:nb_tetrodes
    h(tt) = plot(met_global{tt}(:,1), met_global{tt}(:,2)*factorLFP, 'color', color_tet{tt}, 'linewidth',2);
end

set(gca,'xlim',[-300 500], 'ylim',[-200 340],'fontsize',fontsize),
ylabel('Amplitude (mV)'),xlabel('Time from down start (ms)'),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
legend(h, 'tet A', 'tet B', 'tet C', 'sup'),
title('Global down states')

%local down
for tt=1:nb_tetrodes
    clear h
    subtightplot(3,4,[1+tt 5+tt],gap), hold on
    
    plot(metmid_local{tt}(:,1), metmid_local{tt}(:,2)*factorLFP, 'color', color_lfp2, 'linewidth',1),
    h(4) = plot(metsup_local{tt}(:,1), metsup_local{tt}(:,2)*factorLFP, 'color', color_lfp2, 'linewidth',1);
    for ch=1:nb_tetrodes
        h(ch) = plot(met_local{ch,tt}(:,1), met_local{ch,tt}(:,2)*factorLFP, 'color', color_tet{ch}, 'linewidth',2);
    end
    set(gca,'xlim',[-300 500], 'ylim',[-100 200],'fontsize',fontsize),
    xlabel('Time from down start (ms)'),
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
    title(['Local down of tetrode ' tetrodesNames{tt}]),
    legend(h, 'tet A', 'tet B', 'tet C', 'sup'),

end










