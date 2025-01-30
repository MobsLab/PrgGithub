%%ScriptTestDoubleFitHomeostasis
% 06.09.2019 KJ
%
% Infos
%   script local slow waves
%
% see
%   ScriptLocalGlobalDownState1 ParcoursHomeostasieFakeLocalDelta




%% load

clear
Dir = PathForExperimentsFakeSlowWave;


for p=[4 7 10 13 15 16]
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p homeo_res
    
    %params
    binsize_mua = 5*10; %5ms
    minDurationDown = 75;
    windowsize_density = 60e4; %60s  


    %% load

    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %PFC
    load('ChannelsToAnalyse/PFCx_locations.mat')
    channels_pfc = channels;

    %Spikes
    load('SpikeData.mat', 'S');
    load('SpikesToAnalyse/PFCx_Neurons.mat')
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
    
    
    
    %% global down homeostasis
    [~, ~, Hstat] = DensityCurves_KJ(ts(st_down), 'homeostat',2, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    down.global.x_intervals = Hstat.x_intervals;
    down.global.y_density   = Hstat.y_density;
    down.global.x_peaks  = Hstat.x_peaks;
    down.global.y_peaks  = Hstat.y_peaks;
    down.global.p1   = Hstat.p1;
    down.global.reg1 = Hstat.reg1;
    down.global.p2   = Hstat.p2;
    down.global.reg2 = Hstat.reg2;
    %correlation
    [down.global.rc, down.global.pv] = corrcoef(Hstat.x_peaks,Hstat.y_peaks);
    
    
    %% single channel delta waves 
    for tt=1:3
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
        
        %global firing rate
        fr.nrem.local{tt} = mean(Data(Restrict(MUA_local{tt},NREM)))*(1e4/binsize_mua);
        Fr_all = MakeQfromS(S(local_neurons{tt}), 60e4);
        Fr_tet.t{tt} = Range(Fr_all);
        Fr_tet.y{tt} = sum(full(Data(Fr_all)),2)/60;
        
    
        %% Local delta
        intv = [other_deltacenter{tt}-1500 other_deltacenter{tt}+1000];
        [~,intervals,~] = InIntervals(center_localdown{tt}, intv);
        intervals(intervals==0)=[];
        intervals = unique(intervals);
        local_delta{tt} = other_delta{tt}(intervals);
        fake_delta{tt}  = other_delta{tt}(setdiff(1:length(other_delta{tt}),intervals)');

        
        %% homeostasis 
        
        %local down
        [~, ~, Hstat] = DensityCurves_KJ(ts(st_localdown{tt}), 'homeostat',2, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        down.local.x_intervals{tt} = Hstat.x_intervals;
        down.local.y_density{tt}   = Hstat.y_density;
        down.local.x_peaks{tt}  = Hstat.x_peaks;
        down.local.y_peaks{tt}  = Hstat.y_peaks;
        down.local.p1{tt}   = Hstat.p1;
        down.local.reg1{tt} = Hstat.reg1;
        down.local.p2{tt}   = Hstat.p2;
        down.local.reg2{tt} = Hstat.reg2;
        %correlation
        [down.local.rc, down.local.pv] = corrcoef(Hstat.x_peaks,Hstat.y_peaks);
        
        %global delta
        [~, ~, Hstat] = DensityCurves_KJ(ts(global_delta{tt}), 'homeostat',2, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        delta.global.x_intervals{tt} = Hstat.x_intervals;
        delta.global.y_density{tt}   = Hstat.y_density;
        delta.global.x_peaks{tt}  = Hstat.x_peaks;
        delta.global.y_peaks{tt}  = Hstat.y_peaks;
        delta.global.p1{tt}   = Hstat.p1;
        delta.global.reg1{tt} = Hstat.reg1;
        delta.global.p2{tt}   = Hstat.p2;
        delta.global.reg2{tt} = Hstat.reg2;
        %correlation
        [delta.global.rc, delta.global.pv] = corrcoef(Hstat.x_peaks,Hstat.y_peaks);
        
        %local delta
        [~, ~, Hstat] = DensityCurves_KJ(ts(local_delta{tt}), 'homeostat',2, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        delta.local.x_intervals{tt} = Hstat.x_intervals;
        delta.local.y_density{tt}   = Hstat.y_density;
        delta.local.x_peaks{tt}  = Hstat.x_peaks;
        delta.local.y_peaks{tt}  = Hstat.y_peaks;
        delta.local.p1{tt}   = Hstat.p1;
        delta.local.reg1{tt} = Hstat.reg1;  
        delta.local.p2{tt}   = Hstat.p2;
        delta.local.reg2{tt} = Hstat.reg2;
        %correlation
        [delta.local.rc, delta.local.pv] = corrcoef(Hstat.x_peaks,Hstat.y_peaks);
        
        %local delta
        [~, ~, Hstat] = DensityCurves_KJ(ts(fake_delta{tt}), 'homeostat',2, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        delta.fake.x_intervals{tt} = Hstat.x_intervals;
        delta.fake.y_density{tt}   = Hstat.y_density;
        delta.fake.x_peaks{tt}  = Hstat.x_peaks;
        delta.fake.y_peaks{tt}  = Hstat.y_peaks;
        delta.fake.p1{tt}   = Hstat.p1;
        delta.fake.reg1{tt} = Hstat.reg1;  
        delta.fake.p2{tt}   = Hstat.p2;
        delta.fake.reg2{tt} = Hstat.reg2;
        %correlation
        [delta.fake.rc, delta.fake.pv] = corrcoef(Hstat.x_peaks,Hstat.y_peaks);
        
        
        %% save
        nb.neurons_tet(tt) = length(local_neurons{tt});
        nb.localdown(tt) = length(st_localdown{tt});
        
        nb.delta.all(tt)    = length(st_deltawaves{tt});
        nb.delta.global(tt) = length(global_delta{tt});
        nb.delta.local(tt)  = length(local_delta{tt});
        nb.delta.fake(tt)   = length(fake_delta{tt});
        
        
    end
    
    
     for tt=1:3
    
        limSplit = 15.5;
        idx1 =  down.global.x_intervals<limSplit;
        idx2 =  down.global.x_intervals>limSplit; 
        
        figure, hold on

        %global down states
        subplot(2,2,1), hold on
        hold on, plot(down.global.x_intervals, down.global.y_density,'b')
        hold on, plot(down.global.x_intervals(idx1), down.global.reg1(idx1),'k.')
        hold on, plot(down.global.x_intervals(idx2), down.global.reg2(idx2),'r.')
        hold on, scatter(down.global.x_peaks, down.global.y_peaks,'r')
        title(['Global down states (p= ' num2str(down.global.p1) ')']);
        
        %local down states
        subplot(2,2,2), hold on
        hold on, plot(down.local.x_intervals{tt}, down.local.y_density{tt},'b')
        hold on, plot(down.local.x_intervals{tt}(idx1), down.local.reg1{tt}(idx1),'k.')
        hold on, plot(down.local.x_intervals{tt}(idx2), down.local.reg2{tt}(idx2),'r.')
        hold on, scatter(down.local.x_peaks{tt}, down.local.y_peaks{tt},'r')
        title(['Local down states (p= ' num2str(down.local.p1{tt}) ')']);
        
        %global delta waves
        subplot(2,2,3), hold on
        hold on, plot(delta.global.x_intervals{tt}, delta.global.y_density{tt},'b')
        hold on, plot(delta.global.x_intervals{tt}(idx1), delta.global.reg1{tt}(idx1),'k.')
        hold on, plot(delta.global.x_intervals{tt}(idx2), delta.global.reg2{tt}(idx2),'r.')
        hold on, scatter(delta.global.x_peaks{tt}, delta.global.y_peaks{tt},'r')
        title(['Global delta waves (p= ' num2str(delta.global.p1{tt}) ')']);
        
        %local delta waves
        subplot(2,2,4), hold on
        hold on, plot(delta.local.x_intervals{tt}, delta.local.y_density{tt},'b')
        hold on, plot(delta.local.x_intervals{tt}(idx1), delta.local.reg1{tt}(idx1),'k.')
        hold on, plot(delta.local.x_intervals{tt}(idx2), delta.local.reg2{tt}(idx2),'r.')
        hold on, scatter(delta.local.x_peaks{tt}, delta.local.y_peaks{tt},'r')
        title(['Local delta waves (p= ' num2str(delta.local.p1{tt}) ')']);
        
        
     end
    
    
    
end
