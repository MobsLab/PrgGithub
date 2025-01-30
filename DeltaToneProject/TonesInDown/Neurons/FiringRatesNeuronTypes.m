%%FiringRatesNeuronTypes
% 02.08.2018 KJ
%
%
%   
%
% see
%   DownUpTransitionsSpikesMetrics1  FirstSecondhalfNightSpikeMetrics
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'DownUpTransitionsSpikesMetrics1.mat'))

AllFr{1} = [];
AllFr{2} = [];
AllFr{3} = [];

for p=1:length(transit_res.path)
    
    clearvars -except transit_res p Matfr AllFr
    
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

    
    %% firing rates
    firingrates = transit_res.firingrate{p};
    
    Matfr{p}{1} = firingrates(excited_neurons);
    Matfr{p}{2} = firingrates(neutral_neurons);
    Matfr{p}{3} = firingrates(inhibit_neurons);
    
    AllFr{1} = [AllFr{1} firingrates(excited_neurons)];
    AllFr{2} = [AllFr{2} firingrates(neutral_neurons)];
    AllFr{3} = [AllFr{3} firingrates(inhibit_neurons)];
    
end

%% Plot
labels = {'excited', 'neutral', 'inhibited'};

figure, hold on

for p=1:length(Matfr)
    subplot(2,3,p), hold on
    PlotErrorBarN_KJ(Matfr{p}, 'newfig',0, 'barcolors',{'r','g','m'}, 'paired',0, 'ShowSigstar','sig');
    set(gca,'xtick',1:length(labels),'XtickLabel',labels)
    title([transit_res.name{p} ' - ' num2str(p)])
end

figure, hold on

for p=1:length(Matfr)
    subplot(2,3,p), hold on
    PlotErrorSpreadN_KJ(Matfr{p}, 'newfig',0, 'plotcolors',{'r','g','m'}, 'paired',0, 'ShowSigstar','sig');
    set(gca,'xtick',1:length(labels),'XtickLabel',labels)
    title([transit_res.name{p} ' - ' num2str(p)])
end

figure, hold on
PlotErrorSpreadN_KJ(AllFr, 'newfig',0, 'plotcolors',{'r','g','m'}, 'paired',0, 'ShowSigstar','sig');
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('ALL NIGHTS')




 
