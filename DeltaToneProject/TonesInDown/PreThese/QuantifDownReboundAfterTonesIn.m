%%QuantifDownReboundAfterTonesIn
% 18.09.2018 KJ
%
%
%
%
% see
%   TonesInDownN2N3Effect  
%


clear

Dir = PathForExperimentsRandomTonesSpikes;


%get data for each record
for p=1%:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    range_down = [0 50]*10;   % [0-50ms] after tone in Down
    binsize_mua = 2;
    
    minDuration = 40;
    maxDuration = 30e4;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 800, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_durations = end_down - st_down;
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    up_durations = end_up - st_up;
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_res.nb_tones = length(ToneEvent);
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    
    
    %% Tones in NREM
    ToneDown = Restrict(Restrict(ToneEvent, NREM), down_PFCx);
    tonedown_tmp = Range(ToneDown);
    
    %mean MUA resposne
    [m,~,tps] = mETAverage(tonedown_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.met_inside{p}(:,1) = tps; tones_res.met_inside{p}(:,2) = m;
    
    %Success to create a transition
    intv = [tonedown_tmp+range_down(1) tonedown_tmp+range_down(2)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tonetransit_tmp = tonedown_tmp(intervals);

    
    %% Down and Up around
    
    %down of tones
    intv = [st_down end_down];
    [~,intervals,~] = InIntervals(tonetransit_tmp, intv);
    intervals(intervals==0)=[];
    id_downIn = unique(intervals);
    
    downInDur = down_durations(id_downIn);
    
    %down after
    id_downAfter = id_downIn + 1;
    downAfterDur = down_durations(id_downAfter);
    
    %up after tones
    id_upAfter = [];
    for i=1:length(tonetransit_tmp)
        id_upAfter(i) = find(st_up>tonetransit_tmp(i),1);
    end
    upAfterDur = up_durations(id_upAfter);
    
    %up around
    
    
    
    %%
    

    
    
    
end

% 
% %saving data
% cd(FolderDeltaDataKJ)
% save QuantifDownReboundAfterTonesIn.mat tones_res binsize_met nbBins_met binsize_mua minDuration range_down
% 


