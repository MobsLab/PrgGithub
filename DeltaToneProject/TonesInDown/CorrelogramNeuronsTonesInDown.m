%%CorrelogramNeuronsTonesInDown
% 19.04.2018 KJ
%
%
% see
%   ParcoursToneEffectOnNeurons CorrelogramNeuronsTonesInDownPlot
%



clear


Dir=PathForExperimentsDeltaSleepSpikes('RdmTone');

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p corr_res sham_distrib
    
    corr_res.path{p}   = Dir.path{p};
    corr_res.manipe{p} = Dir.manipe{p};
    corr_res.name{p}   = Dir.name{p};
    corr_res.date{p}   = Dir.date{p};


    %% init
    %params
    binsize1 = 1;
    binsize2 = 5;
    nbBins  = 100;
    
    
    binsize_mua = 2;
    minDuration = 40;

    %tone impact
    load('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')

    %neuron info
    load('InfoNeuronsPFCx.mat', 'MatInfoNeurons', 'InfoNeurons')

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);

    %substages
    load('SleepSubstages.mat')
    N2N3 = CleanUpEpoch(or(Epoch{2},Epoch{3}));
    
    %spikes
    load('SpikeData.mat', 'S')
    

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
    idn_inhib = effect_mean<-1. & t_mean <-1;
    
    responses = zeros(length(NumNeurons),1);
    responses(idn_excit) = 1;
    responses(idn_inhib) = -1;
    
    excited_neurons = NumNeurons(responses==1);
    neutral_neurons = NumNeurons(responses==0);
    inhibit_neurons = NumNeurons(responses==-1);
    
    
    %in down
    Cdiff = Ctones.in - Csham;
    Ct_std = std(Ctones.in,[],2);
    idt = xtones.in>0 & xtones.in<100;

    for i=1:length(neuronsLayers)
        effect_peak(i,1) = max(Cdiff(i,idt));        
        t_peak(i,1) = max(Ctones.out(i,idt));
    end

    idn_downex = effect_peak>4 & t_peak>3*Ct_std;
    down_neurons = NumNeurons(idn_downex==1 & responses==0);
    nodown_neurons = NumNeurons(idn_downex==0 & responses==0);

    
    %% Spikes

    %MUA
    Spikes.all      = PoolNeurons(S,NumNeurons);
    Spikes.excited  = PoolNeurons(S,excited_neurons);
    Spikes.neutral  = PoolNeurons(S,neutral_neurons);
    Spikes.inhibit  = PoolNeurons(S,inhibit_neurons);
    Spikes.down     = PoolNeurons(S,down_neurons);
    Spikes.nodown   = PoolNeurons(S,nodown_neurons);
    
    MUA.all  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA.all, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    

    %% Tones in or out
    intwindow = 3000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);

    %tones in and out down states
    Allnight = intervalSet(0,max(Range(MUA.all)));
    ToneIn   = Restrict(ToneEvent, down_PFCx);
    ToneOut  = Restrict(ToneEvent, CleanUpEpoch(Allnight-aroundDown));
    ToneNREM = Restrict(ToneEvent, CleanUpEpoch(N2N3-down_PFCx));

    %Down with or without
    intv_down = [Start(down_PFCx) End(down_PFCx)];
    [~,intv_with,~] = InIntervals(tones_tmp, intv_down);
    intv_with = unique(intv_with);
    intv_with(intv_with==0) = [];

    intv_without = setdiff(1:length(Start(down_PFCx)), intv_with);

    DownTone = intervalSet(intv_down(intv_with,1),intv_down(intv_with,2));
    DownNo   = intervalSet(intv_down(intv_without,1),intv_down(intv_without,2));


    %% Correlogram
    neurons_pop = {'all','excited','neutral','inhibit','down','nodown'};
    np_comb = nchoosek(1:length(neurons_pop),2);
    for n=1:length(neurons_pop)
        np_comb = [np_comb ; n n];
    end
    
    for i=1:size(np_comb,1)
        
        npop1 = neurons_pop{np_comb(i,1)};
        npop2 = neurons_pop{np_comb(i,2)};
        
        %Whole night
        t1 = Range(Spikes.(npop1));
        t2 = Range(Spikes.(npop2));
        if ~isempty(t1) && ~isempty(t2)
            [Cc1.night{np_comb(i,1),np_comb(i,2)}, xc1.night{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize1,nbBins);
            [Cc2.night{np_comb(i,1),np_comb(i,2)}, xc2.night{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize2,nbBins);
            if np_comb(i,1)~=np_comb(i,2)
                [Cc1.night{np_comb(i,2),np_comb(i,1)}, xc1.night{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize1,nbBins);
                [Cc2.night{np_comb(i,2),np_comb(i,1)}, xc2.night{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize2,nbBins);
            end
        end
        
        %Around down, N3
        intv = intervalSet(Range(ToneNREM), Range(ToneNREM) + 1000);
        intv = CleanUpEpoch(intv,1);
        t1 = Range(Restrict(Spikes.(npop1), intv));
        t2 = Range(Spikes.(npop2));
        if ~isempty(t1) && ~isempty(t2)
            [Cc1.nrem{np_comb(i,1),np_comb(i,2)}, xc1.nrem{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize1,nbBins);
            [Cc2.nrem{np_comb(i,1),np_comb(i,2)}, xc2.nrem{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize2,nbBins);
            if np_comb(i,1)~=np_comb(i,2)
                [Cc1.nrem{np_comb(i,2),np_comb(i,1)}, xc1.nrem{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize1,nbBins);
                [Cc2.nrem{np_comb(i,2),np_comb(i,1)}, xc2.nrem{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize2,nbBins);
            end
        end
        
        %After tones inside
        intv = intervalSet(Range(ToneIn), Range(ToneIn) + 1000);
        intv = CleanUpEpoch(intv,1);
        t1 = Range(Restrict(Spikes.(npop1), intv));
        t2 = Range(Spikes.(npop2));
        if ~isempty(t1) && ~isempty(t2)
            [Cc1.inside{np_comb(i,1),np_comb(i,2)}, xc1.inside{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize1,nbBins);
            [Cc2.inside{np_comb(i,1),np_comb(i,2)}, xc2.inside{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize2,nbBins);
            if np_comb(i,1)~=np_comb(i,2)
                [Cc1.inside{np_comb(i,2),np_comb(i,1)}, xc1.inside{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize1,nbBins);
                [Cc2.inside{np_comb(i,2),np_comb(i,1)}, xc2.inside{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize2,nbBins);
            end
        end
        
        %After tones out
        intv = intervalSet(Range(ToneOut), Range(ToneOut) + 1000);
        intv = CleanUpEpoch(intv,1);
        t1 = Range(Restrict(Spikes.(npop1), intv));
        t2 = Range(Spikes.(npop2));
        if ~isempty(t1) && ~isempty(t2)
            [Cc1.out{np_comb(i,1),np_comb(i,2)}, xc1.out{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize1,nbBins);
            [Cc2.out{np_comb(i,1),np_comb(i,2)}, xc2.out{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize2,nbBins);
            if np_comb(i,1)~=np_comb(i,2)
                [Cc1.out{np_comb(i,2),np_comb(i,1)}, xc1.out{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize1,nbBins);
                [Cc2.out{np_comb(i,2),np_comb(i,1)}, xc2.out{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize2,nbBins);
            end
        end

        %End of down with tone
        intv = intervalSet(End(DownTone), End(DownTone) + 1000);
        intv = CleanUpEpoch(intv,1);
        t1 = Range(Restrict(Spikes.(npop1), intv));
        t2 = Range(Spikes.(npop2));
        if ~isempty(t1) && ~isempty(t2)
            [Cc1.with{np_comb(i,1),np_comb(i,2)}, xc1.with{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize1,nbBins);
            [Cc2.with{np_comb(i,1),np_comb(i,2)}, xc2.with{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize2,nbBins);
            if np_comb(i,1)~=np_comb(i,2)
                [Cc1.with{np_comb(i,2),np_comb(i,1)}, xc1.with{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize1,nbBins);
                [Cc2.with{np_comb(i,2),np_comb(i,1)}, xc2.with{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize2,nbBins);
            end
        end    
        
        %End of down without tone
        intv = intervalSet(End(DownNo), End(DownNo) + 1000);
        intv = CleanUpEpoch(intv,1);
        t1 = Range(Restrict(Spikes.(npop1), intv));
        t2 = Range(Spikes.(npop2));
        if ~isempty(t1) && ~isempty(t2)
            [Cc1.without{np_comb(i,1),np_comb(i,2)}, xc1.without{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize1,nbBins);
            [Cc2.without{np_comb(i,1),np_comb(i,2)}, xc2.without{np_comb(i,1),np_comb(i,2)}] = CrossCorr(t1, t2, binsize2,nbBins);
            if np_comb(i,1)~=np_comb(i,2)
                [Cc1.without{np_comb(i,2),np_comb(i,1)}, xc1.without{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize1,nbBins);
                [Cc2.without{np_comb(i,2),np_comb(i,1)}, xc2.without{np_comb(i,2),np_comb(i,1)}] = CrossCorr(t2, t1, binsize2,nbBins);
            end
        end    
    end
    
    %save
    corr_res.corr1{p} = Cc1;
    corr_res.xc1{p}   = xc1;
    corr_res.corr2{p} = Cc2;
    corr_res.xc2{p}   = xc2;
    
    %number of events
    corr_res.nb_inside{p} = length(ToneIn);
    corr_res.nb_out{p}    = length(ToneOut);
    corr_res.nb_nrem{p}   = length(ToneNREM);
    
    corr_res.nb_with{p} = length(End(DownTone));
    corr_res.nb_without{p} = length(End(DownNo));

end


%saving data
cd(FolderDeltaDataKJ)
save CorrelogramNeuronsTonesInDown.mat corr_res binsize1 binsize2 nbBins binsize_mua minDuration intwindow neurons_pop





