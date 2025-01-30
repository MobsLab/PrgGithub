%%AssessToneEffectMUAtypeTransitionsPlot
% 20.06.2018 KJ
%
%
%   Look at the response of neurons on tones and transitions
%
% see
%   AssessToneEffectMUAtype 
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'AssessToneEffectMUAtype.mat'))


colori = {'k', 'r', 'g', 'm'}; 
met_types = {'down_endo', 'down_indu', 'up_endo', 'up_indu'};
figtypes = {'Down Endogeneous', 'Down Induced', 'Up Endogeneous', 'Up Induced'};


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
titlesfig = {'Up>Down Endogeneous', 'Up>Down Induced', 'Down>Up Endogeneous', 'Down>Up Induced'};

figure, hold on
for k=1:length(met_types)
    subplot(2,2,k), hold on

    for i=1:length(neurons_pop)
        h(i) = plot(x_met.(met_types{k}).(neurons_pop{i}), y_mean.(met_types{k}).(neurons_pop{i}), 'color', colori{i}, 'linewidth', 2); hold on
        shadedErrorBar(x_met.(met_types{k}).(neurons_pop{i}), y_mean.(met_types{k}).(neurons_pop{i}), sem_mean.(met_types{k}).(neurons_pop{i})/10, colori{i},1);
    end
    ylim([0 3.2]),
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    ylabel('normalized firing rate'),
    
    
    if k==1
        lgd = legend(h, neurons_pop);
        lgd.Location = 'northwest';
    end
    
    xlabel('time from transitions (ms)'), 
    title(titlesfig{k}),
end


