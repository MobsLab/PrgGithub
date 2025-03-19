%%ParcoursDownDurationDistribThresholdPlot
% 20.09.2018 KJ
%
%   Distribution of down state duration -> to determine minimum down duration   
%
% see
%   PlotIDSleepData ParcoursDownDurationDistribThreshold DownstatesPermutationsPlot
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'ParcoursDownDurationDistribThreshold.mat'))

animals = unique(down_res.name);

%PLOT
fontsize = 16;
figure, hold on

for m=1:length(animals)
    subplot(2,3,m), hold on
    
    for p=1:length(down_res.path)
        if strcmpi(down_res.name{p},animals{m})
            h(1) = plot(down_res.duration_bins{p}, down_res.nbDown.sws{p},'r'); hold on
            h(2) = plot(down_res.duration_bins{p}, down_res.nbDown.wake{p} ,'k'); hold on
            set(gca,'xscale','log','yscale','log'), hold on
            set(gca,'ylim',[1 1E6],'xlim',[10 800]), hold on
            set(gca,'xtick',[10 50 100 200 500]), hold on
            set(gca,'Fontsize',fontsize), hold on
        end
    end
    line([75 75], get(gca,'ylim'), 'color','k', 'linewidth', 2),
    legend(h, 'SWS','Wake'), xlabel('down duration (ms)'), ylabel('number of down')
    title(animals{m}),

end
% 
% %PLOT
% figure, hold on
% 
% for m=1:length(animals)
%     subplot(2,3,m), hold on
%     
%     for p=1:length(down_res.path)
%         if strcmpi(down_res.name{p},animals{m})
%             y_sws = down_res.nbDown.sws{p};
%             y_wake = down_res.nbDown.wake{p};
%             plot(down_res.duration_bins{p}, y_sws./y_wake, 'k'), hold on
%             set(gca,'xscale','log'), hold on
%             set(gca,'xlim',[10 500]), hold on
%             set(gca,'xtick',[10 50 100 200 500]), hold on
%             set(gca,'Fontsize',fontsize), hold on
%             xlabel('down duration (ms)'), ylabel('ratio sws/wake')
%         end
%     end
%     line([75 75], get(gca,'ylim'), 'color', 'k', 'linewidth', 2),
%     title(animals{m}),
% 
% end
