%%RipplesInDeltaN2N3Raster
% 18.09.2018 KJ
%
%
% see
%   FigRipplesInDeltaN2N3 RipplesInDeltaN2N3Effect RipplesOutDeltaN2N3Raster
%   RipplesInDownN2N3Raster
%

clear

Dir = PathForExperimentsRipplesDelta;

delay_detections = GetDelayBetweenDeltaDown(Dir);


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripraster_res delay_detections
    
    ripraster_res.path{p}   = Dir.path{p};
    ripraster_res.manipe{p} = Dir.manipe{p};
    ripraster_res.name{p}   = Dir.name{p};
    ripraster_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -0.5e4; %1s
    t_end        = 0.5e4; %1s
    minduration = 40;
    
    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
    %night_duration
    load('IdFigureData2.mat', 'night_duration')
    
    %ripples    
    [tRipples, ~] = GetRipples;
    ripples_tmp = Range(tRipples);
    ripples_tmp = ripples_tmp(ripples_tmp>2*abs(t_start) & ripples_tmp<night_duration-2*t_end);
    tRipples = ts(ripples_tmp);
    ripraster_res.nb_ripples = length(tRipples);
    
    %deep
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
    load(['LFPData/LFP' num2str(channel) '.mat'])
    PFCdeep = LFP; clear LFP
    PFCdeep = ResampleTSD(PFCdeep,250);
    
    %Delta waves
    load('DeltaWaves.mat', 'deltamax_PFCx')
    deltamax_PFCx = dropShortIntervals(deltamax_PFCx,minduration);
    deltamax_PFCx = and(deltamax_PFCx,NREM);
    
    
    deltas_PFCx = intervalSet(Start(deltamax_PFCx)+delay_detections(p,1), End(deltamax_PFCx)+delay_detections(p,2));
    deltas_PFCx = CleanUpEpoch(deltas_PFCx,1);
    st_deltas = Start(deltas_PFCx);
    end_deltas = End(deltas_PFCx);
    
    
    %% Create sham
    nb_sham = 7000;
    idx = randsample(length(st_deltas), nb_sham);
    sham_tmp = [];

    for i=1:length(idx)
        min_tmp = st_deltas(idx(i));
        duree = end_deltas(idx(i))-st_deltas(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end    
    ShamEvent = ts(sort(sham_tmp));
    
    
    %% Tones in - N2 & N3
    RipplesDeltaN2 = Restrict(Restrict(tRipples, N2), deltas_PFCx);
    RipplesDeltaN3 = Restrict(Restrict(tRipples, N3), deltas_PFCx);
    RipplesDeltaNREM = Restrict(Restrict(tRipples, NREM), deltas_PFCx);
        
    ripraster_res.n2.nb_ripples{p} = length(RipplesDeltaN2);
    ripraster_res.n3.nb_ripples{p} = length(RipplesDeltaN3);
    ripraster_res.n3.nb_ripples{p} = length(RipplesDeltaNREM);
    
    %% Sham in - N2 & N3
    ShamDeltaN2 = Restrict(Restrict(ShamEvent, N2), deltas_PFCx);
    ShamDeltaN3 = Restrict(Restrict(ShamEvent, N3), deltas_PFCx);
    ShamDeltaNREM = Restrict(Restrict(ShamEvent, N3), deltas_PFCx);
        
    ripraster_res.n2.nb_sham{p} = length(ShamDeltaN2);
    ripraster_res.n3.nb_sham{p} = length(ShamDeltaN3);
    ripraster_res.nrem.nb_sham{p} = length(ShamDeltaNREM);
    
    
    %% Rasters    
    
    %ripples
    ripraster_res.n2.rasters.ripples{p}  = RasterMatrixKJ(PFCdeep, RipplesDeltaN2, t_start, t_end);
    ripraster_res.n3.rasters.ripples{p}  = RasterMatrixKJ(PFCdeep, RipplesDeltaN3, t_start, t_end);
    ripraster_res.nrem.rasters.ripples{p}  = RasterMatrixKJ(PFCdeep, RipplesDeltaNREM, t_start, t_end);
    
    %sham
    ripraster_res.n2.rasters.sham{p}   = RasterMatrixKJ(PFCdeep, ShamDeltaN2, t_start, t_end);
    ripraster_res.n3.rasters.sham{p}   = RasterMatrixKJ(PFCdeep, ShamDeltaN3, t_start, t_end);
    ripraster_res.nrem.rasters.sham{p} = RasterMatrixKJ(PFCdeep, ShamDeltaNREM, t_start, t_end);
    
    
    %% orders for Ripples

    %N2
    ripplesin_tmp = Range(RipplesDeltaN2);
    ripraster_res.n2.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.n2.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_deltas(find(st_deltas<ripplesin_tmp(i),1,'last'));
        ripraster_res.n2.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>ripplesin_tmp(i),1));
        ripraster_res.n2.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %N3
    ripplesin_tmp = Range(RipplesDeltaN3);
    ripraster_res.n3.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.n3.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_deltas(find(st_deltas<ripplesin_tmp(i),1,'last'));
        ripraster_res.n3.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>ripplesin_tmp(i),1));
        ripraster_res.n3.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %NREM
    ripplesin_tmp = Range(RipplesDeltaNREM);
    ripraster_res.nrem.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripraster_res.nrem.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_deltas(find(st_deltas<ripplesin_tmp(i),1,'last'));
        ripraster_res.nrem.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>ripplesin_tmp(i),1));
        ripraster_res.nrem.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    
    %% orders for SHAM

    %N2
    shamin_tmp = Range(ShamDeltaN2);
    ripraster_res.n2.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.n2.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        ripraster_res.n2.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        ripraster_res.n2.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %N3
    shamin_tmp = Range(ShamDeltaN3);
    ripraster_res.n3.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.n3.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        ripraster_res.n3.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        ripraster_res.n3.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end 
    
    %NREM
    shamin_tmp = Range(ShamDeltaNREM);
    ripraster_res.nrem.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripraster_res.nrem.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        ripraster_res.nrem.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        ripraster_res.nrem.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end 
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesInDeltaN2N3Raster.mat -v7.3 ripraster_res t_start t_end





