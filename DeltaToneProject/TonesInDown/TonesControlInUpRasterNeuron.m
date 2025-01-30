%%TonesControlInUpRasterNeuron
% 18.05.2018 KJ
%
%
% see
%   ShamInUpRasterNeuron ToneInDownRasterNeuron
%

clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

sham_distrib = 1;

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p sham_res sham_distrib
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    maxDuration  = 10e4;
    nb_sham = 3000;
    
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);
    
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
    
    sham_res.nb.all{p}     = length(NumNeurons);
    sham_res.nb.excited{p} = length(excited_neurons);
    sham_res.nb.neutral{p} = length(neutral_neurons);
    sham_res.nb.inhibit{p} = length(inhibit_neurons);
    
    
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
    
    
    %% Delay between tones and down

    %tones in
    tonesin_tmp = Range(Restrict(ToneEvent, up_PFCx));
    
    tones_bef = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tones_bef(i) = tonesin_tmp(i) - st_bef;
    end
    
    
    %% Create Sham 
    idx = randsample(length(st_up), nb_sham);
    sham_tmp = [];
        
    if sham_distrib %same distribution as tones for delay(start_down,sham)

        %distribution
        edges_delay = 0:50:4000;
        [y_distrib, x_distrib] = histcounts(tones_bef, edges_delay, 'Normalization','probability');
        x_distrib = x_distrib(1:end-1) + diff(x_distrib);
        delay_generated = GenerateNumbersDistribution_KJ(x_distrib, y_distrib, 6000);

        for i=1:length(idx)
            min_tmp = st_up(idx(i));
            duree  = end_up(idx(i))-st_up(idx(i));
            delays = randsample(delay_generated,1);

            if delays<duree
                sham_tmp = [sham_tmp min_tmp+delays];
            end
        end
    
    else %uniform sham
        for i=1:length(idx)
            min_tmp = st_up(idx(i));
            duree = end_up(idx(i))-st_up(idx(i));
            sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
        end
    end
    
    shamin_tmp = sort(sham_tmp);
    ShamIn = ts(shamin_tmp);
    
    
    %% Rasters
    neuron_pop = {'all','excited','neutral','inhibit'};
    
    for i=1:length(neuron_pop)
        sham_res.rasters.inside.(neuron_pop{i}){p}  = RasterMatrixKJ(MUA.(neuron_pop{i}), ShamIn, t_start, t_end);
    end
    
    
    %% orders
    %sham in down
    sham_res.inside.before{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.after{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.postdown{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        sham_res.inside.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        sham_res.inside.after{p}(i) = end_aft - shamin_tmp(i);
        
        up_post = st_up(find(st_up>shamin_tmp(i),1));
        sham_res.inside.postup{p}(i) = up_post - shamin_tmp(i);

    end

     
end

%saving data
cd(FolderDeltaDataKJ)
if sham_distrib
    save TonesControlInUpRasterNeuron_2.mat -v7.3 sham_res t_start t_end binsize_mua neuron_pop maxDuration sham_distrib nb_sham
else
    save TonesControlInUpRasterNeuron.mat -v7.3 sham_res t_start t_end binsize_mua neuron_pop maxDuration sham_distrib nb_sham
end



