%%LFPonDeltaWavesLayer
%
% 04.06.2019 KJ
%
% see
%   LFPonDownStatesLayer
%


clear
Dir = PathForExperimentsBasalSleepSpike;


%% 
for p=1:length(Dir.path)  
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p layer_res
    
    layer_res.path{p}   = Dir.path{p};
    layer_res.manipe{p} = Dir.manipe{p};
    layer_res.name{p}   = Dir.name{p};
    layer_res.date{p}   = Dir.date{p};
    
    
    %% params
    durations1   = [50 100] * 10; %in ts, for mean curve on down state
    durations2   = [100 200] * 10; 
    durations3   = [200 300] * 10;
    durations4   = [300 400] * 10;
    binsize_met  = 5; %for mETAverage  
    nbBins_met   = 240; %for mETAverage 
    hemisphere=0;

    
    %% load data
    
    %Substages
    load('SleepSubstages.mat','Epoch')
    for sub=1:5
        Substages{p,sub} = Epoch{sub};
    end

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
    
    
    %% Amplitude on down/delta   
    for i=1:length(channels)
        
        %event for the hemisphere
        if hemisphere && strcmpi(hemi_channel{ch},'r') %right
            seldelta1 = selected_delta1_r;
            seldelta2 = selected_delta2_r;
            seldelta3 = selected_delta3_r;
            seldelta4 = selected_delta4_r;            
        else 
            seldelta1 = selected_delta1;
            seldelta2 = selected_delta2;
            seldelta3 = selected_delta3;
            seldelta4 = selected_delta4;
        end
        
        %delta
        [m,~,tps] = mETAverage(seldelta1, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
        meandelta1{i}(:,1) = tps; meandelta1{i}(:,2) = m;
        [m,~,tps] = mETAverage(seldelta2, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
        meandelta2{i}(:,1) = tps; meandelta2{i}(:,2) = m;
        [m,~,tps] = mETAverage(seldelta3, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
        meandelta3{i}(:,1) = tps; meandelta3{i}(:,2) = m;
        [m,~,tps] = mETAverage(seldelta4, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
        meandelta4{i}(:,1) = tps; meandelta4{i}(:,2) = m;         
        
%         %deltas of channel
%         Delta = depth_res.deltas{p}{i};
%         start_delta_ch = Start(Delta);
%         deltach_durations = End(Delta) - Start(Delta);
%         selected_deltach1 = start_delta_ch(deltach_durations>durations1(1) & deltach_durations<durations1(2));
%         selected_deltach2 = start_delta_ch(deltach_durations>durations2(1) & deltach_durations<durations2(2));
%         selected_deltach3 = start_delta_ch(deltach_durations>durations3(1) & deltach_durations<durations3(2));
%         selected_deltach4 = start_delta_ch(deltach_durations>durations4(1) & deltach_durations<durations4(2));
%         
%         [m,~,tps] = mETAverage(selected_deltach1, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
%         meandelta_ch1{i}(:,1) = tps; meandelta_ch1{i}(:,2) = m;
%         [m,~,tps] = mETAverage(selected_deltach2, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
%         meandelta_ch2{i}(:,1) = tps; meandelta_ch2{i}(:,2) = m;
%         [m,~,tps] = mETAverage(selected_deltach3, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
%         meandelta_ch3{i}(:,1) = tps; meandelta_ch3{i}(:,2) = m;
%         [m,~,tps] = mETAverage(selected_deltach4, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
%         meandelta_ch4{i}(:,1) = tps; meandelta_ch4{i}(:,2) = m;
        
    end
    
    
    %% save
    layer_res.delta.meandelta1{p} = meandelta1;
    layer_res.delta.meandelta2{p} = meandelta2;
    layer_res.delta.meandelta3{p} = meandelta3;
    layer_res.delta.meandelta4{p} = meandelta4;
    
    layer_res.delta.nb1{p} = sum(selected_delta1);
    layer_res.delta.nb2{p} = sum(selected_delta2);
    layer_res.delta.nb3{p} = sum(selected_delta3);
    layer_res.delta.nb4{p} = sum(selected_delta4);
    
%     layer_res.delta.meandelta_ch1{p} = meandelta_ch1;
%     layer_res.delta.meandelta_ch2{p} = meandelta_ch2;
%     layer_res.delta.meandelta_ch3{p} = meandelta_ch3;
%     layer_res.delta.meandelta_ch4{p} = meandelta_ch4;
    
    layer_res.channels{p} = channels;
    
    
    
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save LFPonDeltaWavesLayer.mat layer_res binsize_met nbBins_met durations1 durations2 durations3 durations4


    