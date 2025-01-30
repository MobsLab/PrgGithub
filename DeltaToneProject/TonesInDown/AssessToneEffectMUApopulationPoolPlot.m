%%AssessToneEffectMUApopulationPoolPlot
% 14.04.2018 KJ
%
%
% see
%   AssessToneEffectNeuronsPlot AssessToneEffectMUApopulation
%


%load
clear
sham_distrib = 0; %sham distribution from tones distribution

if sham_distrib
    load(fullfile(FolderDeltaDataKJ,'AssessToneEffectMUApopulation_2.mat'))
else
    load(fullfile(FolderDeltaDataKJ,'AssessToneEffectMUApopulation.mat'))
end

colori = {'k', 'r', 'g', 'm'}; %g
met_types = {'met_out', 'met_inside', 'met_nrem', 'met_with', 'met_without','met_endo'};
figtypes = {'out', 'inside', 'nrem', 'with', 'without','endogeneous'};


%% Pool data
smoothing = 2;

for i=1:length(neurons_pop)
    for k=1:length(met_types)
        y_met.(met_types{k}).(neurons_pop{i}) = [];
        sem_met.(met_types{k}).(neurons_pop{i}) = [];
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
            sem_data = Smooth(assess_res.(met_types{k}).(neurons_pop{i}){p}(:,3)/(binsize_mua*1e-3), smoothing);
            
            y_data = y_data / mean(y_data(1:10));
            y_met.(met_types{k}).(neurons_pop{i}) = [y_met.(met_types{k}).(neurons_pop{i}) y_data];  %in Hz
            
            sem_data = sem_data / mean(sem_data(1:10));
            sem_met.(met_types{k}).(neurons_pop{i}) = [sem_met.(met_types{k}).(neurons_pop{i}) sem_data];  %in Hz
        end
        
    end
end

%mean
for i=1:length(neurons_pop)
    for k=1:length(met_types)
        %mean of all records
        y_mean.(met_types{k}).(neurons_pop{i}) = Smooth(mean(y_met.(met_types{k}).(neurons_pop{i}),2), 0);
        sem_mean.(met_types{k}).(neurons_pop{i}) = Smooth(mean(sem_met.(met_types{k}).(neurons_pop{i}),2), 0);
    end
end


%% PLOT
titlesfig = {'Tones out of down', 'Tones in down', 'Tones out off down, in N2/N3', 'Down ends with tone', 'Down ends (no tone)', 'Endogeneous down start'};

figure, hold on
for k=1:length(met_types)
    subplot(2,3,k), hold on

    for i=1:length(neurons_pop)
        h(i) = plot(x_met.(met_types{k}).(neurons_pop{i}), y_mean.(met_types{k}).(neurons_pop{i}), 'color', colori{i}, 'linewidth', 2); hold on
        shadedErrorBar(x_met.(met_types{k}).(neurons_pop{i}), y_mean.(met_types{k}).(neurons_pop{i}), sem_mean.(met_types{k}).(neurons_pop{i})/10, colori{i},1);
    end
    ylim([0 3]),
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    ylabel('normalized firing rate'),
    
    
    if k==1
        lgd = legend(h, neurons_pop);
        lgd.Location = 'northwest';
    end
    
    if k<4
        xlabel('time from tones (ms)'), 
    else
        xlabel('time from end of down state (ms)'), 
    end
    title(titlesfig{k}),
end



