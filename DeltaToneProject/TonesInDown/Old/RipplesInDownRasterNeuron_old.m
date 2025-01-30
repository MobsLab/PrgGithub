%%RipplesInDownRasterNeuron_old
% 30.05.2018 KJ
%
%
% see
%   ToneInDownRasterNeuron  RipplesInDownRasterNeuron
%
% 

clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripples_res
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    minDuration = 40;
    
    %ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;
    RipplesEvent = ts(ripples_tmp);
    
    %tone impact
    load('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers', 'responses')
    
    
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
    idn_inhib = effect_mean<-1.5 & t_mean <-1.5;
    
    responses = zeros(length(NumNeurons),1);
    responses(idn_excit) = 1;
    responses(idn_inhib) = -1;
    
    excited_neurons = NumNeurons(responses==1);
    neutral_neurons = NumNeurons(responses==0);
    inhibit_neurons = NumNeurons(responses==-1);
    
    ripples_res.nb.all{p}     = length(NumNeurons);
    ripples_res.nb.excited{p} = length(excited_neurons);
    ripples_res.nb.neutral{p} = length(neutral_neurons);
    ripples_res.nb.inhibit{p} = length(inhibit_neurons);
    
    
    %% MUA & Down
    %MUA
    MUA.all  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    MUA.excited = GetMuaNeurons_KJ(excited_neurons,'binsize',binsize_mua); 
    MUA.neutral = GetMuaNeurons_KJ(neutral_neurons,'binsize',binsize_mua);
    MUA.inhibit = GetMuaNeurons_KJ(inhibit_neurons,'binsize',binsize_mua);
    
    %down
    down_PFCx = FindDownKJ(MUA.all, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);
    
    
    %% Rippless in or out
    intwindow = 2000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);
    upInterval = intervalSet(Start(down_PFCx)-intwindow, Start(down_PFCx));
    upInterval = CleanUpEpoch(and(upInterval, intervalSet(Start(down_PFCx), Start(down_PFCx)+intwindow)));
    

    %ripples in and out down states
    Allnight = intervalSet(0,max(Range(MUA.all)));
    RipplesIn = Restrict(RipplesEvent, down_PFCx);
    RipplesOut = Restrict(RipplesEvent, CleanUpEpoch(Allnight-aroundDown));
    RipplesAround = Restrict(RipplesEvent, upInterval);
    
    ripplesin_tmp = Range(RipplesIn);
    ripplesout_tmp = Range(RipplesOut);
    ripplesaround_tmp = Range(RipplesAround);
    
    
    %% Rasters
    neuron_pop = {'all','excited','neutral','inhibit'};
    
    for i=1:length(neuron_pop)
        ripples_res.rasters.inside.(neuron_pop{i}){p}  = RasterMatrixKJ(MUA.(neuron_pop{i}), RipplesIn, t_start, t_end);
        ripples_res.rasters.outside.(neuron_pop{i}){p} = RasterMatrixKJ(MUA.(neuron_pop{i}), RipplesOut, t_start, t_end);
        ripples_res.rasters.around.(neuron_pop{i}){p}  = RasterMatrixKJ(MUA.(neuron_pop{i}), RipplesAround, t_start, t_end);
    end
    
    
    %% orders
    %ripples in down
    ripples_res.inside.before{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.after{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.postdown{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        ripples_res.inside.before{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>ripplesin_tmp(i),1));
        ripples_res.inside.after{p}(i) = end_aft - ripplesin_tmp(i);
        
        down_post = st_down(find(st_down>ripplesin_tmp(i),1));
        ripples_res.inside.postdown{p}(i) = down_post - ripplesin_tmp(i);

    end
    
    %ripples around down
    ripples_res.around.before{p} = nan(length(ripplesaround_tmp), 1);
    ripples_res.around.postdown{p} = nan(length(ripplesaround_tmp), 1);
    for i=1:length(ripplesaround_tmp)        
        st_bef = end_down(find(end_down<ripplesaround_tmp(i),1,'last'));
        ripples_res.around.before{p}(i) = ripplesaround_tmp(i) - st_bef;
        
        down_post = st_down(find(st_down>ripplesaround_tmp(i),1));
        ripples_res.around.postdown{p}(i) = down_post - ripplesaround_tmp(i);
    end
    
     
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesInDownRasterNeuron.mat -v7.3 ripples_res t_start t_end binsize_mua neuron_pop minDuration





