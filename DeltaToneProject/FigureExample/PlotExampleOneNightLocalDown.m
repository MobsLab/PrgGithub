%%PlotExampleOneNightLocalDown
% 25.09.2019 KJ
%
% Infos
%   Examples homeostasis figures
%
% see
%     ComputeExampleOneNightLocalDown
%
%


%% init
% pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
% 
% disp(' ')
% disp('****************************************************************')
% cd(pathexample)
% disp(pwd)

% title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' - ' Dir.hemisphere{p}];


%load
load('ComputeExampleOneNightLocalDown.mat')


%params
tetrodesNames = {'A','B','C','D','E','F'};
color_nrem = 'b';
color_rem  = [0 0.5 0];
color_wake = 'k';
color_curve = [0.5 0.5 0.5];
color_S = 'b';
color_peaks = 'r';
color_fit = 'k';

colorStages = {color_rem, color_nrem, color_wake};
NameStages = {'REM','NREM','Wake'};
Labels = {'R','NR','W'};

% X_limH = [11 20];


%% Plot Global
figure, hold on


%down distrib
subplot(2,4,1), hold on
h(1) = plot(duration_bins, nbDownGlob.nrem ,'r');
h(2) = plot(duration_bins, nbDownGlob.wake ,'k');
set(gca,'xscale','log','yscale','log'), hold on
set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
set(gca,'xtick',[10 50 100 200 500 1500]), hold on
legend(h, 'NREM','Wake'), xlabel('down duration (ms)'), ylabel('number of down')
title('All neurons'),


%Cross-corr neurons
subplot(2,4,2), hold on

% MGlobal = MatnGlobal.center;
% MGlobal = MatnGlobal.center ./ mean(MatnGlobal.center(:,x_matG<-150),2);
MGlobal = zscore(MatnGlobal.start,[],2);

imagesc(x_matG, 1:size(MGlobal,1), MGlobal), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
set(gca,'YLim', [1 size(MGlobal,1)],'xlim',[-250 250]);
xlabel('time from global down states center (ms)'), title('SUA on global Down')
ylabel('# neurons'), caxis([-4 6]),


%MUA raster on down
subplot(2,4,3), hold on
 
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


%Homeostasis
subplot(2,4,4), hold on
Homeo = Global.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sglobal.x, Sglobal.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

set(gca, 'xtick',[]),
ylabel('Global Down occupancy (%epoch)'),
title('homeostasis')

% %title
% filename_png = [title_fig  '_global.png'];
% filename_png = fullfile(FolderFigureDelta, 'LabMeeting','20190930','LocalDownRecords',filename_png);
% saveas(gcf,filename_png,'png')
% close all



%% Plot local
for tt=1:nb_tetrodes
    
    figure, hold on
    
    %down distrib
    subplot(2,4,1), hold on
    h(1) = plot(duration_bins, nbDownLoc.nrem{tt},'r');
    h(2) = plot(duration_bins, nbDownLoc.wake{tt},'k');
    set(gca,'xscale','log','yscale','log'), hold on
    set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
    set(gca,'xtick',[10 50 100 200 500 1500]), hold on
    legend(h, 'NREM','Wake'), xlabel('down duration (ms)'), ylabel('number of down')
    title(['Tetrode ' tetrodesNames{tt}]),

    
    %Cross-corr neurons
    subplot(2,4,2), hold on
    %     Mlocal = MatnLocal.center{tt};
    %     MLocal = MatnLocal.center{tt} ./ mean(MatnLocal.center{tt}(:,x_matG<-100),2);
    MLocal = zscore(MatnLocal.start{tt},[],2);
    MLocal = MatnLocal.center{tt} ./ firingrate.sws';
    
    imagesc(x_matG, 1:size(MLocal,1), MLocal), hold on
    axis xy, hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    set(gca,'YLim', [1 size(MLocal,1)],'xlim',[-250 250]);
    xlabel('time from local down (ms)'),
%     caxis([-4 6]),
    
    
    %MUA raster on down
    subplot(2,4,3), hold on

    MatMuaLocal = Data(tRasterLocal{tt})';
    x_tmp = Range(tRasterLocal{tt});
    [~, idxMat] = sort(local_duration{tt});
    MatMuaLocal = MatMuaLocal(idxMat,:);

    imagesc(x_tmp/10, 1:size(MatMuaLocal,1), MatMuaLocal), hold on
    axis xy, hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    set(gca,'YLim', [1 size(MatMuaLocal,1)], 'xlim', [-400 600]);
    xlabel('time from local down states start (ms)'), title('MUA')
    ylabel('# down states'),
    
    
    %Homeostasis
    subplot(2,4,4), hold on
    Homeo = Local.Hstat{tt};
    plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
    plot(Slocal.x{tt}, Slocal.y{tt}*100, color_S),
    scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
    plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

    set(gca, 'xtick',[]),
    ylabel('Global Down occupancy (%epoch)'),
    title('homeostasis')

%     %title
%     filename_png = [title_fig  '_local_' num2str(tt) '.png'];
%     filename_png = fullfile(FolderFigureDelta, 'LabMeeting','20190930','LocalDownRecords',filename_png);
%     saveas(gcf,filename_png,'png')
%     close all


    
end







