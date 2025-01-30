%%TonesInDeltaN2N3Raster
% 18.09.2018 KJ
%
%
% see
%   FigTonesInDeltaN2N3 TonesInDeltaN2N3Effect TonesInDownN2N3Raster
%   ShamInDeltaN2N3Raster
%

clear

Dir = PathForExperimentsRandomTonesDelta;

delay_detections = GetDelayBetweenDeltaDown(Dir);


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tonesras_res delay_detections
    
    tonesras_res.path{p}   = Dir.path{p};
    tonesras_res.manipe{p} = Dir.manipe{p};
    tonesras_res.name{p}   = Dir.name{p};
    tonesras_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s

    minduration = 40;
    
    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
    
    %tones in deltas
    load('behavResources.mat', 'ToneEvent')
    tonesras_res.nb_tones = length(ToneEvent);
    
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
    
    
    %% Tones in - N2 & N3
    ToneDownN2 = Restrict(Restrict(ToneEvent, N2), deltas_PFCx);
    ToneDownN3 = Restrict(Restrict(ToneEvent, N3), deltas_PFCx);
    ToneDownNREM = Restrict(Restrict(ToneEvent, NREM), deltas_PFCx);
        
    tonesras_res.n2.nb_tones{p} = length(ToneDownN2);
    tonesras_res.n3.nb_tones{p} = length(ToneDownN3);
    tonesras_res.n3.nb_tones{p} = length(ToneDownNREM);
    
    
    %% Rasters    
    tonesras_res.n2.rasters{p}  = RasterMatrixKJ(PFCdeep, ToneDownN2, t_start, t_end);
    tonesras_res.n3.rasters{p}  = RasterMatrixKJ(PFCdeep, ToneDownN3, t_start, t_end);
    tonesras_res.nrem.rasters{p}  = RasterMatrixKJ(PFCdeep, ToneDownNREM, t_start, t_end);
    
    
    %% orders

    %N2
    tonesin_tmp = Range(ToneDownN2);
    tonesras_res.n2.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.n2.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tonesras_res.n2.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tonesras_res.n2.after{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %N3
    tonesin_tmp = Range(ToneDownN3);
    tonesras_res.n3.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.n3.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tonesras_res.n3.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tonesras_res.n3.after{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %NREM
    tonesin_tmp = Range(ToneDownNREM);
    tonesras_res.nrem.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.nrem.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tonesras_res.nrem.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tonesras_res.nrem.after{p}(i) = end_aft - tonesin_tmp(i);
    end
     
end

%saving data
cd(FolderDeltaDataKJ)
save TonesInDeltaN2N3Raster.mat -v7.3 tonesras_res t_start t_end





