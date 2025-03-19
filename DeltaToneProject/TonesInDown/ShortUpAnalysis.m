%%ShortUpAnalysis
% 25.06.2018 KJ
%
%
% see
%   Fig2TonesUpDownDurationTransitions
%


clear

%% Dir

Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');

Dir2=PathForExperimentsBasalSleepSpike;
Dir2=RestrictPathForExperiment(Dir2, 'nMice', [243,244,403,451]);
for p=1:length(Dir2.path)
    Dir2.delay{p} = 0;
end
Dir = MergePathForExperiment(Dir1,Dir2);


%% get data for each record

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p shortup_res
    
    shortup_res.path{p}   = Dir.path{p};
    shortup_res.manipe{p} = Dir.manipe{p};
    shortup_res.name{p}   = Dir.name{p};
    shortup_res.date{p}   = Dir.date{p};
    
    %params
    intv_success = 0.2e4;
    binsize_mua = 2; %2ms
    minDuration = 40;
    maxDuration = 30e4;
    
    %tones
    if exist('DeltaSleepEvent.mat','file')==2
        load('DeltaSleepEvent.mat', 'TONEtime2')
        tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
        with_tones = 1;
    else
        with_tones = 0;
    end
    
    %substages
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')
    load('SleepSubstages.mat')
    N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3};
    
    %% MUA
    [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %sec
    up_PFCx = and(up_PFCx, SWSEpoch);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);

    %FR and nb_neuron
    shortup_res.fr{p} = mean(Data(MUA)) / (binsize_mua/1000);
    shortup_res.nb{p} = nb_neurons;
    
    
    %% Tones in or out

    if with_tones
        %Up without tone around
        intv_up = [st_up-intv_success end_up];
        [~,intervals,~] = InIntervals(tones_tmp, intv_up);
        intervals = unique(intervals);
        idx_up = setdiff(1:length(st_up), intervals);
        UpNotone = intervalSet(st_up(idx_up), end_up(idx_up));
    else
        %All Up
        UpNotone = up_PFCx;
    end
    
    %short Up states: 0-50ms
    shortUp = dropLongIntervals(UpNotone, 500);
    %middle Up states: 50-200ms
    middleUp = dropShortIntervals(dropLongIntervals(UpNotone, 2000), 500);
    
    
    %% short Up states
    shortup_res.short.start{p} = Start(shortUp);
    for i=1:length(Start(shortUp))
        mua_up = Restrict(MUA, subset(shortUp,i));
        shortup_res.short.fr{p}(i) = mean(Data(mua_up)) / (binsize_mua/1000);
    end
    
    shortup_res.short.n1{p} = length(Restrict(ts(Start(shortUp)), N1));
    shortup_res.short.n2{p} = length(Restrict(ts(Start(shortUp)), N2));
    shortup_res.short.n3{p} = length(Restrict(ts(Start(shortUp)), N3));
    
    shortup_res.short.durations{p} = End(shortUp) - Start(shortUp);
    
    
    %% middle Up states
    shortup_res.middle.start{p} = Start(middleUp);
    for i=1:length(Start(middleUp))
        mua_up = Restrict(MUA, subset(middleUp,i));
        shortup_res.middle.fr{p}(i) = mean(Data(mua_up)) / (binsize_mua/1000);
    end
    
    shortup_res.middle.n1{p} = length(Restrict(ts(Start(middleUp)), N1));
    shortup_res.middle.n2{p} = length(Restrict(ts(Start(middleUp)), N2));
    shortup_res.middle.n3{p} = length(Restrict(ts(Start(middleUp)), N3));
    
    shortup_res.middle.durations{p} = End(middleUp) - Start(middleUp);
    
    
    %% all Up states
    shortup_res.all.start{p} = Start(UpNotone);
    for i=1:length(Start(UpNotone))
        mua_up = Restrict(MUA, subset(UpNotone,i));
        shortup_res.all.fr{p}(i) = mean(Data(mua_up)) / (binsize_mua/1000);
    end
    
    shortup_res.all.n1{p} = length(Restrict(ts(Start(UpNotone)), N1));
    shortup_res.all.n2{p} = length(Restrict(ts(Start(UpNotone)), N2));
    shortup_res.all.n3{p} = length(Restrict(ts(Start(UpNotone)), N3));
    
    shortup_res.all.durations{p} = End(UpNotone) - Start(UpNotone);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ShortUpAnalysis.mat shortup_res binsize_mua intv_success minDuration maxDuration


