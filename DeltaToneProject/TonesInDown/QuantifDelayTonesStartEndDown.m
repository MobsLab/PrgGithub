%%QuantifDelayTonesStartEndDown
% 18.05.2018 KJ
%
%   Delay between tones or sham and next transitions
%
% see
%   ProbabilityTonesUpDownTransition QuantifDelayRipplesStartEndDown
%


clear


Dir = PathForExperimentsRandomTonesSpikes;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p delay_res
    
    delay_res.path{p}   = Dir.path{p};
    delay_res.manipe{p} = Dir.manipe{p};
    delay_res.name{p}   = Dir.name{p};
    delay_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 2; %2ms
    minDurationDown = 40;
    minDurationUp = 0.05e4;
    maxDurationUp = 30e4;
    
    %substages
    load('SleepSubstages.mat')
    NREM = CleanUpEpoch(or(Epoch{1},or(Epoch{2},Epoch{3})));
    
    
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
    
    
    %% Tones
    load('behavResources.mat', 'ToneEvent')
    tones_tmp = Range(ToneEvent);    
    ToneEvent = Restrict(ToneEvent, NREM);
    TonesDown = Restrict(ToneEvent, down_PFCx);
    TonesUp = Restrict(ToneEvent, up_PFCx);
    
    
    %% Create Sham 
    
    %down
    nb_sham = 1000;
    idx = randsample(length(st_down), nb_sham);
    shamdown_tmp = [];
    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree = end_down(idx(i))-st_down(idx(i));
        shamdown_tmp = [shamdown_tmp min_tmp+rand(1)*duree];
    end
    shamdown_tmp = sort(shamdown_tmp);
    
    %up
    nb_sham = 2000;
    idx = randsample(length(st_up), nb_sham);
    shamup_tmp = [];
    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        shamup_tmp = [shamup_tmp min_tmp+rand(1)*duree];
    end
    shamup_tmp = sort(shamup_tmp);
    
    
    %% Tones and delay    
    
    %tones in
    tonesdown_tmp = Range(TonesDown);
    delay_tonedown = zeros(length(tonesdown_tmp), 1);
    for i=1:length(tonesdown_tmp)
        idx = find(end_down > tonesdown_tmp(i), 1);
        delay_tonedown(i) = end_down(idx) - tonesdown_tmp(i);
    end
    delay_res.tones.inside{p} = delay_tonedown;
    
    %tones out
    tonesup_tmp = Range(TonesUp);
    delay_toneup = zeros(length(tonesup_tmp), 1);
    for i=1:length(tonesup_tmp)
        idx = find(st_down > tonesup_tmp(i), 1);
        delay_toneup(i) = st_down(idx) - tonesup_tmp(i);
    end
    delay_res.tones.outside{p} = delay_toneup;

    %sham in
    delay_shamdown = zeros(length(shamdown_tmp), 1);
    for i=1:length(shamdown_tmp)
        idx = find(end_down > shamdown_tmp(i), 1);
        delay_shamdown(i) = end_down(idx) - shamdown_tmp(i);
    end
    delay_res.sham.inside{p} = delay_shamdown;
    
    %sham out
    delay_shamup = zeros(length(shamup_tmp), 1);
    for i=1:length(shamup_tmp)
        idx = find(st_down > shamup_tmp(i), 1);
        delay_shamup(i) = st_down(idx) - shamup_tmp(i);
    end
    delay_res.sham.outside{p} = delay_shamup;
    
end


%saving data
cd(FolderDeltaDataKJ)
save QuantifDelayTonesStartEndDown.mat delay_res binsize_mua minDurationDown minDurationUp maxDurationUp


