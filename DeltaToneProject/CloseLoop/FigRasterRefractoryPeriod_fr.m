%%FigRasterRefractoryPeriod_fr
% 02.10.2019 KJ
%
% effect of tones in delta waves
% in N2 and N3
%
%   see 
%       FigTonesInDownN2N3 FigTonesInDeltaN2N3 
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'TonesOutDeltaN2N3Raster.mat'))


%params
animals = unique(tonesras_res.name);


%% pool data

select_order = 'before'; %{'before','after'}

MatLFP.n2.tones  = [];
ibefore.n2.tones = [];
MatLFP.n3.tones  = [];
ibefore.n3.tones = []; 
MatLFP.nrem.tones  = []; 
ibefore.nrem.tones = []; 


%tones
for p=1:length(tonesras_res.path)
    
    %N2
    raster_tsd = tonesras_res.n2.rasters{p};
    x_lfp = Range(raster_tsd);
    MatLFP.n2.tones = [MatLFP.n2.tones ; Data(raster_tsd)'];
    
    ibefore.n2.tones = [ibefore.n2.tones ; tonesras_res.n2.(select_order){p}];
    
    %N3
    raster_tsd = tonesras_res.n3.rasters{p};
    x_lfp = Range(raster_tsd);
    MatLFP.n3.tones = [MatLFP.n3.tones ; Data(raster_tsd)'];
    
    ibefore.n3.tones = [ibefore.n3.tones ; tonesras_res.n3.(select_order){p}];
    
    %NREM
    raster_tsd = tonesras_res.nrem.rasters{p};
    x_lfp = Range(raster_tsd);
    MatLFP.nrem.tones = [MatLFP.nrem.tones ; Data(raster_tsd)'];
    
    ibefore.nrem.tones = [ibefore.nrem.tones ; tonesras_res.nrem.(select_order){p}];
end

%sort raster in N2
[~,idx_order] = sort(ibefore.n2.tones);
MatLFP.n2.tones  = MatLFP.n2.tones(idx_order, :);

%sort raster in N3
[~,idx_order] = sort(ibefore.n3.tones);
MatLFP.n3.tones  = MatLFP.n3.tones(idx_order, :);
        
%sort raster in NREM
[~,idx_order] = sort(ibefore.nrem.tones);
MatLFP.nrem.tones  = MatLFP.nrem.tones(idx_order, :);


%% PLOT
fontsize = 20;

figure, hold on

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);

%N2
subplot(3,2,[1 3]), hold on
imagesc(x_lfp/10, 1:size(MatLFP.n2.tones,1), MatLFP.n2.tones), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
caxis([-2000 3000]),
set(gca,'YLim', [0 size(MatLFP.n2.tones,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to tones (s)'), ylabel('#tones'),


%N3
subplot(3,2,[2 4]), hold on
imagesc(x_lfp/10, 1:size(MatLFP.n3.tones,1), MatLFP.n3.tones), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
caxis([-2000 3000]),
set(gca,'YLim', [0 size(MatLFP.n3.tones,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to tones (s)'), ylabel('#tones'),
title('Tones outside delta waves - N3')





