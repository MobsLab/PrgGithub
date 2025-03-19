%%DownUpTransitionsSpikesMetrics2_Plot
% 17.07.2018 KJ
%
%
%   Look at the response of neurons on tones and transitions
%
% see
%   DownUpTransitionsSpikesMetrics1 DownUpTransitionsSpikesMetrics2
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'DownUpTransitionsSpikesMetrics2.mat'))
p=2;

Ccendo = metrics_res.ccendo{p};
Ccindu = metrics_res.ccindu{p};

Tendo = metrics_res.Tendo{p};
Tindu = metrics_res.Tindu{p};


%% concatenate
colordist.endo = [];
colordist.indu = [];

for i=1:length(Ccendo)
    colordist.endo = [colordist.endo ; Smooth(Ccendo{i}(Tendo>0),1)'];
    colordist.indu = [colordist.indu ; Smooth(Ccindu{i}(Tindu>0),1)'];
end
x_corr = Tendo(Tendo>0);


%% Norm and order
MatPlot{1} = colordist.endo;
MatPlot{2} = colordist.indu;

for i=1:length(MatPlot) 
%     MatPlot{i} = zscore(MatPlot{i},[],2);
    MatPlot{i} = SmoothDec(MatPlot{i}, [0.05 1]);
    MatPlot{i} = MatPlot{i} ./ max(MatPlot{i},[],2);
end

for i=1:length(MatPlot)    
    m = SmoothDec(MatPlot{i},[0.05 2]);
    [~, idx{i}] = max(m(:,x_corr<150),[],2);
    [~, idx{i}] = sort(idx{i},'descend');
    Mat{i} = MatPlot{i}(idx{i},:);
end

for i=1:length(MatPlot)
    m = x_corr' .* MatPlot{i};
    idx{i} = mean(m(:,x_corr<150),2);
    [~, idx{i}] = sort(idx{i},'descend');
    Mat{i} = MatPlot{i}(idx{i},:);
end

Mat{2} = MatPlot{2}(idx{1},:);


%% Plot

figure, hold on

%1
subplot(2,1,1), hold on
imagesc(x_corr, 1:size(Mat{1},1), Mat{1}), hold on
axis xy, hold on
set(gca,'YLim', [1 size(Mat{1},1)], 'xlim', [min(x_corr) 200]);
title('Endogen'),
ylabel('# neurons'),

%1
subplot(2,1,2), hold on
imagesc(x_corr, 1:size(Mat{2},1), Mat{2}), hold on
axis xy, hold on
set(gca,'YLim', [1 size(Mat{2},1)], 'xlim', [min(x_corr) 200]);
title('Induced'),
ylabel('# neurons'),



