%%RipplesInDownN2N3Raster
% 19.09.2018 KJ
%
%
% see
%   TonesInDownN2N3Raster RipplesInUpN2N3Raster
%


clear


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
    minDuration = 40;
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    %night_duration
    load('IdFigureData2.mat', 'night_duration')
    
    %ripples    
    [tRipples, ~] = GetRipples;
    ripples_tmp = Range(tRipples);
    ripples_tmp = ripples_tmp(ripples_tmp>2*abs(t_start) & ripples_tmp<night_duration-2*t_end);
    tRipples = ts(ripples_tmp);
    
    
    %% MUA & Down
    %MUA
    if strcmpi(Dir.name{p},'Mouse508')
        MUA = GetMuaNeurons_KJ('PFCx_r', 'binsize',binsize_mua);
    elseif strcmpi(Dir.name{p},'Mouse509')
        MUA = GetMuaNeurons_KJ('PFCx_l', 'binsize',binsize_mua);
    else
        MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    end
    
    %down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    
    
    %% Create sham
    nb_sham = 7000;
    idx = randsample(length(st_down), nb_sham);
    sham_tmp = [];

    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree = end_down(idx(i))-st_down(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end    
    ShamEvent = ts(sort(sham_tmp));
    
    
    %% Ripples in - N2 & N3
    RipplesDownN2 = Restrict(Restrict(tRipples, N2), down_PFCx);
    RipplesDownN3 = Restrict(Restrict(tRipples, N3), down_PFCx);
    RipplesDownNREM = Restrict(Restrict(tRipples, NREM), down_PFCx);
        
    ripraster_res.n2.nb_ripples{p} = length(RipplesDownN2);
    ripraster_res.n3.nb_ripples{p} = length(RipplesDownN3);
    ripraster_res.nrem.nb_ripples{p} = length(RipplesDownNREM);
    
    
    %% Sham in - N2 & N3
    ShamDownN2 = Restrict(Restrict(ShamEvent, N2), down_PFCx);
    ShamDownN3 = Restrict(Restrict(ShamEvent, N3), down_PFCx);
    ShamDownNREM = Restrict(Restrict(ShamEvent, NREM), down_PFCx);
        
    ripples_res.n2.nb_sham{p} = length(ShamDownN2);
    ripples_res.n3.nb_sham{p} = length(ShamDownN3);
    ripples_res.nrem.nb_sham{p} = length(ShamDownNREM);
    
    
    %% Rasters  
    
    %ripples
    ripraster_res.n2.rasters.ripples{p}   = RasterMatrixKJ(MUA, RipplesDownN2, t_start, t_end);
    ripraster_res.n3.rasters.ripples{p}   = RasterMatrixKJ(MUA, RipplesDownN3, t_start, t_end);
    ripraster_res.nrem.rasters.ripples{p} = RasterMatrixKJ(MUA, RipplesDownNREM, t_start, t_end);
    
    %sham
    ripraster_res.n2.rasters.sham{p}   = RasterMatrixKJ(MUA, ShamDownN2, t_start, t_end);
    ripraster_res.n3.rasters.sham{p}   = RasterMatrixKJ(MUA, ShamDownN3, t_start, t_end);
    ripraster_res.nrem.rasters.sham{p} = RasterMatrixKJ(MUA, ShamDownNREM, t_start, t_end);
    
    
    %% orders for Ripples

    %N2
    ripplesin_tmp = Range(RipplesDownN2);
    ripraster_res.n2.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.n2.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        ripraster_res.n2.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>ripplesin_tmp(i),1));
        ripraster_res.n2.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %N3
    ripplesin_tmp = Range(RipplesDownN3);
    ripraster_res.n3.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.n3.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        ripraster_res.n3.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>ripplesin_tmp(i),1));
        ripraster_res.n3.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %NREM
    ripplesin_tmp = Range(RipplesDownNREM);
    ripraster_res.nrem.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.nrem.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        ripraster_res.nrem.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>ripplesin_tmp(i),1));
        ripraster_res.nrem.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    
    %% orders for SHAM

    %N2
    shamin_tmp = Range(ShamDownN2);
    ripraster_res.n2.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.n2.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        ripraster_res.n2.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        ripraster_res.n2.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %N3
    shamin_tmp = Range(ShamDownN3);
    ripraster_res.n3.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.n3.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        ripraster_res.n3.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        ripraster_res.n3.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end 
    
    %NREM
    shamin_tmp = Range(ShamDownNREM);
    ripraster_res.nrem.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.nrem.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        ripraster_res.nrem.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        ripraster_res.nrem.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end 
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesInDownN2N3Raster.mat -v7.3 ripraster_res t_start t_end binsize_mua minDuration





