% QuantifDelayFirstDeltaToneSubstage
% 15.11.2016 KJ
%
% collect data for the quantification of the delay between a tone a the next delta/down, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are just collected and saved in 
%
%   see QuantifDelayFirstDeltaToneSubstage2


Dir_rdm = PathForExperimentsDeltaWavesTone('RdmTone');
Dir_tone  = PathForExperimentsDeltaWavesTone('DeltaToneAll');

%% params
substages_ind = 1:5; %N1, N2, N3, REM, WAKE

%% ISI for Random
for p=1:length(Dir_rdm.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_rdm.path{',num2str(p),'}'')'])
    disp(pwd)
    delay_res.path{p}=Dir_rdm.path{p};
    delay_res.manipe{p}=Dir_rdm.manipe{p};
    delay_res.delay{p}=-1;
    delay_res.name{p}=Dir_rdm.name{p};
    
    %% load
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = Dir_rdm.delay{p}*1E4; %in 1E-4s
    ToneEvent = ts(TONEtime1 + delay);
    %Down states
    try
        load newDownState Down
    catch
        try
            load DownSpk Down
        catch
            Down = intervalSet([],[]);
        end
    end
    start_down = Start(Down);
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    start_deltas = Start(DeltaOffline);
    %Substages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    
    %% Sound and delay    
    for sub=substages_ind
        tones_tmp = Range(Restrict(ToneEvent, Substages{sub}));
        nb_tones = length(tones_tmp);
        
        %delta
        delay_delta_tone = zeros(nb_tones, 1);
        for i=1:nb_tones
            idx_delta_before = find(start_deltas > tones_tmp(i), 1);
            delay_delta_tone(i) = start_deltas(idx_delta_before) - tones_tmp(i);    
        end

        %down states
        if ~isempty(start_down)
            delay_down_tone = zeros(nb_tones, 1);
            for i=1:nb_tones
                idx_down_before = find(start_down > tones_tmp(i), 1);
                delay_down_tone(i) = start_down(idx_down_before) - tones_tmp(i);
            end
        else
            delay_down_tone = nan(nb_tones, 1);
        end
        
        delay_res.delay_delta_tone{p,sub} = delay_delta_tone;
        delay_res.delay_down_tone{p,sub} = delay_down_tone;
        
    end

end

k=length(delay_res.path);

%% ISI for DeltaTone
for p=1:length(Dir_tone.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_tone.path{',num2str(p),'}'')'])
    disp(pwd)
    delay_res.path{p+k}=Dir_tone.path{p};
    delay_res.manipe{p+k}=Dir_tone.manipe{p};
    delay_res.delay{p+k}=Dir_tone.delay{p};
    delay_res.name{p+k}=Dir_tone.name{p};
    
    %% load
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = Dir_tone.delay{p}*1E4; %in 1E-4s
    ToneEvent = ts(TONEtime1 + delay);
    %Down states
    try
        load newDownState Down
    catch
        try
            load DownSpk Down
        catch
            Down = intervalSet([],[]);
        end
    end
    start_down = Start(Down);
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    start_deltas = Start(DeltaOffline);
    %Substages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    
    %% Sound and delay    
    for sub=substages_ind
        tones_tmp = Range(Restrict(ToneEvent, Substages{sub}));
        nb_tones = length(tones_tmp);
        
        %delta
        delay_delta_tone = zeros(nb_tones, 1);
        for i=1:nb_tones
            idx_delta_before = find(start_deltas > tones_tmp(i), 1);
            delay_delta_tone(i) = start_deltas(idx_delta_before) - tones_tmp(i);    
        end

        %down states
        if ~isempty(start_down)
            delay_down_tone = zeros(nb_tones, 1);
            for i=1:nb_tones
                idx_down_before = find(start_down > tones_tmp(i), 1);
                delay_down_tone(i) = start_down(idx_down_before) - tones_tmp(i);
            end
        else
            delay_down_tone = nan(nb_tones, 1);
        end
        
        delay_res.delay_delta_tone{p+k,sub} = delay_delta_tone;
        delay_res.delay_down_tone{p+k,sub} = delay_down_tone;
        
    end

end


name_substages = NamesSubstages(substages_ind);
delays = unique(cell2mat(delay_res.delay));
%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifDelayFirstDeltaToneSubstage.mat delay_res delays substages_ind 



