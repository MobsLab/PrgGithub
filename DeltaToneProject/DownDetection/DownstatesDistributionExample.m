%%DownstatesDistributionExample
%
% 28.11.2019 KJ
%
% see
%   DownstatesPermutationsPlot DownstatesPermutationsPlot2


% load
clear
load(fullfile(FolderDeltaDataKJ,'DownstatesPermutations.mat'))


path_permuted = [1:4 35:40];
all_sws = [];
all_wake = [];

for p=path_permuted
    all_sws  = [all_sws ; down_res.real.sws{p}];
    all_wake = [all_wake ; down_res.real.wake{p}];
end

mean_sws = mean(all_sws,1);
mean_wake = mean(all_wake,1);

std_sws  = std(all_sws,0,1) / sqrt(size(all_sws,1));
std_wake = std(all_wake,0,1) / sqrt(size(all_wake,1));


%% plot

figure, hold on
subplot(1,5,1:3), hold on
   
errorbar(duration_bins, mean_sws, std_sws, 'color', 'r','CapSize',1)
errorbar(duration_bins, mean_wake, std_wake, 'color', 'k','CapSize',1)

h(1) = plot(duration_bins, mean_sws ,'r','linewidth',3); hold on
h(2) = plot(duration_bins, mean_wake ,'k','linewidth',3); hold on

%properties
fontsize = 40;

set(gca,'xscale','log','yscale','log'), hold on
set(gca,'ylim',[10 1E6],'xlim',[10 1000],'xtick',[10 50 100 200 500 1500]), hold on
set(gca,'FontName','Times','fontsize',fontsize),
xlabel('down duration (ms)'), ylabel('number of down')
legend(h,'NREM','Wake')










