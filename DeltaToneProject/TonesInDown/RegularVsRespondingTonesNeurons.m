%%RegularVsRespondingTonesNeurons
% 16.04.2018 KJ
%
%
% see
%   ParcoursToneEffectOnNeurons ToneEffectOnNeurons
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

sham_distrib=1;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p assess_res sham_distrib
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};


    %% init
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    binsize_mua = 2;
    minDuration = 75;

    %tone impact
    load('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')

    %neuron info
    load('InfoNeuronsPFCx.mat', 'MatInfoNeurons', 'InfoNeurons')
    load('SpikeData.mat', 'S')
    load('IdFigureData2.mat', 'night_duration')

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);


    %% responding neurons
    Cdiff = Ctones - Csham;
    idt = xtones>0 & xtones<80;

    for i=1:length(neuronsLayers)
        effect_peak(i) = max(Cdiff(i,idt));
        effect_mean(i) = mean(Cdiff(i,idt));
    end

    responses = zeros(length(neuronsLayers),1);
    idn = effect_peak>4;
    resp_neurons = NumNeurons(idn);
    regular_neurons = NumNeurons(~idn);
    
    
    %% Correlation matrix
    newS = [S(resp_neurons) S(regular_neurons)];
    
    t_step=0:50:night_duration; %5ms
    iFR=nan(length(newS),length(t_step)); iFRz=iFR;
    for i=1:length(newS)
        iFR(i,:) = hist(Range(newS{i}),t_step);
    end
           
    MatCor = corrcoef(iFR');


    %% MUA

    %MUA
    MUA.all  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    MUA.resp = GetMuaNeurons_KJ(resp_neurons,'binsize',binsize_mua); 
    MUA.reg  = GetMuaNeurons_KJ(regular_neurons,'binsize',binsize_mua);

    %Down
    down_PFCx = FindDownKJ(MUA.all, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);

    %FR and nb_neuron
    tones_res.fr.all{p}  = mean(Data(MUA.all)) / (binsize_mua/1000);
    tones_res.fr.resp{p} = mean(Data(MUA.resp)) / (binsize_mua/1000);
    tones_res.fr.reg{p}  = mean(Data(MUA.reg)) / (binsize_mua/1000);

    tones_res.nb.all{p}  = length(NumNeurons);
    tones_res.nb.resp{p} = length(resp_neurons);
    tones_res.nb.reg{p}  = length(regular_neurons);


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
    
    
    %number of events
    tones_res.nb_inside{p} = length(ToneIn);
    tones_res.nb_out{p} = length(ToneOut);
    tones_res.nb_shamin{p} = length(ShamIn);
    
    tones_res.nb_with{p} = length(End(DownTone));
    tones_res.nb_without{p} = length(End(DownNo));


    
    %% Correlograms on whole night
    [C] = CrossCorr(MUA.resp, MUA.reg, binsize_met,nbBins_met);
    
    
        [CT, ~] = CrossCorr(tones_tmp, Range(PoolNeurons(S,i)),10,400);
        baseline = CT(1:90);

        %all tones
        [Ctones(i,:), xtones] = CrossCorr(tones_tmp, Range(PoolNeurons(S,i)),10,100);
        Ctones(i,:) = (Ctones(i,:) -mean(baseline)) / std(baseline);
    
    
    
    %% Correlogram on 
    
 

end


%saving data
cd(FolderDeltaDataKJ)
save RegularVsRespondingTonesNeurons.mat tones_res sham_distrib binsize_met nbBins_met binsize_mua minDuration intwindow nb_sham conditions





