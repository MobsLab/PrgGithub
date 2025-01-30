%%ParcoursRippleEffectOnNeurons
% 12.04.2018 KJ
%
%
% see
%   ParcoursToneEffectOnNeurons
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
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10; %in ts

    
    %% Create sham
    nb_sham=3000;
    sham_tmp = [];
    for i=1:nb_sham
        timeripple = randsample(ripples_tmp, 1);
        sham_tmp = [sham_tmp;timeripple + (rand-0.5)*2e4];
    end
    sham_tmp = sort(sham_tmp);


    %% spikes
    load('SpikeData.mat', 'neuronsLayers','S')
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    NumNeurons = number;
    neuronsLayers = neuronsLayers(NumNeurons);
    S = S(NumNeurons);


    %% correlo
    
    %Ripples
    for i=1:length(S)

        %all tones
        [CT, ~] = CrossCorr(ripples_tmp, Range(PoolNeurons(S,i)),10,400);
        baseline = CT(1:90);

        %all tones
        [Cripples(i,:), xrip] = CrossCorr(ripples_tmp, Range(PoolNeurons(S,i)),10,100);
        Cripples(i,:) = (Cripples(i,:) -mean(baseline)) / std(baseline);

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


    save('NeuronRipples', 'Cripples', 'xrip', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')


end


