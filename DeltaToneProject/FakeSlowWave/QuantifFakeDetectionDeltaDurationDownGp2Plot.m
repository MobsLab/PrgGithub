%%QuantifFakeDetectionDeltaDurationDownGp2Plot
% 28.09.2019 KJ
%
%   
%   
%
% see
%   FigureCharacterisationDeltaDownStates
%   QuantifFakeDetectionDeltaDurationDownGp6
%   


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifFakeDetectionDeltaDurationDownGp2.mat'))


%% init 
%select nights and animals
list_path = [];
for p=1:length(quantif_res.path)
    try
        if ~isempty(quantif_res.channels{p})
            list_path = [list_path ; p];
        end
    end
end
animals = unique(quantif_res.name(list_path));

%electrodes
all_electrodes = [];
for p=1:length(list_path)
    channels = quantif_res.channels{list_path(p)};
    for ch=1:length(channels)
        row_elec = [find(strcmpi(animals,quantif_res.name{list_path(p)})) channels(ch)];
        all_electrodes = [all_electrodes ; row_elec];
    end

end
electrodes = unique(all_electrodes, 'rows');


%% Precision on down state detection
for d=1:length(duration_range)
    for i=1:size(electrodes,1)
        m = electrodes(i,1);
        elec = electrodes(i,2);

        elec_precision  = [];
        elec_recall     = [];
        elec_fscore     = [];
        %look for electrode data
        for p=1:length(quantif_res.path)
            if strcmpi(animals{m},quantif_res.name{p})
                channels = quantif_res.channels{p};
                for ch=1:length(channels)
                    if channels(ch)==elec
                        elec_precision  = [elec_precision 1-quantif_res.single.precision{p}(d,ch)];
                        elec_recall     = [elec_recall 1-quantif_res.single.recall{p}(d,ch)];
                        elec_fscore     = [elec_fscore quantif_res.single.fscore{p}(d,ch)];
                    end
                end
            end
        end

        %mean and save
        average_res.precision(i,d) = mean(elec_precision)*100;
        average_res.recall(i,d)    = mean(elec_recall)*100;
        average_res.fscore(i,d)    = mean(elec_fscore)*100;
    end

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
colori_clu3 = [0 0.5 0];
color_diff = [0.6 0.6 0.6];
x_plot = duration_range/10;

% 
figure, hold on

%precision
subplot(1,3,1), hold on
[~,h(1)]=PlotErrorLineN_KJ(average_res.precision, 'x_data',x_plot,'newfig',0,'linecolor',colori_clu3,'ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(multi_res.precision, 'x_data',x_plot,'newfig',0,'linecolor',color_diff,'ShowSigstar','none','errorbars',1,'linespec','-.');
set(gca,'xlim',[0 320], 'ylim',[0 100], 'xtick',0:50:300, 'fontsize', fontsize);
xlabel('Minimum down duration'), ylabel('% false positive')
legend(h, 'Group 2', '2-layers');

%recall
subplot(1,3,2), hold on
[~,h(1)]=PlotErrorLineN_KJ(average_res.recall, 'x_data',x_plot,'newfig',0,'linecolor',colori_clu3,'ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(multi_res.recall, 'x_data',x_plot,'newfig',0,'linecolor',color_diff,'ShowSigstar','none','errorbars',1,'linespec','-.');
set(gca,'xlim',[0 320], 'ylim',[0 100], 'xtick',0:50:300, 'fontsize', fontsize);
xlabel('Minimum down duration'), ylabel('% missed down')
legend(h, 'Group 2', '2-layers');

%fscore
subplot(1,3,3), hold on
[~,h(1)]=PlotErrorLineN_KJ(average_res.fscore, 'x_data',x_plot,'newfig',0,'linecolor',colori_clu3,'ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(multi_res.fscore, 'x_data',x_plot,'newfig',0,'linecolor',color_diff,'ShowSigstar','none','errorbars',1,'linespec','-.');
set(gca,'xlim',[0 320], 'ylim',[0 100], 'xtick',0:50:300, 'fontsize', fontsize);
xlabel('Minimum down duration'), ylabel('f-score')
legend(h, 'Group 2', '2-layers');









