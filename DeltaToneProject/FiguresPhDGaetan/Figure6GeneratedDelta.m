% Figure6GeneratedDelta
% 08.12.2016 KJ
%
% Collect data to plot the figures from the Figure6.pdf of Gaetan PhD
% 
% 
%   see Figure6GeneratedDelta_bis Figure6GeneratedDelta2 Figure6GeneratedDelta3 Figure6GeneratedDelta4 
%


Dir_basal = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir_basal.path)
    Dir_basal.delay{p}=0;
end
Dir1 = PathForExperimentsDeltaWavesTone('RdmTone');
Dir2 = PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir_tone = MergePathForExperiment(Dir1,Dir2);
clear Dir1 Dir2


% Dir_basal = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir_basal.path)
%     Dir_basal.delay{p}=0;
% end
% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 = PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir_tone = MergePathForExperiment(Dir1,Dir2);
% clear Dir1 Dir2


%Dir with spikes
Dir_spikes1 = PathForExperimentsDeltaSleepSpikes('Basal');
Dir_basal_spikes = IntersectPathForExperiment(Dir_basal,Dir_spikes1);
Dir_spikes2 = PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir_spikes3 = PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
Dir_spikes = MergePathForExperiment(Dir_spikes2,Dir_spikes3);
Dir_tone_spikes = IntersectPathForExperiment(Dir_tone,Dir_spikes);

clear Dir1 Dir2 Dir_spikes Dir_spikes1 Dir_spikes2 Dir_spikes3

%params
t_before = -4E4; %in 1E-4s
t_after = 4E4; %in 1E-4s
binsize_mua=10;
effect_period = 3000; %300ms
substage_ind = 1:5;


%% RECORD WITH TONE
for p=1:length(Dir_tone.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir_tone.path{',num2str(p),'}'')'])
        disp(pwd)
        figure6_res.path{p}=Dir_tone.path{p};
        figure6_res.manipe{p}=Dir_tone.manipe{p};
        figure6_res.delay{p}=Dir_tone.delay{p};
        figure6_res.name{p}=Dir_tone.name{p};
        
        if ismember(Dir_tone.path{p},Dir_tone_spikes.path)
            with_spike=1;
        else
            with_spike=0;
        end
       
        %% Load
        
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

        %LFP
        load ChannelsToAnalyse/PFCx_deep
        eval(['load LFPData/LFP',num2str(channel)])
        LFPdeep=LFP;
        clear LFP channel
        try
            load ChannelsToAnalyse/PFCx_sup
        catch
            load ChannelsToAnalyse/PFCx_deltasup
        end
        eval(['load LFPData/LFP',num2str(channel)])
        LFPsup=LFP;
        clear LFP channel
        
        %MUA
        load SpikeData
        eval('load SpikesToAnalyse/PFCx_Neurons')
        NumNeurons=number;
        clear number
        T=PoolNeurons(S,NumNeurons);
        ST{1}=T;
        try
            ST=tsdArray(ST);
        end
        Q = MakeQfromS(ST,binsize_mua*10); %binsize*10 to be in E-4s
        nb_neuron = length(NumNeurons);
        
        %Delta waves
        try
            load DeltaPFCx DeltaOffline
        catch
            load newDeltaPFCx DeltaEpoch
            DeltaOffline = DeltaEpoch;
            clear DeltaEpoch
        end
        start_deltas = Start(DeltaOffline);
        end_deltas = End(DeltaOffline);
        
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
        down_durations = End(Down) - Start(Down);
        
        %tones
        load('DeltaSleepEvent.mat', 'TONEtime1')
        delay = Dir_tone.delay{p}*1E4;
        tones_tmp = TONEtime1 + delay;
        ToneEvent = ts(tones_tmp);
        nb_tones = length(tones_tmp);
        tone_intv_post = intervalSet(tones_tmp, tones_tmp + effect_period);  % Tone and its window where an effect could be observed
        
        
         %% SUBSTAGE
        substage_tone = nan(1,length(tones_tmp));
        for sub=substage_ind
            substage_tone(ismember(tones_tmp, Range(Restrict(ToneEvent, Substages{sub})))) = sub;
        end
        
        %% INDUCED Delta or Down ?
        induce_delta = zeros(nb_tones, 1);
        [status,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
        
        if ~isempty(start_down)
            induce_down = zeros(nb_tones, 1);
            [status,interval,~] = InIntervals(start_down, [Start(tone_intv_post) End(tone_intv_post)]);
            down_tone_success = unique(interval);
            induce_down(down_tone_success(2:end)) = 1;  %do not consider the first nul element
        else
            induce_down = [];
        end
        
        
        %% SAVE AND RASTER
        figure6_res.with_spike{p} = with_spike; 
        
        figure6_res.tone.delta.raster.deep{p} = RasterMatrixKJ(LFPdeep, ToneEvent, t_before, t_after);
        figure6_res.tone.delta.raster.sup{p} = RasterMatrixKJ(LFPsup, ToneEvent, t_before, t_after);
        figure6_res.tone.delta.induced{p} = induce_delta;
        
        figure6_res.tone.down.raster{p} = RasterMatrixKJ(Q, ToneEvent, t_before, t_after);
        figure6_res.tone.down.delay{p} = delay_down_tone;
        figure6_res.tone.down.induced{p} = induce_down;
        figure6_res.tone.down.duration{p} = down_durations;
        
        figure6_res.tone.substage_tone{p} = substage_tone;
        
    end
end

%saving data
cd([FolderProjetDelta 'Data/']) 
save Figure6GeneratedDelta.mat -v7.3 figure6_res t_before t_after binsize_mua effect_period substage_ind


