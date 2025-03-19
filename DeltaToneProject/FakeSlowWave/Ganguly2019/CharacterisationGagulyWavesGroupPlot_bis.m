%%CharacterisationGagulyWavesGroupPlot_bis
% 23.11.2019 KJ
%
% Infos
%
% see
%    CharacterisationGagulyWavesGroup 


% load
clear
load(fullfile(FolderDeltaDataKJ,'CharacterisationGagulyWavesGroup.mat'))


%params
cludeep = 3:6;

%% Get electrodes, animals

%animals
animals = unique(ganguly_res.name);

%animals that have each layer
for i=1:length(cludeep)
    animalsclu{i}=cell(0);
    for p=1:length(ganguly_res.path)
        if ismember(cludeep(i),ganguly_res.clusters{p})
            animalsclu{i}{end+1} = ganguly_res.name{p};
        end
    end
    animalsclu{i} = unique(animalsclu{i});
end


%% 
for i=1:length(cludeep)
    average_diff.recall{i}   = []; average_diff.precision{i}   = []; average_diff.fscore{i}   = [];
    average_so.recall{i}     = []; average_so.precision{i}     = []; average_so.fscore{i}     = [];
    average_deltag.recall{i} = []; average_deltag.precision{i} = []; average_deltag.fscore{i} = [];
    
    for m=1:length(animalsclu{i})
        mouse_recall.diff   = []; mouse_precision.diff   = []; mouse_fscore.diff   = [];
        mouse_recall.so     = []; mouse_precision.so     = []; mouse_fscore.so     = [];
        mouse_recall.deltag = []; mouse_precision.deltag = []; mouse_fscore.deltag = [];
        
        %loop over nights
        for p=1:length(ganguly_res.path)
            if strcmpi(animalsclu{i}{m},ganguly_res.name{p})
                
                mouse_recall.diff    = [mouse_recall.diff 1-ganguly_res.diff.recall{p}];
                mouse_precision.diff = [mouse_precision.diff 1-ganguly_res.diff.precision{p}];
                mouse_fscore.diff    = [mouse_fscore.diff ganguly_res.diff.fscore{p}];
                
                channels = ganguly_res.channels{p};
                clusters = ganguly_res.clusters{p};
                for ch=1:length(channels)
                    if clusters(ch) == cludeep(i)
                        mouse_recall.so    = [mouse_recall.so 1-ganguly_res.so.recall{p}(ch)];
                        mouse_precision.so = [mouse_precision.so 1-ganguly_res.so.precision{p}(ch)];
                        mouse_fscore.so    = [mouse_fscore.so ganguly_res.so.fscore{p}(ch)];
                        
                        mouse_recall.deltag    = [mouse_recall.deltag 1-ganguly_res.deltag.recall{p}(ch)];
                        mouse_precision.deltag = [mouse_precision.deltag 1-ganguly_res.deltag.precision{p}(ch)];
                        mouse_fscore.deltag    = [mouse_fscore.deltag ganguly_res.deltag.fscore{p}(ch)];
                    end
                end
            end
        end
        
        %averaged per mouse
        average_diff.recall{i}(m,1) = mean(mouse_recall.diff)*100;
        average_diff.precision{i}(m,1) = mean(mouse_precision.diff)*100;
        average_diff.fscore{i}(m,1) = mean(mouse_fscore.diff)*100;
        
        average_so.recall{i}(m,1) = mean(mouse_recall.so)*100;
        average_so.precision{i}(m,1) = mean(mouse_precision.so)*100;
        average_so.fscore{i}(m,1) = mean(mouse_fscore.so)*100;
        
        average_deltag.recall{i}(m,1) = mean(mouse_recall.deltag)*100;
        average_deltag.precision{i}(m,1) = mean(mouse_precision.deltag)*100;
        average_deltag.fscore{i}(m,1) = mean(mouse_fscore.deltag)*100;
        
    end
end


%% data to plot

for c=1:length(cludeep)

    data_recall{c}    = [average_diff.recall{c} average_so.recall{c} average_deltag.recall{c}];
    data_precision{c} = [average_diff.precision{c} average_so.precision{c} average_deltag.precision{c}];
    data_fscore{c}    = [average_diff.fscore{c} average_so.fscore{c} average_deltag.fscore{c}];
end

%% Plot

fontsize = 18;
labels = {'2-layers','SO','\delta'};
colori = {'k',[0.7 0.7 0.7], [1 0.3 0.7]};

figure, hold on
for c=1:length(cludeep)
    
    subplot(1,length(cludeep),c), hold on
    PlotErrorBarN_KJ(data_precision{c}, 'newfig',0, 'barcolors', colori, 'paired',1, 'ShowSigstar','sig','showpoints',1); hold on
    set(gca, 'ylim',[0 100], 'ytick',0:20:100, 'xlim', [0 4], 'xtick', 1:3, 'XTickLabel',labels,'fontsize',fontsize), 
    ylabel('% false postive'), xtickangle(30)
    title(['group' num2str(cludeep(c))])
end


figure, hold on
for c=1:length(cludeep)
    
    subplot(1,length(cludeep),c), hold on
    PlotErrorBarN_KJ(data_recall{c}, 'newfig',0, 'barcolors', colori, 'paired',1, 'ShowSigstar','sig','showpoints',1); hold on
    set(gca, 'ylim',[0 120], 'ytick',0:20:100, 'xlim', [0 4], 'xtick', 1:3, 'XTickLabel',labels,'fontsize',fontsize), 
    ylabel('% missed'), xtickangle(30)
    title(['group' num2str(cludeep(c))])
end


figure, hold on
for c=1:length(cludeep)
    
    subplot(1,length(cludeep),c), hold on
    PlotErrorBarN_KJ(data_fscore{c}, 'newfig',0, 'barcolors', colori, 'paired',1, 'ShowSigstar','sig','showpoints',1); hold on
    set(gca, 'ylim',[0 100], 'ytick',0:20:100, 'xlim', [0 4], 'xtick', 1:3, 'XTickLabel',labels,'fontsize',fontsize), 
    ylabel('fscore'), xtickangle(30)
    title(['group' num2str(cludeep(c))])
end



