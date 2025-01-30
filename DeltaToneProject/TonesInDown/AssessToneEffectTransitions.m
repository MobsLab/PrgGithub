%%AssessToneEffectTransitions
% 17.07.2018 KJ
%
%
%   Look at the effect of tones on transitions dynamics, in function of the occurence of deltas around the tone 
%
% see
%   AssessToneEffectMUAtype
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p assess_res
    
    assess_res.path{p}   = Dir.path{p};
    assess_res.manipe{p} = Dir.manipe{p};
    assess_res.name{p}   = Dir.name{p};
    assess_res.date{p}   = Dir.date{p};


    %% init
    %params
    binsize_mua = 2;
    minDuration = 40;
    intv_success_down = 1000; %100ms
    intv_success_up = 500; %50ms
    windowsize = 10e4; %10sec


    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);

    %substages
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')

    %neurons
    load('NeuronTones', 'NumNeurons')
    
    %% MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %FR and nb_neuron
    assess_res.firingrate{p}      = mean(Data(MUA)) / (binsize_mua/1000);
    assess_res.nb_neurons{p}      = length(NumNeurons);

    
    %% Tones
    ToneNREM = Restrict(ToneEvent, SWSEpoch);
    ToneDown = Restrict(ToneNREM, down_PFCx);
    ToneUp   = Restrict(ToneNREM, up_PFCx);
    
    % Down to Up ?
    intv_post_tones = [Range(ToneDown) Range(ToneDown)+intv_success_up];
    [~,intervals,~] = InIntervals(st_up, intv_post_tones);
    intervals = unique(intervals); intervals(intervals==0)=[];
    ToneDownUp = subset(ToneDown, intervals);
    ToneDownDown = subset(ToneDown, setdiff(1:length(ToneDown), intervals));
    % Up to Down ?
    intv_post_tones = [Range(ToneUp) Range(ToneUp)+intv_success_down];
    [~,intervals,~] = InIntervals(st_down, intv_post_tones);
    intervals = unique(intervals); intervals(intervals==0)=[];
    ToneUpDown = subset(ToneUp, intervals);
    ToneUpUp = subset(ToneUp, setdiff(1:length(ToneUp), intervals));
    

    %number of events
    assess_res.nb_tone.down_up{p}   = length(ToneDownUp);
    assess_res.nb_tone.down_down{p} = length(ToneDownDown);
    assess_res.nb_tone.up_down{p}   = length(ToneUpDown);
    assess_res.nb_tone.up_up{p}     = length(ToneUpUp);
    
    
    %% Transitions
    
    %down>up
    tones_downup = Range(ToneDownUp);
    for i=1:length(tones_downup)
        select_down = st_down - tones_downup(i);
        select_down = select_down(select_down>-windowsize & select_down<windowsize);
        assess_res.delays.downup.down{p,i} = select_down;
        
        select_up = st_up - tones_downup(i);
        select_up = select_up(select_up>-windowsize & select_up<windowsize);
        assess_res.delays.downup.up{p,i} = select_up;
    end
    
    %down>down
    tones_downdown = Range(ToneDownDown);
    for i=1:length(tones_downdown)
        select_down = st_down - tones_downdown(i);
        select_down = select_down(select_down>-windowsize & select_down<windowsize);
        assess_res.delays.downdown.down{p,i} = select_down;
        
        select_up = st_up - tones_downdown(i);
        select_up = select_up(select_up>-windowsize & select_up<windowsize);
        assess_res.delays.downdown.up{p,i} = select_up;
    end
    
    %up>down
    tones_updown = Range(ToneUpDown);
    for i=1:length(tones_updown)
        select_down = st_down - tones_updown(i);
        select_down = select_down(select_down>-windowsize & select_down<windowsize);
        assess_res.delays.updown.down{p,i} = select_down;
        
        select_up = st_up - tones_updown(i);
        select_up = select_up(select_up>-windowsize & select_up<windowsize);
        assess_res.delays.updown.up{p,i} = select_up;
    end
    
    %up>up
    tones_upup = Range(ToneUpUp);
    for i=1:length(tones_upup)
        select_down = st_down - tones_upup(i);
        select_down = select_down(select_down>-windowsize & select_down<windowsize);
        assess_res.delays.upup.down{p,i} = select_down;
        
        select_up = st_up - tones_upup(i);
        select_up = select_up(select_up>-windowsize & select_up<windowsize);
        assess_res.delays.upup.up{p,i} = select_up;
    end

end


%saving data
cd(FolderDeltaDataKJ)
save AssessToneEffectTransitions.mat assess_res binsize_mua minDuration intv_success_down intv_success_up



