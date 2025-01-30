% MotherCurvesPlot_VC2
% 26.06.2017 KJ
%
% Mean curves sync on stimulation time - VIRTUAL CHANNEL
% -> Collect data
%
%   see 
%       MotherCurves_VC1, MotherCurvesPlot_VC1
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'MotherCurves_VC1.mat'])

conditions = unique(mother_res.condition);
colori = {'b','k','r'};

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


%% PLOT

figure, hold on
for cond=1:length(conditions)
    
    shadedErrorBar(mother_curve_dreem.x{cond}, mother_curve_dreem.y{cond}, mother_curve_dreem.sem{cond},colori{cond});
    h(cond) = plot(mother_curve_dreem.x{cond}, mother_curve_dreem.y{cond},colori{cond},'Linewidth', 2); hold on

    ylim([-80 80]), xlim([-3 3]), hold on
    plot(mother_curve_dreem.x{cond},zeros(length(mother_curve_dreem.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (ms)')
    title('Mean Curves SEM'),
end
legend(h(1:3),conditions{:});
suplabel('DREEM','t');






% figure, hold on
% for cond=1:length(conditions)
%     
%     if strcmpi(conditions{cond},'upphase') || strcmpi(conditions{cond},'sham')
%         shadedErrorBar(mother_curve_dreem.x{cond}, mother_curve_dreem.y{cond}, mother_curve_dreem.sem{cond},colori{cond});
%         h(cond) = plot(mother_curve_dreem.x{cond}, mother_curve_dreem.y{cond},colori{cond},'Linewidth', 2); hold on
%         
%         ylim([-80 80]), xlim([-3 3]), hold on
%         plot(mother_curve_dreem.x{cond},zeros(length(mother_curve_dreem.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
%         line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
%         ylabel('EEG averaged on stimulations'); xlabel('Time (ms)')
%         title('Mean Curves SEM'),
%     end
% end
% legend(h(2:3),'Sham','Stim Up');
% suplabel('DREEM','t');





