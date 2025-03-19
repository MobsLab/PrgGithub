%%QuantifDeltaDownIntersectionPlot
% 12.09.2019 KJ
%
%   
%   
%
% see
%   FigureQuantifDeltaDownIntersection QuantifDeltaDownIntersection
%   


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifDeltaDownIntersection.mat'))


% unique animals & electrodes
[animals, electrodes, all_electrodes, ecogs] = Get_uniqueElectrodes_KJ(quantif_res);


for d=1:length(down_durations)
    %% Accuracy on down state detection

    % precision, recall, frechet distance, ratio decrease, 
    for i=1:size(electrodes,1)
        m = electrodes(i,1);
        elec = electrodes(i,2);

        elec_recall     = [];
        elec_precision  = [];
        elec_fscore     = [];

        %look for electrode data
        for p=1:length(quantif_res.path)
            if strcmpi(animals{m},quantif_res.name{p})
                channels = quantif_res.channels{p};
                for ch=1:length(channels)
                    if channels(ch)==elec
                        elec_recall     = [elec_recall 1-quantif_res.single.recall{p,d}(ch)];
                        elec_precision  = [elec_precision 1-quantif_res.single.precision{p,d}(ch)];
                        elec_fscore     = [elec_fscore quantif_res.single.fscore{p,d}(ch)];
                    end
                end
            end
        end

        %mean and save
        average_res.recall(i,d)    = mean(elec_recall);
        average_res.precision(i,d) = mean(elec_precision);
        average_res.fscore(i,d)    = mean(elec_fscore);
    end

    %% 2-layers
    for m=1:length(animals)
        elec_recall     = [];
        elec_precision  = [];
        elec_fscore     = [];

        %look for electrode data
        for p=1:length(quantif_res.path)
            if strcmpi(animals{m},quantif_res.name{p})
                elec_recall     = [elec_recall 1-max(quantif_res.multi.recall{p,d})];
                elec_precision  = [elec_precision 1-max(quantif_res.multi.precision{p,d})];
                elec_fscore     = [elec_fscore max(quantif_res.multi.fscore{p,d})];
            end
        end

        %mean and save
        multi_res.recall(m,d)    = mean(elec_recall);
        multi_res.precision(m,d) = mean(elec_precision);
        multi_res.fscore(m,d)    = mean(elec_fscore);
    end


    %% Best score for each animals
    for m=1:length(animals)

        idx_animal = electrodes(:,1)==m;   
        bestelec.recall{d}(m,1)    = max(average_res.recall(idx_animal,d));
        bestelec.precision{d}(m,1) = max(average_res.precision(idx_animal,d));
        bestelec.fscore{d}(m,1)    = min(average_res.fscore(idx_animal,d));

        bestelec.recall{d}(m,2)    = mean(average_res.recall(idx_animal,d));
        bestelec.precision{d}(m,2) = mean(average_res.precision(idx_animal,d));
        bestelec.fscore{d}(m,2)    = mean(average_res.fscore(idx_animal,d));

        bestelec.recall{d}(m,3)   = multi_res.recall(m,d);
        bestelec.precision{d}(m,3)= multi_res.precision(m,d);
        bestelec.fscore{d}(m,3)   = multi_res.fscore(m,d);

    end
    bestelec.recall{d} = bestelec.recall{d} * 100; %in %
    bestelec.precision{d} = bestelec.precision{d} * 100; %in %
    bestelec.fscore{d} = bestelec.fscore{d} * 100; %in %

    
end


%% down durations diff
duration_missed = [bestelec.recall{1}(:,3) bestelec.recall{2}(:,3) bestelec.recall{3}(:,3) bestelec.recall{4}(:,3)];
duration_fake   = [bestelec.precision{1}(:,3) bestelec.precision{2}(:,3) bestelec.precision{3}(:,3) bestelec.precision{4}(:,3)];


%% plot

figure, hold on

for d=1:length(down_durations)

    % Recall precision compare with two layers
    subplot(2,2,d), hold on

    show_sig = 'sig';
    barcolors={[0.2 0.1 0.2],'k',[0.7 0.7 0.7]};
    PlotErrorBarN_KJ(bestelec.recall{d}, 'x_data',1:3, 'newfig',0, 'barcolors','b', 'paired',1, 'ShowSigstar',show_sig); hold on
    PlotErrorBarN_KJ(bestelec.precision{d}, 'x_data',5:7, 'newfig',0, 'barcolors','r', 'paired',1, 'ShowSigstar',show_sig); hold on
%     PlotErrorBarN_KJ(bestelec.fscore{d}, 'x_data',9:11, 'newfig',0, 'barcolors', [0.3 0.3 0.3], 'paired',1, 'ShowSigstar',show_sig); hold on
    set(gca, 'xlim',[0 8], 'ylim',[0 120],'ytick',0:20:100),
    set(gca, 'XTick',[1:3 5:7] ,'XTickLabel',{'worst','best','2-layers','worst','best','2-layers'})
    ylabel('%')
    % xtickangle(30), 
    title(['down > ' num2str(down_durations(d)/10) 'ms'])

end


figure, hold on
subplot(1,2,1), hold on
PlotErrorBarN_KJ(duration_missed, 'newfig',0, 'barcolors','b', 'paired',1, 'ShowSigstar','none'); hold on
set(gca, 'xlim',[0 5], 'ylim', [0 100]),
set(gca, 'XTick',1:4,'XTickLabel',{'down>75ms','down>100ms','down>125ms','down>150ms'})
ylabel('% of missed')
title('Percentage of missed detection')

subplot(1,2,2), hold on
PlotErrorBarN_KJ(duration_fake, 'newfig',0, 'barcolors','r', 'paired',1, 'ShowSigstar','none'); hold on
set(gca, 'xlim',[0 5], 'ylim', [0 100]),
set(gca, 'XTick',1:4,'XTickLabel',{'down>75ms','down>100ms','down>125ms','down>150ms'})
ylabel('% of false positive')
title('Percentage of false detection')





