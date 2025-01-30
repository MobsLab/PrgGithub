% MeanCurvesSpindlePlot_VC1
% 26.07.2017 KJ
%
% Mean curves, spindle filtered, sync on stimulation time - VIRTUAL CHANNEL
% -> Plot data
%
%   see 
%       MeanCurvesSpindle_VC1, MotherCurvesPlot_VC2
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'MeanCurvesSpindle_VC1.mat'])

conditions = unique(curves_res.condition);
colori = {'b','k','r'};

%% DREEM
for cond=1:length(conditions)
    mother_curve_dreem.y{cond} = [];
    
    for p=1:length(curves_res.filename)
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_tones{p}>0
            
            mother_curve_dreem.x{cond} = curves_res.Ms_tone_dreem{p}(:,1);
            
            if isempty(mother_curve_dreem.y{cond})
                mother_curve_dreem.y{cond} = curves_res.Ms_tone_dreem{p}(:,2) * curves_res.nb_tones{p};
                mother_curve_dreem.sem{cond} = curves_res.Ms_tone_dreem{p}(:,4) * curves_res.nb_tones{p};
                nb_tones = curves_res.nb_tones{p};
            else
                try
                    mother_curve_dreem.y{cond} = mother_curve_dreem.y{cond} + curves_res.Ms_tone_dreem{p}(:,2) * curves_res.nb_tones{p};
                    mother_curve_dreem.sem{cond} = mother_curve_dreem.sem{cond} + curves_res.Ms_tone_dreem{p}(:,4) * curves_res.nb_tones{p};
                    nb_tones = nb_tones + curves_res.nb_tones{p};
                catch
                    mother_curve_dreem.y{cond} = mother_curve_dreem.y{cond} + [curves_res.Ms_tone_dreem{p}(:,2);0] * curves_res.nb_tones{p};
                    mother_curve_dreem.sem{cond} = mother_curve_dreem.sem{cond} + [curves_res.Ms_tone_dreem{p}(:,4);0] * curves_res.nb_tones{p};
                    nb_tones = nb_tones + curves_res.nb_tones{p};
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

    ylim([2 5]), xlim([-3 3]), hold on
    plot(mother_curve_dreem.x{cond},zeros(length(mother_curve_dreem.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (ms)')
end
legend(h,conditions{:});
title('Mean Curves SEM - spindle band');



% 
% figure, hold on
% for cond=1:length(conditions)
%     
%     if strcmpi(conditions{cond},'upphase') || strcmpi(conditions{cond},'sham')
%         shadedErrorBar(mother_curve_dreem.x{cond}, mother_curve_dreem.y{cond}, mother_curve_dreem.sem{cond},colori{cond});
%         h(cond) = plot(mother_curve_dreem.x{cond}, mother_curve_dreem.y{cond},colori{cond},'Linewidth', 2); hold on
%         
% %         ylim([-80 80]), xlim([-3 3]), hold on
%         plot(mother_curve_dreem.x{cond},zeros(length(mother_curve_dreem.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
%         line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
%         ylabel('EEG averaged on stimulations'); xlabel('Time (ms)')
%         title('Mean Curves SEM'),
%     end
% end
% legend(h(2:3),'Sham','Stim Up');
% suplabel('DREEM','t');






