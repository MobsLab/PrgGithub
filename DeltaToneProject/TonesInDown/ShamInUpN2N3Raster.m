%%ShamInUpN2N3Raster
% 18.09.2018 KJ
%
%
% see
%   ShamInUpN2N3Effect ShamInDownN2N3Raster
%


clear

Dir = PathForExperimentsRandomShamSpikes;


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p shamras_res
    
    shamras_res.path{p}   = Dir.path{p};
    shamras_res.manipe{p} = Dir.manipe{p};
    shamras_res.name{p}   = Dir.name{p};
    shamras_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    minDuration = 40;
    maxDuration = 30e4;
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_res.nb_sham = length(SHAMtime);
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    
    
    %% MUA & Down
    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    
    %down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Sham in - N2 & N3 & NREM
    ShamUpN2 = Restrict(Restrict(SHAMtime, N2), up_PFCx);
    ShamUpN3 = Restrict(Restrict(SHAMtime, N3), up_PFCx);
    ShamUpNREM = Restrict(Restrict(SHAMtime, NREM), up_PFCx);
        
    shamras_res.n2.nb_sham{p} = length(ShamUpN2);
    shamras_res.n3.nb_sham{p} = length(ShamUpN3);
    shamras_res.nrem.nb_sham{p} = length(ShamUpNREM);
    
    
    %% Rasters    
    shamras_res.n2.rasters{p}  = RasterMatrixKJ(MUA, ShamUpN2, t_start, t_end);
    shamras_res.n3.rasters{p}  = RasterMatrixKJ(MUA, ShamUpN3, t_start, t_end);
    shamras_res.nrem.rasters{p}  = RasterMatrixKJ(MUA, ShamUpNREM, t_start, t_end);
    
    
    %% orders

    %N2
    shamin_tmp = Range(ShamUpN2);
    shamras_res.n2.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.n2.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        shamras_res.n2.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        shamras_res.n2.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %N3
    shamin_tmp = Range(ShamUpN3);
    shamras_res.n3.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.n3.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        shamras_res.n3.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        shamras_res.n3.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamUpNREM);
    shamras_res.nrem.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.nrem.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        shamras_res.nrem.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        shamras_res.nrem.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ShamInUpN2N3Raster.mat -v7.3 shamras_res t_start t_end binsize_mua minDuration maxDuration





