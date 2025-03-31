% Figure6GeneratedDelta4
% 09.12.2016 KJ
%
% plot data from Figure6GeneratedDelta to plot the figures from the Figure6.pdf of Gaetan PhD
% - figure d
% 
%   see Figure6GeneratedDelta Figure6GeneratedDelta2 Figure6GeneratedDelta3
%

%load
clear
eval(['load ' FolderProjetDelta 'Data/Figure6GeneratedDelta.mat'])

delays = unique(cell2mat(figure6_res.delay));
animals = unique(figure6_res.name);
conditions = unique(figure6_res.manipe);
%params
center = abs(t_before) / (binsize_mua*10);
pre_stim = center-30/binsize_mua:center;
post_stim = center+120/binsize_mua:center+170/binsize_mua;


%% Graph d, Raster sync on tones and mean MUA
for d=1:length(delays)
    delay_raster = [];
    mean_fr_pre = [];
    mean_fr_post = [];
    
    for p=1:length(figure6_res.path)
        if strcmpi(figure6_res.manipe{p}, 'DeltaToneAll') & figure6_res.with_spike{p} & figure6_res.delay{p}==delays(d);
            raster_tsd = figure6_res.tone.down.raster{p};
            raster_x = Range(raster_tsd);
            if isempty(delay_raster)
                delay_raster = Data(raster_tsd)';
            else
                delay_raster = [delay_raster;Data(raster_tsd)'];
            end
        end
    end

    %zscore raster
    %delay_raster = zscore(delay_raster,1);
    
    %order them by firing rate after the tone
    for r=1:size(delay_raster,1)
        mean_fr_pre(r) = nanmean(delay_raster(r,pre_stim));
        mean_fr_post(r) = nanmean(delay_raster(r,post_stim));
    end

    [~,idx_raster] = sort(mean_fr_post,'ascend');
    mua.raster_matrix{d} = delay_raster(idx_raster,:);
    mua.raster_time{d} = raster_x;
    mua.mean_fr{d} = mean(zscore(delay_raster(idx_raster,:),0,2),1);
    %used in graph e
    firing_rate.pre{d} = mean_fr_pre;
    firing_rate.post{d} = mean_fr_post;

end

% Plot
for d=1:length(delays)
    figure, hold on

    %raster
    subplot(2,1,1), hold on
    imagesc(mua.raster_time{d}/1E4, 1:size(mua.raster_matrix{d},1), mua.raster_matrix{d}), hold on
    axis xy, xlabel('time (sec)'), ylabel('# triggered tone'), hold on
    line([0 0], ylim), hold on
    set(gca,'YLim', [0 size(mua.raster_matrix{d},1)], 'XLim', [-2 2]);
    colorbar, hold on

    %mean firing rate
    subplot(2,1,2), hold on
    plot(mua.raster_time{d}/1E4, SmoothDec(zscore(mua.mean_fr{d},1),1),'k'), hold on
    line([0 0], ylim), hold on
    set(gca, 'XLim', [-2 2]), hold on
    xlabel('time (sec)'), ylabel('Firing rate'), hold on
    
    suplabel(['MUA for a delay of ' num2str(delays(d)*1000) 'ms'], 't');
end



%% Graph e - bar plot of firing rates, for different delays

% plot
barcolors = {[0.2 0.173 0.127], 'k'};
labels = {'Pre', 'Post'};

figure, hold on
for d=1:length(delays)
    subplot(2,2,d), hold on
    data_fr = [firing_rate.pre{d}' firing_rate.post{d}'];
    
    PlotErrorBarN_KJ(data_fr, 'newfig',0,'paired',1,'barcolors',barcolors,'showPoints',0);
    ylabel('Firing rate'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on
    title([num2str(delays(d)*1000) 'ms'])
    
end





