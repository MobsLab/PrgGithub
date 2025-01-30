%%FigLocalDownOneNightExamplePlot2
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

load('FigLocalDownOneNightExample.mat')
factorLFP = 0.195;
tetrodesNames = {'A','B','C'};

%% PLOT 1 : ColorMap & MUA
figure, hold on

%Global down - neurons (cross corr)
subplot(2,4,1), hold on

% MGlobal = MatnGlobal.center;
% MGlobal = MatnGlobal.center ./ mean(MatnGlobal.center(:,x_matG<-150),2);
MGlobal = zscore(MatnGlobal.start,[],2);


imagesc(x_matG, 1:size(MGlobal,1), MGlobal), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
set(gca,'YLim', [1 size(MGlobal,1)],'xlim',[-250 250]);
xlabel('time from global down states center (ms)'), title('SUA on global Down')
ylabel('# neurons'), caxis([-4 6]),

%local down - neurons (cross corr)
for tt=1:nb_tetrodes

    subplot(2,4,1+tt), hold on

%     Mlocal = MatnLocal.center{tt};
%     MLocal = MatnLocal.center{tt} ./ mean(MatnLocal.center{tt}(:,x_matG<-100),2);
    MLocal = zscore(MatnLocal.start{tt},[],2);
    
    imagesc(x_matG, 1:size(MLocal,1), MLocal), hold on
    axis xy, hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    set(gca,'YLim', [1 size(MLocal,1)],'xlim',[-250 250]);
    xlabel('time from local down (ms)'), title(['tetrode ' tetrodesNames{tt}]),
    caxis([-4 6]),

end


%MUA raster on down
subplot(2,4,5), hold on

%Mat sorted 
MatMuaGlobal = Data(tRasterGlobal)';
x_tmp = Range(tRasterGlobal);
[~, idxMat] = sort(global_duration);
MatMuaGlobal = MatMuaGlobal(idxMat,:);

imagesc(x_tmp/10, 1:size(MatMuaGlobal,1), MatMuaGlobal), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
set(gca,'YLim', [1 size(MatMuaGlobal,1)], 'xlim', [-400 600]);
xlabel('time from global down states start (ms)'), title('MUA')
ylabel('# down states'),

for tt=1:nb_tetrodes

    subplot(2,4,5+tt), hold on
    
    %Mat sorted 
    MatMuaLocal = Data(tRasterLocal{tt})';
    x_tmp = Range(tRasterLocal{tt});
    [~, idxMat] = sort(local_duration{tt});
    MatMuaLocal = MatMuaLocal(idxMat,:);
    
    imagesc(x_tmp/10, 1:size(MatMuaLocal,1), MatMuaLocal), hold on
    axis xy, hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    set(gca,'YLim', [1 size(MatMuaLocal,1)], 'xlim', [-400 600]);
    xlabel('time from local start (ms)')
    ylabel('# local down'),

end



%% PLOT 2 - Mean Curves on global/local
color_deep = 'k';
color_other = 'k';
color_tet = 'r';
gap = [0.03 0.03];

figure, hold on

%Global down - neurons (cross corr)
subtightplot(5,4,1,gap), hold on
h(1)= plot(metdeep_global(:,1), metdeep_global(:,2)*factorLFP, 'color', color_deep, 'linewidth',2);
h(2)= plot(metmid_global(:,1), metmid_global(:,2)*factorLFP, 'color', [0 0.5 0], 'linewidth',2);
h(3)= plot(metsup_global(:,1), metsup_global(:,2)*factorLFP, 'color', 'b', 'linewidth',2);
xlim([-300 500]), ylim([-200 320]),
ylabel('Amplitude (mV)')
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
legend(h, 'LFP 1', 'LFP middle', 'LFP sup'),
title('Global down states')

%local on channels
for tt=1:nb_tetrodes
    subtightplot(5,4,1+tt,gap), hold on
    plot(metdeep_local{tt}(:,1), metdeep_local{tt}(:,2)*factorLFP, 'color', color_other, 'linewidth',2),
    plot(metmid_local{tt}(:,1), metmid_local{tt}(:,2)*factorLFP, 'color', [0 0.5 0], 'linewidth',2),
    plot(metsup_local{tt}(:,1), metsup_local{tt}(:,2)*factorLFP, 'color', 'b', 'linewidth',2),
    xlim([-300 500]), ylim([-200 320]),
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
    
    title(['Local down (tetrode ' tetrodesNames{tt} ')']),
end

%same on tetrodes channels
for ch=1:nb_tetrodes
    
    %Global down - neurons (cross corr)
    subtightplot(5,4,4*ch+1,gap), hold on
    clear h
    h(1) = plot(met_global{ch}(:,1), met_global{ch}(:,2)*factorLFP, 'color', color_other, 'linewidth',2);
    plot(metsup_global(:,1), metsup_global(:,2)*factorLFP, 'color', 'b', 'linewidth',2),
    xlim([-300 500]), ylim([-200 320]),
    ylabel('Amplitude (mV)')
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
    legend(h, ['LFP tetrode ' tetrodesNames{ch}]),
%     if ch==nb_tetrodes
%        xlabel('Time from down states start (ms)'),  
%     end
    
    for tt=1:nb_tetrodes
        subtightplot(5,4,4*ch+1+tt,gap), hold on
        if ch==tt
            plot(met_local{ch,tt}(:,1), met_local{ch,tt}(:,2)*factorLFP, 'color', color_tet, 'linewidth',2),
        else
            plot(met_local{ch,tt}(:,1), met_local{ch,tt}(:,2)*factorLFP, 'color', color_other, 'linewidth',2),
        end
        plot(metsup_local{tt}(:,1), metsup_local{tt}(:,2)*factorLFP, 'color', 'b', 'linewidth',2),
        xlim([-300 500]), ylim([-200 320]),
        line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
%         if ch==nb_tetrodes
%             xlabel('Time from down states start (ms)'),  
%         end
    end

end


%all
for tt=1:nb_tetrodes
    
    %global
    subtightplot(5,4,17,gap), hold on
    h(tt) = plot(met_global{tt}(:,1), met_global{tt}(:,2)*factorLFP, 'linewidth',2);
    xlim([-300 500]), ylim([-200 320]),
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
    legend(h, tetrodesNames),
    
    %local
    subtightplot(5,4,17+tt,gap), hold on
    for ch=1:nb_tetrodes
        if ch==tt
            plot(met_local{ch,tt}(:,1), met_local{ch,tt}(:,2)*factorLFP, 'color', color_tet, 'linewidth',2),
        else
            plot(met_local{ch,tt}(:,1), met_local{ch,tt}(:,2)*factorLFP, 'color', color_other, 'linewidth',2),
        end
    end
    xlim([-300 500]), ylim([-100 150]),
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
end












