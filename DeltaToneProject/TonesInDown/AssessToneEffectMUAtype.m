%%AssessToneEffectMUAtype
% 20.06.2018 KJ
%
%
%   Look at the response of neurons on tones and transitions
%
% see
%   AssessToneEffectMUApopulation AssessToneEffectMUAtypePlot
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir);


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
    binsize_met = 2;
    nbBins_met  = 400;
    binsize_mua = 2;
    minDuration = 40;
    intv_success_down = 1000; %100ms
    intv_success_up = 500; %50ms

    %tone impact
    load('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')
    
    %neuron info
    load('InfoNeuronsPFCx.mat', 'MatInfoNeurons', 'InfoNeurons')

    % tones
    load('behavResources.mat', 'ToneEvent')

    %substages
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')
    

    %% responding neurons
    Cdiff = Ctones.out - Csham;
    Ct_std = std(Ctones.out,[],2);
    idt = xtones.out>0 & xtones.out<100;

    for i=1:length(neuronsLayers)
        effect_peak(i,1) = max(Cdiff(i,idt));
        effect_mean(i,1) = mean(Cdiff(i,idt));
        
        t_peak(i,1) = max(Ctones.out(i,idt));
        t_mean(i,1) = mean(Ctones.out(i,idt));
    end

    idn_excit = effect_peak>4 & t_peak>3*Ct_std;
    idn_inhib = effect_mean<-1 & t_mean <-1;
    idn_neutral = (effect_mean>-0.5 & effect_peak<3.5) | (t_mean>0 & t_peak<3*Ct_std);
    
    responses = nan(length(NumNeurons),1);
    responses(idn_excit) = 1;
    responses(idn_inhib) = -1;
    responses(idn_neutral) = 0;
    
    excited_neurons = NumNeurons(responses==1);
    neutral_neurons = NumNeurons(responses==0);
    inhibit_neurons = NumNeurons(responses==-1);


    %% MUA

    %MUA
    MUA.all  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    MUA.excited = GetMuaNeurons_KJ(excited_neurons, 'binsize',binsize_mua); 
    MUA.neutral = GetMuaNeurons_KJ(neutral_neurons, 'binsize',binsize_mua);
    MUA.inhibit = GetMuaNeurons_KJ(inhibit_neurons, 'binsize',binsize_mua);

    %Down
    down_PFCx = FindDownKJ(MUA.all, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    

    %FR and nb_neuron
    assess_res.fr.all{p}      = mean(Data(MUA.all)) / (binsize_mua/1000);
    assess_res.fr.excited{p}  = mean(Data(MUA.excited)) / (binsize_mua/1000);
    assess_res.fr.neutral{p}  = mean(Data(MUA.neutral)) / (binsize_mua/1000);
    assess_res.fr.inhibit{p}  = mean(Data(MUA.inhibit)) / (binsize_mua/1000);

    assess_res.nb.all{p}      = length(NumNeurons);
    assess_res.nb.excited{p}  = length(excited_neurons);
    assess_res.nb.neutral{p}  = length(neutral_neurons);
    assess_res.nb.inhibit{p}  = length(inhibit_neurons);

    
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
    

    %% Transitions
    
    %Endogeneous and Induced Down
    intv_post_tones = [Range(ToneUp) Range(ToneUp)+intv_success_down];
    [status,~,~] = InIntervals(st_down, intv_post_tones);
    DownEndo = subset(down_PFCx, find(~status));
    DownIndu = subset(down_PFCx, find(status));
    
    %Endogeneous and Induced Up
    intv_post_tones = [Range(ToneDown) Range(ToneDown)+intv_success_up];
    [status,~,~] = InIntervals(st_up, intv_post_tones);
    UpEndo = subset(up_PFCx, find(~status));
    UpIndu = subset(up_PFCx, find(status));
    

    %% MUA response
    neurons_pop = {'all','excited','neutral','inhibit'};
    
    for n=1:length(neurons_pop)
        
        npop = neurons_pop{n};
        
        %% On tones
        
        % down -> up
        [m,sem,tps] = mETAverage(Range(ToneDownUp), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.down_up.(npop){p}(:,1) = tps; assess_res.down_up.(npop){p}(:,2) = m; assess_res.down_up.(npop){p}(:,3) = sem;
        
        % down -> down
        [m,sem,tps] = mETAverage(Range(ToneDownDown), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.down_down.(npop){p}(:,1) = tps; assess_res.down_down.(npop){p}(:,2) = m; assess_res.down_down.(npop){p}(:,3) = sem;
        
        % up -> down
        [m,sem,tps] = mETAverage(Range(ToneUpDown), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.up_down.(npop){p}(:,1) = tps; assess_res.up_down.(npop){p}(:,2) = m; assess_res.up_down.(npop){p}(:,3) = sem;
        
        % up -> up
        [m,sem,tps] = mETAverage(Range(ToneUpUp), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.up_up.(npop){p}(:,1) = tps; assess_res.up_up.(npop){p}(:,2) = m; assess_res.up_up.(npop){p}(:,3) = sem;

        

        %% On transitions
        
        %endogeneous down
        [m,sem,tps] = mETAverage(Start(DownEndo), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.down_endo.(npop){p}(:,1) = tps; assess_res.down_endo.(npop){p}(:,2) = m; assess_res.down_endo.(npop){p}(:,3) = sem;
        
        %induced down
        [m,sem,tps] = mETAverage(Start(DownIndu), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.down_indu.(npop){p}(:,1) = tps; assess_res.down_indu.(npop){p}(:,2) = m; assess_res.down_indu.(npop){p}(:,3) = sem;
        
        %endogeneous up
        [m,sem,tps] = mETAverage(Start(UpEndo), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.up_endo.(npop){p}(:,1) = tps; assess_res.up_endo.(npop){p}(:,2) = m; assess_res.up_endo.(npop){p}(:,3) = sem;
        
        %induced up
        [m,sem,tps] = mETAverage(Start(UpIndu), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.up_indu.(npop){p}(:,1) = tps; assess_res.up_indu.(npop){p}(:,2) = m; assess_res.up_indu.(npop){p}(:,3) = sem;
        

    end
    
    %number of events
    assess_res.nb_tone.down_up{p}   = length(ToneDownUp);
    assess_res.nb_tone.down_down{p} = length(ToneDownDown);
    assess_res.nb_tone.up_down{p}   = length(ToneUpDown);
    assess_res.nb_tone.up_up{p}     = length(ToneUpUp);
    
    assess_res.nb_down.endo{p} = length(End(DownEndo));
    assess_res.nb_down.indu{p} = length(End(DownIndu));
    assess_res.nb_up.endo{p}   = length(End(UpEndo));
    assess_res.nb_up.indu{p}   = length(End(UpIndu));
    

end


%saving data
cd(FolderDeltaDataKJ)
save AssessToneEffectMUAtype.mat assess_res binsize_met nbBins_met binsize_mua minDuration intv_success_down intv_success_up neurons_pop


