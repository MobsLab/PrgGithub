%%QuantifIntersectionSWSupDeltaWavesStat
% 20.10.2019 KJ
%   
%
% see
%   QuantifIntersectionSWSupDeltaWaves
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifIntersectionSWSupDeltaWaves.mat'))
animals = unique(delta_res.name);


all_precision = [];
all_recall = [];

for m=1:length(animals)
    
    mouse_precision = [];
    mouse_recall = [];
    for p=1:length(delta_res.path)
        if strcmpi(delta_res.name{p}, animals{m})
            mouse_precision = [mouse_precision delta_res.precision(p)];
            mouse_recall = [mouse_recall delta_res.recall(p)];
        end
    end
    
    all_precision(m) = mean(mouse_precision);
    all_recall(m) = mean(mouse_recall);
   
end