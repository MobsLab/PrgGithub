%%ToneInUpRasterNeuron
% 18.04.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneInUpRasterNeuronPlot
%   ToneInDownRasterNeuronPlot2 ToneInDownRasterNeuron
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
    maxDuration  = 30e4;
    
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
    
    %Down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %5sec
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Tones in up
    ToneIn = Restrict(ToneEvent, up_PFCx);
    tonesin_tmp = Range(ToneIn);
    
    
    %% Rasters
    neuron_pop = {'all','excited','neutral','inhibit'};
    
    for i=1:length(neuron_pop)
        tones_res.rasters.inside.(neuron_pop{i}){p}  = RasterMatrixKJ(MUA.(neuron_pop{i}), ToneIn, t_start, t_end);
    end
    
    
    %% orders
    %tones in up
    tones_res.inside.before{p} = nan(length(tonesin_tmp), 1);
    tones_res.inside.after{p} = nan(length(tonesin_tmp), 1);
    tones_res.inside.postup{p} = nan(length(tonesin_tmp), 1);
    tones_res.inside.postdown{p} = nan(length(tonesin_tmp), 1);
    
    for i=1:length(tonesin_tmp)        
        st_bef = st_up(find(st_up<tonesin_tmp(i),1,'last'));
        tones_res.inside.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>tonesin_tmp(i),1));
        tones_res.inside.after{p}(i) = end_aft - tonesin_tmp(i);
        
        up_post = st_up(find(st_up>tonesin_tmp(i),1));
        tones_res.inside.postup{p}(i) = up_post - tonesin_tmp(i);
        
        down_post = st_down(find(st_down>tonesin_tmp(i),1));
        tones_res.inside.postdown{p}(i) = down_post - tonesin_tmp(i);

    end
    
end

%saving data
cd(FolderDeltaDataKJ)
save ToneInUpRasterNeuron.mat -v7.3 tones_res t_start t_end binsize_mua neuron_pop maxDuration





