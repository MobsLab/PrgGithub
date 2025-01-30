%%QuantifFakeDetectionDeltaDurationDownPlotAll
% 28.09.2019 KJ
%
%   
%   
%
% see
%   FigureCharacterisationDeltaDownStates QuantifFakeDetectionDeltaDurationDown
%   


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifFakeDetectionDeltaDurationDown.mat'))


%% init 

%params
list_clusters = 1:6;
nb_clusters = 6;

animals = unique(quantif_res.name);

%electrodes
all_electrodes = [];
for p=1:length(quantif_res.path)
    channels = quantif_res.channels{p};
    clusterX = quantif_res.clusters{p};
    for ch=1:length(channels)
        row_elec = [find(strcmpi(animals,quantif_res.name{p})) channels(ch) clusterX(ch)];
        all_electrodes = [all_electrodes ; row_elec];
    end

end
electrodes = unique(all_electrodes, 'rows');


%% Precision on down state detection

for d=1:length(duration_range)
    for i=1:size(electrodes,1)
        m = electrodes(i,1);
        elec = electrodes(i,2);
        clu = electrodes(i,3);

        elec_precision  = [];
        elec_recall     = [];
        elec_fscore     = [];
        %look for electrode data
        for p=1:length(quantif_res.path)
            if strcmpi(animals{m},quantif_res.name{p})
                channels = quantif_res.channels{p};
                clusterRec = quantif_res.clusters{p};
                for ch=1:length(channels)
                    if channels(ch)==elec && clusterRec(ch)==clu
                        elec_precision  = [elec_precision 1-quantif_res.single.precision{p}(d,ch)];
                        elec_recall     = [elec_recall 1-quantif_res.single.recall{p}(d,ch)];
                        elec_fscore     = [elec_fscore quantif_res.single.fscore{p}(d,ch)];
                    end
                end
            end
        end

        %mean and save
        elec_res.precision(i,d) = mean(elec_precision)*100;
        elec_res.recall(i,d)    = mean(elec_recall)*100;
        elec_res.fscore(i,d)    = mean(elec_fscore)*100;
    end

end


%% Clusters

for c=1:nb_clusters
    idx = electrodes(:,3)==c;
    
    average_res.precision{c} = elec_res.precision(idx,:);
    average_res.recall{c}    = elec_res.recall(idx,:);
    average_res.fscore{c}    = elec_res.fscore(idx,:);
    
end



%% 2-layers
for d=1:length(duration_range)
    for m=1:length(animals)
        elec_precision  = [];
        elec_recall     = [];
        elec_fscore     = [];
        
        %look for electrode data
        for p=1:length(quantif_res.path)
            if strcmpi(animals{m},quantif_res.name{p})
                try
                    elec_precision  = [elec_precision 1-max(quantif_res.multi.precision{p}(d,:))];
                    elec_recall     = [elec_recall 1-max(quantif_res.multi.recall{p}(d,:))];
                    elec_fscore     = [elec_fscore max(quantif_res.multi.fscore{p}(d,:))];
                end
            end
        end

        %mean and save
        multi_res.precision(m,d) = mean(elec_precision)*100;
        multi_res.recall(m,d)    = mean(elec_recall)*100;
        multi_res.fscore(m,d)    = mean(elec_fscore)*100;
    end
end


%% PLOT

fontsize = 20;
x_plot = duration_range/10;
labels = {'ECog','group 1','group 2','group 3','group 4','group 5','2-layers'};

% colors
color_diff = [0.6 0.6 0.6];

colori{1} = [0 0 0];
colori{2} = [0 0 1];
colori{3} = [0 0.5 0];
colori{4} = [1 0 0.3];
colori{5} = [1 0.45 0];
colori{6} = [1 0 0];
% 
figure, hold on

%precision
subplot(1,3,1), hold on
for c=1:nb_clusters
    [~,h(c)] = PlotErrorLineN_KJ(average_res.precision{c}, 'x_data',x_plot,'newfig',0,'linecolor',colori{c},'ShowSigstar','none','errorbars',1,'linespec','-.');
end
[~,h(nb_clusters+1)]=PlotErrorLineN_KJ(multi_res.precision, 'x_data',x_plot,'newfig',0,'linecolor',color_diff,'ShowSigstar','none','errorbars',1,'linespec','-.');
set(gca,'xlim',[0 320], 'ylim',[0 100], 'xtick',0:50:300, 'fontsize', fontsize);
xlabel('Minimum down duration'), ylabel('% false positive')

figure, hold on

%recall
subplot(1,3,2), hold on
for c=1:nb_clusters
    [~,h(c)] = PlotErrorLineN_KJ(average_res.recall{c}, 'x_data',x_plot,'newfig',0,'linecolor',colori{c},'ShowSigstar','none','errorbars',1,'linespec','-.');
end
[~,h(nb_clusters+1)]=PlotErrorLineN_KJ(multi_res.recall, 'x_data',x_plot,'newfig',0,'linecolor',color_diff,'ShowSigstar','none','errorbars',1,'linespec','-.');
set(gca,'xlim',[0 320], 'ylim',[0 100], 'xtick',0:50:300, 'fontsize', fontsize);
xlabel('Minimum down duration'), ylabel('% missed down')

figure, hold on
%fscore
subplot(1,3,3), hold on
for c=1:nb_clusters
    [~,h(c)] = PlotErrorLineN_KJ(average_res.fscore{c}, 'x_data',x_plot,'newfig',0,'linecolor',colori{c},'ShowSigstar','none','errorbars',1,'linespec','-.');
end
[~,h(nb_clusters+1)]=PlotErrorLineN_KJ(multi_res.fscore, 'x_data',x_plot,'newfig',0,'linecolor',color_diff,'ShowSigstar','none','errorbars',1,'linespec','-.');
set(gca,'xlim',[0 320], 'ylim',[0 100], 'xtick',0:50:300, 'fontsize', fontsize);
xlabel('Minimum down duration'), ylabel('f-score')
legend(h, labels);









