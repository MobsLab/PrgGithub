%%ShortUpAnalysisPlot
% 27.06.2018 KJ
%
% analysis of short up states
%
%   see 
%       ShortUpAnalysis 
%


clear


%load
load(fullfile(FolderDeltaDataKJ,'ShortUpAnalysis.mat'))

%% params

%duration
hstep = 2;
max_edge_duration = 800;
edges_dur = 0:hstep:max_edge_duration;
%occurences
hstep = 0.5;
max_edge_occurence = 12;
edges_occur = 0:hstep:max_edge_occurence;
%firing rate
hstep = 0.05;
max_edge_fr = 3;
edges_fr = 0:hstep:max_edge_fr;

%plot type
stairsplot = 0;
smoothing = 1;

normalization = 'count';
normalization2 = 'probability';
% 'probability'; % 'count'probability


%% Concatenate


%Duration
short.durations   = [];
middle.durations  = [];
all.durations     = [];

for p=1:length(shortup_res.path)
    short.durations   = [short.durations ; shortup_res.short.durations{p}/10];
    middle.durations  = [middle.durations ; shortup_res.middle.durations{p}/10];
    all.durations     = [all.durations ; shortup_res.all.durations{p}/10];
end


%Occurence in the night
short.occurences   = [];
middle.occurences  = [];
all.occurences     = [];

for p=1:length(shortup_res.path)
    short.occurences   = [short.occurences ; shortup_res.short.start{p}/3600e4];
    middle.occurences  = [middle.occurences ; shortup_res.middle.start{p}/3600e4];
    all.occurences     = [all.occurences ; shortup_res.all.start{p}/3600e4];
end


%Substages
short.ratiosub.n1 = []; short.ratiosub.n2 = []; short.ratiosub.n3 = [];
middle.ratiosub.n1 = []; middle.ratiosub.n2 = []; middle.ratiosub.n3 = [];

for p=1:length(shortup_res.path)
    short.ratiosub.n1 = [short.ratiosub.n1 100*shortup_res.short.n1{p}/(shortup_res.short.n1{p}+shortup_res.short.n2{p}+shortup_res.short.n3{p})];
    short.ratiosub.n2 = [short.ratiosub.n2 100*shortup_res.short.n2{p}/(shortup_res.short.n1{p}+shortup_res.short.n2{p}+shortup_res.short.n3{p})];
    short.ratiosub.n3 = [short.ratiosub.n3 100*shortup_res.short.n3{p}/(shortup_res.short.n1{p}+shortup_res.short.n2{p}+shortup_res.short.n3{p})];
    
    middle.ratiosub.n1 = [middle.ratiosub.n1 100*shortup_res.middle.n1{p}/(shortup_res.middle.n1{p}+shortup_res.middle.n2{p}+shortup_res.middle.n3{p})];
    middle.ratiosub.n2 = [middle.ratiosub.n2 100*shortup_res.middle.n2{p}/(shortup_res.middle.n1{p}+shortup_res.middle.n2{p}+shortup_res.middle.n3{p})];
    middle.ratiosub.n3 = [middle.ratiosub.n3 100*shortup_res.middle.n3{p}/(shortup_res.middle.n1{p}+shortup_res.middle.n2{p}+shortup_res.middle.n3{p})];
    
end


%FR
short.firingrates   = [];
middle.firingrates  = [];
all.firingrates     = [];

for p=1:length(shortup_res.path)
    
    short.firingrates   = [short.firingrates shortup_res.short.fr{p}/shortup_res.fr{p}];
    middle.firingrates  = [middle.firingrates shortup_res.middle.fr{p}/shortup_res.fr{p}];
    all.firingrates     = [all.firingrates shortup_res.all.fr{p}/shortup_res.fr{p}];
end



%% Durations
[short.duration.y_distrib, short.duration.x_distrib] = histcounts(short.durations, edges_dur,'Normalization',normalization);
[middle.duration.y_distrib, middle.duration.x_distrib] = histcounts(middle.durations, edges_dur,'Normalization',normalization);
[all.duration.y_distrib, all.duration.x_distrib] = histcounts(all.durations, edges_dur,'Normalization',normalization);

short.duration.x_distrib = short.duration.x_distrib(1:end-1) + diff(short.duration.x_distrib);
middle.duration.x_distrib = middle.duration.x_distrib(1:end-1) + diff(middle.duration.x_distrib);
all.duration.x_distrib = all.duration.x_distrib(1:end-1) + diff(all.duration.x_distrib);


%% Occurence in the night
[short.occur.y_distrib, short.occur.x_distrib] = histcounts(short.occurences, edges_occur,'Normalization',normalization2);
[middle.occur.y_distrib, middle.occur.x_distrib] = histcounts(middle.occurences, edges_occur,'Normalization',normalization2);
[all.occur.y_distrib, all.occur.x_distrib] = histcounts(all.occurences, edges_occur,'Normalization',normalization2);

short.occur.x_distrib = short.occur.x_distrib(1:end-1) + diff(short.occur.x_distrib);
middle.occur.x_distrib = middle.occur.x_distrib(1:end-1) + diff(middle.occur.x_distrib);
all.occur.x_distrib = all.occur.x_distrib(1:end-1) + diff(all.occur.x_distrib);


%% Firing rates
[short.fr.y_distrib, short.fr.x_distrib] = histcounts(short.firingrates, edges_fr,'Normalization',normalization2);
[middle.fr.y_distrib, middle.fr.x_distrib] = histcounts(middle.firingrates, edges_fr,'Normalization',normalization2);
[all.fr.y_distrib, all.fr.x_distrib] = histcounts(all.firingrates, edges_fr,'Normalization',normalization2);

short.fr.x_distrib = short.fr.x_distrib(1:end-1) + diff(short.fr.x_distrib);
middle.fr.x_distrib = middle.fr.x_distrib(1:end-1) + diff(middle.fr.x_distrib);
all.fr.x_distrib = all.fr.x_distrib(1:end-1) + diff(all.fr.x_distrib);



%% DATA TO PLOT
if stairsplot
    
    [short.duration.x_plot, short.duration.y_plot] = stairs(short.duration.x_distrib, short.duration.y_distrib);
    [middle.duration.x_plot, middle.duration.y_plot] = stairs(middle.duration.x_distrib, middle.duration.y_distrib);
    [all.duration.x_plot, all.duration.y_plot] = stairs(all.duration.x_distrib, all.duration.y_distrib);
    
    [short.occur.x_plot, short.occur.y_plot] = stairs(short.occur.x_distrib, short.occur.y_distrib);
    [middle.occur.x_plot, middle.occur.y_plot] = stairs(middle.occur.x_distrib, middle.occur.y_distrib);
    [all.occur.x_plot, all.occur.y_plot] = stairs(all.occur.x_distrib, all.occur.y_distrib);
    
    [short.fr.x_plot, short.fr.y_plot] = stairs(short.fr.x_distrib, short.fr.y_distrib);
    [middle.fr.x_plot, middle.fr.y_plot] = stairs(middle.fr.x_distrib, middle.fr.y_distrib);
    [all.fr.x_plot, all.fr.y_plot] = stairs(all.fr.x_distrib, all.fr.y_distrib);

else
    short.duration.x_plot = short.duration.x_distrib;
    short.duration.y_plot = Smooth(short.duration.y_distrib, smoothing);
    middle.duration.x_plot = middle.duration.x_distrib;
    middle.duration.y_plot = Smooth(middle.duration.y_distrib, smoothing);
    all.duration.x_plot = all.duration.x_distrib;
    all.duration.y_plot = Smooth(all.duration.y_distrib, smoothing);
    
    short.occur.x_plot = short.occur.x_distrib;
    short.occur.y_plot = Smooth(short.occur.y_distrib, smoothing);
    middle.occur.x_plot = middle.occur.x_distrib;
    middle.occur.y_plot = Smooth(middle.occur.y_distrib, smoothing);
    all.occur.x_plot = all.occur.x_distrib;
    all.occur.y_plot = Smooth(all.occur.y_distrib, smoothing);

    short.fr.x_plot = short.fr.x_distrib;
    short.fr.y_plot = Smooth(short.fr.y_distrib, smoothing);
    middle.fr.x_plot = middle.fr.x_distrib;
    middle.fr.y_plot = Smooth(middle.fr.y_distrib, smoothing);
    all.fr.x_plot = all.fr.x_distrib;
    all.fr.y_plot = Smooth(all.fr.y_distrib, smoothing);

end

%substages
labelsbar = {'N1 short', 'N1 reg', 'N2 short', 'N2 reg', 'N3 short', 'N3 reg'};
barcolors = {'b','r','b','r','b','r'};
databar = {short.ratiosub.n1, middle.ratiosub.n1, short.ratiosub.n2, middle.ratiosub.n2, short.ratiosub.n3, middle.ratiosub.n3};
columntest = [nchoosek([1 3 5],2); nchoosek([2 4 6],2)];
columntest = [1 2 ; 3 4 ; 5 6];

%% PLOT
figure, hold on

%Up durations
subplot(2,2,1), hold on
plot(short.duration.x_plot, short.duration.y_plot, 'color', 'b', 'LineWidth',2); hold on,
plot(middle.duration.x_plot, middle.duration.y_plot, 'color', 'r', 'LineWidth',2); hold on,
plot(all.duration.x_plot, all.duration.y_plot, 'color', [0.6 0.6 0.6], 'LineWidth',2); hold on,

xlabel('duration (ms)'), ylabel(normalization)
set(gca,'XTick',0:100:max_edge_duration,'XLim',[0 max_edge_duration],'FontName','Times'), hold on,
legend('short', 'regular', 'all'),
title('Duration of up states')

%Up occurencess
subplot(2,2,2), hold on
plot(short.occur.x_plot, short.occur.y_plot, 'color', 'b', 'LineWidth',2); hold on,
plot(middle.occur.x_plot, middle.occur.y_plot, 'color', 'r', 'LineWidth',2); hold on,
plot(all.occur.x_plot, all.occur.y_plot, 'color', [0.6 0.6 0.6], 'LineWidth',2); hold on,

xlabel('debut (h)'), ylabel(normalization2)
set(gca,'XTick',0:1:max_edge_occurence,'XLim',[0 max_edge_occurence],'FontName','Times'), hold on,
legend('short', 'regular', 'all'),
title('Occurences of up states')

%Up firing rate
subplot(2,2,3), hold on
plot(short.fr.x_plot, short.fr.y_plot, 'color', 'b', 'LineWidth',2); hold on,
plot(middle.fr.x_plot, middle.fr.y_plot, 'color', 'r', 'LineWidth',2); hold on,
plot(all.fr.x_plot, all.fr.y_plot, 'color', [0.6 0.6 0.6], 'LineWidth',2); hold on,

xlabel('Firing rate (norm)'), ylabel(normalization2)
set(gca,'XTick',0:0.5:max_edge_fr,'XLim',[0 max_edge_fr],'FontName','Times'), hold on,
legend('short', 'regular', 'all'),
title('Mean Firing rates')

%Substages Error Bar
subplot(2,2,4), hold on
PlotErrorBarN_KJ(databar, 'newfig',0, 'paired', 1,  'barcolors',barcolors, 'ShowSigstar','sig','showpoints',1,'ColumnTest',columntest);
ylabel('%'),
set(gca,'xtick',1:6,'XtickLabel',labelsbar),
title('Percentage of up in substages'),






