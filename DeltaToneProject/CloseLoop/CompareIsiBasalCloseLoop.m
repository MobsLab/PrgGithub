% CompareIsiBasalCloseLoop
% 01.10.2019 KJ
%
% Look at the effect of tones on the ISI
%
% CompareIsiBasalCloseLoopPlot


clear


%% basal ISI
Dir_basal = PathForExperimentsDeltaCloseLoop('Basal');

for p=1:length(Dir_basal.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_basal.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir_basal p basal_res
    
    basal_res.path{p}   = Dir_basal.path{p};
    basal_res.manipe{p} = Dir_basal.manipe{p};
    basal_res.name{p}   = Dir_basal.name{p};
    basal_res.date{p}   = Dir_basal.date{p};
    
    %% load
    
    %Delta waves
    delta_PFCx = GetDeltaWaves;
    start_deltas = Start(delta_PFCx);
    end_deltas = End(delta_PFCx);
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %Restrict
    DeltaNrem = dropShortIntervals(and(delta_PFCx, NREM),750);
    st_deltas = Start(DeltaNrem);
    
    
    %% ISI
    %delta
    for i=1:length(st_deltas)
        next_delta = start_deltas(find(start_deltas>st_deltas(i), 3));
        for k=1:3
            try
                isi_basal{k}(i) = next_delta(k) - st_deltas(i);
            catch
                isi_basal{k}(i) = nan;
            end
        end
    end
    %save
    basal_res.isi_basal{p} = isi_basal;

end


%% BCI ISI
Dir_bci = PathForExperimentsDeltaCloseLoop('DeltaToneDelay');
effect_periods = GetEffectPeriodDeltaTone(Dir_bci);
delays = unique(cell2mat(Dir_bci.delay));


for p=1:length(Dir_bci.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_bci.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir_bci p basal_res bci_res effect_periods delays
    
    bci_res.path{p}   = Dir_bci.path{p};
    bci_res.manipe{p} = Dir_bci.manipe{p};
    bci_res.name{p}   = Dir_bci.name{p};
    bci_res.date{p}   = Dir_bci.date{p};
    
    %% load
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    
    %Delta waves
    delta_PFCx = GetDeltaWaves;
    st_deltas = Start(delta_PFCx);
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %Restrict
    ToneNREM = Restrict(ToneEvent, NREM);
    nb_tones = length(ToneNREM);
    
    
    %% Select tones that are really triggered by delta and distinguish Success and failed
    
    %triggered
    pre_period = 1000; %100ms
    delay = Dir_bci.delay{p}*1e4;
    TonesTriggeredIntv = [Range(ToneNREM) - (delay+pre_period),  Range(ToneNREM) - (delay-pre_period)];
    
    delta_triggered = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(st_deltas, TonesTriggeredIntv);
    tone_trig = unique(interval);
    tone_trig(tone_trig==0)=[];
    delta_triggered(tone_trig) = 1;  %do not consider the first nul element

    
    %induced
    TonesSuccessIntv = [Range(ToneNREM) + effect_periods(p,1), Range(ToneNREM) + effect_periods(p,2)];
    
    induce_delta = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(st_deltas, TonesSuccessIntv);
    tone_success = unique(interval);
    tone_success(tone_success==0)=[];
    induce_delta(tone_success) = 1;  %do not consider the first nul element
    
    %selected tones
    tones_tmp = Range(ToneNREM);
    tones_success = tones_tmp(induce_delta==1 & delta_triggered==1);
    tones_failed = tones_tmp(induce_delta==0 & delta_triggered==1);
    
    
    %% ISI
    
    %success
    for i=1:length(tones_success)
        next_delta = st_deltas(find(st_deltas>tones_success(i), 3));
        prev_delta = st_deltas(find(st_deltas<tones_success(i), 1, 'last'));
        for k=1:3
            try
                isi_success{k}(i) = next_delta(k) - prev_delta;
            catch
                isi_success{k}(i) = nan;
            end
        end
    end
    bci_res.isi_success{p} = isi_success;
    
    %failed
    for i=1:length(tones_failed)
        next_delta = st_deltas(find(st_deltas>tones_failed(i), 3));
        prev_delta = st_deltas(find(st_deltas<tones_failed(i), 1, 'last'));
        for k=1:3
            try
                isi_failed{k}(i) = next_delta(k) - prev_delta;
            catch
                isi_failed{k}(i) = nan;
            end
        end
    end
    bci_res.isi_failed{p} = isi_failed;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save CompareIsiBasalCloseLoop.mat basal_res bci_res effect_periods delays




