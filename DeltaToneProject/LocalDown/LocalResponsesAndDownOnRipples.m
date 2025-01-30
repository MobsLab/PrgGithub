%%LocalResponsesAndDownOnRipples
% 09.09.2019 KJ
%
% Infos
%   
%
% see
%     OccurenceRipplesFakeDeltaDeep
%    



Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)

    clearvars -except Dir p crosscorr_res
    
    crosscorr_res.path{p}   = Dir.path{p};
    crosscorr_res.manipe{p} = Dir.manipe{p};
    crosscorr_res.name{p}   = Dir.name{p};
    crosscorr_res.date{p}   = Dir.date{p};
    crosscorr_res.hemisphere{p}   = Dir.hemisphere{p};
    crosscorr_res.tetrodes{p} = Dir.tetrodes{p};

    %params
    binsize_mua = 10;
    binsize_cc = 10; %10ms
    binsize_met       = 5; %for mETAverage  
    nbBins_met        = 240; %for mETAverage 
    nb_binscc = 200;
    minDurationDown = 75;
    maxDurationDown = 800; %800ms

    %NREM
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);
    
    %PFC
    load('ChannelsToAnalyse/PFCx_locations.mat')
    channels_pfc = channels;

    %Ripples  
    [tRipples, ~] = GetRipples;

    %Spikes
    load('SpikeData.mat', 'S');
    if ~isempty(Dir.hemisphere{p})
        load(['SpikesToAnalyse/PFCx_' Dir.hemisphere{p} '_Neurons.mat'])
    else
        load('SpikesToAnalyse/PFCx_Neurons.mat')
    end
    all_neurons = number; clear number
    if ~isa(S,'tsdArray')
        S = tsdArray(S);
    end
    
    load('NeuronClassification.mat', 'UnitID')
    
    %Spike tetrode
    load('SpikesToAnalyse/PFCx_tetrodes.mat')
    NeuronTetrodes = numbers;
    tetrodeChannelsCell = channels;
    tetrodeChannels = [];
    for tt=1:length(tetrodeChannelsCell)
        tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
    end
    %only good tetrodes
    tetrodeChannels =  tetrodeChannels(Dir.tetrodes{p});
    NeuronTetrodes =  NeuronTetrodes(Dir.tetrodes{p});
    tetrodeChannelsCell =  tetrodeChannelsCell(Dir.tetrodes{p});
    nb_tetrodes = length(Dir.tetrodes{p});
    crosscorr_res.nb_tetrodes{p} = nb_tetrodes;


    %% downstates
    %global
    MUA = MakeQfromS(S(all_neurons), binsize_mua);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown = and(GlobalDown,NREM);
    
    
    %% Ripples inducing global down
    ripples_tmp = Range(tRipples);
    intvRip = [ripples_tmp ripples_tmp+500];
    [~,intervals,~] = InIntervals(Start(GlobalDown), intvRip);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_Global = ripples_tmp(intervals);
    ripples_NoGlobal = ripples_tmp(setdiff(1:length(ripples_tmp),intervals)');
    
    
    %tetrodes
    for tt=1:nb_tetrodes
        
        %% local down states
        local_neurons{tt} = NeuronTetrodes{tt};
        %MUA & down
        MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
        MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
        AllDown_local{tt} = FindDownKJ(MUA_local{tt}, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        AllDown_local{tt} = and(AllDown_local{tt},NREM);
        
        %distinguish local and global
        [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(AllDown_local{tt}, GlobalDown);
        LocalDown{tt} = subset(AllDown_local{tt}, setdiff(1:length(Start(AllDown_local{tt})), idAlocal)');

        %% LFP
        load(['LFPData/LFP' num2str(tetrodeChannels(tt)) '.mat'])
        
        %% Ripples inducing local down
        [~,intervals,~] = InIntervals(Start(LocalDown{tt}), intvRip);
        intervals(intervals==0)=[];
        intervals = unique(intervals);
        ripples_Local{tt} = ripples_tmp(intervals);
        ripples_NoLocal{tt} = ripples_tmp(setdiff(1:length(ripples_tmp),intervals)');

    end
    
    
    %% Plot    
    figure, hold on

    % all ripples
    subplot(2+nb_tetrodes,nb_tetrodes+1,1), hold on
    [y_met,~,x_met] = mETAverage(Range(tRipples), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    y_met = y_met/mean(y_met(1:50));
    plot(x_met,y_met,'k','linewidth',2),
    ylim([0 1.5])
    for tt=1:nb_tetrodes
        subplot(2+nb_tetrodes,nb_tetrodes+1,1+tt), hold on
        [y_met,~,x_met] = mETAverage(Range(tRipples), Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
        y_met = y_met/mean(y_met(1:50));
        plot(x_met,y_met,'k','linewidth',2),
        ylim([0 1.5])
    end
    
    
    %titles
    subplot(2+nb_tetrodes,nb_tetrodes+1,1), hold on
    title(Dir.name{p})
    subplot(2+nb_tetrodes,nb_tetrodes+1,2), hold on
    title(Dir.date{p})
    
    
    % ripples global down
    subplot(2+nb_tetrodes,nb_tetrodes+1,nb_tetrodes+2), hold on
    [y_met1,~,x_met] = mETAverage(ripples_Global, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    [y_met2,~,x_met] = mETAverage(ripples_NoGlobal, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    normf = mean(y_met1(1:50));
    y_met1 = y_met1/normf;
    y_met2 = y_met2/normf;
    plot(x_met,y_met1,'k','linewidth',2),
    plot(x_met,y_met2,'r','linewidth',2),
    % ylim([0 1.5])

    for tt=1:nb_tetrodes
        subplot(2+nb_tetrodes,nb_tetrodes+1,nb_tetrodes+2+tt), hold on
        [y_met1,~,x_met] = mETAverage(ripples_Global, Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
        [y_met2,~,x_met] = mETAverage(ripples_NoGlobal, Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
        normf = mean(y_met1(1:50));
        y_met1 = y_met1/normf;
        y_met2 = y_met2/normf;
        plot(x_met,y_met1,'k','linewidth',2),
        plot(x_met,y_met2,'r','linewidth',2),
        % ylim([0 1.5])
    end

    
    % ripples local down
    for i=1:nb_tetrodes
        subplot(2+nb_tetrodes,nb_tetrodes+1,(i+1)*(nb_tetrodes+1)+1), hold on
        [y_met1,~,x_met] = mETAverage(ripples_Local{i}, Range(MUA), Data(MUA), binsize_met, nbBins_met);
        [y_met2,~,x_met] = mETAverage(ripples_NoLocal{i}, Range(MUA), Data(MUA), binsize_met, nbBins_met);
        normf = mean(y_met1(1:50));
        y_met1 = y_met1/normf;
        y_met2 = y_met2/normf;
        plot(x_met,y_met1,'k','linewidth',2),
        plot(x_met,y_met2,'r','linewidth',2),
        % ylim([0 1.5])
        
        for tt=1:nb_tetrodes
            subplot(2+nb_tetrodes,nb_tetrodes+1,(i+1)*(nb_tetrodes+1)+tt+1), hold on
            [y_met1,~,x_met] = mETAverage(ripples_Local{i}, Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
            [y_met2,~,x_met] = mETAverage(ripples_NoLocal{i}, Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
            normf = mean(y_met1(1:50));
            y_met1 = y_met1/normf;
            y_met2 = y_met2/normf;
            plot(x_met,y_met1,'k','linewidth',2),
            plot(x_met,y_met2,'r','linewidth',2),
        % ylim([0 1.5])
        end

    end


end


