%%ParcoursUpRipplesDescription
% 20.09.2018 KJ
%
%
%   Look at the Up states with ripples
%
% see
%   ParcoursUpRipplesDescriptionPlot       



clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripstat_res
    
    ripstat_res.path{p}   = Dir.path{p};
    ripstat_res.manipe{p} = Dir.manipe{p};
    ripstat_res.name{p}   = Dir.name{p};
    ripstat_res.date{p}   = Dir.date{p};
    
    %params
    minDuration = 75;
    binsize_mua = 2;
    
    %% load
    
    % Substages
    try
        load('SleepSubstages.mat', 'Epoch')
        Substages = Epoch;
    catch
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
    end
    N1 = Substages{1}; N2 = Substages{2}; N3 = Substages{3}; REM = Substages{4}; Wake = Substages{5}; NREM = Substages{7};
    N2N3 = or(N2,N3);
    
    %MUA 
    [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx     = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down       = Start(down_PFCx);
    end_down      = End(down_PFCx);
    
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);

    %FR and nb_neuron
    ripstat_res.fr{p} = mean(Data(MUA)) / (binsize_mua/1000);
    ripstat_res.nb{p} = nb_neurons;

    % ripples
    load('Ripples.mat')
    ripples_tmp = Ripples(:,2)*10;
    
    %night duration
    load('IdFigureData2.mat', 'night_duration')
    ripstat_res.night_duration{p} = night_duration;
    
    
    %% Up&Down with Ripples
    
    duration_up = End(up_PFCx) - Start(up_PFCx);
    duration_down = End(down_PFCx) - Start(down_PFCx);

    %Down
    intv = [Start(down_PFCx) End(down_PFCx)];
    [status, intervals,~] = InIntervals(ripples_tmp, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    
    
    ripstat_res.night.ripples.down{p} = ripples_tmp(status);
    
    ripstat_res.night.withrip.down_duration{p} = duration_down(intervals);
    ripstat_res.night.all.down_duration{p} = duration_down; 
    
    ripstat_res.night.withrip.down_start{p} = st_down(intervals);
    ripstat_res.night.all.down_start{p} = st_down;
    
    %Up
    intv = [Start(up_PFCx) End(up_PFCx)];
    [~,intervals,~] = InIntervals(ripples_tmp, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    
    ripstat_res.night.ripples.up{p} = ripples_tmp(status);
    
    ripstat_res.night.withrip.up_duration{p} = duration_up(intervals);
    ripstat_res.night.all.up_duration{p} = duration_up;     
    
    ripstat_res.night.withrip.up_start{p} = st_up(intervals);
    ripstat_res.night.all.up_start{p} = st_up; 
    
    %% in N2
    
    down_N2 = and(down_PFCx,N2);
    up_N2 = and(up_PFCx,N2);
    
    duration_down = End(down_N2) - Start(down_N2);
    duration_up = End(up_N2) - Start(up_N2);
    
    st_down = Start(down_N2);
    st_up = Start(up_N2);

    %Down
    intv = [Start(down_N2) End(down_N2)];
    [status, intervals,~] = InIntervals(ripples_tmp, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    
    ripstat_res.n2.ripples.down{p} = ripples_tmp(status);
    
    ripstat_res.n2.withrip.down_duration{p} = duration_down(intervals);
    ripstat_res.n2.all.down_duration{p} = duration_down; 
    
    ripstat_res.n2.withrip.down_start{p} = st_down(intervals);
    ripstat_res.n2.all.down_start{p} = st_down;
    
    
    %Up
    intv = [Start(up_N2) End(up_N2)];
    [~,intervals,~] = InIntervals(ripples_tmp, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    
    ripstat_res.n2.ripples.up{p} = ripples_tmp(status);
    
    ripstat_res.n2.withrip.up_duration{p} = duration_up(intervals);
    ripstat_res.n2.all.up_duration{p} = duration_up;     
    
    ripstat_res.n2.withrip.up_start{p} = st_up(intervals);
    ripstat_res.n2.all.up_start{p} = st_up;
    
    %% in N3
    
    down_N3 = and(down_PFCx,N3);
    up_N3 = and(up_PFCx,N3);
    
    duration_down = End(down_N3) - Start(down_N3);
    duration_up = End(up_N3) - Start(up_N3);
    
    st_down = Start(down_N3);
    st_up = Start(up_N3);

    %Down
    intv = [Start(down_N3) End(down_N3)];
    [status, intervals,~] = InIntervals(ripples_tmp, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    
    ripstat_res.n3.ripples.down{p} = ripples_tmp(status);
    
    ripstat_res.n3.withrip.down_duration{p} = duration_down(intervals);
    ripstat_res.n3.all.down_duration{p} = duration_down; 
    
    ripstat_res.n3.withrip.down_start{p} = st_down(intervals);
    ripstat_res.n3.all.down_start{p} = st_down;
    
    %Up
    intv = [Start(up_N3) End(up_N3)];
    [~,intervals,~] = InIntervals(ripples_tmp, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    
    ripstat_res.n3.ripples.up{p} = ripples_tmp(status);
    
    ripstat_res.n3.withrip.up_duration{p} = duration_up(intervals);
    ripstat_res.n3.all.up_duration{p} = duration_up;     
    
    ripstat_res.n3.withrip.up_start{p} = st_up(intervals);
    ripstat_res.n3.all.up_start{p} = st_up;
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursUpRipplesDescription.mat ripstat_res minDuration binsize_mua


