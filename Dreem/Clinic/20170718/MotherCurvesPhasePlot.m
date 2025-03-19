% MotherCurvesPhasePlot
% 12.07.2017 KJ
%
% Mean curves sync on stimulation time - VIRTUAL CHANNEL DATA
% In function of the phase
% -> Plot data
%
%   see 
%       MotherCurves_VC1, MotherCurvesPlot1 MotherCurvesPhaseDelay MotherCurvesDelayPlot 
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
    tone_phases{cond} = [];
    
    for p=1:length(mother_res.filename)
        if strcmpi(mother_res.condition{p},conditions{cond}) && mother_res.nb_tones{p}>0
            
            tone_times{cond} = mother_res.times{p};
            
            if isempty(tone_curves{cond})
                tone_curves{cond} = mother_res.Tone_map{p};
                tone_phases{cond} = mother_res.phase{p};
            else
                tone_curves{cond} = [tone_curves{cond} ; mother_res.Tone_map{p}];
                tone_phases{cond} = [tone_phases{cond} ; mother_res.phase{p}];            
            end
        end
    end
    
end

%% Mean and sem
phases_group = [-pi/4 pi/4; pi/4 3*pi/4; 3*pi/4 -3*pi/4; -3*pi/4 -pi/4];
labels_phase = {'peak', 'descending','trough','ascending'}; 

for cond=1:length(conditions)
    for i=1:size(phases_group,1)
        if phases_group(i,1)<phases_group(i,2)
            idx_curve = tone_phases{cond}>phases_group(i,1) & tone_phases{cond}<phases_group(i,2);
        else
            idx_curve = tone_phases{cond}>phases_group(i,1) | tone_phases{cond}<phases_group(i,2);
        end
        
        phase_curve = tone_curves{cond}(idx_curve,:);
        
        mother_phase.mean{cond,i} = mean(phase_curve);
        mother_phase.sem{cond,i} = stdError(phase_curve);
        mother_phase.times{cond,i} = tone_times{cond};
        
        mother_phase.nb_tones{cond,i} = size(phase_curve,1);
        
        labels_legend{i}{cond} = [conditions{cond} ' (' num2str(mother_phase.nb_tones{cond,i}) ' events)'];
        
    end
end


%% PLOT


%DREEM
figure, hold on
for i=1:length(phases_group)
    subplot(2,2,i),hold on
    
    for cond=1:length(conditions)
        plot(mother_phase.times{cond,i}, mother_phase.mean{cond,i}, 'color', colori{cond}, 'Linewidth', 2), hold on
    end
    legend(labels_legend{i});
    
    for cond=1:length(conditions)
        shadedErrorBar(mother_phase.times{cond,i}, mother_phase.mean{cond,i}, mother_phase.sem{cond,i},colori{cond});
    end 
    
    ylim([-80 80]), xlim([-3 3]), hold on
    plot(mother_phase.times{cond,i},zeros(length(mother_phase.times{cond,i}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)')

    title([labels_phase{i} ' = ' num2str(round(phases_group(i,1)*180/pi)) '° : ' num2str(round(phases_group(i,2)*180/pi)) '°']),
end
suplabel('Mean curves for different phases','t');






