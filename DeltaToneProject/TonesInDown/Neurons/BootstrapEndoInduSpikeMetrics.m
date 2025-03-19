%%BootstrapEndoInduSpikeMetrics
% 08.08.2018 KJ
%
%
%   metrics in 1st and 2nd half of the night
%
% see
%   DownUpTransitionsSpikesMetrics1  FirstSecondhalfNightSpikeMetrics2
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'DownUpTransitionsSpikesMetrics1.mat'))

for p=1:length(transit_res.path)
    
    clearvars -except transit_res p
    
    speth = transit_res.speth{p};

    %tone impact
    load(fullfile(transit_res.path{p},'NeuronTones.mat'), 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')


    %% Bootstrap
    first_endo = -transit_res.endo.first{p}/10;
    first_indu = -transit_res.indu.first{p}/10;
    
    nb_tones = size(first_indu,1);
    nb_neurons = size(first_endo,2);
    
    %induced
    for i=1:nb_neurons
        indu.first(i) = nanmean(first_indu(:,i));
    end
    
    %bootstrap on endogeneous
    
    for i=1:nb_neurons
        neuron_endo = first_endo(:,i);
        for k=1:1000
            endo.first(i,k) = nanmean(datasample(neuron_endo,nb_tones));
        end
    end
    
    
    %% data top plot
    sc_endo1 = [];
    sc_endo2 = [];
    sc_indu = [];
    
    for i=1:nb_neurons
        for k=1:30
            sc_endo1 = [sc_endo1 ; datasample(endo.first(i,:)',100)];
            sc_endo2 = [sc_endo2 ; datasample(endo.first(i,:)',100)];
            sc_indu  = [sc_indu ; repmat(indu.first(i), [100 1])];
        end
    end
    

    %% Plot

    sz=25;
    colori = [0.55 0 0.55;0 0.7 0;1 0 0] ;

    figure, hold on
    subplot(2,2,1), hold on
    scatter(sc_endo1,sc_endo2,sz,'filled'),
    plot(0:300,0:300,'color',[0.7 0.7 0.7]),
    xlabel('mean first spike 1'),
    ylabel('mean first spike 2'),
    title('endogeneous - bootstrap')

    subplot(2,2,2), hold on
    plot(0:300,0:300,'color',[0.7 0.7 0.7]),
    scatter(sc_endo1,sc_indu,sz,'filled'),
    xlabel('mean first spike / endogeneous'),
    ylabel('mean first spike /  induced'),
    title('endo vs induced'),


    suplabel(transit_res.path{p},'t');

end








