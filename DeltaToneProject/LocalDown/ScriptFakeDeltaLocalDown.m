%%ScriptFakeDeltaLocalDown
% 06.09.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%




%% load

clear
Dir = PathForExperimentsFakeSlowWave;


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    binsize_mua = 5*10;
    minDurationDown = 75;
    t_before = -0.5e4;
    t_after = 0.5e4;
    binsize_met = 10;
    nbBins_met  = 160;
    binsize_cc = 10; %10ms
    nb_binscc = 200;

    
    %% load
    %hemisphere
    if strcmpi(Dir.name{p},'Mouse508')
        hsp='_r';
    elseif strcmpi(Dir.name{p},'Mouse509')
        hsp='_l';
    else
        hsp='';
    end
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %PFC
    load('ChannelsToAnalyse/PFCx_locations.mat')
    channels_pfc = channels;

    %Spikes
    load('SpikeData.mat', 'S');
    load(['SpikesToAnalyse/PFCx' hsp '_Neurons.mat'])
    all_neurons = number;
    if ~isa(S,'tsdArray')
        S = tsdArray(S);
    end
    %Spike tetrode
    load('SpikesToAnalyse/PFCx_tetrodes.mat')
    nb_tetrodes = length(numbers);
    NeuronTetrodes = numbers;
    tetrodeChannelsCell = channels;
    tetrodeChannels = [];
    for tt=1:nb_tetrodes
        tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
    end
    
    
    %% Global downstate
    MUA = MakeQfromS(S(all_neurons), binsize_mua);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    Down = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    Down = and(Down,NREM);
    st_down = Start(Down);
    
    
    %% single channel delta waves 
    for tt=1:nb_tetrodes
        %load
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(tetrodeChannels(tt))])
        eval(['a = delta_ch_' num2str(tetrodeChannels(tt)) ';'])
        deltawaves{tt} = a;
        st_deltawaves{tt} = Start(deltawaves{tt});
        center_deltawaves{tt} = (Start(deltawaves{tt}) + End(deltawaves{tt})) /2;
        
        %down and other
        intv = [st_deltawaves{tt}-500 st_deltawaves{tt}+1500];
        [~,intervals,~] = InIntervals(st_down, intv);
        intervals(intervals==0)=[];
        intervals = unique(intervals);
        global_delta{tt} = st_deltawaves{tt}(intervals); %with a global down states
        other_delta{tt}  = st_deltawaves{tt}(setdiff(1:length(st_deltawaves{tt}),intervals)'); %no global down states
        other_deltacenter{tt}  = center_deltawaves{tt}(setdiff(1:length(st_deltawaves{tt}),intervals)'); %center
        
        
        %% local down states
        local_neurons{tt} = NeuronTetrodes{tt};
        %MUA & down
        MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
        MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
        Down_local{tt} = FindDownKJ(MUA_local{tt}, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        Down_local{tt} = and(Down_local{tt},NREM);
        
        %distinguish local and global
        intv = [Start(Down_local{tt})-2*binsize_mua*10 End(Down_local{tt} )];
        [~,intervals,~] = InIntervals(st_down, intv);
        intervals(intervals==0)=[];
        intervals = setdiff(1:length(Start(Down_local{tt})), unique(intervals));
        Down_local{tt} = subset(Down_local{tt}, intervals);
        st_localdown{tt} = Start(Down_local{tt});
        center_localdown{tt} = (Start(Down_local{tt}) + End(Down_local{tt})) /2;
        
        
        %% Local delta
        intv = [other_deltacenter{tt}-1500 other_deltacenter{tt}+1000];
        [~,intervals,~] = InIntervals(center_localdown{tt}, intv);
        intervals(intervals==0)=[];
        intervals = unique(intervals);
        local_delta{tt} = other_delta{tt}(intervals);
        fake_delta{tt}  = other_delta{tt}(setdiff(1:length(other_delta{tt}),intervals)');


        %% correlogram
        [crosscorr.y{tt}, crosscorr.x{tt}] = CrossCorr(other_deltacenter{tt}, center_localdown{tt}, binsize_cc, nb_binscc);

        %% mean curves
        [m,~,tps] = mETAverage(other_delta{tt}, Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
        met_mua{tt}(:,1) = tps; met_mua{tt}(:,2) = m;

        %% raster
        raster_locat{tt} = RasterMatrixKJ(MUA_local{tt}, ts(other_delta{tt}), t_before, t_after);


        %% quantif
        ratio.global(tt) = length(global_delta{tt})/length(st_deltawaves{tt});
        ratio.local(tt)  = length(local_delta{tt})/length(st_deltawaves{tt});
        ratio.fake(tt)   = length(fake_delta{tt})/length(st_deltawaves{tt});
        

        %% homeostasie
    
    
    end
    
    
    %% Plot
    figure, hold on
    
    for tt=1:nb_tetrodes
        
        %raster
        subplot(nb_tetrodes,3,1+3*(tt-1)), hold on

        %Mat sorted 
        Mat = Data(raster_locat{tt})';
        x_tmp = Range(raster_locat{tt});
        vmean = mean(Mat(:,x_tmp>0&x_tmp<0.1e4),2);
        [~, idxMat] = sort(vmean);
        Mat = Mat(idxMat,:);

        imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
        axis xy, hold on
        line([0 0], ylim,'Linewidth',2,'color','k'), hold on
        set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-0.5 0.5]);
        xlabel('time from delta waves detected on deep (ms)'), title('MUA tetrode')
        ylabel('# deltas detected on deep with no down'),
        
        c = caxis;
        c(2) = c(2)+1;
        caxis(c);
        
        %mean MUA
        subplot(nb_tetrodes,3,2+3*(tt-1)), hold on
        plot(met_mua{tt}(:,1), met_mua{tt}(:,2), 'color','k', 'linewidth',2);
        ylimax = get(gca,'ylim'); ylimax(1)=0; ylim(ylimax);
        xlim([-500 500]),
        line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
        xlabel('time from delta waves (ms)'), ylabel('mean MUA amplitude')
        
        
        %Cross-corr
        smoothing = 0;
        subplot(nb_tetrodes,3,3+3*(tt-1)), hold on
        hold on, h(1)=plot(crosscorr.x{tt}, Smooth(crosscorr.y{tt},smoothing), 'color','k', 'linewidth',2);
        xlim([-500 500]),
        line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
        xlabel('time from delta (ms)'), ylabel('down frequency')
    
    end
    
    %save figure
    filename_fig = ['FigureScriptFakeDeltaLocalDown_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    folderfig = fullfile(FolderFigureDelta,'LabMeeting','20190909','FigureLocalDeltaDown');
    filename_png = fullfile(folderfig,filename_png);
    saveas(gcf,filename_png,'png')
    close all
    
    
    
end
