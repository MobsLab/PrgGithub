%%Fig3CompareInducedVsEndogeneousDown
% 18.05.2018 KJ
%
%
% see
%   CompareInducedVsEndogeneousDown
%




%load
clear

load(fullfile(FolderDeltaDataKJ,'CompareInducedVsEndogeneousDown.mat'),'compare_res')
load(fullfile(FolderDeltaDataKJ,'CompareInducedVsEndogeneousDown.mat'),'raster_res','binsize_mua')

load(fullfile(FolderDeltaDataKJ,'CompareInducedVsEndogeneousDownSham.mat'),'comparesham_res')
load(fullfile(FolderDeltaDataKJ,'CompareInducedVsEndogeneousDownSham.mat'),'rastersham_res','binsize_mua')


%params
smoothing = 2;


%% POOL

durations_down = {[],[]};
onset_fr = {[],[]};
offset_fr = {[],[]};

endogen.onset.y_mua = [];
endogen.offset.y_mua = [];
induced.onset.y_mua = [];
induced.offset.y_mua = [];


for p=1:6 %length(compare_res.path)
    
    
    %% durations
    durations_down{1}(p) = nanmean(comparesham_res.sham.duration{p}/10);
    durations_down{2}(p) = nanmean(compare_res.induced.duration{p}/10);


    %% Mean curves 
    
    %Endogen - Onset
    raster_tsd = rastersham_res.sham.rasters.pre{p};
    MatMua = Data(raster_tsd);
    endogen.onset.y_mua = [endogen.onset.y_mua Smooth(mean(MatMua,2), smoothing) / (binsize_mua/1000)];
    endogen.onset.x_mua = Range(raster_tsd)/1e4;
    
    idx = endogen.onset.x_mua>-0.05 & endogen.onset.x_mua<0; 
    onset_fr{1}(p) = median(mean(MatMua(idx,:),1));
    
    %Endogen - Offset
    raster_tsd = rastersham_res.sham.rasters.post{p};
    MatMua = Data(raster_tsd);
    endogen.offset.y_mua = [endogen.offset.y_mua Smooth(mean(MatMua,2), smoothing) / (binsize_mua/1000)];
    endogen.offset.x_mua = Range(raster_tsd)/1e4;
    
    idx = endogen.offset.x_mua>0 & endogen.offset.x_mua<0.05; 
    offset_fr{1}(p) = median(mean(MatMua(idx,:),1));
    
    %Induced - Onset
    raster_tsd = raster_res.induced.rasters.pre{p};
    MatMua = Data(raster_tsd);
    induced.onset.y_mua = [induced.onset.y_mua Smooth(mean(MatMua,2), smoothing) / (binsize_mua/1000)];
    induced.onset.x_mua = Range(raster_tsd)/1e4;
    
    idx = induced.onset.x_mua>-0.05 & induced.onset.x_mua<0; 
    onset_fr{2}(p) = median(mean(MatMua(idx,:),1));
    
    %Induced - Offset
    raster_tsd = raster_res.induced.rasters.post{p};
    MatMua = Data(raster_tsd);
    induced.offset.y_mua = [induced.offset.y_mua Smooth(mean(MatMua,2), smoothing) / (binsize_mua/1000)];
    induced.offset.x_mua = Range(raster_tsd)/1e4;

    idx = induced.offset.x_mua>0 & induced.offset.x_mua<0.05; 
    offset_fr{2}(p) = median(mean(MatMua(idx,:),1));
    
end

%averaging mean curves
endogen.onset.y_plot = mean(endogen.onset.y_mua,2);
endogen.offset.y_plot = mean(endogen.offset.y_mua,2);
induced.onset.y_plot = mean(induced.onset.y_mua,2);
induced.offset.y_plot = mean(induced.offset.y_mua,2);


%% Plot
figure, hold on 

subplot(2,6,1:2), hold on
PlotErrorBarN_KJ(durations_down, 'newfig',0, 'paired', 1,  'barcolors',{'r','b'}, 'ShowSigstar','sig','showpoints',1);
ylabel('duration (ms)'),
set(gca,'xtick',1:2,'XtickLabel',{'endogeneous','induced'}),
title('Duration of down states'),

subplot(2,6,3:4), hold on
PlotErrorBarN_KJ(onset_fr, 'newfig',0, 'paired', 1,  'barcolors',{'r','b'}, 'ShowSigstar','sig','showpoints',1);
ylabel('FR'),
set(gca,'xtick',1:2,'XtickLabel',{'endogeneous','induced'}),
title('FR before down state'),

subplot(2,6,5:6), hold on
PlotErrorBarN_KJ(offset_fr, 'newfig',0, 'paired', 1,  'barcolors',{'r','b'}, 'ShowSigstar','sig','showpoints',1);
ylabel('FR'),
set(gca,'xtick',1:2,'XtickLabel',{'endogeneous','induced'}),
title('FR after down state'),


subplot(2,6,7:9), hold on
h(1) = plot(endogen.onset.x_mua, endogen.onset.y_plot, 'color', 'r', 'linewidth', 2); hold on
h(2) = plot(induced.onset.x_mua, induced.onset.y_plot, 'color', 'b', 'linewidth', 2); hold on
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
ylabel('firing rate'),
legend(h, 'endogeneous','induced');
title('Onset of down states')

subplot(2,6,10:12), hold on
h(1) = plot(endogen.offset.x_mua, endogen.offset.y_plot, 'color', 'r', 'linewidth', 2); hold on
h(2) = plot(induced.offset.x_mua, induced.offset.y_plot, 'color', 'b', 'linewidth', 2); hold on
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
legend(h, 'endogeneous','induced');
title('Offset of down states')


    


