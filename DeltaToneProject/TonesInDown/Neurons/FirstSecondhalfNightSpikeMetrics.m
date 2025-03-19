%%FirstSecondhalfNightSpikeMetrics
% 02.08.2018 KJ
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
    %neuron info
    load(fullfile(transit_res.path{p},'InfoNeuronsPFCx.mat'), 'MatInfoNeurons', 'InfoNeurons')

    %params

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
    idn_inhib = effect_mean<-1 & t_mean <-1;
    idn_neutral = (effect_mean>-0.5 & effect_peak<3.5) | (t_mean>0 & t_peak<3*Ct_std);

    responses = zeros(length(NumNeurons),1);
    responses(idn_excit) = 1;
    responses(idn_inhib) = -1;
    responses(idn_neutral) = 0;

    excited_neurons = NumNeurons(responses==1);
    neutral_neurons = NumNeurons(responses==0);
    inhibit_neurons = NumNeurons(responses==-1);


    %% 
    first_endo = -transit_res.endo.first{p}/10;
    first_indu = -transit_res.indu.first{p}/10;

    halfsize = floor(size(first_endo,1)/2);

    for i=1:size(first_endo,2)
        begin.first(i) = nanmean(first_endo(1:halfsize,i));
        ending.first(i) = nanmean(first_endo(halfsize:end,i));    
        indu.first(i) = nanmean(first_indu(:,i));
    end


    %% Plot

    sz=25;
    colori = [0.55 0 0.55;0 0.7 0;1 0 0] ;

    figure, hold on
    subplot(2,2,1), hold on
    scatter(begin.first,ending.first,sz,'filled'),
    plot(0:300,0:300,'color',[0.7 0.7 0.7]),
    xlabel('mean first spike / 1st half'),
    ylabel('mean first spike / 2nd half'),
    title('1st vs 2nd half of the night - endogeneous')

    subplot(2,2,2), hold on
    plot(0:300,0:300,'color',[0.7 0.7 0.7]),
    gscatter(begin.first,indu.first, responses, colori);
    xlabel('mean first spike / 1st half'),
    ylabel('mean first spike / all induced'),
    title('1st half endo vs all induced'),

    subplot(2,2,3), hold on
    scatter(begin.first,indu.first,sz,'filled')
    plot(0:300,0:300,'color',[0.7 0.7 0.7]),
    xlabel('mean first spike / 1st half'),
    ylabel('mean first spike / all induced'),
    title('1st half endo vs all induced'),


    subplot(2,2,4), hold on
    scatter(ending.first,indu.first,sz,'filled'),
    plot(0:300,0:300,'color',[0.7 0.7 0.7]),
    xlabel('mean first spike / 2nd half'),
    ylabel('mean first spike / all induced'),
    title('2nd half endo vs all induced')

    suplabel(transit_res.path{p},'t');

end








