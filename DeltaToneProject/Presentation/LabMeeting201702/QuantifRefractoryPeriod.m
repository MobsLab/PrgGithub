% QuantifRefractoryPeriod
% 15.02.2017 KJ
%
% Collect data to analyse the delays and refractory period with random tones
% 
% 
%   see  
%       RandomPethAnalysis QuantifRefractoryPeriod_bis

clear
Dir = PathForExperimentsDeltaWavesTone('RdmTone');
%Dir = PathForExperimentsDeltaKJHD('RdmTone');


%params
t_before = -4E4; %in 1E-4s
t_after = 4E4; %in 1E-4s
binsize_mua=10;
effect_period = 2000; %200ms
substage_ind = 1:5;

%% loop
for p=1:length(Dir.path)
%     try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        refractory_res.path{p}=Dir.path{p};
        refractory_res.manipe{p}=Dir.manipe{p};
        refractory_res.delay{p}=Dir.delay{p};
        refractory_res.name{p}=Dir.name{p};
        
        %% Load
        %Times will be convert in seconds or 1E-4s
        load behavResources TimeDebRec TimeEndRec
        
        %Epoch
        load StateEpochSB SWSEpoch Wake REMEpoch
        %Substages
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        if ~isempty(op)
            disp('Loading epochs from NREMepochsML.m')
        else
            clear op NamesOp Dpfc Epoch noise
            load NREMepochsML_old.mat op NamesOp Dpfc Epoch noise
            disp('Loading epochs from NREMepochsML.m')
        end
        [Substages,NamesSubstages]=DefineSubStages(op,noise);

        %Delta waves
        try
            load DeltaPFCx DeltaOffline
        catch
            load newDeltaPFCx DeltaEpoch
            DeltaOffline = DeltaEpoch;
            clear DeltaEpoch
        end
        tdeltas = ts((Start(DeltaOffline)+End(DeltaOffline))/2);
        delta_center = Range(tdeltas);
        start_deltas = Start(DeltaOffline);
        
        %tones
        load('DeltaSleepEvent.mat', 'TONEtime2')
        load('DeltaSleepEvent.mat', 'TONEtime1')
        delay = Dir.delay{p}*1E4;
        if exist('TONEtime2','var')
            tones_tmp = TONEtime2 + delay;
        else
            tones_tmp = TONEtime1 + delay;
        end
        ToneEvent = ts(tones_tmp);
        nb_tones = length(tones_tmp);
        tone_intv_post = intervalSet(tones_tmp, tones_tmp + effect_period);  % Tone and its window where an effect could be observed
        
        
        %% DELAY 
        %delta
        delay_delta_tone = zeros(nb_tones, 1);
        for i=1:nb_tones
            idx_delta_before = find(delta_center < tones_tmp(i), 1,'last');
            delay_delta_tone(i) = tones_tmp(i) - delta_center(idx_delta_before);    
        end        
        %down
        delay_down_tone = nan(nb_tones, 1);
        for i=1:nb_tones
            try
                idx_down_before = find(end_down < tones_tmp(i), 1,'last');
                delay_down_tone(i) = tones_tmp(i) - end_down(idx_down_before);    
            end
        end
        
        
        %% INDUCED Delta or Down ?
        induce_delta = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
        
        
        %% SUBSTAGE
        substage_tone = nan(1,length(tones_tmp));
        for sub=substage_ind
            substage_tone(ismember(tones_tmp, Range(Restrict(ToneEvent, Substages{sub})))) = sub;
        end
        
        
        %% SAVE AND RASTER
        refractory_res.delta.delay{p} = delay_delta_tone;
        refractory_res.delta.induced{p} = induce_delta;
        
        refractory_res.substage_tone{p} = substage_tone;

%     catch
%         disp('error for this record')
%     end
end

%saving data
cd([FolderProjetDelta 'Data/']) 
save QuantifRefractoryPeriod.mat -v7.3 refractory_res substage_ind


