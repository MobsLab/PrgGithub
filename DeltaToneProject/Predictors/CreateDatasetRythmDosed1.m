% CreateDatasetRythmDosed1
% 01.06.2018 KJ
%
% Create a dataset for Rythm Machine Learning project
% It contains:
%   - LFP signals from: PFCx (many layer)
%   - MUA signals from PFCx
%   - down states
%
% SEE
%   CreateDatasetRythm1 CreateDatasetRythm2 CreateDatasetRythm3
%
%



clear

%params
foldername = '/home/mobsjunior/Documents/DosedDataset/';

%% Dir

a=0;
%BASAL
% ------------ 243 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; 
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
% ------------ 244 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
% ------------ 403 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse403/Breath-Mouse-403-05122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse403/Breath-Mouse-403-09122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse403/Breath-Mouse-403-12122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse403/Breath-Mouse-403-17122016/';
%------------ 451 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';
% ------------ 508 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/'; % Mouse 508 - Basal 1 
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/'; % Mouse 508 - Basal 2
% ------------ 509 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; % Mouse 509 - Basal 1 
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/'; % Mouse 509 - Basal 2



% name, manipe, group, date 
for i=1:length(Dir.path)
    Dir.manipe{i}='Basal';
    Dir.group{i}='WT';

    %mouse name
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'/Mouse'):strfind(Dir.path{i},'/Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    Dir.name{i}(Dir.name{i}=='/')=[];
    
    %date
    ind = strfind(Dir.path{i},'/201');
    Dir.date{i} = Dir.path{i}(ind + [7 8 5 6 1:4]);

end


%% load clustering
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))
meancurves = layer_res.down.meandown2;
[~, nightX, ~, clusterX] = Clustering_Curves_KJ(meancurves, 'features','adhoc','algo_clustering','manual','nb_clusters',5);



%% LOOP
for p=10:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        cd(Dir.path{p})
        disp(pwd)

        clearvars -except Dir p foldername layer_res nightX clusterX

        %% params
        binsize_mua = 10;
        minDuration = 30;
        fs_lfp = 1250;

        %% load

        %LFP
        load('ChannelsToAnalyse/PFCx_locations.mat')
        channels_number = channels; clear channels
        for ch=1:length(channels_number)
            clear LFP
            load(['LFPData/LFP' num2str(channels_number(ch))], 'LFP')
            lfp_signals{ch} = Data(LFP); %time in ms
            name_channels{ch} = ['PFCx_' num2str(ch)];
        end

        %MUA
        MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
        mua = full(Data(MUA)); %time in ms
        fs_mua = 1 / (binsize_mua/1e3);

        %NREM
        load('SleepScoring_OBGamma.mat', 'SWSEpoch')


        %% LFP clusters
        idx_path = find(strcmpi(layer_res.path, Dir.path{p}));
        for ch=1:length(channels_number)
            idx_ch = find(layer_res.channels{idx_path}==channels_number(ch));
            cluster_channel(ch) = clusterX(ismember(nightX, [idx_path idx_ch], 'rows'));
        end


        %% Down states
        down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 700, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        down_PFCx = and(down_PFCx, SWSEpoch);

        start_down = Start(down_PFCx);
        end_down = End(down_PFCx);
        down_duration = end_down - start_down;

        %binary
        tmp_sig = Range(LFP);
        binary_down = zeros(length(lfp_signals{1}),1);
        for i=1:length(start_down)
            idx = tmp_sig>=start_down(i) & tmp_sig<=end_down(i);
            binary_down(idx) = 1;
        end


        %% Ripples
        load('Ripples.mat', 'RipplesEpoch')
        start_ripples = Start(RipplesEpoch);
        end_ripples = End(RipplesEpoch);
        ripples_duration = end_ripples - start_ripples;

        %binary
        tmp_sig = Range(LFP);
        binary_ripples = zeros(length(lfp_signals{1}),1);
        for i=1:length(start_ripples)
            idx = tmp_sig>=start_ripples(i) & tmp_sig<=end_ripples(i);
            binary_ripples(idx) = 1;
        end

        %% write in h5

        %init
        night_name = [Dir.name{p} '_' Dir.date{p}];
        filename = fullfile(foldername,night_name);

        hdf5write(filename, '/infos/animals', Dir.name{p});
        hdf5write(filename, '/infos/date', Dir.date{p}, 'WriteMode','append');

        %lfp
        for ch=1:length(name_channels)
            hdf5write(filename, ['/lfp/' name_channels{ch}], lfp_signals{ch}, 'WriteMode','append');
        end

        hdf5write(filename, '/infoLfp/fs', fs_lfp, 'WriteMode','append');
        hdf5write(filename, '/infoLfp/channels_number', channels_number, 'WriteMode','append');
        hdf5write(filename, '/infoLfp/channels_name', name_channels, 'WriteMode','append');
        hdf5write(filename, '/infoLfp/cluster_channel', cluster_channel, 'WriteMode','append');

        %mua
        hdf5write(filename, '/mua/fs', fs_mua, 'WriteMode','append');
        hdf5write(filename, '/mua/pfcx', mua, 'WriteMode','append');

        %down
        hdf5write(filename, '/downstates/start', start_down, 'WriteMode','append');
        hdf5write(filename, '/downstates/durations', down_duration, 'WriteMode','append');
        hdf5write(filename, '/downstates/binary', binary_down, 'WriteMode','append');

        %ripples
        hdf5write(filename, '/ripples/start', start_ripples, 'WriteMode','append');
        hdf5write(filename, '/ripples/durations', ripples_duration, 'WriteMode','append');
        hdf5write(filename, '/ripples/binary', binary_ripples, 'WriteMode','append');
        
    catch
        disp('error for this record')
    end
    
end









