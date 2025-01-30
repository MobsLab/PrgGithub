%%AssessToneEffectNeurons
% 14.04.2018 KJ
%
%
% see
%   ParcoursToneEffectOnNeurons ToneEffectOnNeurons
%   AssessToneEffectNeuronsPlot
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

sham_distrib=0;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p assess_res sham_distrib
    
    assess_res.path{p}   = Dir.path{p};
    assess_res.manipe{p} = Dir.manipe{p};
    assess_res.name{p}   = Dir.name{p};
    assess_res.date{p}   = Dir.date{p};


    %% init
    %params
    binsize_met = 10;
    nbBins_met  = 80;
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


    %% responding neurons
    Cdiff = Ctones.out - Csham.out;
    Ct_std = std(Ctones,[],2);
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

    %FR and nb_neuron
    assess_res.fr.all{p}      = mean(Data(MUA.all)) / (binsize_mua/1000);
    assess_res.fr.excited{p}  = mean(Data(MUA.excited)) / (binsize_mua/1000);
    assess_res.fr.neutral{p}  = mean(Data(MUA.neutral)) / (binsize_mua/1000);
    assess_res.fr.inhibit{p}  = mean(Data(MUA.inhibit)) / (binsize_mua/1000);

    assess_res.nb.all{p}      = length(NumNeurons);
    assess_res.nb.excited{p}  = length(excited_neurons);
    assess_res.nb.neutral{p}  = length(neutral_neurons);
    assess_res.nb.inhibit{p}  = length(inhibit_neurons);


    %% Tones in or out
    intwindow = 3000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);

    %tones in and out down states
    Allnight = intervalSet(0,max(Range(MUA.all)));
    ToneIn = Restrict(ToneEvent, down_PFCx);
    ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-aroundDown));

    %Down with or without
    intv_down = [Start(down_PFCx) End(down_PFCx)];
    [~,intv_with,~] = InIntervals(tones_tmp, intv_down);
    intv_with = unique(intv_with);
    intv_with(intv_with==0) = [];

    intv_without = setdiff(1:length(Start(down_PFCx)), intv_with);

    DownTone = intervalSet(intv_down(intv_with,1),intv_down(intv_with,2));
    DownNo   = intervalSet(intv_down(intv_without,1),intv_down(intv_without,2));


    %% Create Sham 
    nb_sham = 3000;
    idx = randsample(length(st_down), nb_sham);
    sham_tmp = [];

    if sham_distrib %same distribution as tones for delay(start_down,sham)
        
        %distribution of the delay start down - tones
        tonesin_tmp = Range(ToneIn);
        stdown_tones_distrib = nan(length(tonesin_tmp), 1);
        for i=1:length(tonesin_tmp)
            st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
            stdown_tones_distrib(i) = tonesin_tmp(i) - st_bef;
        end

        %generate
        edges_delay = 0:50:4000;
        [y_distrib, x_distrib] = histcounts(stdown_tones_distrib, edges_delay, 'Normalization','probability');
        x_distrib = x_distrib(1:end-1) + diff(x_distrib);
        delay_generated = GenerateNumbersDistribution_KJ(x_distrib, y_distrib, 6000);

        for i=1:length(idx)
            min_tmp = st_down(idx(i));
            duree  = end_down(idx(i))-st_down(idx(i));
            delays = randsample(delay_generated,1);

            if delays<duree
                sham_tmp = [sham_tmp min_tmp+delays];
            end
        end

    else %uniform sham
        for i=1:length(idx)
            min_tmp = st_down(idx(i));
            duree = end_down(idx(i))-st_down(idx(i));
            sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
        end
    end

    shamin_tmp = sort(sham_tmp);
    ShamIn = ts(shamin_tmp);


    %% MUA response for tones & sham
    neurons_pop = {'all','excited','neutral','inhibit'};
    
    for n=1:length(neurons_pop)
        
        npop = neurons_pop{n};

        % In down
        [m,~,tps] = mETAverage(Range(ToneIn), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.met_inside.(npop){p}(:,1) = tps; assess_res.met_inside.(npop){p}(:,2) = m;
        
        % out of down
        [m,~,tps] = mETAverage(Range(ToneOut), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.met_out.(npop){p}(:,1) = tps; assess_res.met_out.(npop){p}(:,2) = m;
        
        %sham in
        [m,~,tps] = mETAverage(Range(ShamIn), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.met_shamin.(npop){p}(:,1) = tps; assess_res.met_shamin.(npop){p}(:,2) = m;
        

        %% MUA response to the end of down states
        % with
        [m,~,tps] = mETAverage(End(DownTone), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.met_with.(npop){p}(:,1) = tps; assess_res.met_with.(npop){p}(:,2) = m;
        
        % without
        [m,~,tps] = mETAverage(End(DownNo), Range(MUA.(npop)), Data(MUA.(npop)), binsize_met, nbBins_met);
        assess_res.met_without.(npop){p}(:,1) = tps; assess_res.met_without.(npop){p}(:,2) = m;

    end
    
    %number of events
    assess_res.nb_inside{p} = length(ToneIn);
    assess_res.nb_out{p} = length(ToneOut);
    assess_res.nb_shamin{p} = length(ShamIn);
    
    assess_res.nb_with{p} = length(End(DownTone));
    assess_res.nb_without{p} = length(End(DownNo));

end


%saving data
cd(FolderDeltaDataKJ)
if sham_distrib
    save AssessToneEffectNeurons_2.mat assess_res sham_distrib binsize_met nbBins_met binsize_mua minDuration intwindow nb_sham neurons_pop
else
    save AssessToneEffectNeurons.mat assess_res sham_distrib binsize_met nbBins_met binsize_mua minDuration intwindow nb_sham neurons_pop
end




