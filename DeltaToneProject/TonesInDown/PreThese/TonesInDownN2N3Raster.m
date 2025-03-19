%%TonesInDownN2N3Raster
% 18.09.2018 KJ
%
%
% see
%   TonesInDownN2N3Effect ToneInDownRasterNeuron
%

clear

Dir = PathForExperimentsRandomTonesSpikes;


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tonesras_res
    
    tonesras_res.path{p}   = Dir.path{p};
    tonesras_res.manipe{p} = Dir.manipe{p};
    tonesras_res.name{p}   = Dir.name{p};
    tonesras_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    minDuration = 40;
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tonesras_res.nb_tones = length(ToneEvent);
    
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
    
    
    %% Tones in - N2 & N3
    ToneDownN2 = Restrict(Restrict(ToneEvent, N2), down_PFCx);
    ToneDownN3 = Restrict(Restrict(ToneEvent, N3), down_PFCx);
    ToneDownNREM = Restrict(Restrict(ToneEvent, NREM), down_PFCx);
        
    tonesras_res.n2.nb_tones{p} = length(ToneDownN2);
    tonesras_res.n3.nb_tones{p} = length(ToneDownN3);
    tonesras_res.n3.nb_tones{p} = length(ToneDownNREM);
    
    
    %% Rasters    
    tonesras_res.n2.rasters{p}  = RasterMatrixKJ(MUA, ToneDownN2, t_start, t_end);
    tonesras_res.n3.rasters{p}  = RasterMatrixKJ(MUA, ToneDownN3, t_start, t_end);
    tonesras_res.nrem.rasters{p}  = RasterMatrixKJ(MUA, ToneDownNREM, t_start, t_end);
    
    
    %% orders

    %N2
    tonesin_tmp = Range(ToneDownN2);
    tonesras_res.n2.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.n2.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tonesras_res.n2.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tonesras_res.n2.after{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %N3
    tonesin_tmp = Range(ToneDownN3);
    tonesras_res.n3.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.n3.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tonesras_res.n3.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tonesras_res.n3.after{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %NREM
    tonesin_tmp = Range(ToneDownNREM);
    tonesras_res.nrem.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.nrem.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tonesras_res.nrem.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tonesras_res.nrem.after{p}(i) = end_aft - tonesin_tmp(i);
    end
     
end

%saving data
cd(FolderDeltaDataKJ)
save TonesInDownN2N3Raster.mat -v7.3 tonesras_res t_start t_end binsize_mua minDuration





