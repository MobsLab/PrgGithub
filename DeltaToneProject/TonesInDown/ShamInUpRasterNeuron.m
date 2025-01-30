%%ShamInUpRasterNeuron
% 18.05.2018 KJ
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
    
    clearvars -except Dir p sham_res
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
    %params
    t_start      = -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    maxDuration  = 10e4;
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    
    
    %% MUA & Down
    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    
    %Down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %5sec
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Sham in and out
    ShamIn = Restrict(SHAMtime, up_PFCx);
    shamin_tmp = Range(ShamIn);
    
    
    %% Rasters    
    sham_res.rasters.inside.all{p}  = RasterMatrixKJ(MUA, ShamIn, t_start, t_end);
    
    
    %% orders
    %sham in down
    sham_res.inside.before{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.after{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.postdown{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        sham_res.inside.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        sham_res.inside.after{p}(i) = end_aft - shamin_tmp(i);
        
        up_post = st_up(find(st_up>shamin_tmp(i),1));
        sham_res.inside.postup{p}(i) = up_post - shamin_tmp(i);

    end

     
end

%saving data
cd(FolderDeltaDataKJ)
save ShamInUpRasterNeuron.mat -v7.3 sham_res t_start t_end binsize_mua maxDuration




