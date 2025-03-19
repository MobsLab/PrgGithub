%%RipplesInUpRasterNeuron_old
% 18.04.2018 KJ
%
%
% see
%   ToneInUpRasterNeuron
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
    t_start      =  -2e4; %1s
    t_end        = 2e4; %1s
    binsize_mua  = 2; %2ms
    maxDuration  = 10e4;
    
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
    
    %Down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %5sec
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Ripples in up
    RipplesIn = Restrict(RipplesEvent, up_PFCx);
    ripplesin_tmp = Range(RipplesIn);
    
    
    %% Rasters
    neuron_pop = {'all','excited','neutral','inhibit'};
    
    for i=1:length(neuron_pop)
        ripples_res.rasters.inside.(neuron_pop{i}){p}  = RasterMatrixKJ(MUA.(neuron_pop{i}), RipplesIn, t_start, t_end);
    end
    
    
    %% orders
    %ripples in up
    ripples_res.inside.before{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.after{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.postup{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.postdown{p} = nan(length(ripplesin_tmp), 1);
    
    for i=1:length(ripplesin_tmp)     
        try
            st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
            ripples_res.inside.before{p}(i) = ripplesin_tmp(i) - st_bef;
        end
        try
            end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
            ripples_res.inside.after{p}(i) = end_aft - ripplesin_tmp(i);
        end
        try
            up_post = st_up(find(st_up>ripplesin_tmp(i),1));
            ripples_res.inside.postup{p}(i) = up_post - ripplesin_tmp(i);
        end
        try
            down_post = st_down(find(st_down>ripplesin_tmp(i),1));
            ripples_res.inside.postdown{p}(i) = down_post - ripplesin_tmp(i);
        end
    end
    
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesInUpRasterNeuron.mat -v7.3 ripples_res t_start t_end binsize_mua neuron_pop maxDuration





