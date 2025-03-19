% MotherCurvesPlot_VC1
% 26.06.2017 KJ
%
% Mean curves sync on stimulation time - VIRTUAL CHANNEL
% -> Collect data
%
%   see 
%       MotherCurves_VC1, MotherCurvesPlot1
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'MotherCurves_VC1.mat'])

conditions = unique(mother_res.condition);

%% DREEM
for cond=1:length(conditions)
    mother_curve_dreem.y{cond} = [];
    
    for p=1:length(mother_res.filename)
        if strcmpi(mother_res.condition{p},conditions{cond}) && mother_res.nb_tones{p}>0
            
            mother_curve_dreem.x{cond} = mother_res.Ms_tone_dreem{p}(:,1);
            
            if isempty(mother_curve_dreem.y{cond})
                mother_curve_dreem.y{cond} = mother_res.Ms_tone_dreem{p}(:,2) * mother_res.nb_tones{p};
                mother_curve_dreem.sem{cond} = mother_res.Ms_tone_dreem{p}(:,4) * mother_res.nb_tones{p};
                nb_tones = mother_res.nb_tones{p};
            else
                try
                    mother_curve_dreem.y{cond} = mother_curve_dreem.y{cond} + mother_res.Ms_tone_dreem{p}(:,2) * mother_res.nb_tones{p};
                    mother_curve_dreem.sem{cond} = mother_curve_dreem.sem{cond} + mother_res.Ms_tone_dreem{p}(:,4) * mother_res.nb_tones{p};
                    nb_tones = nb_tones + mother_res.nb_tones{p};
                catch
                    mother_curve_dreem.y{cond} = mother_curve_dreem.y{cond} + [mother_res.Ms_tone_dreem{p}(:,2);0] * mother_res.nb_tones{p};
                    mother_curve_dreem.sem{cond} = mother_curve_dreem.sem{cond} + [mother_res.Ms_tone_dreem{p}(:,4);0] * mother_res.nb_tones{p};
                    nb_tones = nb_tones + mother_res.nb_tones{p};
                end
            end
        end
    end
    mother_curve_dreem.y{cond} = mother_curve_dreem.y{cond} / nb_tones;
    mother_curve_dreem.sem{cond} = mother_curve_dreem.sem{cond} / nb_tones;
    
end


%% ACTIWAVE
for cond=1:length(conditions)
    mother_curve_psg.y{cond} = [];
    
    for p=1:length(mother_res.filename)
        if strcmpi(mother_res.condition{p},conditions{cond}) && mother_res.nb_tones{p}>0
            
            mother_curve_psg.x{cond} = mother_res.Ms_tone_psg{p}(:,1);
            
            if isempty(mother_curve_psg.y{cond})
                mother_curve_psg.y{cond} = mother_res.Ms_tone_psg{p}(:,2) * mother_res.nb_tones{p};
                mother_curve_psg.sem{cond} = mother_res.Ms_tone_psg{p}(:,4) * mother_res.nb_tones{p};
                nb_tones = mother_res.nb_tones{p};
            else
                try
                    mother_curve_psg.y{cond} = mother_curve_psg.y{cond} + [mother_res.Ms_tone_psg{p}(:,2);0] * mother_res.nb_tones{p};
                    mother_curve_psg.sem{cond} = mother_curve_psg.sem{cond} + [mother_res.Ms_tone_psg{p}(:,4);0] * mother_res.nb_tones{p};
                    nb_tones = nb_tones + mother_res.nb_tones{p};
                catch
                end
            end
        end
    end
    mother_curve_psg.y{cond} = mother_curve_psg.y{cond} / nb_tones;
    mother_curve_psg.sem{cond} = mother_curve_psg.sem{cond} / nb_tones;
    
end

%% PLOT

%DREEM
figure, hold on
for cond=1:length(conditions)
    subplot(2,2,cond),hold on

    plot(mother_curve_dreem.x{cond}, mother_curve_dreem.y{cond},'k','Linewidth', 2), hold on
    shadedErrorBar(mother_curve_dreem.x{cond}, mother_curve_dreem.y{cond}, mother_curve_dreem.sem{cond});
    
    ylim([-80 80]), xlim([-3 3]), hold on
    plot(mother_curve_dreem.x{cond},zeros(length(mother_curve_dreem.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (ms)')
    title(conditions{cond})
end
suplabel('DREEM','t');


%ACTIWAVE
figure, hold on
for cond=1:length(conditions)
    subplot(2,2,cond),hold on

    plot(mother_curve_psg.x{cond}, mother_curve_psg.y{cond},'k','Linewidth', 2), hold on
    shadedErrorBar(mother_curve_psg.x{cond}, mother_curve_psg.y{cond}, mother_curve_psg.sem{cond});
    
    ylim([-80 80]), xlim([-3 3]), hold on
    plot(mother_curve_psg.x{cond},zeros(length(mother_curve_psg.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (ms)')
    title(conditions{cond})
end
suplabel('ACTIWAVE','t');





