% DeltaToneBciEfficiency
% 12.07.2019 KJ
%
% Quantify the efficiency of the BCI close-loop system:
%   - triggered after a delta waves
%   - induced a delta waves 
% 
%   SEE 
%       DeltaToneBciEfficiencyPlot
%


clear

Dir = PathForExperimentsDeltaCloseLoop('DeltaToneDelay');
clear Dir1 Dir2


% params
substages_ind = 1:5; %N1, N2, N3, REM, WAKE
NamesSubstages = {'N1','N2','N3','REM','Wake'};
effectperiod  = GetEffectPeriodDeltaTone(Dir);
preperiod = 150*10; %150ms

%% ISI for Sham
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    bci_res.path{p}      = Dir.path{p};
    bci_res.manipe{p}    = Dir.manipe{p};
    bci_res.delay{p}     = Dir.delay{p};
    bci_res.name{p}      = Dir.name{p};
    bci_res.date{p}      = Dir.date{p};

    %% load
    %tones
    load('behavResources.mat', 'ToneEvent')
    nb_tones = length(ToneEvent);
    tones_tmp = Range(ToneEvent);
    tone_intv_post = intervalSet(tones_tmp+effectperiod(p,1), tones_tmp+effectperiod(p,2));  % Tone and its window where an effect could be observed
    %before tones
    delay = Dir.delay{p};
    tone_intv_pre = intervalSet(tones_tmp-(delay+preperiod), tones_tmp-delay); %interval before tones where a delta shoul be observed
    
    %Delta waves
    delta_PFCx = GetDeltaWaves;
    start_deltas = Start(delta_PFCx);
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};
    
    %% Tones not in delta waves
    tones_in = zeros(1,length(tones_tmp));
    tones_in(ismember(tones_tmp, Range(Restrict(ToneEvent, delta_PFCx)))) = 1;
    
    %% TRIGGERED by a delta waves ?
    triggered_delta = zeros(nb_tones, 1);
    triggered_tone  = zeros(nb_tones, 1);
    [~,interval,~]  = InIntervals(start_deltas, [Start(tone_intv_pre) End(tone_intv_pre)]);
    triggered       = unique(interval);
    triggered_tone(triggered(2:end)) = 1;  %do not consider the first nul element
    
    %% INDUCE a delta waves ?
    induce_delta    = zeros(nb_tones, 1);
    [~,interval,~]  = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success    = unique(interval);
    induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element

    %% SUBSTAGE
    substage_tone = nan(1,length(tones_tmp));
    for sub=substages_ind
        substage_tone(ismember(tones_tmp, Range(Restrict(ToneEvent, Substages{sub})))) = sub;
    end
    
    %% SAVE
    bci_res.tones_in{p}      = tones_in;
    bci_res.triggered{p}     = triggered_tone;
    bci_res.induced{p}       = induce_delta;
    bci_res.substage_tone{p} = substage_tone;
    

end


%saving data
cd(FolderDeltaDataKJ)
save DeltaToneBciEfficiency.mat bci_res substages_ind NamesSubstages effectperiod preperiod






