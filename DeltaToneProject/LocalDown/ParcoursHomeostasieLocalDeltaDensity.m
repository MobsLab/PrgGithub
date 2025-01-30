%%ParcoursHomeostasieLocalDeltaDensity
% 06.09.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%  ParcoursHomeostasieLocalDeltaOccupancy




%% load

clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p homeo_res
    
    homeo_res.path{p}   = Dir.path{p};
    homeo_res.manipe{p} = Dir.manipe{p};
    homeo_res.name{p}   = Dir.name{p};
    homeo_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 5*10; %5ms
    minDurationDown = 75;
    maxDurationDown = 800; %800ms
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
    if ~isempty(Dir.hemisphere{p})
        load(['SpikesToAnalyse/PFCx_' Dir.hemisphere{p} '_Neurons.mat'])
    else
        load('SpikesToAnalyse/PFCx_Neurons.mat')
    end
    all_neurons = number;
    if ~isa(S,'tsdArray')
        S = tsdArray(S);
    end
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
    
    
    %% Global downstate
    MUA = MakeQfromS(S(all_neurons), binsize_mua);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown = and(GlobalDown,NREM);
    
    %save
    homeo_res.nb.down{p} = length(Start(GlobalDown));
    homeo_res.nb.tetrodes{p} = nb_tetrodes;
    homeo_res.nb.allneurons{p} = length(all_neurons);
    
    
    %% global down homeostasis
    [~, ~, Hstat] = DensityCurves_KJ(ts(Start(GlobalDown)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    homeo_res.down.global.x_intervals{p} = Hstat.x_intervals;
    homeo_res.down.global.y_density{p}   = Hstat.y_density;
    homeo_res.down.global.x_peaks{p}  = Hstat.x_peaks;
    homeo_res.down.global.y_peaks{p}  = Hstat.y_peaks;
    homeo_res.down.global.p0{p}   = Hstat.p0;
    homeo_res.down.global.reg0{p} = Hstat.reg0;
    homeo_res.down.global.p1{p}   = Hstat.p1;
    homeo_res.down.global.reg1{p} = Hstat.reg1; 
    homeo_res.down.global.p2{p}   = Hstat.p2;
    homeo_res.down.global.reg2{p} = Hstat.reg2; 
    homeo_res.down.global.exp_a{p} = Hstat.exp_a; 
    homeo_res.down.global.exp_b{p} = Hstat.exp_b;
    %correlation
    homeo_res.down.global.pv0{p}  = Hstat.pv0;
    homeo_res.down.global.R2_0{p} = Hstat.R2_0;
    homeo_res.down.global.pv1{p}  = Hstat.pv1;
    homeo_res.down.global.R2_1{p} = Hstat.R2_1;
    homeo_res.down.global.pv2{p}  = Hstat.pv2;
    homeo_res.down.global.R2_2{p} = Hstat.R2_2;
    homeo_res.down.global.exp_R2{p} = Hstat.exp_R2; 
    
    %global firing rate
    homeo_res.fr.nrem.all{p} = mean(Data(Restrict(MUA,NREM)))*(1e4/binsize_mua);
    Fr_all = MakeQfromS(S(all_neurons), 60e4);
    homeo_res.Fr_all.t{p} = Range(Fr_all);
    homeo_res.Fr_all.y{p} = sum(full(Data(Fr_all)),2)/60;
    
    
    %% single channel delta waves 
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
        st_localdown{tt} = Start(LocalDown{tt});
        center_localdown{tt} = (Start(LocalDown{tt}) + End(LocalDown{tt})) /2;
        
        %global firing rate
        homeo_res.fr.nrem.local{p,tt} = mean(Data(Restrict(MUA_local{tt},NREM)))*(1e4/binsize_mua);
        Fr_all = MakeQfromS(S(local_neurons{tt}), 60e4);
        homeo_res.Fr_tet.t{p,tt} = Range(Fr_all);
        homeo_res.Fr_tet.y{p,tt} = sum(full(Data(Fr_all)),2)/60;
        
        
        %% delta waves of channel (signle channel detection)
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(tetrodeChannels(tt))])
        eval(['a = delta_ch_' num2str(tetrodeChannels(tt)) ';'])
        DeltaWavesTT{tt} = a;
        
        %global delta and other delta
        [GlobalDelta{tt}, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesTT{tt}, GlobalDown);
        OtherDelta{tt} = subset(DeltaWavesTT{tt}, setdiff(1:length(Start(DeltaWavesTT{tt})),idGlobDelta)');
        
        %Local delta and fake delta
        [LocalDelta{tt}, ~, ~,idLocDelta,~] = GetIntersectionsEpochs(OtherDelta{tt}, LocalDown{tt});
        FakeDelta{tt} = subset(OtherDelta{tt}, setdiff(1:length(Start(OtherDelta{tt})),idLocDelta)');
        
        
        %% homeostasis 
        
        %all local down
        [~, ~, Hstat] = DensityCurves_KJ(ts(Start(AllDown_local{tt})), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.down.all_local.x_intervals{p,tt} = Hstat.x_intervals;
        homeo_res.down.all_local.y_density{p,tt}   = Hstat.y_density;
        homeo_res.down.all_local.x_peaks{p,tt}  = Hstat.x_peaks;
        homeo_res.down.all_local.y_peaks{p,tt}  = Hstat.y_peaks;
        homeo_res.down.all_local.p0{p,tt}   = Hstat.p0;
        homeo_res.down.all_local.reg0{p,tt} = Hstat.reg0;
        homeo_res.down.all_local.p1{p,tt}   = Hstat.p1;
        homeo_res.down.all_local.reg1{p,tt} = Hstat.reg1;
        homeo_res.down.all_local.p2{p,tt}   = Hstat.p2;
        homeo_res.down.all_local.reg2{p,tt} = Hstat.reg2;
        homeo_res.down.all_local.exp_a{p,tt} = Hstat.exp_a; 
        homeo_res.down.all_local.exp_b{p,tt} = Hstat.exp_b;
        %correlation
        homeo_res.down.all_local.pv0{p,tt}  = Hstat.pv0;
        homeo_res.down.all_local.R2_0{p,tt} = Hstat.R2_0;
        homeo_res.down.all_local.pv1{p,tt}  = Hstat.pv1;
        homeo_res.down.all_local.R2_1{p,tt} = Hstat.R2_1;
        homeo_res.down.all_local.pv2{p,tt}  = Hstat.pv2;
        homeo_res.down.all_local.R2_2{p,tt} = Hstat.R2_2;
        homeo_res.down.all_local.exp_R2{p,tt} = Hstat.exp_R2; 
        
        
        %local down
        [~, ~, Hstat] = DensityCurves_KJ(ts(Start(LocalDown{tt})), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.down.local.x_intervals{p,tt} = Hstat.x_intervals;
        homeo_res.down.local.y_density{p,tt}   = Hstat.y_density;
        homeo_res.down.local.x_peaks{p,tt}  = Hstat.x_peaks;
        homeo_res.down.local.y_peaks{p,tt}  = Hstat.y_peaks;
        homeo_res.down.local.p0{p,tt}   = Hstat.p0;
        homeo_res.down.local.reg0{p,tt} = Hstat.reg0;
        homeo_res.down.local.p1{p,tt}   = Hstat.p1;
        homeo_res.down.local.reg1{p,tt} = Hstat.reg1;
        homeo_res.down.local.p2{p,tt}   = Hstat.p2;
        homeo_res.down.local.reg2{p,tt} = Hstat.reg2;
        homeo_res.down.local.exp_a{p,tt} = Hstat.exp_a; 
        homeo_res.down.local.exp_b{p,tt} = Hstat.exp_b;
        %correlation
        homeo_res.down.local.pv0{p,tt}  = Hstat.pv0;
        homeo_res.down.local.R2_0{p,tt} = Hstat.R2_0;
        homeo_res.down.local.pv1{p,tt}  = Hstat.pv1;
        homeo_res.down.local.R2_1{p,tt} = Hstat.R2_1;
        homeo_res.down.local.pv2{p,tt}  = Hstat.pv2;
        homeo_res.down.local.R2_2{p,tt} = Hstat.R2_2;
        homeo_res.down.local.exp_R2{p,tt} = Hstat.exp_R2; 
        
        
        %global delta
        [~, ~, Hstat] = DensityCurves_KJ(ts(Start(GlobalDelta{tt})), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.delta.global.x_intervals{p,tt} = Hstat.x_intervals;
        homeo_res.delta.global.y_density{p,tt}   = Hstat.y_density;
        homeo_res.delta.global.x_peaks{p,tt}  = Hstat.x_peaks;
        homeo_res.delta.global.y_peaks{p,tt}  = Hstat.y_peaks;
        homeo_res.delta.global.p0{p,tt}   = Hstat.p0;
        homeo_res.delta.global.reg0{p,tt} = Hstat.reg0;
        homeo_res.delta.global.p1{p,tt}   = Hstat.p1;
        homeo_res.delta.global.reg1{p,tt} = Hstat.reg1;
        homeo_res.delta.global.p2{p,tt}   = Hstat.p2;
        homeo_res.delta.global.reg2{p,tt} = Hstat.reg2;
        homeo_res.delta.global.exp_a{p,tt} = Hstat.exp_a; 
        homeo_res.delta.global.exp_b{p,tt} = Hstat.exp_b;
        %correlation
        homeo_res.delta.global.pv0{p,tt}  = Hstat.pv0;
        homeo_res.delta.global.R2_0{p,tt} = Hstat.R2_0;
        homeo_res.delta.global.pv1{p,tt}  = Hstat.pv1;
        homeo_res.delta.global.R2_1{p,tt} = Hstat.R2_1;
        homeo_res.delta.global.pv2{p,tt}  = Hstat.pv2;
        homeo_res.delta.global.R2_2{p,tt} = Hstat.R2_2;
        homeo_res.delta.global.exp_R2{p,tt} = Hstat.exp_R2;
        
        
        %local delta
        [~, ~, Hstat] = DensityCurves_KJ(ts(Start(LocalDelta{tt})), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.delta.local.x_intervals{p,tt} = Hstat.x_intervals;
        homeo_res.delta.local.y_density{p,tt}   = Hstat.y_density;
        homeo_res.delta.local.x_peaks{p,tt}  = Hstat.x_peaks;
        homeo_res.delta.local.y_peaks{p,tt}  = Hstat.y_peaks;
        homeo_res.delta.local.p0{p,tt}   = Hstat.p0;
        homeo_res.delta.local.reg0{p,tt} = Hstat.reg0;  
        homeo_res.delta.local.p1{p,tt}   = Hstat.p1;
        homeo_res.delta.local.reg1{p,tt} = Hstat.reg1;  
        homeo_res.delta.local.p2{p,tt}   = Hstat.p2;
        homeo_res.delta.local.reg2{p,tt} = Hstat.reg2;
        homeo_res.delta.local.exp_a{p,tt} = Hstat.exp_a; 
        homeo_res.delta.local.exp_b{p,tt} = Hstat.exp_b;
        %correlation
        homeo_res.delta.local.pv0{p,tt}  = Hstat.pv0;
        homeo_res.delta.local.R2_0{p,tt} = Hstat.R2_0;
        homeo_res.delta.local.pv1{p,tt}  = Hstat.pv1;
        homeo_res.delta.local.R2_1{p,tt} = Hstat.R2_1;
        homeo_res.delta.local.pv2{p,tt}  = Hstat.pv2;
        homeo_res.delta.local.R2_2{p,tt} = Hstat.R2_2;
        homeo_res.delta.local.exp_R2{p,tt} = Hstat.exp_R2;
        
        
        %local delta
        [~, ~, Hstat] = DensityCurves_KJ(ts(Start(FakeDelta{tt})), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.delta.fake.x_intervals{p,tt} = Hstat.x_intervals;
        homeo_res.delta.fake.y_density{p,tt}   = Hstat.y_density;
        homeo_res.delta.fake.x_peaks{p,tt}  = Hstat.x_peaks;
        homeo_res.delta.fake.y_peaks{p,tt}  = Hstat.y_peaks;
        homeo_res.delta.fake.p0{p,tt}   = Hstat.p0;
        homeo_res.delta.fake.reg0{p,tt} = Hstat.reg0;
        homeo_res.delta.fake.p1{p,tt}   = Hstat.p1;
        homeo_res.delta.fake.reg1{p,tt} = Hstat.reg1;  
        homeo_res.delta.fake.p2{p,tt}   = Hstat.p2;
        homeo_res.delta.fake.reg2{p,tt} = Hstat.reg2;
        homeo_res.delta.fake.exp_a{p,tt} = Hstat.exp_a; 
        homeo_res.delta.fake.exp_b{p,tt} = Hstat.exp_b;
        %correlation
        homeo_res.delta.fake.pv0{p,tt}  = Hstat.pv0;
        homeo_res.delta.fake.R2_0{p,tt} = Hstat.R2_0;
        homeo_res.delta.fake.pv1{p,tt}  = Hstat.pv1;
        homeo_res.delta.fake.R2_1{p,tt} = Hstat.R2_1;
        homeo_res.delta.fake.pv2{p,tt}  = Hstat.pv2;
        homeo_res.delta.fake.R2_2{p,tt} = Hstat.R2_2;
        homeo_res.delta.fake.exp_R2{p,tt} = Hstat.exp_R2;
        
        
        %% save
        homeo_res.nb.neurons_tet{p}(tt) = length(local_neurons{tt});
        homeo_res.nb.localdown{p}(tt)   = length(Start(LocalDown{tt}));
        
        homeo_res.nb.delta.all{p}(tt)    = length(Start(DeltaWavesTT{tt}));
        homeo_res.nb.delta.global{p}(tt) = length(Start(GlobalDelta{tt}));
        homeo_res.nb.delta.local{p}(tt)  = length(Start(LocalDelta{tt}));
        homeo_res.nb.delta.fake{p}(tt)   = length(Start(FakeDelta{tt}));
        
    end
    
    
    %union of all down
    UnionAllDown = AllDown_local{1};
    for tt=2:nb_tetrodes
        UnionAllDown = or(UnionAllDown,AllDown_local{tt});
    end
    UnionAllDown = CleanUpEpoch(dropLongIntervals(UnionAllDown, 2e4),1); %not more than 2sec
    
    [~, ~, Hstat] = DensityCurves_KJ(ts(Start(UnionAllDown)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    homeo_res.down.union.x_intervals{p} = Hstat.x_intervals;
    homeo_res.down.union.y_density{p}   = Hstat.y_density;
    homeo_res.down.union.x_peaks{p}  = Hstat.x_peaks;
    homeo_res.down.union.y_peaks{p}  = Hstat.y_peaks;
    homeo_res.down.union.p0{p}   = Hstat.p0;
    homeo_res.down.union.reg0{p} = Hstat.reg0;
    homeo_res.down.union.p1{p}   = Hstat.p1;
    homeo_res.down.union.reg1{p} = Hstat.reg1; 
    homeo_res.down.union.p2{p}   = Hstat.p2;
    homeo_res.down.union.reg2{p} = Hstat.reg2;
    homeo_res.down.union.exp_a{p} = Hstat.exp_a; 
    homeo_res.down.union.exp_b{p} = Hstat.exp_b;
    %correlation
    homeo_res.down.union.pv0{p}  = Hstat.pv0;
    homeo_res.down.union.R2_0{p} = Hstat.R2_0;
    homeo_res.down.union.pv1{p}  = Hstat.pv1;
    homeo_res.down.union.R2_1{p} = Hstat.R2_1;
    homeo_res.down.union.pv2{p}  = Hstat.pv2;
    homeo_res.down.union.R2_2{p} = Hstat.R2_2;
    homeo_res.down.union.exp_R2{p} = Hstat.exp_R2;
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ParcoursHomeostasieLocalDeltaDensity.mat homeo_res




