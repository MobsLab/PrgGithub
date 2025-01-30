% Figure6GeneratedDelta_raster
% 09.12.2016 KJ
%
% plot data from Figure6GeneratedDelta to plot the figures from the Figure6.pdf of Gaetan PhD
% - figure ratser
% 
%   see Figure6GeneratedDelta Figure6GeneratedDelta2
%

%load
clear
eval(['load ' FolderProjetDelta 'Data/Figure6GeneratedDelta.mat'])

delays = unique(cell2mat(figure6_res.delay));
animals = unique(figure6_res.name);
conditions = unique(figure6_res.manipe);
%params
center = -t_before / (binsize_mua*10);
post_lim = center + 200/binsize_mua;



%% Graph d, Raster sync on tones
for d=1:length(delays)
    for m=1:length(animals)
       
        mouse_raster = [];
        for p=1:length(figure6_res.path)
            if strcmpi(figure6_res.name{p}, animals{m}) & strcmpi(figure6_res.manipe{p}, 'DeltaToneAll') & figure6_res.with_spike{p} & figure6_res.delay{p}==delays(d);
                raster_tsd = figure6_res.tone.down.raster{p};
                raster_x = Range(raster_tsd);
                if isempty(mouse_raster)
                    mouse_raster = Data(raster_tsd)';
                else
                    mouse_raster = [mouse_raster;Data(raster_tsd)'];
                end
            end
        end
        
        %order them by firing rate after the tone
        mean_fr_post = [];
        for r=1:size(mouse_raster,1)
            mean_fr_post(r) = nanmean(mouse_raster(r,center:post_lim));
        end
        [~,idx_raster] = sort(mean_fr_post,'ascend');
        mua.raster_matrix{d,m} = mouse_raster(idx_raster,:);
        mua.raster_time{d,m} = raster_x;
        mua.mean_fr{d,m} = mean(zscore(mouse_raster(idx_raster,:),0,2),1);

    end
end



%% Raster for each animal
for m=1:length(animals)
    figure, hold on
    for d=1:length(delays)
        if ~isempty(mua.raster_matrix{d,m})
            %raster
            subplot(2,2,d), hold on
            imagesc(mua.raster_time{d,m}/1E4, 1:size(mua.raster_matrix{d,m},1), mua.raster_matrix{d,m}), hold on
            axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
            line([0 0], ylim), hold on
            set(gca,'YLim', [0 size(mua.raster_matrix{d,m},1)], 'XLim', [-2 2]);
            colorbar, title([num2str(delays(d)*1000) 'ms']), hold on
        end
    end
    suplabel([animals{m} ' - MUA'], 't');
end


%% Mean firing rate, sync on tones, for each animals
for m=1:length(animals)
    figure, hold on 
    for d=1:length(delays)
        if ~isempty(mua.raster_matrix{d,m})
            subplot(2,2,d), hold on
            plot(mua.raster_time{d,m}/1E4, SmoothDec(mua.mean_fr{d,m},1),'k'), hold on;
            line([0 0], ylim), hold on
            set(gca, 'XLim', [-2 2]);
            title([num2str(delays(d)*1000) 'ms']), hold on
        end
    end
    suplabel([animals{m} ' - MUA'], 't');
end




