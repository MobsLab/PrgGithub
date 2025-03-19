%%ShamInDownN2N3Raster
% 18.09.2018 KJ
%
%
% see
%   ShamInDownN2N3Effect TonesInDownN2N3Raster
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
    
    
    %% Sham in - N2 & N3
    ShamDownN2 = Restrict(Restrict(SHAMtime, N2), down_PFCx);
    ShamDownN3 = Restrict(Restrict(SHAMtime, N3), down_PFCx);
    ShamDownNREM = Restrict(Restrict(SHAMtime, NREM), down_PFCx);
        
    shamras_res.n2.nb_sham{p} = length(ShamDownN2);
    shamras_res.n3.nb_sham{p} = length(ShamDownN3);
    shamras_res.nrem.nb_sham{p} = length(ShamDownNREM);
    
    
    %% Rasters    
    shamras_res.n2.rasters{p}  = RasterMatrixKJ(MUA, ShamDownN2, t_start, t_end);
    shamras_res.n3.rasters{p}  = RasterMatrixKJ(MUA, ShamDownN3, t_start, t_end);
    shamras_res.nrem.rasters{p}  = RasterMatrixKJ(MUA, ShamDownNREM, t_start, t_end);
    
    
    %% orders

    %N2
    shamin_tmp = Range(ShamDownN2);
    shamras_res.n2.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.n2.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        shamras_res.n2.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        shamras_res.n2.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %N3
    shamin_tmp = Range(ShamDownN3);
    shamras_res.n3.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.n3.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        shamras_res.n3.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        shamras_res.n3.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamDownNREM);
    shamras_res.nrem.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.nrem.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        shamras_res.nrem.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        shamras_res.nrem.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
     
end

%saving data
cd(FolderDeltaDataKJ)
save ShamInDownN2N3Raster.mat -v7.3 shamras_res t_start t_end binsize_mua minDuration





