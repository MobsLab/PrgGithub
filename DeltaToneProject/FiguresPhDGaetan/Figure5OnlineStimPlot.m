% Figure5OnlineStimPlot
% 11.12.2016 KJ
%
% Plot the figures from the Figure5.pdf of Gaetan PhD
% 
% 
%   see Figure5OnlineStim
%


clear
load([FolderProjetDelta 'Data/Figure5OnlineStim_bis.mat'])


delays = unique(cell2mat(figure5_res.delay));
animals = unique(figure5_res.name);
%params
center = nb_bins_MET/2 + 1;
center_raster = -t_before / (binsize_mua*10);
weighted_average = 0;

%% Delta LFP Amplitude

detect_deep = [];
detect_sup = [];
offline_deep = [];
offline_sup = [];
nbtot_detect = 0;
nbtot_offline = 0;

%loop over path
for p=1:length(figure5_res.path)
        if ~isempty( figure5_res.met.detect.deep.y{p}) & strcmpi(figure5_res.manipe{p},'DeltaToneAll')
            
            if weighted_average==1
                nb_detect = figure5_res.nb.detections{p};
                nb_offline = figure5_res.nb.delta{p};
            else
                nb_detect = 1;
                nb_offline = 1;
            end
            
            if isempty(detect_deep)
                detect_deep = figure5_res.met.detect.deep.y{p} * nb_detect;
                detect_sup = figure5_res.met.detect.sup.y{p} * nb_detect;
                
                offline_deep = figure5_res.met.offline.deep.y{p} * nb_offline;
                offline_sup = figure5_res.met.offline.sup.y{p} * nb_offline;
            else
                detect_deep = [detect_deep figure5_res.met.detect.deep.y{p} * nb_detect];
                detect_sup = [detect_sup figure5_res.met.detect.sup.y{p} * nb_detect];
                
                offline_deep = [offline_deep figure5_res.met.offline.deep.y{p} * nb_offline];
                offline_sup = [offline_sup figure5_res.met.offline.sup.y{p} * nb_offline];
            end
            nbtot_detect = nbtot_detect + nb_detect;
            nbtot_offline = nbtot_offline + nb_offline;
            timestamps = figure5_res.met.detect.sup.x{p};
        end
end

detect_mua = mean(detect_deep,2) / nbtot_detect;
detect_lfp_sup = mean(detect_sup,2) / nbtot_detect;
offline_lfp_deep = mean(offline_deep,2) / nbtot_offline;
offline_lfp_sup = mean(offline_sup,2) / nbtot_offline;

%% plot
figure, hold on
plot(timestamps/1E3, detect_mua,'k'), hold on
plot(timestamps/1E3, detect_lfp_sup,'b'), hold on
plot(timestamps/1E3, offline_lfp_deep,'r'), hold on
plot(timestamps/1E3, offline_lfp_sup,'m'), hold on
line([0 0], ylim), hold on
set(gca, 'XLim', [-1 1]); xlabel('time (s)'); ylabel('amplitude');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MUA

detect_mua = [];
nbtot_detect = 0;

%loop over path
for p=1:length(figure5_res.path)
        if ~isempty(figure5_res.met.detect.deep.y{p}) & strcmpi(figure5_res.manipe{p},'DeltaToneAll')
            
            if weighted_average==1
                nb_detect = figure5_res.nb.detections{p};
            else
                nb_detect = 1;
            end
            
            if isempty(detect_mua)
                detect_mua = figure5_res.met.detect.mua.y{p} * nb_detect / figure5_res.nb_neuron{p};
            else
                detect_mua = [detect_mua figure5_res.met.detect.mua.y{p} * nb_detect / figure5_res.nb_neuron{p}];
            end
            nbtot_detect = nbtot_detect + nb_detect;
            timestamps = figure5_res.met.detect.mua.x{p};
        end
end
mean_detect_mua = mean(detect_mua,2) / nbtot_detect;

for m=1:length(animals)
    detect_mua_animal = [];
    nbtot_detect_animal = 0;
    %loop over path
    for p=1:length(figure5_res.path)
            if ~isempty(figure5_res.met.detect.deep.y{p}) & strcmpi(figure5_res.manipe{p},'DeltaToneAll') & strcmpi(figure5_res.name{p},animals{m})

                if weighted_average==1
                    nb_detect = figure5_res.nb.detections{p};
                else
                    nb_detect = 1;
                end

                if isempty(detect_mua_animal)
                    detect_mua_animal = figure5_res.met.detect.mua.y{p} * nb_detect / figure5_res.nb_neuron{p};
                else
                    detect_mua_animal = [detect_mua_animal figure5_res.met.detect.mua.y{p} * nb_detect / figure5_res.nb_neuron{p}];
                end
                nbtot_detect_animal = nbtot_detect_animal + nb_detect;
                timestamps = figure5_res.met.detect.mua.x{p};
            end
    end
    animal_detect_mua{m} = mean(detect_mua_animal,2) / nbtot_detect_animal;
end

%% plot
figure, hold on
for m=1:length(animal_detect_mua)
    plot(timestamps/1E3, animal_detect_mua{m}), hold on
end
legend(animals)
plot(timestamps/1E3, mean_detect_mua,'k','Linewidth',2), hold on
line([0 0], ylim), hold on
set(gca, 'XLim', [-1 1]); xlabel('time (s)'); ylabel('firing rate');







