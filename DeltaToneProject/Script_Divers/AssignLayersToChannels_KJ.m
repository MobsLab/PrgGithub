%%AssignLayersToChannels_KJ
% 31.08.2018 KJ
%
%
% see
%   LinkNeuronsToLayers_KJ
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir);

% Dir = PathForExperimentsBasalSleepSpike;

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p


%     %% load clustering
%     load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))
% 
%     excluded_signals = [];
%     excluded_nights = [];
% 
%     %feature extraction and clustering
%     meancurves = layer_res.down.meandown2;
%     nb_clusters = 5;
%     algo_clustering = 'manual';
%     method_features = 'adhoc';
% 
%     [all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
%                                         'excluded_signals',excluded_signals, 'excluded_nights',excluded_nights);


    %% LFP responses on down states
    durations2   = [100 200] * 10; 
    binsize_met  = 5; %for mETAverage  
    nbBins_met   = 240; %for mETAverage 

    %LFP channels
    try
        load('ChannelsToAnalyse/PFCx_locations.mat','channels')

    catch
        channels = GetDifferentLocationStructure('PFCx');
        save('ChannelsToAnalyse/PFCx_locations.mat','channels')
    end

    %LFP 
    Signals = cell(0); hemi_channel = cell(0);
    load(fullfile(Dir.path{p}, 'LFPData', 'InfoLFP.mat'))

    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = lower(hemi_channel{ch}(1));
        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
        Signals{ch} = LFP; clear LFP
    end

    %down
    load('DownState.mat', 'down_PFCx')
    start_down = Start(down_PFCx);
    down_durations = End(down_PFCx) - Start(down_PFCx);
    selected_down = start_down(down_durations>durations2(1) & down_durations<durations2(2));

    for ch=1:length(channels)
        [m,~,tps] = mETAverage(selected_down, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandown{ch}(:,1) = tps; meandown{ch}(:,2) = m;
    end


    %% Put new points in clusters

    clusters = [];

    %features
    for ch=1:length(channels)
        x = meandown{ch}(:,1);
        y = meandown{ch}(:,2);

        %postive deflection
        if sum(y(x>0 & x<=150))>0
            x1 = x>0 & x<=200;
            x2 = x>150 & x<=350;
            feat1 = max(y(x1));
            feat2 = min(y(x2));

        %negative deflection
        else
            x1 = x>0 & x<=250;
            x2 = x>200 & x<=350;
            feat1 = min(y(x1));
            feat2 = max(y(x2));

        end

        % x and y on 2D space
        xp = feat1;
        yp = feat2;

        % clustering
        if yp>(0.8*xp-200)
            clusters(ch) = 1;
        elseif yp<=(0.8*xp-200) && yp>(0.8*xp-900)
            clusters(ch) = 2;
        elseif yp<=(0.8*xp-900) && yp>(0.8*xp-1600)
            clusters(ch) = 3;
        elseif yp<=(0.8*xp-1600) && yp>(0.7*xp-2140)
            clusters(ch) = 4;
        elseif yp<=(0.7*xp-2140)
            clusters(ch) = 5;
        end

    end

    
    %% save layers info
    save('ChannelsToAnalyse/PFCx_clusters.mat','clusters')


end






