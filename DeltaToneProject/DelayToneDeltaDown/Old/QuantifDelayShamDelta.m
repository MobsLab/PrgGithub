% QuantifDelayShamDelta
% 12.05.2017 KJ
%
% collect data for the quantification of the delay between a sham and the next delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are just collected and saved in 
%
%   see QuantifDelayTonevsDelta 


%% Dir
Dir=PathForExperimentsDeltaLongSleepNew('basal');
% Dir = PathForExperimentsDeltaKJHD('basal');

Dir.condition=Dir.manipe;

% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE, NREM


%% load random train of tones from random records
Dir_rdm=PathForExperimentsDeltaLongSleepNew('RdmTone');

tones_rdm = cell(0);
last_tone = [];
for p=1:length(Dir_rdm.path)
    
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_rdm.path{',num2str(p),'}'')'])
    disp(pwd)
    
    %tones
    delay = Dir_rdm.delay{p}*1E4; %in 1E-4s
    try
        load('DeltaSleepEvent.mat', 'TONEtime2')
        tone_tmp = (TONEtime2 + delay);
    catch
        load('DeltaSleepEvent.mat', 'TONEtime1')
        tone_tmp = (TONEtime1 + delay);
    end
    
    %keep
    tones_rdm{end+1} = ts(tone_tmp);
    last_tone = [last_tone max(tone_tmp)];    
end



%% ISI for DeltaTone
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    delay_res.path{p}=Dir.path{p};
    delay_res.manipe{p}=Dir.manipe{p};
    delay_res.delay{p}=0;
    delay_res.name{p}=Dir.name{p};
    delay_res.condition{p}=Dir.condition{p};
    
    
    %% load
    %tones
    load('ShamSleepEvent.mat', 'SHAMtime')
    %Delta waves
    if exist('DeltaWaves.mat','file')==2
        load('DeltaWaves.mat', 'deltas_PFCx')
        start_deltas = Start(deltas_PFCx);
        
    elseif exist('DeltaPFCx.mat','file')==2
        load('DeltaPFCx.mat', 'DeltaOffline')
        start_deltas = Start(DeltaOffline);
        
    elseif exist('newDeltaPFCx.mat','file')==2
        load('newDeltaPFCx.mat', 'DeltaEpoch')
        start_deltas = Start(DeltaEpoch);
    end

    %Substages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    %% SHAM: Sound and delay    
    for sub=substages_ind
        rdm_tmp = Range(Restrict(SHAMtime, Substages{sub}));
        nb_rdm = length(rdm_tmp);
        
        %delta
        delay_delta_rdm = nan(nb_rdm, 1);
        for i=1:nb_rdm
            idx_delta_before = find(start_deltas > rdm_tmp(i), 1);
            delay_delta_rdm(i) = start_deltas(idx_delta_before) - rdm_tmp(i);    
        end
        
        delay_res.delay_delta_sham{p,sub} = delay_delta_rdm;
        
    end
    
    %% Random train: Sound and delay   
    RdmTime = tones_rdm{randi(length(tones_rdm))};
    
    for sub=substages_ind
        rdm_tmp = Range(Restrict(RdmTime, Substages{sub}));
        nb_rdm = length(rdm_tmp);
        
        %delta
        delay_delta_rdm = nan(nb_rdm, 1);
        for i=1:nb_rdm
            idx_delta_before = find(start_deltas > rdm_tmp(i), 1);
            if ~isempty(idx_delta_before)
                delay_delta_rdm(i) = start_deltas(idx_delta_before) - rdm_tmp(i);   
            end
        end
        
        delay_res.delay_delta_rdm{p,sub} = delay_delta_rdm;
        
    end

end


%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifDelayShamDelta2.mat delay_res substages_ind 



    