% CreateDatasetRythm3
% 25.01.2017 KJ
%
% Create a dataset for Rythm Machine Learning project
% It contains:
%   - LFP signals from: PFCx (many layer), hippocampus, OB 
%   - MUA signals from PFCx
%   - hypnograms and sleep scoring
%   - down states, delta waves, spindles and ripples
%
% SEE
%   CreateDatasetForNN DatasetForNN1 CreateDatasetRythm1 CreateDatasetRythm2
%


clear


%% Dir and filename to write in
filename = '/home/mobsjunior/Documents/rythm_dataset.h5';
% hdf5write(filename, '/coucou', 'petite perruche')
% 
% a=0;
% %BASAL
% % ------------ 243 ------------
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; 
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
% % ------------ 244 ------------
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
% % ------------ 403 ------------
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse403/Breath-Mouse-403-05122016/';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse403/Breath-Mouse-403-09122016/';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse403/Breath-Mouse-403-12122016/';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse403/Breath-Mouse-403-17122016/';
% %------------ 451 ------------
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';
% % ------------ 508 ------------
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/'; % Mouse 508 - Basal 1 
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/'; % Mouse 508 - Basal 2
% % ------------ 509 ------------
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; % Mouse 509 - Basal 1 
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/'; % Mouse 509 - Basal 2
% ------------ 512 ------------
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170202/ProjectEmbReact_M512_20170202_BaselineSleep/'; % Mouse 512 - Basal 1 
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170204/ProjectEmbReact_M512_20170204_BaselineSleep/'; % Mouse 512 - Basal 2


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


%% LOOP OVE
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p filename
    
    %% params
    mua_binsize = 10;
    
    
    %% LFP
    channels_number = GetDifferentLocationStructure('PFCx');
    for ch=1:length(channels_number)
        %Load data
        load(['LFPData/LFP' num2str(channels_number(ch))], 'LFP')
        lfp_signals{ch} = [Range(LFP)/10 Data(LFP)]; %time in ms
        name_channels{ch} = ['PFCx_' num2str(ch)];
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
    mua = [Range(MUA)/10 full(Data(MUA))]; %time in ms
    
    %% Substages
    load('SleepSubstages.mat', 'Epoch', 'NameEpoch')
    NamesSubstages = NameEpoch(1:6);
    Substages = Epoch(1:6); %N1,N2,N3,REM and Wake
    for s=1:length(Substages)
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
    try
        load('Ripples.mat', 'Ripples')
        Ripples = Ripples * 1e3; % in ms
    end
    
    %% write in h5
    hdf5write(filename, ['/' Dir.name{p} '/' Dir.date{p} '/infos/channels_number'], channels_number, 'WriteMode','append');
    hdf5write(filename, ['/' Dir.name{p} '/' Dir.date{p} '/infos/channels_name'], name_channels, 'WriteMode','append');
    
    for ch=1:length(name_channels)
        hdf5write(filename, ['/' Dir.name{p} '/' Dir.date{p} '/lfp/' name_channels{ch}], lfp_signals{ch}, 'WriteMode','append');
    end
    
    hdf5write(filename, ['/' Dir.name{p} '/' Dir.date{p} '/MUA/PFCx'], mua, 'WriteMode','append');
    
    for s=1:6
        hdf5write(filename, ['/' Dir.name{p} '/' Dir.date{p} '/SleepStages/' NamesSubstages{s}], substages_time{s}, 'WriteMode','append');
    end
    
    hdf5write(filename, ['/' Dir.name{p} '/' Dir.date{p} '/Event/downstates'], down_states, 'WriteMode','append');
    hdf5write(filename, ['/' Dir.name{p} '/' Dir.date{p} '/Event/deltawaves'], delta_waves, 'WriteMode','append');
    if exist('Ripples','var')
        hdf5write(filename, ['/' Dir.name{p} '/' Dir.date{p} '/Event/ripples'], Ripples, 'WriteMode','append');
    end
    
end



