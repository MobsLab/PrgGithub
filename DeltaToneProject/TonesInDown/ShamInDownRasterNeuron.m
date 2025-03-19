%%ShamInDownRasterNeuron
% 11.05.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneInDownRasterNeuronPlot
%   ToneInDownRasterNeuronPlot2 ToneInDownRasterNeuron
%

clear

Dir=PathForExperimentsRandomShamSpikes;

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p sham_res sham_distrib
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    minDuration = 40;

    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    
    
    %% MUA & Down
    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    
    %down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);

    
    %% Sham in and out
    ShamIn = Restrict(SHAMtime, down_PFCx);
    shamin_tmp = Range(ShamIn);
    
    
    %% Rasters
    sham_res.rasters.inside.all{p}  = RasterMatrixKJ(MUA, ShamIn, t_start, t_end);
    
    
    %% orders
    %sham in down
    sham_res.inside.before{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.after{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.postdown{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        sham_res.inside.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        sham_res.inside.after{p}(i) = end_aft - shamin_tmp(i);
        
        down_post = st_down(find(st_down>shamin_tmp(i),1));
        sham_res.inside.postdown{p}(i) = down_post - shamin_tmp(i);

    end

     
end

%saving data
cd(FolderDeltaDataKJ)
save ShamInDownRasterNeuron.mat -v7.3 sham_res t_start t_end binsize_mua minDuration




