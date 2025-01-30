% DistribDelayToneShamDelta
% 11.07.2019 KJ
%
% quantification of the delay between a tone/sham and the next delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE, NREM
%
% Here, the data are just collected and saved 
%
%   see QuantifDelayTonevsDelta QuantifDelayShamDelta
%   DistribDelayToneShamDeltaPlot
%


% clear

Dir_basal = PathForExperimentsDeltaCloseLoop('Basal');
Dir_tone  = PathForExperimentsDeltaCloseLoop('AllTone');

% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE, NREM
range_delay = [200 500] * 10; % range of delays after sham detection, to compare with delta triggered tones
minduration = 75*10;
% margin_deltas = 50*10; %50ms


%% ISI for Sham
for p=1:length(Dir_basal.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir_basal.path{p})
    disp(pwd)
    
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
    %sham
    load('ShamSleepEvent.mat', 'SHAMtime')
    SHAMtime = ts(Range(SHAMtime) + randi(range_delay));
    %Delta waves
%     delta_PFCx = GetDeltaWaves;
    load('DeltaWaves.mat', 'deltamax_PFCx')
    delta_PFCx = dropShortIntervals(deltamax_PFCx,minduration);
    delta_PFCx = and(delta_PFCx,NREM);
    end_deltas = Start(delta_PFCx);
    
    
    %% SHAM: Sound and delay    
    for sub=substages_ind
        intv = intervalSet(Start(delta_PFCx), End(delta_PFCx));
        intv = CleanUpEpoch(Substages{sub}-intv);
        rdm_tmp = Range(Restrict(SHAMtime, intv));
        nb_rdm = length(rdm_tmp);
        
        %delta
        delay_sham = nan(nb_rdm, 1);
        for i=1:nb_rdm
            try
                idx_delta_before = find(deltas_tmp > rdm_tmp(i), 1);
                delay_sham(i) = deltas_tmp(idx_delta_before) - rdm_tmp(i);  
            end
        end
        
        sham_res.delay_sham{p,sub} = delay_sham;
        
    end
    
    %% Random train: Sound and delay       
    for sub=substages_ind
        intv = intervalSet(Start(delta_PFCx), End(delta_PFCx));
        intv = CleanUpEpoch(Substages{sub}-intv);
        rdm_tmp = Range(Restrict(RdmTime,intv));
        nb_rdm = length(rdm_tmp);
        
        %delta
        delay_rdm = nan(nb_rdm, 1);
        for i=1:nb_rdm
            idx_delta_before = find(deltas_tmp > rdm_tmp(i), 1);
            if ~isempty(idx_delta_before)
                delay_rdm(i) = deltas_tmp(idx_delta_before) - rdm_tmp(i);   
            end
        end
        
        sham_res.delay_rdm{p,sub} = delay_rdm;
        
    end

end


%% DeltaTone and RandomTone
for p=1:length(Dir_tone.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir_tone.path{p})
    disp(pwd)
    
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
%     delta_PFCx = GetDeltaWaves;
    load('DeltaWaves.mat', 'deltamax_PFCx')
    delta_PFCx = dropShortIntervals(deltamax_PFCx,minduration);
    delta_PFCx = and(delta_PFCx,NREM);
    end_deltas = Start(delta_PFCx);
    
    
    %% Sound and delay    
    for sub=substages_ind
        intv = intervalSet(Start(delta_PFCx), End(delta_PFCx));
        intv = CleanUpEpoch(Substages{sub}-intv);
        tones_tmp = Range(Restrict(ToneEvent, intv));
        nb_tones  = length(tones_tmp);
        
        %delta
        delay_deltatone = nan(nb_tones, 1);
        for i=1:nb_tones
            idx_delta_before = find(deltas_tmp > tones_tmp(i), 1);
            delay_deltatone(i) = deltas_tmp(idx_delta_before) - tones_tmp(i);    
        end
        
        tones_res.delay_deltatone{p,sub} = delay_deltatone;
    end

end

%saving data
cd(FolderDeltaDataKJ)
save DistribDelayToneShamDelta.mat sham_res tones_res substages_ind




