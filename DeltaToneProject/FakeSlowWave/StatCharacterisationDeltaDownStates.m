%%StatCharacterisationDeltaDownStates
% 19.10.2019 KJ
%
%   
%   
%
% see
%   FigureCharacterisationDeltaDownStates CharacterisationDeltaDownStates
%



% load
clear
load(fullfile(FolderDeltaDataKJ,'CharacterisationDeltaDownStates.mat'))

normfrcurve = 1;
smoothingfr = 2;
smoothingcc = 0;
amplitude_range = [-1000 -10 60 200 300 600];
factorLFP = 0.195;

exclude = [[8 31]];

% unique animals & electrodes
[animals, electrodes, all_electrodes, ecogs] = Get_uniqueElectrodes_KJ(layer_res,'exclude',{'Mouse330'});


idexclude = ismember(electrodes, exclude, 'rows');
electrodes(idexclude,:)=[];
ecogs(idexclude)=[];
all_electrodes(ismember(all_electrodes, exclude, 'rows'),:) = [];


%% Features in 1D-space

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_elecdown    = [];
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    y_elecdown = [y_elecdown layer_res.down.meandown{p}{ch}(:,2)*factorLFP];            
                    x_elecdown = layer_res.down.meandown{p}{ch}(:,1);                   
                end
            end
        end
    end
    
    average_res.y_elecdown{i} = mean(y_elecdown,2);     
    average_res.x_elecdown{i} = x_elecdown; 

end


    
%features extraction
for i=1:size(electrodes,1)
    
    xi = average_res.x_elecdown{i};
    yi = average_res.y_elecdown{i};
    %postive deflection
    if sum(yi(xi>0 & xi<=150))>0
        idx = xi>0 & xi<=200;
        Xp(i,1) = max(yi(idx));
    %negative deflection
    else
        idx = xi>0 & xi<=250;
        Xp(i,1) = min(yi(idx));
    end
    
end


%% Clusters
%clustering
clusterX = nan(length(Xp),1);

for c=1:length(amplitude_range)-1
    cond = Xp>amplitude_range(c) & Xp<=amplitude_range(c+1);
    clusterX(cond) = c+1;
end
clusterX(ecogs==1) = 1;
nb_clusters = length(unique(clusterX));



%% Accuracy on down state detection

% precision, recall, frechet distance, ratio decrease, 
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    elec_recall     = [elec_recall 1-layer_res.single.recall{p}(ch)];
                    elec_precision  = [elec_precision 1-layer_res.single.precision{p}(ch)];
                    elec_fscore     = [elec_fscore layer_res.single.fscore{p}(ch)];
                end
            end
        end
    end
    
    %mean and save
    average_res.recall(i)    = mean(elec_recall);
    average_res.precision(i) = mean(elec_precision);
    average_res.fscore(i)    = mean(elec_fscore);
end

%data for plot line
for c=1:nb_clusters
    yline.recall{c}    = average_res.recall(clusterX==c) * 100;
    yline.precision{c} = average_res.precision(clusterX==c) * 100;
    yline.fscore{c}    = average_res.fscore(clusterX==c) * 100;
end


%% multi layer
%2-layers
for m=1:length(animals)
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];

    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            elec_recall     = [elec_recall 1-max(layer_res.multi.recall{p})];
            elec_precision  = [elec_precision 1-max(layer_res.multi.precision{p})];
            elec_fscore     = [elec_fscore max(layer_res.multi.fscore{p})];
        end
    end

    %mean and save
    multi_res.recall(m)    = mean(elec_recall);
    multi_res.precision(m) = mean(elec_precision);
    multi_res.fscore(m)    = mean(elec_fscore);
end


%% Best score for each animals
for m=1:length(animals)
    
    
    idx_animal = electrodes(:,1)==m;   
    bestelec.recall(m,1)    = max(average_res.recall(idx_animal));
    bestelec.precision(m,1) = max(average_res.precision(idx_animal));
    bestelec.fscore(m,1)    = min(average_res.fscore(idx_animal));
    
    bestelec.recall(m,2)    = mean(average_res.recall(idx_animal));
    bestelec.precision(m,2) = mean(average_res.precision(idx_animal));
    bestelec.fscore(m,2)    = mean(average_res.fscore(idx_animal));
    
    bestelec.recall(m,3)   = multi_res.recall(m);
    bestelec.precision(m,3)= multi_res.precision(m);
    bestelec.fscore(m,3)   = multi_res.fscore(m);
    
end
bestelec.recall = bestelec.recall * 100; %in %
bestelec.precision = bestelec.precision * 100; %in %
bestelec.fscore = bestelec.fscore * 100; %in %



%% Stat clusters
l = cellfun(@length,yline.precision);
precision_clusters = nan(max(l),length(yline.precision));
for i=1:length(yline.precision)
    precision_clusters(1:length(yline.precision{i}),i) = yline.precision{i}';
end

%normal
[pval1,tbl,stats] = kruskalwallis(precision_clusters);



%% Stat worst/best/2-layers
for i=1:3
    A{i} = bestelec.precision(:,i);
end

[p12,h12,stat12]= signrank(A{1},A{2});
[p13,h13,stat13]= signrank(A{1},A{3});
[p23,h23,stat23]= signrank(A{2},A{3});












