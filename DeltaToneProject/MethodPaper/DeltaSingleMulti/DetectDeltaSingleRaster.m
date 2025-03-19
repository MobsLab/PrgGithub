%%DetectDeltaSingleRaster
%
% 31.01.2018 KJ
%
%
% see
%   DetectDeltaDepthMultiChannel DeltaSingleChannelAnalysis DeltaSingleChannelAnalysis2
%

clear
load(fullfile(FolderProjetDelta,'Data','DetectDeltaDepthSingleChannel.mat'))


%% single channels
for p=1:length(depth_res.path)   
    disp(' ')
    disp('****************************************************************')
    eval(['cd(depth_res.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except p depth_res

    %% MUA
    load('SpikeData','S')
    if exist('SpikesToAnalyse/PFCx_down.mat','file')==2
        load SpikesToAnalyse/PFCx_down
    elseif exist('SpikesToAnalyse/PFCx_Neurons.mat','file')==2
        load SpikesToAnalyse/PFCx_Neurons
    elseif exist('SpikesToAnalyse/PFCx_MUA.mat','file')==2
        load SpikesToAnalyse/PFCx_MUA
    else
        number=[];
    end
    NumNeurons=number;
    clear number

    binsize=10;
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
    
    %%
    %subplot dimension
    nx = numSubplots(length(depth_res.channels{p}));
    ny = nx(1); nx = nx(2);
    
    %plot
    figure, hold on
    for i=1:length(single_res.channels{p})
        subplot(nx,ny,i), hold on
        
        deltas = depth_res.deltas{p}{i};
        raster_tsd = RasterMatrixKJ(Q, ts(Start(deltas)), -1.5E4, 1.5E4);
        raster_mat = Data(raster_tsd);
        raster_t = Range(raster_tsd);

        figure, hold on
        imagesc(raster_t/1E4, 1:size(raster_mat,2), raster_mat'), hold on
        axis xy, ylabel('delta'), hold on
        line([0 0], ylim,'Linewidth',2,'color','k'), hold on
        set(gca,'YLim', [0 size(raster_mat,2)], 'xlim',[-0.2 0.2]);
    
    end
    
    
end








