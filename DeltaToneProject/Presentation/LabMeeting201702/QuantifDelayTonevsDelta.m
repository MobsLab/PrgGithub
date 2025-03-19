% QuantifDelayTonevsDelta
% 15.02.2017 KJ
%
% collect data for the quantification of the delay between a tone a the next delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are just collected and saved in 
%
%   see QuantifDelayFirstDeltaToneSubstage QuantifDelayTonevsDelta2


%% Dir
Dir1=PathForExperimentsDeltaLongSleepNew('RdmTone');
Dir2=PathForExperimentsDeltaLongSleepNew('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);

% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 = PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);


Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    elseif strcmpi(Dir.manipe{p},'RdmTone')
        Dir.condition{p} = ['Random (' num2str(Dir.delay{p}*1000) 'ms)'];
    end
end

% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE, NREM


%% ISI for DeltaTone
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    delay_res.path{p}=Dir.path{p};
    delay_res.manipe{p}=Dir.manipe{p};
    delay_res.delay{p}=Dir.delay{p};
    delay_res.name{p}=Dir.name{p};
    delay_res.condition{p}=Dir.condition{p};
    
    
    %% load
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    delay = Dir.delay{p}*1E4; %in 1E-4s
    ToneEvent = ts(TONEtime2 + delay);
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
        delay_delta_tone = nan(nb_tones, 1);
        for i=1:nb_tones
            idx_delta_before = find(start_deltas > tones_tmp(i), 1);
            delay_delta_tone(i) = start_deltas(idx_delta_before) - tones_tmp(i);    
        end
        
        delay_res.delay_delta_tone{p,sub} = delay_delta_tone;
        
    end

end


%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifDelayTonevsDelta.mat delay_res substages_ind 


