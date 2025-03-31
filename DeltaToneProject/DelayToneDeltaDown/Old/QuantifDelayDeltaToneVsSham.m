% QuantifDelayDeltaToneVsSham
% 06.10.2016 KJ (15.11.2016)
%
% Distribution of the delays of the 1st delta/down,
% after :
%   - Tone
%   - Sham
% The analysis is done for each substage
%
% INFO
%   A delay needs to be added to SHAMtime
% 
% 


Dir_sham = PathForExperimentsDeltaWavesTone('Basal');
Dir_tone = PathForExperimentsDeltaWavesTone('DeltaToneAll');
substages_ind = 1:5; %N1, N2, N3, REM, WAKE
delays = unique(cell2mat(Dir_tone.delay));

%% Delay for sham
for p=1:length(Dir_sham.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_sham.path{',num2str(p),'}'')'])
    disp(pwd)
    
    sham_res.path{p}=Dir_sham.path{p};
    sham_res.manipe{p}=Dir_sham.manipe{p};
    sham_res.name{p}=Dir_sham.name{p};

    %% load
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
    %Sham
    load ShamSleepEvent SHAMtime
    %Substages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    for d=1:length(delays)
        delay = delays(d);
        sham_res.delay{p,d}=delay;
        ShamEvent = ts(Range(SHAMtime) + delay*1E4);
        
        for sub=substages_ind
            sham_tmp = Range(Restrict(ShamEvent, Substages{sub}));
            nb_sham = length(sham_tmp);

            %delta
            delay_delta_sham = zeros(nb_sham, 1);
            for i=1:nb_sham
                idx_delta_before = find(start_deltas > sham_tmp(i), 1);
                if ~isempty(idx_delta_before)
                    delay_delta_sham(i) = start_deltas(idx_delta_before) - sham_tmp(i);
                else
                    delay_delta_sham(i) = nan;
                end
            end

            %down states
            if ~isempty(start_down)
                delay_down_sham = zeros(nb_sham, 1);
                for i=1:nb_sham
                    idx_down_before = find(start_down > sham_tmp(i), 1);
                    if ~isempty(idx_down_before)
                        delay_down_sham(i) = start_down(idx_down_before) - sham_tmp(i);
                    else
                        delay_down_sham(i) = nan;
                    end
                end
            else
                delay_down_sham = nan(nb_sham, 1);
            end

            sham_res.delay_delta_sham{p,sub,d} = delay_delta_sham;
            sham_res.delay_down_sham{p,sub,d} = delay_down_sham;

        end
    end  
end 


%% ISI for DeltaTone
for p=1:length(Dir_tone.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_tone.path{',num2str(p),'}'')'])
    disp(pwd)
    delay_res.path{p}=Dir_tone.path{p};
    delay_res.manipe{p}=Dir_tone.manipe{p};
    delay_res.delay{p}=Dir_tone.delay{p};
    delay_res.name{p}=Dir_tone.name{p};
    
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
        
        delay_res.delay_delta_tone{p,sub} = delay_delta_tone;
        delay_res.delay_down_tone{p,sub} = delay_down_tone;
        
    end

end


name_substages = NamesSubstages(substages_ind);
%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifDelayDeltaToneVsSham.mat sham_res delay_res delays substages_ind 


