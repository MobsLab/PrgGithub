% MotherCurvesPlot1
% 13.03.2017 KJ
%
% Mean curves sync on stimulation time
% -> Collect data
%
%   see 
%       MotherCurves1
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'MotherCurves1.mat'])

conditions = unique(mother_res.condition);

%% loop over conditions
for cond=1:length(conditions)
    mother_curve.y{cond} = [];
    
    for p=1:length(mother_res.filename)
        if strcmpi(mother_res.condition{p},conditions{cond})
            
            mother_curve.x{cond} = mother_res.Ms_tone{p}(:,1);
            
            if isempty(mother_curve.y{cond})
                mother_curve.y{cond} = mother_res.Ms_tone{p}(:,2) * mother_res.nb_tones{p};
                mother_curve.sem{cond} = mother_res.Ms_tone{p}(:,4) * mother_res.nb_tones{p};
                nb_tones = mother_res.nb_tones{p};
            else
                mother_curve.y{cond} = mother_curve.y{cond} + mother_res.Ms_tone{p}(:,2) * mother_res.nb_tones{p};
                mother_curve.sem{cond} = mother_curve.sem{cond} + mother_res.Ms_tone{p}(:,4) * mother_res.nb_tones{p};
                nb_tones = nb_tones + mother_res.nb_tones{p};
            end
        end
    end
    mother_curve.y{cond} = mother_curve.y{cond} / nb_tones;
    mother_curve.sem{cond} = mother_curve.sem{cond} / nb_tones;
    
end


%% PLOT

figure, hold on
for cond=1:length(conditions)
    subplot(2,2,cond),hold on

    plot(mother_curve.x{cond}, mother_curve.y{cond},'k','Linewidth', 2), hold on
    shadedErrorBar(mother_curve.x{cond}, mother_curve.y{cond}, mother_curve.sem{cond});
    
    ylim([-80 80]), xlim([-3 3]), hold on
    plot(mother_curve.x{cond},zeros(length(mother_curve.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (ms)')
    title(conditions{cond})
end








