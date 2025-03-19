%%ParcoursToneEffectOnNeurons
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


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;

    %down
    load('DownState.mat', 'down_PFCx')
    
    %duration
    load('IdFigureData2.mat', 'night_duration')
    Allnight = intervalSet(0,night_duration);
    
    
    %% Tones out of down
    intwindow = 1000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);
    tones_tmp = Range(Restrict(ts(tones_tmp), CleanUpEpoch(Allnight-aroundDown)));
    
    %% Create sham
    nb_sham=3000;
    sham_tmp = [];
    for i=1:nb_sham
        timetone = randsample(tones_tmp, 1);
        sham_tmp = [sham_tmp;timetone + (rand-0.5)*4e4];
    end
    sham_tmp = sort(sham_tmp);


    %% spikes
    load('SpikeData.mat', 'neuronsLayers','S')
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    NumNeurons = number;
    neuronsLayers = neuronsLayers(NumNeurons);
    S = S(NumNeurons);


    %% correlo
    
    %Tones
    for i=1:length(S)

        %all tones
        [CT, ~] = CrossCorr(tones_tmp, Range(PoolNeurons(S,i)),10,400);
        baseline = CT(1:90);

        %all tones
        [Ctones(i,:), xtones] = CrossCorr(tones_tmp, Range(PoolNeurons(S,i)),10,100);
        Ctones(i,:) = (Ctones(i,:) -mean(baseline)) / std(baseline);

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


