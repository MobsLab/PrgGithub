% MotherCurvesDelayPlot
% 12.07.2017 KJ
%
% Mean curves sync on stimulation time - VIRTUAL CHANNEL DATA
% In function of the delay
% -> Plot data
%
%   see 
%       MotherCurves_VC1, MotherCurvesPlot1 MotherCurvesPhaseDelay MotherCurvesPhasePlot 
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'MotherCurvesPhaseDelay.mat'])

conditions = unique(mother_res.condition);
conditions = {'sham','random'};
colori = {'k','b','r'};


%% Gather Data
for cond=1:length(conditions)
    tone_curves{cond} = [];
    tone_delay{cond} = [];
    
    for p=1:length(mother_res.filename)
        if strcmpi(mother_res.condition{p},conditions{cond}) && mother_res.nb_tones{p}>0
            
            tone_times{cond} = mother_res.times{p};
            
            if isempty(tone_curves{cond})
                tone_curves{cond} = mother_res.Tone_map{p};
                tone_delay{cond} = mother_res.delay{p}/10;
            else
                tone_curves{cond} = [tone_curves{cond} ; mother_res.Tone_map{p}];
                tone_delay{cond} = [tone_delay{cond} ; mother_res.delay{p}/10];            
            end
        end
    end
    
end


%percentile
delay_group = [0 200;200 400;400 600;600 800;800 1000;1000 1200];
delay_group = [0 100;100 300;300 500;500 800;800 1200];



%% Mean and sem

for cond=1:length(conditions)
    for i=1:size(delay_group,1)
        idx_curve = tone_delay{cond}>delay_group(i,1) & tone_delay{cond}<delay_group(i,2);
        delay_curve = tone_curves{cond}(idx_curve,:);
        
        mother_delay.mean{cond,i} = mean(delay_curve);
        mother_delay.sem{cond,i} = stdError(delay_curve);
        mother_delay.times{cond,i} = tone_times{cond};
        
        mother_delay.nb_tones{cond,i} = size(delay_curve,1);
        
        labels_legend{i}{cond} = [conditions{cond} ' (' num2str(mother_delay.nb_tones{cond,i}) ' events)'];
        
    end
end


%% PLOT

figure, hold on
for i=1:length(delay_group)
    subplot(2,3,i), hold on
    
    for cond=1:length(conditions)
        plot(mother_delay.times{cond,i}, mother_delay.mean{cond,i}, 'color',colori{cond}, 'Linewidth', 2), hold on
    end
    legend(labels_legend{i});
    
    for cond=1:length(conditions)
        try
            shadedErrorBar(mother_delay.times{cond,i}, mother_delay.mean{cond,i}, mother_delay.sem{cond,i}, colori{cond});
        end
    end
    
    ylim([-110 110]), xlim([-3 3]), hold on
    plot(mother_delay.times{cond,i},zeros(length(mother_delay.times{cond,i}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)')

    title(['[ ' num2str(delay_group(i,1)) ' ' num2str(delay_group(i,2)) 'ms]']),
end
suplabel('Mean curves for different delays','t');






