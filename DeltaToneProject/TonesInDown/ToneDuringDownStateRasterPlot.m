%%ToneDuringDownStateRasterPlot
% 06.04.2018 KJ
%
% raster of tones around down states
%
%   see 
%       ToneDuringDownStateRaster
%

%load
clear
load(fullfile(FolderDeltaDataKJ,'ToneDuringDownStateRaster.mat'))

%{'inside', 'before', 'after'}
select_tone = 'inside'; 

% {'after','post','before'};
select_order = 'before';


%% Plot
figure, hold on
gap = [0.04 0.02];

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);


for p=1:length(tones_res.path)
    
    raster_tsd = tones_res.Rasters.(select_tone){p};
    x_mua = Range(raster_tsd);
    MatMUA = Data(raster_tsd)';
    
    idx_order = tones_res.idx_order.(select_tone).(select_order){p};
    MatMUA = MatMUA(idx_order, :);
    
    
    %raster
    subtightplot(2,3,p, gap), hold on
    imagesc(x_mua/1E4, 1:size(MatMUA,1), MatMUA), hold on
    axis xy, hold on
    line([0 0], ylim,'Linewidth',2,'color','w'), hold on
    line([0.025 0.025], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on
    set(gca,'YLim', [0 size(MatMUA,1)], 'XLim',[-0.5 0.5]);
    title([tones_res.name{p} ' (' tones_res.manipe{p} ')']),
    
    
    %xlabel, ylabel
    if p<=3
        set(gca, 'Xticklabel',{});
    end
    if p==1 || p==4
        ylabel('# tones'),
    end
    
end


