%%LFPonDownStatesLayer
%
% 24.01.2018 KJ
%
% see
%   LFPonDownStatesLayerPlot LFPonDownStatesClustering3
%


clear
Dir = PathForExperimentsBasalSleepSpike;
load(fullfile(FolderDeltaDataKJ, 'DetectDeltaDepthSingleChannel.mat'))


%% 
for p=1:length(Dir.path)  
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p layer_res Substages depth_res
    
    layer_res.path{p}   = Dir.path{p};
    layer_res.manipe{p} = Dir.manipe{p};
    layer_res.name{p}   = Dir.name{p};
    layer_res.date{p}   = Dir.date{p};
    layer_res.ecogs{p}  = depth_res.date{p};
    
    
    %% params
    durations1   = [50 100] * 10; %in ts, for mean curve on down state
    durations2   = [100 200] * 10; 
    durations3   = [200 300] * 10;
    durations4   = [300 400] * 10;
    binsize_met  = 5; %for mETAverage  
    nbBins_met   = 240; %for mETAverage 
    preripples_window = 4000; %500ms
    hemisphere=0;
    
    
    %% load data
    
    %Substages
    load('SleepSubstages.mat','Epoch')
    for sub=1:5
        Substages{p,sub} = Epoch{sub};
    end
    NREM = or(Epoch{1},or(Epoch{2},Epoch{3}));

    %LFP 
    Signals = cell(0); hemi_channel = cell(0);
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    load(fullfile(Dir.path{p}, 'LFPData', 'InfoLFP.mat'))

    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = lower(hemi_channel{ch}(1));
        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
        Signals{ch} = LFP; clear LFP
    end

    %down
    load('DownState.mat', 'down_PFCx')
    Down = down_PFCx;
    start_down = Start(Down);
    center_down = (End(Down) + Start(Down))/2;
    down_durations = End(Down) - Start(Down);
    selected_down1 = start_down(down_durations>durations1(1) & down_durations<durations1(2));
    selected_down2 = start_down(down_durations>durations2(1) & down_durations<durations2(2));
    selected_down3 = start_down(down_durations>durations3(1) & down_durations<durations3(2));
    selected_down4 = start_down(down_durations>durations4(1) & down_durations<durations4(2));
    
    %other hemisphere
    load('DownState.mat', 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        hemisphere=1;
        Down_r = down_PFCx_r;
        start_down_r = Start(Down_r);
        center_down_r = (End(Down_r) + Start(Down_r))/2;
        down_durations_r = End(Down_r) - Start(Down_r);
        selected_down1_r = start_down_r(down_durations_r>durations1(1) & down_durations_r<durations1(2));
        selected_down2_r = start_down_r(down_durations_r>durations2(1) & down_durations_r<durations2(2));
        selected_down3_r = start_down_r(down_durations_r>durations3(1) & down_durations_r<durations3(2));
        selected_down4_r = start_down_r(down_durations_r>durations4(1) & down_durations_r<durations4(2));
    end
    load('DownState.mat', 'down_PFCx_l')
    if exist('down_PFCx_l','var')
        hemisphere=1;
        Down_l = down_PFCx_l;
        start_down_l = Start(Down_l);
        center_down_l = (End(Down_l) + Start(Down_l))/2;
        down_durations_l = End(Down_l) - Start(Down_l);
        selected_down1_l = start_down_l(down_durations_l>durations1(1) & down_durations_l<durations1(2));
        selected_down2_l = start_down_l(down_durations_l>durations2(1) & down_durations_l<durations2(2));
        selected_down3_l = start_down_l(down_durations_l>durations3(1) & down_durations_l<durations3(2));
        selected_down4_l = start_down_l(down_durations_l>durations4(1) & down_durations_l<durations4(2));
    end
    
    
    %deltas
    load('DeltaWaves.mat', 'deltas_PFCx')
    Delta = deltas_PFCx;
    start_delta = Start(Delta);
    delta_durations = End(Delta) - Start(Delta);
    selected_delta1 = start_delta(delta_durations>durations1(1) & delta_durations<durations1(2));
    selected_delta2 = start_delta(delta_durations>durations2(1) & delta_durations<durations2(2));
    selected_delta3 = start_delta(delta_durations>durations3(1) & delta_durations<durations3(2));
    selected_delta4 = start_delta(delta_durations>durations4(1) & delta_durations<durations4(2));
    
    %other hemisphere
    load('DeltaWaves.mat', 'deltas_PFCx_r')
    if exist('deltas_PFCx_r','var')
        Delta_r = deltas_PFCx_r;
        start_delta_r = Start(Delta_r);
        delta_durations_r = End(Delta_r) - Start(Delta_r);
        selected_delta1_r = start_delta_r(delta_durations_r>durations1(1) & delta_durations_r<durations1(2));
        selected_delta2_r = start_delta_r(delta_durations_r>durations2(1) & delta_durations_r<durations2(2));
        selected_delta3_r = start_delta_r(delta_durations_r>durations3(1) & delta_durations_r<durations3(2));
        selected_delta4_r = start_delta_r(delta_durations_r>durations4(1) & delta_durations_r<durations4(2));
    end
    load('DeltaWaves.mat', 'deltas_PFCx_l')
    if exist('deltas_PFCx_l','var')
        Delta_l = deltas_PFCx_l;
        start_delta_l = Start(Delta_l);
        delta_durations_l = End(Delta_l) - Start(Delta_l);
        selected_delta1_l = start_delta_l(delta_durations_l>durations1(1) & delta_durations_l<durations1(2));
        selected_delta2_l = start_delta_l(delta_durations_l>durations2(1) & delta_durations_l<durations2(2));
        selected_delta3_l = start_delta_l(delta_durations_l>durations3(1) & delta_durations_l<durations3(2));
        selected_delta4_l = start_delta_l(delta_durations_l>durations4(1) & delta_durations_l<durations4(2));
    end
    
    %ripples
    if exist('Ripples.mat','file')==2
        [tRipples, ~] = GetRipples;
        ripples_tmp = Range(Restrict(tRipples, NREM));
        
        %ripples without down before
        preripples_intv = [ripples_tmp-preripples_window  ripples_tmp];
        [~,interval,~] = InIntervals(center_down, preripples_intv);
        interval(interval==0)=[];
        interval=unique(interval);
        ripples_alone = ripples_tmp(~ismember(1:length(ripples_tmp),interval));
        
    else
        ripples_tmp = [];
        ripples_alone = [];
    end
    
%     if hemisphere && exist('Ripples.mat','file')==2
%         %ripples without down before
%         [~,interval,~] = InIntervals(center_down_r, preripples_intv);
%         interval(interval==0)=[];
%         interval=unique(interval);
%         ripples_alone_r = ripples_tmp(~ismember(1:length(ripples_tmp),interval));
%     else
%         ripples_alone_r = [];    
%     end
%     

    %spindles
    if exist('Spindles.mat','file')==2
        [tSpindles, ~] = GetSpindles;
        spindles_tmp = Range(tSpindles);
    else
        spindles_tmp = [];
    end
    
    
    %% Amplitude on down/delta   
    for ch=1:length(channels)
        
        
        %event for the hemisphere
        if hemisphere && strcmpi(hemi_channel{ch},'r') %right
            seldown1 = selected_down1_r;
            seldown2 = selected_down2_r;
            seldown3 = selected_down3_r;
            seldown4 = selected_down4_r;
            
            seldelta1 = selected_delta1_r;
            seldelta2 = selected_delta2_r;
            seldelta3 = selected_delta3_r;
            seldelta4 = selected_delta4_r;
            
        elseif hemisphere && strcmpi(hemi_channel{ch},'l') %left
            seldown1 = selected_down1_l;
            seldown2 = selected_down2_l;
            seldown3 = selected_down3_l;
            seldown4 = selected_down4_l;
            
            seldelta1 = selected_delta1_l;
            seldelta2 = selected_delta2_l;
            seldelta3 = selected_delta3_l;
            seldelta4 = selected_delta4_l;
            
        else 
            seldown1 = selected_down1;
            seldown2 = selected_down2;
            seldown3 = selected_down3;
            seldown4 = selected_down4;
            
            seldelta1 = selected_delta1;
            seldelta2 = selected_delta2;
            seldelta3 = selected_delta3;
            seldelta4 = selected_delta4;
        end
        
        
        %down
        [m,~,tps] = mETAverage(seldown1, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandown1{ch}(:,1) = tps; meandown1{ch}(:,2) = m;
        [m,~,tps] = mETAverage(seldown2, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandown2{ch}(:,1) = tps; meandown2{ch}(:,2) = m;
        [m,~,tps] = mETAverage(seldown3, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandown3{ch}(:,1) = tps; meandown3{ch}(:,2) = m;
        [m,~,tps] = mETAverage(seldown4, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandown4{ch}(:,1) = tps; meandown4{ch}(:,2) = m;
        
        %ripples
        if ~isempty(ripples_tmp)
            [m,s,tps] = mETAverage(ripples_tmp, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meanripples{ch}(:,1) = tps; meanripples{ch}(:,2) = m;
        else
            meanripples{ch} = [];
        end
        
        %ripples without down before
        if ~isempty(ripples_alone)
            [m,s,tps] = mETAverage(ripples_alone, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meanripplesco{ch}(:,1) = tps; meanripplesco{ch}(:,2) = m;
        else
            meanripplesco{ch} = [];
        end
        
        %spindles
        if ~isempty(spindles_tmp)
            [m,s,tps] = mETAverage(spindles_tmp*10, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meanspindles{ch}(:,1) = tps; meanspindles{ch}(:,2) = m;
        else
            meanspindles{ch} = [];
        end
        
        %delta
        [m,~,tps] = mETAverage(seldelta1, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandelta1{ch}(:,1) = tps; meandelta1{ch}(:,2) = m;
        [m,~,tps] = mETAverage(seldelta2, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandelta2{ch}(:,1) = tps; meandelta2{ch}(:,2) = m;
        [m,~,tps] = mETAverage(seldelta3, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandelta3{ch}(:,1) = tps; meandelta3{ch}(:,2) = m;
        [m,~,tps] = mETAverage(seldelta4, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandelta4{ch}(:,1) = tps; meandelta4{ch}(:,2) = m;         
        
        %deltas of channel
        Delta = depth_res.deltas{p}{ch};
        start_delta_ch = Start(Delta);
        deltach_durations = End(Delta) - Start(Delta);
        selected_deltach1 = start_delta_ch(deltach_durations>durations1(1) & deltach_durations<durations1(2));
        selected_deltach2 = start_delta_ch(deltach_durations>durations2(1) & deltach_durations<durations2(2));
        selected_deltach3 = start_delta_ch(deltach_durations>durations3(1) & deltach_durations<durations3(2));
        selected_deltach4 = start_delta_ch(deltach_durations>durations4(1) & deltach_durations<durations4(2));
        
        try
            [m,~,tps] = mETAverage(selected_deltach1, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meandelta_ch1{ch}(:,1) = tps; meandelta_ch1{ch}(:,2) = m;
        end
        try
            [m,~,tps] = mETAverage(selected_deltach2, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meandelta_ch2{ch}(:,1) = tps; meandelta_ch2{ch}(:,2) = m;
        end
        try
            [m,~,tps] = mETAverage(selected_deltach3, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meandelta_ch3{ch}(:,1) = tps; meandelta_ch3{ch}(:,2) = m;
        end
        try
            [m,~,tps] = mETAverage(selected_deltach4, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meandelta_ch4{ch}(:,1) = tps; meandelta_ch4{ch}(:,2) = m;
        end
    end
    
    
    %% save
    layer_res.down.meandown1{p} = meandown1;
    layer_res.down.meandown2{p} = meandown2;
    layer_res.down.meandown3{p} = meandown3;
    layer_res.down.meandown4{p} = meandown4;
    
    layer_res.down.nb1{p} = sum(selected_down1);
    layer_res.down.nb2{p} = sum(selected_down2);
    layer_res.down.nb3{p} = sum(selected_down3);
    layer_res.down.nb4{p} = sum(selected_down4);
    
    layer_res.ripples.meancurves{p} = meanripples;
    layer_res.ripples.nb{p} = length(ripples_tmp);
    
    layer_res.ripples_correct.meancurves{p} = meanripplesco;
    layer_res.ripples_correct.nb{p} = length(ripples_alone);
    
    layer_res.spindles.meancurves{p} = meanspindles;
    layer_res.spindles.nb{p} = length(spindles_tmp);
    
    layer_res.delta.meandelta1{p} = meandelta1;
    layer_res.delta.meandelta2{p} = meandelta2;
    layer_res.delta.meandelta3{p} = meandelta3;
    layer_res.delta.meandelta4{p} = meandelta4;
    
    layer_res.delta.nb1{p} = sum(selected_delta1);
    layer_res.delta.nb2{p} = sum(selected_delta2);
    layer_res.delta.nb3{p} = sum(selected_delta3);
    layer_res.delta.nb4{p} = sum(selected_delta4);
    
    layer_res.delta.meandelta_ch1{p} = meandelta_ch1;
    layer_res.delta.meandelta_ch2{p} = meandelta_ch2;
    layer_res.delta.meandelta_ch3{p} = meandelta_ch3;
    layer_res.delta.meandelta_ch4{p} = meandelta_ch4;
    
    layer_res.channels{p} = channels;
    
end

%saving data
cd(FolderDeltaDataKJ)
save LFPonDownStatesLayer.mat layer_res Substages durations1 durations2 durations3 durations4 binsize_met nbBins_met


    
    