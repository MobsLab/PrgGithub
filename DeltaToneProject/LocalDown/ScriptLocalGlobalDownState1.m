%%ScriptLocalGlobalDownState1
% 06.09.2019 KJ
%
% Infos
%   script local slow waves
%
% see
%




%% load

clear
Dir = PathForExperimentsFakeSlowWave;


for p=6
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    binsize_mua = 5*10; %5ms
    minDurationDown = 75;
    windowsize_density = 60e4; %60s  
    binsize_cc = 5; %5ms
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
    
    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')
    
    %NREM
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
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
    GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown = and(GlobalDown,NREM);
    st_down = Start(GlobalDown);
    
    %% global down homeostasis
    [~, ~, Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',1, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    homeo.down.global.x_intervals = Hstat.x_intervals;
    homeo.down.global.y_density   = Hstat.y_density;
    homeo.down.global.x_peaks  = Hstat.x_peaks;
    homeo.down.global.y_peaks  = Hstat.y_peaks;
    homeo.down.global.p1   = Hstat.p1;
    homeo.down.global.reg1 = Hstat.reg1; 
    
    
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
        OtherDelta{tt} = subset(deltawaves{tt}, setdiff(1:length(st_deltawaves{tt}),intervals)');
        st_other_delta{tt}  = st_deltawaves{tt}(setdiff(1:length(st_deltawaves{tt}),intervals)'); %no global down states
        other_deltacenter{tt}  = center_deltawaves{tt}(setdiff(1:length(st_deltawaves{tt}),intervals)'); %center
        
        
        %% local down states
        local_neurons{tt} = NeuronTetrodes{tt};
        %MUA & down
        MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
        MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
        AllDown_local{tt} = FindDownKJ(MUA_local{tt}, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        AllDown_local{tt} = and(AllDown_local{tt},NREM);
        
        %distinguish local and global
        intv = [Start(AllDown_local{tt})-2*binsize_mua*10 End(AllDown_local{tt} )];
        [~,intervals,~] = InIntervals(st_down, intv);
        intervals(intervals==0)=[];
        intervals = setdiff(1:length(Start(AllDown_local{tt})), unique(intervals));
        Down_local{tt} = subset(AllDown_local{tt}, intervals);
        st_localdown{tt} = Start(Down_local{tt});
        center_localdown{tt} = (Start(Down_local{tt}) + End(Down_local{tt})) /2;
        
        
        %% Local delta
        intv = [other_deltacenter{tt}-1500 other_deltacenter{tt}+1000];
        [~,intervals,~] = InIntervals(center_localdown{tt}, intv);
        intervals(intervals==0)=[];
        intervals = unique(intervals);
        LocalDeltaDown{tt} = subset(OtherDelta{tt}, intervals);
        local_delta{tt} = st_other_delta{tt}(intervals);
        fake_delta{tt}  = st_other_delta{tt}(setdiff(1:length(st_other_delta{tt}),intervals)');
    
    
        %% homeostasis
        
        %all local
        [~, ~, Hstat] = DensityOccupation_KJ(AllDown_local{tt}, 'homeostat',1, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo.down.local.x_intervals{tt} = Hstat.x_intervals;
        homeo.down.local.y_density{tt}   = Hstat.y_density;
        homeo.down.local.x_peaks{tt}  = Hstat.x_peaks;
        homeo.down.local.y_peaks{tt}  = Hstat.y_peaks;
        homeo.down.local.p1{tt}   = Hstat.p1;
        homeo.down.local.reg1{tt} = Hstat.reg1; 

        %local only
        [~, ~, Hstat] = DensityOccupation_KJ(OtherDelta{tt}, 'homeostat',1, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo.delta.local.x_intervals{tt} = Hstat.x_intervals;
        homeo.delta.local.y_density{tt}   = Hstat.y_density;
        homeo.delta.local.x_peaks{tt}  = Hstat.x_peaks;
        homeo.delta.local.y_peaks{tt}  = Hstat.y_peaks;
        homeo.delta.local.p1{tt}   = Hstat.p1;
        homeo.delta.local.reg1{tt} = Hstat.reg1; 
        
        %local delta+down
        [~, ~, Hstat] = DensityOccupation_KJ(LocalDeltaDown{tt}, 'homeostat',1, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo.both.local.x_intervals{tt} = Hstat.x_intervals;
        homeo.both.local.y_density{tt}   = Hstat.y_density;
        homeo.both.local.x_peaks{tt}  = Hstat.x_peaks;
        homeo.both.local.y_peaks{tt}  = Hstat.y_peaks;
        homeo.both.local.p1{tt}   = Hstat.p1;
        homeo.both.local.reg1{tt} = Hstat.reg1; 
        
    end
    
    %union of all down
    UnionAllDown = AllDown_local{1};
    for tt=2:nb_tetrodes
        UnionAllDown = or(UnionAllDown,AllDown_local{tt});
    end
    [~, ~, Hstat] = DensityOccupation_KJ(UnionAllDown, 'homeostat',1, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    homeo.down.union.x_intervals = Hstat.x_intervals;
    homeo.down.union.y_density   = Hstat.y_density;
    homeo.down.union.x_peaks  = Hstat.x_peaks;
    homeo.down.union.y_peaks  = Hstat.y_peaks;
    homeo.down.union.p1   = Hstat.p1;
    homeo.down.union.reg1 = Hstat.reg1; 
        
    %% evolution
    
    %union and global
    ratioh.union.x_intervals = homeo.down.union.x_intervals;
    ratioh.union.y_density   = homeo.down.global.y_density ./ homeo.down.union.y_density;
    
    for tt=1:nb_tetrodes
        %all local and global
        ratioh.down.x_intervals{tt} = homeo.down.global.x_intervals;
        ratioh.down.y_density{tt}   = homeo.down.global.y_density ./ homeo.down.local.y_density{tt};
        
        %other delta and global
        ratioh.delta.x_intervals{tt} = homeo.down.global.x_intervals;
        ratioh.delta.y_density{tt}   = homeo.down.global.y_density ./ homeo.delta.local.y_density{tt};
        
        %real local delta and global
        ratioh.both.x_intervals{tt} = homeo.down.global.x_intervals;
        ratioh.both.y_density{tt}   = homeo.down.global.y_density ./ homeo.both.local.y_density{tt};
        
    end


        
    
    
    
    %% Plot
    
    for tt=1:nb_tetrodes
    
        figure, hold on

        %global down states
        subplot(2,4,1), hold on
        hold on, plot(homeo.down.global.x_intervals, homeo.down.global.y_density,'b')
        hold on, plot(homeo.down.global.x_intervals, homeo.down.global.reg1,'k.')
        hold on, scatter(homeo.down.global.x_peaks, homeo.down.global.y_peaks,'r')
        title(['Global down states (p= ' num2str(homeo.down.global.p1) ')']);

        %local down states
        subplot(2,4,2), hold on
        hold on, plot(homeo.down.local.x_intervals{tt}, homeo.down.local.y_density{tt},'b')
        hold on, plot(homeo.down.local.x_intervals{tt}, homeo.down.local.reg1{tt},'k.')
        hold on, scatter(homeo.down.local.x_peaks{tt}, homeo.down.local.y_peaks{tt},'r')
        title(['All local down states (p= ' num2str(homeo.down.local.p1{tt}) ')']);
        
        %local delta waves
        subplot(2,4,3), hold on
        hold on, plot(homeo.delta.local.x_intervals{tt}, homeo.delta.local.y_density{tt},'b')
        hold on, plot(homeo.delta.local.x_intervals{tt}, homeo.delta.local.reg1{tt},'k.')
        hold on, scatter(homeo.delta.local.x_peaks{tt}, homeo.delta.local.y_peaks{tt},'r')
        title(['Local delta waves (p= ' num2str(homeo.delta.local.p1{tt}) ')']);
        
        %local delta-down
        subplot(2,4,4), hold on
        hold on, plot(homeo.both.local.x_intervals{tt}, homeo.both.local.y_density{tt},'b')
        hold on, plot(homeo.both.local.x_intervals{tt}, homeo.both.local.reg1{tt},'k.')
        hold on, scatter(homeo.both.local.x_peaks{tt}, homeo.both.local.y_peaks{tt},'r')
        title(['Local delta-down (p= ' num2str(homeo.both.local.p1{tt}) ')']);
        
        
        % ratio intersection/union
        subplot(2,4,5), hold on
        hold on, plot(ratioh.union.x_intervals, ratioh.union.y_density,'b')
        
        % ratio intersection/union
        subplot(2,4,6), hold on
        hold on, plot(ratioh.down.x_intervals{tt}, ratioh.down.y_density{tt},'b')
        
        % ratio intersection/union
        subplot(2,4,7), hold on
        hold on, plot(ratioh.delta.x_intervals{tt}, ratioh.delta.y_density{tt},'b')
        
        % ratio intersection/union
        subplot(2,4,8), hold on
        hold on, plot(ratioh.both.x_intervals{tt}, ratioh.both.y_density{tt},'b')
        

%         suplabel([Dir.name{p} ' - ' Dir.date{p} '(tetrode ' num2str(tt) ' channel ' num2str(tetrodeChannels(tt))   ')'], 't');
        
    end
    
end
