%%InfoOnNeuronsResponsiveToRipplesPlot
% 20.09.2018 KJ
%
%
%   
%
% see
%   ParcoursRipplesNeuronCrossCorr ClassifyNeuronsResponseToRipples InfoOnNeuronsResponsiveToRipples
%   


%load
clear

load(fullfile(FolderDeltaDataKJ,'InfoOnNeuronsResponsiveToRipples.mat'))

%group of response
dc = distinguishable_colors(4);
for i=1:length(dc)
    colori{i} = dc(i,:);
end
labels = {'group1','group2','group3','group4'}; 

%layers
dc = distinguishable_colors(5);
for i=1:length(dc)
    colori_layer{i} = dc(i,:);
end
NameLayers = {'1','2','3','4','5'};

%substage
colori_substage = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
NameSubstages = {'N1','N2','N3','REM','Wake'};


%% pool
all_data.neuronClass = [];
all_data.firingrate = [];
all_data.substages = [];
all_data.layer = [];
all_data.soloist = [];
all_data.putative = [];
all_data.fr_substage = [];

for p=1:length(infos_res.path)
    
    all_data.neuronClass = [all_data.neuronClass ; infos_res.neuronClass{p}];
    all_data.firingrate = [all_data.firingrate ; infos_res.firingrate{p}];
    all_data.substages = [all_data.substages ; infos_res.substages{p}];
    all_data.layer = [all_data.layer ; infos_res.layer{p}];
    all_data.soloist = [all_data.soloist ; infos_res.soloist{p}];
    all_data.putative = [all_data.putative ; infos_res.putative{p}];
    all_data.fr_substage = [all_data.fr_substage ; infos_res.fr_substage{p}];
    
end

%% by class
nb_class = max(all_data.neuronClass);

for i=1:nb_class
    idx = all_data.neuronClass==i;
    
    byclass.firingrate{i} = all_data.firingrate(idx);
    byclass.substages{i} = all_data.substages(idx);
    byclass.layer{i} = all_data.layer(idx);
    byclass.soloist{i} = all_data.soloist(idx);
    byclass.putative{i} = all_data.putative(idx);
    byclass.fr_substage{i} = all_data.fr_substage(idx,:);
end



%% Plot
figure, hold on
edges_fr = 0:1:40;

%firing rates
subplot(2,3,1), hold on
PlotErrorBarN_KJ(byclass.firingrate, 'newfig',0, 'barcolors',colori, 'paired',0, 'showPoints',0,'ShowSigstar','sig');
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Firing rates'),

%layer
subplot(2,3,2), hold on

nb_layer_class = [];
for i=1:nb_class
    nb_per_layer = [0 0 0 0 0];
    for l=1:5
        nb_per_layer(l) = sum(byclass.layer{i}==l);
    end
    
    nb_layer_class = [nb_layer_class ; nb_per_layer];
end
h = bar(1:nb_class, nb_layer_class, 'stacked');
for i = 1:3
    h(i).FaceColor = 'flat';
    h(i).CData = colori_layer{i};
 end
set(gca,'xtick',1:4,'XtickLabel',labels),
legend(NameLayers)
title('putative layer');

%putative
subplot(2,3,3), hold on

nb_putative_class = [];
for i=1:nb_class
    nb_putative = [sum(byclass.putative{i}<0) sum(byclass.putative{i}>0)];
    
    nb_putative_class = [nb_putative_class ; nb_putative];
end
bar(1:nb_class, nb_putative_class, 'stacked');
set(gca,'xtick',1:4,'XtickLabel',labels),
legend('Interneuron','Pyramidal')
title('Putative Interneuron/pyramidale');

%soloist
subplot(2,3,4), hold on

nb_soloist_class = [];
for i=1:nb_class
    nb_soloist = [sum(byclass.soloist{i}==0) sum(byclass.soloist{i}==1)];
    
    nb_soloist_class = [nb_soloist_class ; nb_soloist];
end
bar(1:nb_class, nb_soloist_class, 'stacked');
set(gca,'xtick',1:4,'XtickLabel',labels),
legend('Chorist','Soloist')
title('Chorist/Soloist');

%substages
subplot(2,3,5), hold on

nb_substage_class = [];
for i=1:nb_class
    nb_per_substage = [0 0 0 0 0];
    for s=1:5
        nb_per_substage(s) = sum(byclass.substages{i}==s);
    end
    
    nb_substage_class = [nb_substage_class ; nb_per_substage];
end
h=bar(1:nb_class, nb_substage_class, 'stacked');
for i = 1:3
    h(i).FaceColor = 'flat';
    h(i).CData = colori_substage{i};
 end
set(gca,'xtick',1:4,'XtickLabel',labels),
legend(NameSubstages)
title('Prefered substage');


%% Plot in percentage
figure, hold on
edges_fr = 0:1:40;

%firing rates
subplot(2,3,1), hold on
PlotErrorBarN_KJ(byclass.firingrate, 'newfig',0, 'barcolors',colori, 'paired',0, 'showPoints',0,'ShowSigstar','sig');
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Firing rates'),

%layer
subplot(2,3,2), hold on

nb_layer_class = [];
for i=1:nb_class
    nb_per_layer = [0 0 0 0 0];
    for l=1:5
        nb_per_layer(l) = sum(byclass.layer{i}==l);
    end
    
    nb_layer_class = [nb_layer_class ; 100*nb_per_layer/sum(nb_per_layer)];
end
h = bar(1:nb_class, nb_layer_class, 'stacked');
for i = 1:3
    h(i).FaceColor = 'flat';
    h(i).CData = colori_layer{i};
 end
set(gca,'xtick',1:4,'XtickLabel',labels, 'xlim', [0 6]),
legend(NameLayers), ylabel('%'),
title('putative layer');

%putative
subplot(2,3,3), hold on

nb_putative_class = [];
for i=1:nb_class
    nb_putative = [sum(byclass.putative{i}<0) sum(byclass.putative{i}>0)];
    
    nb_putative_class = [nb_putative_class ; 100*nb_putative/sum(nb_putative)];
end
bar(1:nb_class, nb_putative_class, 'stacked');
set(gca,'xtick',1:4,'XtickLabel',labels),
legend('Interneuron','Pyramidal'), ylabel('%'),
title('Putative Interneuron/pyramidale');

%soloist
subplot(2,3,4), hold on

nb_soloist_class = [];
for i=1:nb_class
    nb_soloist = [sum(byclass.soloist{i}==0) sum(byclass.soloist{i}==1)];
    
    nb_soloist_class = [nb_soloist_class ; 100*nb_soloist/sum(nb_soloist)];
end
bar(1:nb_class, nb_soloist_class, 'stacked');
set(gca,'xtick',1:4,'XtickLabel',labels),
legend('Chorist','Soloist'), ylabel('%'),
title('Chorist/Soloist');

%substages
subplot(2,3,5), hold on

nb_substage_class = [];
for i=1:nb_class
    nb_per_substage = [0 0 0 0 0];
    for s=1:5
        nb_per_substage(s) = sum(byclass.substages{i}==s);
    end
    
    nb_substage_class = [nb_substage_class ; 100*nb_per_substage/sum(nb_per_substage)];
end
h=bar(1:nb_class, nb_substage_class, 'stacked');
for i = 1:3
    h(i).FaceColor = 'flat';
    h(i).CData = colori_substage{i};
 end
set(gca,'xtick',1:4,'XtickLabel',labels),
legend(NameSubstages), ylabel('%'),
title('Prefered substage');








