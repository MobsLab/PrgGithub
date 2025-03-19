%%DownUpTransitionsSpikesMetrics1_Plot
% 17.07.2018 KJ
%
%
%   Look at the response of neurons on tones and transitions
%
% see
%   DownUpTransitionsSpikesMetrics1 
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'DownUpTransitionsSpikesMetrics1.mat'))
p=6;
speth = transit_res.speth{p};

%params
max_edge = 500;
hstep = 3;
edges = 0:hstep:max_edge;
normalization = 'probability';


%% 
first_endo = -transit_res.endo.first{p}/10;
mean_endo  = -transit_res.endo.meansp{p}/10;
first_indu = -transit_res.indu.first{p}/10;
mean_indu  = -transit_res.indu.meansp{p}/10;

peth_endo = [];
peth_indu = [];

for i=1:length(speth.endo.y)
    peth_endo = [peth_endo ; speth.endo.y{i}'];
    peth_indu = [peth_indu ; speth.indu.y{i}'];
end

colordist.endo.first = [];
colordist.endo.mean = [];
colordist.indu.first = [];
colordist.indu.mean = [];

for i=1:size(first_endo,2)
    [y_distrib, x_distrib] = histcounts(first_endo(:,i), edges,'Normalization',normalization);
    y_distrib = y_distrib(2:end);
    x_distrib = x_distrib(2:end-1);
    colordist.endo.first = [colordist.endo.first ; y_distrib/max(y_distrib)];
    
    [y_distrib, x_distrib] = histcounts(mean_endo(:,i), edges,'Normalization',normalization);
    y_distrib = y_distrib(2:end);
    x_distrib = x_distrib(2:end-1);
    colordist.endo.mean = [colordist.endo.mean ; y_distrib/max(y_distrib)];
    
    [y_distrib, x_distrib] = histcounts(first_indu(:,i), edges,'Normalization',normalization);
    y_distrib = y_distrib(2:end);
    x_distrib = x_distrib(2:end-1);
    colordist.indu.first = [colordist.indu.first ; y_distrib/max(y_distrib)];
    
    [y_distrib, x_distrib] = histcounts(mean_indu(:,i), edges,'Normalization',normalization);
    y_distrib = y_distrib(2:end);
    x_distrib = x_distrib(2:end-1);
    colordist.indu.mean = [colordist.indu.mean ; y_distrib/max(y_distrib)];
    
end

firingrates = transit_res.firingrate{p};
[~, id] = sort(firingrates);

%% Order

MatPlot{1} = colordist.endo.first;
MatPlot{2} = colordist.endo.mean;
MatPlot{3} = colordist.indu.first;
MatPlot{4} = colordist.indu.mean;

MatPETH{1} = peth_endo;
MatPETH{2} = peth_indu;


idxdist = x_distrib<=200;
%
for i=1:4
    [~, idx{i}] = max(SmoothDec(MatPlot{i}(:,idxdist),[0.05 2]),[],2);
    [~, idx{i}] = sort(idx{i},'descend');
    Mat{i} = MatPlot{i}(idx{i},:);
end


%first spike
[~, idx{1}] = max(SmoothDec(MatPlot{1}(:,idxdist),[0.05 3]),[],2);
[~, idx{1}] = sort(idx{1},'descend');
Mat{1} = MatPlot{1}(idx{1},:);

%mass center
idx{2} = mean(SmoothDec(MatPlot{2},[0.05 4]),2);
[~, idx{2}] = sort(idx{2},'descend');
Mat{2} = MatPETH{1}(idx{2},:);


Mat{3} = MatPlot{3}(idx{1},:);
Mat{4} = MatPlot{4}(idx{2},:);

Mat{3} = MatPlot{1}(idx{2},:);
Mat{4} = MatPETH{1}(idx{3},:);


%% Plot

figure, hold on

%1
subplot(2,2,1), hold on
imagesc(x_distrib, 1:size(Mat{1},1), Mat{1}), hold on
axis xy, hold on
set(gca,'YLim', [1 size(Mat{1},1)], 'XLim',[0 max_edge-hstep]);
title('First spike'),
ylabel('# neurons'),

%1
subplot(2,2,2), hold on
imagesc(x_distrib, 1:size(Mat{2},1), Mat{2}), hold on
axis xy, hold on
set(gca,'YLim', [1 size(Mat{2},1)], 'XLim',[0 max_edge-hstep]);
title('Mass center'),
ylabel('# neurons'),

%3
subplot(2,2,3), hold on
imagesc(x_distrib, 1:size(Mat{3},1), Mat{3}), hold on
axis xy, hold on
set(gca,'YLim', [1 size(Mat{3},1)], 'XLim',[0 max_edge-hstep]);
title('First spike'),
ylabel('# neurons'),

%4
subplot(2,2,4), hold on
imagesc(x_distrib, 1:size(Mat{4},1), Mat{4}), hold on
axis xy, hold on
set(gca,'YLim', [1 size(Mat{4},1)], 'XLim',[0 max_edge-hstep]);
title('Mass center'),
ylabel('# neurons'),





