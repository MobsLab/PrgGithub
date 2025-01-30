% RandomPethAnalysis
% 06.12.2016 KJ
%
% Collect data to analyse the raster plot of ramdon tone
% 
% 
%   see  
%

clear
Dir = PathForExperimentsDeltaWavesTone('RdmTone');
%Dir = PathForExperimentsDeltaKJHD('RdmTone');

Dir2 = PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir = IntersectPathForExperiment(Dir,Dir2);

%params
t_before = -4E4; %in 1E-4s
t_after = 4E4; %in 1E-4s
binsize_mua=10;
effect_period = 3000; %300ms
substage_ind = 1:5;

%
for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        rdmpeth_res.path{p}=Dir.path{p};
        rdmpeth_res.manipe{p}=Dir.manipe{p};
        rdmpeth_res.delay{p}=Dir.delay{p};
        rdmpeth_res.name{p}=Dir.name{p};
        
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
        if exist('DeltaPFCx','file')==2
            load DeltaPFCx DeltaOffline
        elseif exist('newDeltaPFCx','file')==2
            load newDeltaPFCx DeltaEpoch
            DeltaOffline = DeltaEpoch;
            clear DeltaEpoch
        elseif exist('AllDeltaPFCx','file')==2
            load AllDeltaPFCx DeltaEpoch
            DeltaOffline = DeltaEpoch;
            clear DeltaEpoch
        elseif exist('DeltaWaves','file')==2
            load DeltaWaves deltas_PFCx
            DeltaOffline = deltas_PFCx;
            clear DeltaEpoch
        end
        
        tdeltas = ts((Start(DeltaOffline)+End(DeltaOffline))/2);
        delta_center = Range(tdeltas);
        start_deltas = Start(DeltaOffline);
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
        tdowns = ts((Start(Down)+End(Down))/2);
        start_down = Start(Down);
        end_down = End(Down);
        
        %tones
        load('DeltaSleepEvent.mat', 'TONEtime1')
        delay = Dir.delay{p}*1E4;
        tones_tmp = TONEtime1 + delay;
        ToneEvent = ts(tones_tmp);
        nb_tones = length(tones_tmp);
        tone_intv_post = intervalSet(tones_tmp, tones_tmp + effect_period);  % Tone and its window where an effect could be observed
        
        
        %% DIFF
        clear delta_centers delta_epoch firing_rate delta_density
        % find factor to increase EEGsup signal compared to EEGdeep
        k=1;
        for i=0.1:0.1:4
            distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
            k=k+1;
        end
        Factor=find(distance==min(distance))*0.1;
        % Difference between EEG deep and EEG sup (*factor)
        LFPdiff = tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup));
        
        
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
        
        if ~isempty(start_down)
            induce_down = zeros(nb_tones, 1);
            [~,interval,~] = InIntervals(start_down, [Start(tone_intv_post) End(tone_intv_post)]);
            down_tone_success = unique(interval);
            induce_down(down_tone_success(2:end)) = 1;  %do not consider the first nul element
        else
            induce_down = [];
        end
        
        
        %% SUBSTAGE
        substage_tone = nan(1,length(tones_tmp));
        for sub=substage_ind
            substage_tone(ismember(tones_tmp, Range(Restrict(ToneEvent, Substages{sub})))) = sub;
        end
        
        
        %% SAVE AND RASTER
        rdmpeth_res.delta.raster.diff{p} = RasterMatrixKJ(LFPdiff, ToneEvent, t_before, t_after);
        rdmpeth_res.delta.raster.deep{p} = RasterMatrixKJ(LFPdeep, ToneEvent, t_before, t_after);
        rdmpeth_res.delta.raster.sup{p} = RasterMatrixKJ(LFPsup, ToneEvent, t_before, t_after);
        rdmpeth_res.delta.delay{p} = delay_delta_tone;
        rdmpeth_res.delta.induced{p} = induce_delta;
        
        rdmpeth_res.down.raster{p} = RasterMatrixKJ(Q, ToneEvent, t_before, t_after);
        rdmpeth_res.down.delay{p} = delay_down_tone;
        rdmpeth_res.down.induced{p} = induce_down;
        
        rdmpeth_res.substage_tone{p} = substage_tone;
        
    catch
        disp('error for this record')
    end
end

%saving data
cd([FolderProjetDelta 'Data/']) 
save RandomPethAnalysis.mat -v7.3 rdmpeth_res substage_ind
