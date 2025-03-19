%%UpDownDurations
% 25.05.2018 KJ
%
%
% see
%   CompareInducedVsEndogeneousDown ShortUpAnalysis UpDownDurations2
%


clear

%% Dir

Dir1 = PathForExperimentsRandomTonesSpikes;
Dir2 = PathForExperimentsRandomShamSpikes;

Dir = MergePathForExperiment(Dir1,Dir2);


%% get data for each record

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p duration_res
    
    duration_res.path{p}   = Dir.path{p};
    duration_res.manipe{p} = Dir.manipe{p};
    duration_res.name{p}   = Dir.name{p};
    duration_res.date{p}   = Dir.date{p};
    
    %params
    intv_success = 0.2e4;
    binsize_mua = 2; %2ms
    minDurationDown = 40; %in ms
    minDurationUp = 0.05e4;
    maxDurationUp = 30e4;
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    if exist('ToneEvent','var')
        tones_tmp = Range(ToneEvent);
        with_tones = 1;
    else
        with_tones = 0;
    end
    
    %substages
    load('SleepSubstages.mat')
    NREM = CleanUpEpoch(or(Epoch{1}, or(Epoch{2},Epoch{3})));
    
    
    %% MUA
    [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDurationUp); %sec
    up_PFCx = dropShortIntervals(up_PFCx, minDurationUp); %sec
    up_PFCx = and(up_PFCx, NREM);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);

    %FR and nb_neuron
    duration_res.fr{p} = mean(Data(MUA)) / (binsize_mua/1000);
    duration_res.nb{p} = nb_neurons;
    
    
    %% Tones in or out

    if with_tones
        %Down without tone around
        intv_down = [st_down-intv_success end_down];
        [~,intervals,~] = InIntervals(tones_tmp, intv_down);
        intervals = unique(intervals);
        idx_down = setdiff(1:length(st_down), intervals);
        DownNotone = intervalSet(st_down(idx_down), end_down(idx_down));

        %Up without tone around
        intv_up = [st_up-intv_success end_up];
        [~,intervals,~] = InIntervals(tones_tmp, intv_up);
        intervals = unique(intervals);
        idx_up = setdiff(1:length(st_up), intervals);
        UpNotone = intervalSet(st_up(idx_up), end_up(idx_up));
        
    else
        %All Down
        DownNotone = down_PFCx;
        
        %All Up
        UpNotone = up_PFCx;
    end
    
    
    %% durations
    duration_res.down{p} = End(DownNotone) - Start(DownNotone); 
    duration_res.up{p}   = End(UpNotone) - Start(UpNotone); 
    
        
end


%saving data
cd(FolderDeltaDataKJ)
save UpDownDurations.mat duration_res binsize_mua intv_success minDurationDown maxDurationUp


