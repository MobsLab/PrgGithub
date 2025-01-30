% DistribDelayToneShamEndDelta
% 11.07.2019 KJ
%
% quantification of the delay between a tone/sham and the end of the delta delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE, NREM
%
% Here, the data are just collected and saved 
%
%   see 
%       DistribDelayToneShamEndDeltaMousePlot
%


% clear

Dir_basal = PathForExperimentsRandomShamDelta;
Dir_tone  = PathForExperimentsRandomTonesDelta;

% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE, NREM
delay_detections = GetDelayBetweenDeltaDown(Dir_basal);
minduration = 40*10;

%% ISI for Sham
for p=1:length(Dir_basal.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir_basal.path{p})
    disp(pwd)
    
    clearvars -except p Dir_basal Dir_tone sham_res sham_res delay_detections substages_ind minduration
    
    sham_res.path{p}      = Dir_basal.path{p};
    sham_res.manipe{p}    = Dir_basal.manipe{p};
    sham_res.delay{p}     = 0;
    sham_res.name{p}      = Dir_basal.name{p};

    
    %% load
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};
    %random
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    RdmTime = SHAMtime;
    %Delta waves
    load('DeltaWaves.mat', 'deltamax_PFCx')
    deltamax_PFCx = dropShortIntervals(deltamax_PFCx,minduration);
    deltamax_PFCx = and(deltamax_PFCx,NREM);
    
    deltas_PFCx = intervalSet(Start(deltamax_PFCx)+delay_detections(p,1), End(deltamax_PFCx)+delay_detections(p,2));
    end_deltas = End(deltas_PFCx);
   
    
    %% Random train: Sound and delay       
    for sub=substages_ind
        rdm_tmp = Range(Restrict(Restrict(SHAMtime, deltas_PFCx),Substages{sub}));
        nb_rdm = length(rdm_tmp);
        
        %delta
        delay_rdm = nan(nb_rdm, 1);
        for i=1:nb_rdm
            idx_delta_before = find(end_deltas > rdm_tmp(i), 1);
            if ~isempty(idx_delta_before)
                delay_rdm(i) = end_deltas(idx_delta_before) - rdm_tmp(i);   
            end
        end
        
        sham_res.delay_rdm{p,sub} = delay_rdm;
        
    end

end



%% DeltaTone and RandomTone
delay_detections = GetDelayBetweenDeltaDown(Dir_tone);

for p=1:length(Dir_tone.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir_tone.path{p})
    disp(pwd)
    
    clearvars -except p Dir_basal Dir_tone sham_res sham_res tones_res delay_detections substages_ind minduration
    
    tones_res.path{p}       = Dir_tone.path{p};
    tones_res.manipe{p}     = Dir_tone.manipe{p};
    tones_res.delay{p}      = Dir_tone.delay{p};
    tones_res.name{p}       = Dir_tone.name{p};
    tones_res.date{p}       = Dir_tone.date{p};
    
    
    %% load
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};
    %tones
    load('behavResources.mat', 'ToneEvent')
    %Delta waves
    load('DeltaWaves.mat', 'deltamax_PFCx')
    deltamax_PFCx = dropShortIntervals(deltamax_PFCx,minduration);
    deltamax_PFCx = and(deltamax_PFCx,NREM);
    
    deltas_PFCx = intervalSet(Start(deltamax_PFCx)+delay_detections(p,1), End(deltamax_PFCx)+delay_detections(p,2));
    end_deltas = End(deltas_PFCx);
    
    
    %% Sound and delay    
    for sub=substages_ind
        tones_tmp = Range(Restrict(Restrict(ToneEvent, deltas_PFCx),Substages{sub}));
        nb_tones  = length(tones_tmp);
        
        %delta
        delay_deltatone = nan(nb_tones, 1);
        for i=1:nb_tones
            idx_delta_before = find(end_deltas > tones_tmp(i), 1);
            delay_deltatone(i) = end_deltas(idx_delta_before) - tones_tmp(i);    
        end
        
        tones_res.delay_deltatone{p,sub} = delay_deltatone;
    end

end

%saving data
cd(FolderDeltaDataKJ)
save DistribDelayToneShamEndDelta.mat sham_res tones_res substages_ind minduration




