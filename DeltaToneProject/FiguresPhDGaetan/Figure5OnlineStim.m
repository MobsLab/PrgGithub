% Figure5OnlineStim
% 09.12.2016 KJ
%
% Collect data to plot the figures from the Figure5.pdf of Gaetan PhD
% 
% 
%   see
%



Dir = PathForExperimentsDeltaWavesTone('DeltaToneAll');
% Dir = PathForExperimentsDeltaKJHD('DeltaToneAll');

%Dir with spikes
Dir_spikes = PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
Dir_spikes = IntersectPathForExperiment(Dir,Dir_spikes);

clear Dir1 Dir2 Dir_spikes1 Dir_spikes2 Dir_spikes3

%params
t_before = -2E4; %in 1E-4s
t_after = 2E4; %in 1E-4s
binsize_mua = 10;
binsize_MET = 10;
nb_bins_MET = 200;


%% RECORD WITH TONE
for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        figure5_res.path{p}=Dir.path{p};
        figure5_res.manipe{p}=Dir.manipe{p};
        figure5_res.delay{p}=Dir.delay{p};
        figure5_res.name{p}=Dir.name{p};
        
        if ismember(Dir.path{p},Dir_spikes.path)
            with_spike=1;
        else
            with_spike=0;
        end
        
        %% load
        
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
        delta_center = (Start(DeltaOffline) + End(DeltaOffline)) /2;

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
        
        %tones and detection
        load('DeltaSleepEvent.mat', 'TONEtime1', 'DeltaDetect')
        delay = Dir.delay{p}*1E4;
        tones_tmp = TONEtime1 + delay;
        ToneEvent = ts(tones_tmp);
        detect_tmp = DeltaDetect;
        DetectEvent = ts(detect_tmp);
        
        %% Mean LFP and MUA - RASTER
        %deep
        [Met_y, ~, Met_x] = mETAverage(detect_tmp, Range(LFPdeep), Data(LFPdeep), binsize_MET, nb_bins_MET);
        figure5_res.met.detect.deep.x{p} = Met_x;
        figure5_res.met.detect.deep.y{p} = Met_y;
        %sup
        [Met_y, ~, Met_x] = mETAverage(detect_tmp, Range(LFPsup), Data(LFPsup), binsize_MET, nb_bins_MET);
        figure5_res.met.detect.sup.x{p} = Met_x;
        figure5_res.met.detect.sup.y{p} = Met_y;
        %mua
        [Met_y, ~, Met_x] = mETAverage(detect_tmp, Range(Q), full(Data(Q)), binsize_MET, nb_bins_MET);
        figure5_res.met.detect.mua.x{p} = Met_x;
        figure5_res.met.detect.mua.y{p} = Met_y;
        
        %offline
        %deep
        [Met_y, ~, Met_x] = mETAverage(delta_center, Range(LFPdeep), Data(LFPdeep), binsize_MET, nb_bins_MET);
        figure5_res.met.offline.deep.x{p} = Met_x;
        figure5_res.met.offline.deep.y{p} = Met_y;
        %sup
        [Met_y, ~, Met_x] = mETAverage(delta_center, Range(LFPsup), Data(LFPsup), binsize_MET, nb_bins_MET);
        figure5_res.met.offline.sup.x{p} = Met_x;
        figure5_res.met.offline.sup.y{p} = Met_y;
        
        %mua raster on tone
        figure5_res.raster.detect.mua{p} = RasterMatrixKJ(Q, DetectEvent, t_before, t_after);
        
        
        
        %% SAVE DATA
        figure5_res.with_spike{p} = with_spike;
        figure5_res.nb_neuron{p} = nb_neuron;
        
        figure5_res.detections{p} = detect_tmp;
        figure5_res.tones{p} = tones_tmp;
        figure5_res.delta{p} = DeltaOffline;
        figure5_res.down{p} = Down;
        
        figure5_res.nb.detections{p} = length(detect_tmp);
        figure5_res.nb.tones{p} = length(tones_tmp);
        figure5_res.nb.delta{p} = length(Start(DeltaOffline));
        figure5_res.nb.down{p} = length(Start(Down));
        
    catch
        disp('error for this record')
    end
end

%saving data
cd([FolderProjetDelta 'Data/']) 
save Figure5OnlineStim_bis.mat -v7.3 figure5_res t_before t_after binsize_mua binsize_MET nb_bins_MET






