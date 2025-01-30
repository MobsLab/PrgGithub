%%ShamInDeltaN2N3Raster
% 23.07.2019 KJ
%
%
% see
%   FigTonesInDeltaN2N3 ShamInDownN2N3Raster TonesInDeltaN2N3Raster
%


% clear

Dir = PathForExperimentsRandomShamDelta;

delay_detections = GetDelayBetweenDeltaDown(Dir);

for p=23:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p shamras_res delay_detections
    
    shamras_res.path{p}   = Dir.path{p};
    shamras_res.manipe{p} = Dir.manipe{p};
    shamras_res.name{p}   = Dir.name{p};
    shamras_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s

    minduration = 40;
    
    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    shamras_res.nb_sham = length(SHAMtime);
    
    %deep
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
    load(['LFPData/LFP' num2str(channel) '.mat'])
    PFCdeep = LFP;
    %sup
    try
        load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
    catch
        load('ChannelsToAnalyse/PFCx_deltasup.mat', 'channel')
    end
    load(['LFPData/LFP' num2str(channel) '.mat'])
    PFCsup = LFP;
    clear LFP
    
    %Delta waves
    load('DeltaWaves.mat', 'deltamax_PFCx')
    deltamax_PFCx = dropShortIntervals(deltamax_PFCx,minduration);
    deltamax_PFCx = and(deltamax_PFCx,NREM);
    
    deltas_PFCx = intervalSet(Start(deltamax_PFCx)+delay_detections(p,1), End(deltamax_PFCx)+delay_detections(p,2));
    st_deltas = Start(deltas_PFCx);
    end_deltas = End(deltas_PFCx);
 
    
    %% Sham in - N2 & N3
    ShamDownN2 = Restrict(Restrict(SHAMtime, N2), deltas_PFCx);
    ShamDownN3 = Restrict(Restrict(SHAMtime, N3), deltas_PFCx);
    ShamDownNREM = Restrict(Restrict(SHAMtime, NREM), deltas_PFCx);
    
    %create new sham if none
    if isempty(ShamDownNREM)
        nb_sham = 200;
        idx = randsample(length(st_deltas), nb_sham);
        sham_tmp = [];
        for i=1:length(idx)
            min_tmp = st_deltas(idx(i));
            duree = end_deltas(idx(i))-st_deltas(idx(i));
            sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
        end
        shamin_tmp = sort(sham_tmp);
        ShamIn = ts(shamin_tmp);
        
        ShamDownN2 = Restrict(Restrict(ShamIn, N2), deltas_PFCx);
        ShamDownN3 = Restrict(Restrict(ShamIn, N3), deltas_PFCx);
        ShamDownNREM = Restrict(Restrict(ShamIn, NREM), deltas_PFCx); 
    end
    
    shamras_res.n2.nb_sham{p} = length(ShamDownN2);
    shamras_res.n3.nb_sham{p} = length(ShamDownN3);
    shamras_res.nrem.nb_sham{p} = length(ShamDownNREM);
    
    
    %% Rasters    
    shamras_res.n2.rasters{p}  = RasterMatrixKJ(PFCdeep, ShamDownN2, t_start, t_end);
    shamras_res.n3.rasters{p}  = RasterMatrixKJ(PFCdeep, ShamDownN3, t_start, t_end);
    shamras_res.nrem.rasters{p}  = RasterMatrixKJ(PFCdeep, ShamDownNREM, t_start, t_end);
    
    
    %% orders

    %N2
    shamin_tmp = Range(ShamDownN2);
    shamras_res.n2.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.n2.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        shamras_res.n2.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        shamras_res.n2.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %N3
    shamin_tmp = Range(ShamDownN3);
    shamras_res.n3.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.n3.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        shamras_res.n3.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        shamras_res.n3.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamDownNREM);
    shamras_res.nrem.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.nrem.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        shamras_res.nrem.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        shamras_res.nrem.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
     
end

%saving data
cd(FolderDeltaDataKJ)
save ShamInDeltaN2N3Raster.mat -v7.3 shamras_res t_start t_end 





