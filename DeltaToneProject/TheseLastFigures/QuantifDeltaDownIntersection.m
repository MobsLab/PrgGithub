%%QuantifDeltaDownIntersection
% 13.09.2019 KJ
%
%   
%
% see
%   CharacterisationDeltaDownStates
%


clear
Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p quantif_res
    
    quantif_res.path{p}   = Dir.path{p};
    quantif_res.manipe{p} = Dir.manipe{p};
    quantif_res.name{p}   = Dir.name{p};
    quantif_res.date{p}   = Dir.date{p};
    
    
    %% params
    hemisphere        = 0;
    marginsup         = 0.1e4;  
    down_durations = [75 100 125 150]*10;    

    %% load data

    % Epoch
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    
    %LFP load
    hemi_channel = cell(0);
    load('ChannelsToAnalyse/PFCx_clusters.mat','channels','clusters')
    load(fullfile(Dir.path{p}, 'LFPData', 'InfoLFP.mat'))
    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = char(lower(hemi_channel{ch}));
        hemi_channel{ch} = hemi_channel{ch}(1);
    end
    
    quantif_res.channels{p}     = channels;
    quantif_res.clusters{p}     = clusters;
    quantif_res.hemi_channel{p} = hemi_channel;
    
    %ECOG ?
    ecogs = [];
    if exist('ChannelsToAnalyse/PFCx_ecog.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog.mat','channel')
        ecogs = [ecogs channel];
    end
    if exist('ChannelsToAnalyse/PFCx_ecog_right.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog_right.mat','channel')
        ecogs = [ecogs channel];
    end
    if exist('ChannelsToAnalyse/PFCx_ecog_left.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog_left.mat','channel')
        ecogs = [ecogs channel];
    end
    quantif_res.ecogs{p} = unique(ecogs);
    
    
    %Delta detection
    for ch=1:length(channels)
        name_var = ['delta_ch_' num2str(channels(ch))];
        load('DeltaWavesChannels.mat', name_var)
        eval(['deltas = ' name_var ';'])
        %Restrict    
        deltas_chan{ch}  = and(deltas, NREM);
    end

    
    %% load events
    
    %down
    load('DownState.mat', 'down_PFCx')
        load('DownState.mat', 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        hemisphere=1;
    end
    load('DownState.mat', 'down_PFCx_l')
    if exist('down_PFCx_l','var')
        hemisphere=1;
    end
     
    %deltas
    load('DeltaWaves.mat', 'deltas_PFCx')
    if hemisphere
        load('DeltaWaves.mat', 'deltas_PFCx_r')
        load('DeltaWaves.mat', 'deltas_PFCx_l')
    end
    
    %different down duration
    for i=1:length(down_durations)
        Down{i}   = dropShortIntervals(down_PFCx, down_durations(i));
        if hemisphere
            Down_r{i} = dropShortIntervals(down_PFCx_r, down_durations(i));
            Down_l{i} = dropShortIntervals(down_PFCx_l, down_durations(i));
        end
    end
    
    
    %% Quantification intersection delta waves and down states
    for i=1:length(down_durations)
        if hemisphere %left and right
            %right                
            [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx_r, Down_r{i});
            quantif_res.multi.precision{p,i}(1) = Istat.precision;
            quantif_res.multi.recall{p,i}(1)    = Istat.recall;
            quantif_res.multi.fscore{p,i}(1)    = Istat.fscore;
            %left                
            [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx_l, Down_l{i});
            quantif_res.multi.precision{p,i}(2) = Istat.precision;
            quantif_res.multi.recall{p,i}(2)    = Istat.recall;
            quantif_res.multi.fscore{p,i}(2)    = Istat.fscore;

            for ch=1:length(quantif_res.channels{p})
                if strcmpi(hemi_channel{ch},'r')
                    down_PFCx_h = Down_r{i};
                elseif strcmpi(hemi_channel{ch},'l')
                    down_PFCx_h = Down_l{i};
                end

                if clusters(ch)==1
                    larger_deltas = intervalSet(Start(deltas_chan{ch})-marginsup,End(deltas_chan{ch}));
                    [~,~,Istat] = GetIntersectionsEpochs(larger_deltas, down_PFCx_h);
                else
                    [~,~,Istat] = GetIntersectionsEpochs(deltas_chan{ch}, down_PFCx_h);
                end
                quantif_res.single.precision{p,i}(ch) = Istat.precision;
                quantif_res.single.recall{p,i}(ch)    = Istat.recall;
                quantif_res.single.fscore{p,i}(ch)    = Istat.fscore;
            end

        else
            [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx, Down{i});
            quantif_res.multi.precision{p,i} = Istat.precision;
            quantif_res.multi.recall{p,i}    = Istat.recall;
            quantif_res.multi.fscore{p,i}    = Istat.fscore;

            for ch=1:length(quantif_res.channels{p})
                if clusters(ch)==1
                    larger_deltas = intervalSet(Start(deltas_chan{ch})-marginsup,End(deltas_chan{ch}));
                    [~,~,Istat] = GetIntersectionsEpochs(larger_deltas, Down{i});
                else
                    [~,~,Istat] = GetIntersectionsEpochs(deltas_chan{ch}, Down{i});
                end
                quantif_res.single.precision{p,i}(ch) = Istat.precision;
                quantif_res.single.recall{p,i}(ch)    = Istat.recall;
                quantif_res.single.fscore{p,i}(ch)    = Istat.fscore;
            end
        end
    
    end
    
end


%saving data
cd(FolderDeltaDataKJ)
save QuantifDeltaDownIntersection.mat quantif_res down_durations




