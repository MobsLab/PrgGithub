%%ToneInDownRasterNeuron
% 18.04.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneInDownRasterNeuronPlot
%   ToneInDownRasterNeuronPlot2
%

clear

Dir = PathForExperimentsRandomTonesSpikes;


for p=1:length(Dir.path)

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
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    minDuration = 40;
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_tmp = Range(ToneEvent);
    
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
    
    tones_res.nb.all{p}     = length(NumNeurons);
    tones_res.nb.excited{p} = length(excited_neurons);
    tones_res.nb.neutral{p} = length(neutral_neurons);
    tones_res.nb.inhibit{p} = length(inhibit_neurons);
    
    
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
    
    
    %% Tones in or out
    intwindow = 2000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);
    upInterval = intervalSet(Start(down_PFCx)-intwindow, Start(down_PFCx));
    upInterval = CleanUpEpoch(and(upInterval, intervalSet(Start(down_PFCx), Start(down_PFCx)+intwindow)));
    

    %tones in and out down states
    Allnight = intervalSet(0,max(Range(MUA.all)));
    ToneIn = Restrict(ToneEvent, down_PFCx);
    ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-aroundDown));
    ToneAround = Restrict(ToneEvent, upInterval);
    
    tonesin_tmp = Range(ToneIn);
    tonesout_tmp = Range(ToneOut);
    tonesaround_tmp = Range(ToneAround);
    
    
    %% Rasters
    neuron_pop = {'all','excited','neutral','inhibit'};
    
    for i=1:length(neuron_pop)
        tones_res.rasters.inside.(neuron_pop{i}){p}  = RasterMatrixKJ(MUA.(neuron_pop{i}), ToneIn, t_start, t_end);
        tones_res.rasters.outside.(neuron_pop{i}){p} = RasterMatrixKJ(MUA.(neuron_pop{i}), ToneOut, t_start, t_end);
        tones_res.rasters.around.(neuron_pop{i}){p}  = RasterMatrixKJ(MUA.(neuron_pop{i}), ToneAround, t_start, t_end);
    end
    
    
    %% orders
    %tones in down
    tones_res.inside.before{p} = nan(length(tonesin_tmp), 1);
    tones_res.inside.after{p} = nan(length(tonesin_tmp), 1);
    tones_res.inside.postdown{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tones_res.inside.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tones_res.inside.after{p}(i) = end_aft - tonesin_tmp(i);
        
        down_post = st_down(find(st_down>tonesin_tmp(i),1));
        tones_res.inside.postdown{p}(i) = down_post - tonesin_tmp(i);

    end
    
    %tones around down
    tones_res.around.before{p} = nan(length(tonesaround_tmp), 1);
    tones_res.around.postdown{p} = nan(length(tonesaround_tmp), 1);
    for i=1:length(tonesaround_tmp)        
        st_bef = end_down(find(end_down<tonesaround_tmp(i),1,'last'));
        tones_res.around.before{p}(i) = tonesaround_tmp(i) - st_bef;
        
        down_post = st_down(find(st_down>tonesaround_tmp(i),1));
        tones_res.around.postdown{p}(i) = down_post - tonesaround_tmp(i);
    end
    
     
end

%saving data
cd(FolderDeltaDataKJ)
save ToneInDownRasterNeuron.mat -v7.3 tones_res t_start t_end binsize_mua neuron_pop minDuration





