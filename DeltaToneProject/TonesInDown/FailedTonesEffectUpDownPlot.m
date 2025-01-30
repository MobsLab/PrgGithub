%%FailedTonesEffectUpDownPlot
% 31.05.2018 KJ
%
% Assess the effect of a failed tones on the activity
%   -> plot
%
% see
%   FailedTonesEffectUpDown
%


%load
clear
load(fullfile(FolderDeltaDataKJ,'FailedTonesEffectUpDown.mat'))



%% Pool
smoothing = 2;

tones.y_corr = [];
sham.y_corr = [];
tones.y_mua = [];
sham.y_mua = [];

for p=1:4% length(failed_res.path)    
    tones.y_corr = [tones.y_corr failed_res.tones.corr.y{p} / sum(failed_res.tones.corr.y{p})];
    sham.y_corr = [sham.y_corr failed_res.sham.corr.y{p} / sum(failed_res.sham.corr.y{p})];
    
    y_fr = Smooth(failed_res.tones.mua{p}(:,2), 1);
    y_fr = y_fr / mean(y_fr(1:20));
    tones.y_mua = [tones.y_mua y_fr];
    
    y_fr = Smooth(failed_res.sham.mua{p}(:,2), 1);
    y_fr = y_fr / mean(y_fr(1:20));
    sham.y_mua = [sham.y_mua y_fr];
    
end


%data to plot
tones.x_corr = failed_res.tones.corr.x{1};
tones.y_corr = Smooth(mean(tones.y_corr,2), smoothing);
sham.x_corr = failed_res.sham.corr.x{1};
sham.y_corr = Smooth(mean(sham.y_corr,2), smoothing);

tones.x_mua = failed_res.tones.mua{1}(:,1);
tones.y_mua = Smooth(mean(tones.y_mua,2), smoothing);
sham.x_mua = failed_res.sham.mua{1}(:,1);
sham.y_mua = Smooth(mean(sham.y_mua,2), smoothing);


%% Plot

figure, hold on

%correlogram
subplot(2,1,1), hold on
h(1) = plot(tones.x_corr, tones.y_corr, 'color', 'k', 'LineWidth',2); hold on,
h(2) = plot(sham.x_corr, sham.y_corr, 'color', [0.4 0.4 0.4], 'LineWidth',2); hold on,
xlabel('time (ms) from tones/sham'), ylabel('probability')
line([0 0], ylim,'Linewidth',2,'color',[0.8 0.8 0.8]), hold on
title('Correlogram tones/sham and down states, for failed events in Up states')
legend(h,'Tones','Sham')

%firing rate
subplot(2,1,2), hold on
h(1) = plot(tones.x_mua, tones.y_mua, 'color', 'k', 'LineWidth',2); hold on,
h(2) = plot(sham.x_mua, sham.y_mua, 'color', [0.4 0.4 0.4], 'LineWidth',2); hold on,
xlabel('time (ms) from tones/sham'), ylabel('firing rate')
line([0 0], ylim,'Linewidth',2,'color', [0.8 0.8 0.8]), hold on
title('Mean FR on tones/sham, for failed events in Up states')

