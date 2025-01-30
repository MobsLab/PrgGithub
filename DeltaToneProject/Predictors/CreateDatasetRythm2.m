% CreateDatasetRythm2
% 11.12.2017 KJ
%
% Create a dataset for Rythm Machine Learning project
% It contains:
%   - LFP signals from: PFCx (many layer), hippocampus, OB 
%   - MUA signals from PFCx
%   - hypnograms and sleep scoring
%   - down states, delta waves, spindles and ripples
%
% SEE
%   CreateDatasetForNN DatasetForNN1 CreateDatasetRythm1 CreateDatasetRythm3
%


clear
%% Dir and filename to write in
filename = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/rythm_dataset.h5';
% hdf5write(filename, '/coucou', 'petite perruche')

%dir
a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';  % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
Dir.delay{a}=0.2;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
Dir.delay{a}=0.2;
% name, manipe, group, date 
for i=1:length(Dir.path)
    Dir.manipe{i}='RandomStim';
    Dir.group{i}='WT';

    %mouse name
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'/Mouse'):strfind(Dir.path{i},'/Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    Dir.name{i}(Dir.name{i}=='/')=[];
    
    %date
    ind = strfind(Dir.path{i},'/201');
    Dir.date{i} = Dir.path{i}(ind + [7 8 5 6 1:4]);

end



for p=2:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p filename
    
    %% params
    name_channels = {'PFCx_deep', 'PFCx_sup', 'PFCx_deltadeep', 'PFCx_deltasup', 'PFCx_1', 'PFCx_2', 'PFCx_3', 'PFCx_4', ...
        'MoCx_deep', 'MoCx_sup', 'PaCx_deep', 'PaCx_sup', 'dHPC_rip', 'dHPC_deep', 'Bulb_deep', 'Bulb_sup'};
    mua_binsize = 10;
    
    
    %Session
    clear sessions
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    
    %% Tones
    %Tones/Shams
    load('DeltaSleepEvent.mat', 'TONEtime2', 'TONEtime1')
    if exist('TONEtime2','var')
        tones_tmp = (TONEtime2 + Dir.delay{p}*1E4) / 10;
    else
        tones_tmp = (TONEtime1 + Dir.delay{p}*1E4) / 10;
    end
    
    
    %% LFP
    channels_number = [];
    for ch=1:length(name_channels)
        %Load data
        load(['ChannelsToAnalyse/' name_channels{ch}])
        eval(['load LFPData/LFP',num2str(channel)])
        channels_number(ch) = channel;
        lfp_signals{ch} = [Range(LFP) Data(LFP)];
        clear LFP
    end
    
    
    %% MUA
    load SpikeData
    eval('load SpikesToAnalyse/PFCx_Neurons')
    NumNeurons=number;
    clear number
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    MUA = MakeQfromS(ST,mua_binsize*10); %binsize*10 to be in E-4s
    mua = [full(Range(MUA)) full(Data(MUA))];
    
    %% Substages
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
    for s=1:6
        substages_time{s} = [Start(Substages{s}) End(Substages{s})] / 10;
    end
    
    %% Event
    %Down states
    load('DownState.mat', 'down_PFCx')  
    down_states = [Start(down_PFCx) End(down_PFCx)] / 10;
    %Delta waves
    load('DeltaWaves.mat', 'deltas_PFCx')
    delta_waves = [Start(deltas_PFCx) End(deltas_PFCx)] / 10;
    %Ripples
    load('Ripples.mat', 'Ripples')
    Ripples = Ripples * 1e3; % in ms
    
    
    %% write in h5
    hdf5write(filename, ['/' Dir.name{p} '_stim/infos/channels_number'], channels_number, 'WriteMode','append');
    hdf5write(filename, ['/' Dir.name{p} '_stim/infos/channels_name'], name_channels, 'WriteMode','append');
    
    for ch=1:length(name_channels)
        hdf5write(filename, ['/' Dir.name{p} '_stim/lfp/' name_channels{ch}], lfp_signals{ch}, 'WriteMode','append');
    end
    
    hdf5write(filename, ['/' Dir.name{p} '_stim/MUA/PFCx'], mua, 'WriteMode','append');
    
    for s=1:6
        hdf5write(filename, ['/' Dir.name{p} '_stim/SleepStages/' NamesSubstages{s}], substages_time{s}, 'WriteMode','append');
    end
    
    hdf5write(filename, ['/' Dir.name{p} '_stim/Event/downstates'], down_states, 'WriteMode','append');
    hdf5write(filename, ['/' Dir.name{p} '_stim/Event/deltawaves'], delta_waves, 'WriteMode','append');
    hdf5write(filename, ['/' Dir.name{p} '_stim/Event/ripples'], Ripples, 'WriteMode','append');
    hdf5write(filename, ['/' Dir.name{p} '_stim/Event/stim'], tones_tmp, 'WriteMode','append');
    
end

