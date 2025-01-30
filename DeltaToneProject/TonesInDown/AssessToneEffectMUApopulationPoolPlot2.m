%%AssessToneEffectMUApopulationPoolPlot2
% 14.04.2018 KJ
%
%
% see
%   AssessToneEffectNeuronsPlot AssessToneEffectMUApopulation     
%   AssessToneEffectMUApopulationPoolPlot
%


%load
clear
sham_distrib = 0; %sham distribution from tones distribution

if sham_distrib
    load(fullfile(FolderDeltaDataKJ,'AssessToneEffectMUApopulation_2.mat'))
else
    load(fullfile(FolderDeltaDataKJ,'AssessToneEffectMUApopulation.mat'))
end

colori = {'b','r', 'g', [0.2 0.2 0.2], 'k' , [0.5 0.5 0.5]};
met_types = {'met_out', 'met_inside', 'met_nrem','met_shamin', 'met_with', 'met_without'};
figtypes = {'out', 'inside', 'nrem', 'with', 'without'};


%% Pool data
smoothing = 1;

for i=1:length(neurons_pop)
    for k=1:length(met_types)
        y_met.(met_types{k}).(neurons_pop{i}) = [];
        x_met.(met_types{k}).(neurons_pop{i}) = assess_res.(met_types{k}).(neurons_pop{i}){1}(:,1);
    end
end
    
for k=1:length(met_types)
    for i=1:length(neurons_pop)
        for p=1:4
            y_data = Smooth(assess_res.(met_types{k}).(neurons_pop{i}){p}(:,2)/(binsize_mua*1e-3), smoothing);
            if mean(y_data)<10
                continue
            end
            
            y_data = y_data / mean(y_data(1:10));
            y_met.(met_types{k}).(neurons_pop{i}) = [y_met.(met_types{k}).(neurons_pop{i}) y_data];  %in Hz
        end
        
    end
end

%mean
for i=1:length(neurons_pop)
    for k=1:length(met_types)
        %mean of all records
        y_mean.(met_types{k}).(neurons_pop{i}) = Smooth(mean(y_met.(met_types{k}).(neurons_pop{i}),2), 0);
    end
end


%% PLOT
gap = [0.08 0.04];
legendsmet = {'outside', 'inside', 'N2/N3', 'Sham'};
legends2 = {'with tone', 'without tone'};

figure, hold on
for i=1:length(neurons_pop)
    subtightplot(2,4,i, gap), hold on
    clear h
    for k=1:4
        h(k) = plot(x_met.(met_types{k}).(neurons_pop{i}), y_mean.(met_types{k}).(neurons_pop{i}), 'color', colori{k}, 'linewidth', 2); hold on
    end
    ylim([0 3]),
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    xlabel('time from tones (ms)'), 
    if i==1
        ylabel('normalized firing rate'),
        lgd = legend(h, legendsmet);
        lgd.Location = 'northwest';
    end
    title(neurons_pop{i}),
    
    
    subtightplot(2,4,i+4, gap), hold on
    clear h
    for k=5:6
        h(k-4) = plot(x_met.(met_types{k}).(neurons_pop{i}), y_mean.(met_types{k}).(neurons_pop{i}), 'color', colori{k}, 'linewidth', 2); hold on
    end
    ylim([0 3.5]),
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    xlabel('time from end of down state (ms)'), 
    if i==1
        ylabel('normalized firing rate'),
        lgd = legend(h, legends2);
        lgd.Location = 'northwest';
    end
    title(neurons_pop{i}),
    
end










