% MeanSpecgramGraphPlot_VC
% 05.07.2017 KJ
%
% Mean spectrogram sync on stimulation time - VIRTUAL CHANNEL DATA
% -> Collect data
%
%
%   see 
%       MeanSpecgramGraph_VC
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'MeanSpecgramGraph_VC2.mat'])

conditions = unique(meanspec_res.condition);
cond_random = find(strcmpi(conditions,'random'));
cond_sham = find(strcmpi(conditions,'sham'));
cond_up = find(strcmpi(conditions,'upphase'));


%% BASELINE FOR EACH CONDITION
for cond=1:length(conditions)
    baseline = [];
    
    for p=1:length(meanspec_res.filename)
        if strcmpi(meanspec_res.condition{p},conditions{cond})
            
            t_value = meanspec_res.dreem.times{p};
            f_value = meanspec_res.dreem.freq{p};
            
            if isempty(baseline)
                baseline = meanspec_res.dreem.Specg{p} * meanspec_res.nb_tones{p};
                nb_tones = meanspec_res.nb_tones{p};
            else
                baseline = baseline + meanspec_res.dreem.Specg{p} * meanspec_res.nb_tones{p};
                nb_tones = nb_tones + meanspec_res.nb_tones{p};
            end
        end
    end
    baseline = baseline / nb_tones;
    meanspec_graph.baseline{cond} = baseline(t_value<met_window,:);
    
end


%% DREEM
for cond=1:length(conditions)
    meanspec_graph.spec{cond} = [];
    
    for p=1:length(meanspec_res.filename)
        if strcmpi(meanspec_res.condition{p},conditions{cond})
            
            
            t_value = meanspec_res.dreem.times{p};
            f_value = meanspec_res.dreem.freq{p};
            Sp_value = meanspec_res.dreem.Specg{p}(t_value>met_window,:);
                        
            if isempty(meanspec_graph.spec{cond})
                meanspec_graph.spec{cond} = Sp_value * meanspec_res.nb_tones{p};
                nb_tones = meanspec_res.nb_tones{p};
            else
                meanspec_graph.spec{cond} = meanspec_graph.spec{cond} + Sp_value * meanspec_res.nb_tones{p};
                nb_tones = nb_tones + meanspec_res.nb_tones{p};
            end
        end
    end
    
    meanspec_graph.x{cond} = t_value(t_value>met_window);
    meanspec_graph.y{cond} = f_value;
    meanspec_graph.spec{cond} = meanspec_graph.spec{cond} / nb_tones;
    meanspec_graph.spec{cond} = meanspec_graph.spec{cond} ./ meanspec_graph.baseline{cond};
    
end



%% PLOT
figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
UpRandom_Axes = axes('position', [0.05 0.05 0.28 0.8]);
UpSham_Axes = axes('position', [0.37 0.05 0.28 0.8]);
RandomSham_Axes = axes('position', [0.68 0.05 0.28 0.8]);


%Up vs Random
axes(UpRandom_Axes);
graph = 10*log(meanspec_graph.spec{cond_up})' - 10*log(meanspec_graph.spec{cond_random})';
imagesc(meanspec_graph.x{cond}-5, meanspec_graph.y{cond}, graph), hold on
axis xy, ylabel('frequency'), hold on
set(gca,'Yticklabel',5:5:50);
colorbar, caxis([-8 8]);
title([conditions{cond_up} ' vs ' conditions{cond_random}])

%Up vs Sham
axes(UpSham_Axes);
graph = 10*log(meanspec_graph.spec{cond_up})' - 10*log(meanspec_graph.spec{cond_sham})';
imagesc(meanspec_graph.x{cond}-5, meanspec_graph.y{cond}, graph), hold on
axis xy, ylabel('frequency'), hold on
set(gca,'Yticklabel',5:5:50);
colorbar, caxis([-8 8]);
title([conditions{cond_up} ' vs ' conditions{cond_sham}])

%Random vs Sham
axes(RandomSham_Axes);
graph = 10*log(meanspec_graph.spec{cond_random})' - 10*log(meanspec_graph.spec{cond_sham})';
imagesc(meanspec_graph.x{cond}-5, meanspec_graph.y{cond}, graph), hold on
axis xy, ylabel('frequency'), hold on
set(gca,'Yticklabel',5:5:50);
colorbar, caxis([-8 8]);
title([conditions{cond_random} ' vs ' conditions{cond_sham}])













