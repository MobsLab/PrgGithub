% MotherCurvesPlot2
% 13.03.2017 KJ
%
% Mean curves sync on stimulation time
% -> Collect data
%
%   see 
%       MotherCurves2 MotherCurvesPlot1
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'MotherCurves2.mat'])

conditions = unique(mother_res.condition);

%% loop over conditions
for ch=1:length(channels)
    for cond=1:length(conditions)
        mother_curve.y{cond,ch} = [];

        for p=1:length(mother_res.filename)
            if strcmpi(mother_res.condition{p},conditions{cond}) && ~isempty(mother_res.Ms_tone{p,ch})

                mother_curve.x{cond,ch} = mother_res.Ms_tone{p,ch}(:,1);

                if isempty(mother_curve.y{cond,ch})
                    mother_curve.y{cond,ch} = mother_res.Ms_tone{p,ch}(:,2) * mother_res.nb_tones{p};
                    mother_curve.sem{cond,ch} = mother_res.Ms_tone{p,ch}(:,4) * mother_res.nb_tones{p};
                    nb_tones = mother_res.nb_tones{p};
                    nb_record = 1;
                else
                    mother_curve.y{cond,ch} = mother_curve.y{cond,ch} + mother_res.Ms_tone{p,ch}(:,2) * mother_res.nb_tones{p};
                    mother_curve.sem{cond,ch} = mother_curve.sem{cond,ch} + mother_res.Ms_tone{p,ch}(:,4) * mother_res.nb_tones{p};
                    nb_tones = nb_tones + mother_res.nb_tones{p};
                    nb_record = nb_record + 1;
                end
            end
        end
        mother_curve.y{cond,ch} = mother_curve.y{cond,ch} / nb_tones;
        mother_curve.sem{cond,ch} = mother_curve.sem{cond,ch} / nb_tones;
        mother_curve.nb_tones{cond,ch} = nb_tones;
        mother_curve.nb_record{cond,ch} = nb_record;
        
    end
end

%% PLOT

for ch=1:length(channels)
    
    figure, hold on
    for cond=1:length(conditions)
        subplot(2,2,cond),hold on

        plot(mother_curve.x{cond,ch}, mother_curve.y{cond,ch},'k','Linewidth', 2), hold on
        shadedErrorBar(mother_curve.x{cond,ch}, mother_curve.y{cond,ch}, mother_curve.sem{cond,ch});

        ylim([-80 80]), xlim([-3 3]), hold on
        plot(mother_curve.x{cond,ch},zeros(length(mother_curve.x{cond,ch}),1), 'color',[0.5 0.5 0.5]), hold on
        line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
        ylabel('EEG averaged on stimulations'); xlabel('Time (ms)')
        title([conditions{cond} ' (' num2str(mother_curve.nb_tones{cond,ch}) ' tones / ' num2str(mother_curve.nb_record{cond,ch}) ' records)'])
    end
    suplabel(name_channels{ch},'t');

end







