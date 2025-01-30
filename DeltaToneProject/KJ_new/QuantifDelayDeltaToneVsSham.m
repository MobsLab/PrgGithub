% QuantifDelayDeltaToneVsSham
% 06.10.2016 KJ
%
% Distribution of the delays of the 1st and 2nd delta/down,
% after :
%   - Tone
%   - Sham
%   - Random Event
% The analysis is done for each substage
%
% INFO
%   A delay needs to be added to SHAMtime
% 
% 


Dir_sham=PathForExperimentsDeltaWavesTone('Basal');
Dir_tone=PathForExperimentsDeltaWavesTone('DeltaToneAll');%% params
substages_ind = 1:5; %N1, N2, N3, REM, WAKE
delays = unique(cell2mat(Dir_tone.delay));

%% Delay for sham
for p=1:length(Dir_sham)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_sham.path{',num2str(p),'}'')'])
    disp(pwd)
    
    sham_res.path{p}=Dir_sham.path{p};
    sham_res.manipe{p}=Dir_sham.manipe{p};
    sham_res.name{p}=Dir_sham.name{p};
    
    for d=1:length(delays)
        try
            delay = delays(d);
            sham_res.delay{p,d}=delay;

            %% load
            load StateEpochSB SWSEpoch Wake
            %Down states
            load newDownState Down
            %Delta
            load DeltaPFCx DeltaOffline
            %Ripples
            load newRipHPC Ripples_tmp
            %Sham
            load ShamSleepEvent SHAMtime
            ShamEvent = ts(Range(SHAMtime) + delay*1E4);
            %Substages
            clear op NamesOp Dpfc Epoch noise
            load NREMepochsML.mat op NamesOp Dpfc Epoch noise
            disp('Loading epochs from NREMepochsML.m')
            [Substages,NamesSubstages]=DefineSubStages(op,noise);



            %% When arrives the next deltas
            for sub=substages_ind
                sham_res.substage{p,d,sub} = NamesSubstages{sub};

                sham_substage = Range(ShamEvent, Substages{sub}));
                
                nb_sham = length(ShamEvent);

                
                %delta
                time_delta_sham = zeros(nb_tones, 1);
                for i=1:nb_tones
                    idx_first_delta = find(start_deltas > tones_tmp(i), 1);
                    time_delta_sham(i) = start_deltas(idx_first_delta) - tones_tmp(i);    
                end
                
                
                intv_deltas = diff(delta_substage);
                sham_res.intv_deltas1{p,sub} = intv_deltas;
                sham_res.intv_deltas2{p,sub} = intv_deltas(1:end-1) + intv_deltas(2:end);



            end
        catch
            disp('error for this record')
        end
        
    end 
end
