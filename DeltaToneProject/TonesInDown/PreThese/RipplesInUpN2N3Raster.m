%%RipplesInUpN2N3Raster
% 19.09.2018 KJ
%
%
% see
%   TonesInUpN2N3Raster RipplesInDownN2N3Raster
%


% clear

Dir=PathForExperimentsRipplesDown;


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripraster_res
    
    ripraster_res.path{p}   = Dir.path{p};
    ripraster_res.manipe{p} = Dir.manipe{p};
    ripraster_res.name{p}   = Dir.name{p};
    ripraster_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    minDurationDown = 75;
    minDuration = 0.75e4;
    maxDuration = 30e4;
    
    %ripples    
    [tRipples, RipplesEpoch] = GetRipples;
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    
    
    %% MUA & Down
    if strcmpi(Dir.name{p},'Mouse508')
        MUA = GetMuaNeurons_KJ('PFCx_r', 'binsize',binsize_mua);
        down_PFCx = GetDownStates('area','PFCx_r');
    elseif strcmpi(Dir.name{p},'Mouse509')
        MUA = GetMuaNeurons_KJ('PFCx_l', 'binsize',binsize_mua);
        down_PFCx = GetDownStates('area','PFCx_l');
    else
        MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
        down_PFCx = GetDownStates;
    end
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropShortIntervals(up_PFCx, minDuration);
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %% Create sham
    nb_sham = min(4000, length(st_up));
    idx = randsample(length(st_up), nb_sham);
    sham_tmp = [];

    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end    
    ShamIn = ts(sort(sham_tmp));
    
    
    %% Ripples in - N2 & N3 & NREM
    RipplesUpN2 = Restrict(Restrict(tRipples, N2), up_PFCx);
    RipplesUpN3 = Restrict(Restrict(tRipples, N3), up_PFCx);
    RipplesUpNREM = Restrict(Restrict(tRipples, NREM), up_PFCx);
        
    ripraster_res.n2.nb_ripples{p} = length(RipplesUpN2);
    ripraster_res.n3.nb_ripples{p} = length(RipplesUpN3);
    ripraster_res.nrem.nb_ripples{p} = length(RipplesUpNREM);
    
    %% Sham in - N2 & N3 & NREM
    ShamUpN2   = Restrict(Restrict(ShamIn, N2), up_PFCx);
    ShamUpN3   = Restrict(Restrict(ShamIn, N3), up_PFCx);
    ShamUpNREM = Restrict(Restrict(ShamIn, NREM), up_PFCx);
        
    ripraster_res.n2.nb_sham{p}   = length(ShamUpN2);
    ripraster_res.n3.nb_sham{p}   = length(ShamUpN3);
    ripraster_res.nrem.nb_sham{p} = length(ShamUpNREM);
    
    
    %% Rasters  
    
    %ripples
    ripraster_res.n2.rasters.ripples{p}   = RasterMatrixKJ(MUA, RipplesUpN2, t_start, t_end);
    try
        ripraster_res.n3.rasters.ripples{p}   = RasterMatrixKJ(MUA, RipplesUpN3, t_start, t_end);
    end
    ripraster_res.nrem.rasters.ripples{p} = RasterMatrixKJ(MUA, RipplesUpNREM, t_start, t_end);
    
    %sham
    ripraster_res.n2.rasters.sham{p}   = RasterMatrixKJ(MUA, ShamUpN2, t_start, t_end);
    ripraster_res.n3.rasters.sham{p}   = RasterMatrixKJ(MUA, ShamUpN3, t_start, t_end);
    ripraster_res.nrem.rasters.sham{p} = RasterMatrixKJ(MUA, ShamUpNREM, t_start, t_end);
    
    
    %% orders for Ripples

    %N2
    ripplesin_tmp = Range(RipplesUpN2);
    ripraster_res.n2.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.n2.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
        ripraster_res.n2.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
        ripraster_res.n2.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %N3
    ripplesin_tmp = Range(RipplesUpN3);
    ripraster_res.n3.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.n3.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
        ripraster_res.n3.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
        ripraster_res.n3.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %NREM
    ripplesin_tmp = Range(RipplesUpNREM);
    ripraster_res.nrem.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.nrem.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
        ripraster_res.nrem.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
        ripraster_res.nrem.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    
    %% orders for SHAM

    %N2
    shamin_tmp = Range(ShamUpN2);
    ripraster_res.n2.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.n2.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        ripraster_res.n2.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        ripraster_res.n2.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %N3
    shamin_tmp = Range(ShamUpN3);
    ripraster_res.n3.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.n3.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        ripraster_res.n3.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        ripraster_res.n3.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end 
    
    %NREM
    shamin_tmp = Range(ShamUpNREM);
    ripraster_res.nrem.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.nrem.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        ripraster_res.nrem.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        ripraster_res.nrem.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end 
    
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesInUpN2N3Raster.mat -v7.3 ripraster_res t_start t_end binsize_mua minDurationDown maxDuration





