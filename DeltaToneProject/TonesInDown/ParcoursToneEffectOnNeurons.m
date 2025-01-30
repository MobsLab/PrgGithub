%%ParcoursToneEffectOnNeurons2
% 12.04.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneEffectOnNeurons
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

Dir = PathForExperimentsRandomTonesSpikes;


for p=5:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p

    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_tmp = Range(ToneEvent);

    %down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    
    %duration
    if exist('IdFigureData2.mat','file')==2
        load('IdFigureData2.mat', 'night_duration')
    else
        load('LFPData/LFP0.mat')
        night_duration = max(Range(LFP));
        clear LFP
    end
    Allnight = intervalSet(0,night_duration);
    
    
    %% Tones in or out
    intwindow = 8000; %800ms
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);

    %tones in and out down states
    ToneIn = Restrict(ToneEvent, down_PFCx);
    ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-aroundDown));
    ToneUp = Restrict(ToneEvent, up_PFCx);
    
    tonesin_tmp = Range(ToneIn);
    tonesout_tmp = Range(ToneOut);
    tonesup_tmp = Range(ToneUp);
    
    
    %% Create sham
    nb_sham=4000;
    sham_tmp = [];
    for i=1:nb_sham
        timetone = randsample(tones_tmp, 1);
        sham_tmp = [sham_tmp;timetone + (rand-0.5)*4e4];
    end
    sham_tmp = sort(sham_tmp);


    %% spikes
    load('SpikeData.mat','S')
    load('InfoNeuronsAll.mat', 'InfoNeurons')
    NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx'));
    neuronsLayers = InfoNeurons.layer(NumNeurons);
    S = S(NumNeurons);


    %% correlo
    
    %Tones
    for i=1:length(S)

        %all tones BASELINE
        [CT, ~] = CrossCorr(tones_tmp, Range(PoolNeurons(S,i)),10,400);
        baseline = CT(1:90);

        %tones out
        [Ctones.out(i,:), xtones.out] = CrossCorr(tonesout_tmp, Range(PoolNeurons(S,i)),10,100);
        Ctones.out(i,:) = (Ctones.out(i,:) -mean(baseline)) / std(baseline);
        
        %tones in
        [Ctones.in(i,:), xtones.in] = CrossCorr(tonesin_tmp, Range(PoolNeurons(S,i)),10,100);
        Ctones.in(i,:) = (Ctones.in(i,:) -mean(baseline)) / std(baseline);
        
        %tones around
        [Ctones.up(i,:), xtones.around] = CrossCorr(tonesup_tmp, Range(PoolNeurons(S,i)),10,100);
        Ctones.up(i,:) = (Ctones.up(i,:) -mean(baseline)) / std(baseline);

    end

    %Sham
    for i=1:length(S)

        %all tones
        [CT, ~] = CrossCorr(sham_tmp, Range(PoolNeurons(S,i)),10,400);
        baseline = CT(1:50);

        %all tones
        [Csham(i,:), xsham] = CrossCorr(sham_tmp, Range(PoolNeurons(S,i)),10,100);
        Csham(i,:) = (Csham(i,:) -mean(baseline)) / std(baseline);

    end
    
    responses = QuantifyPethResponse(S, ts(tones_tmp));


    save('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers', 'responses')


end


