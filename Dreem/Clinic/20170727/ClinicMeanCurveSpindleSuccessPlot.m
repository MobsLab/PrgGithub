% ClinicMeanCurveSpindleSuccessPlot
% 27.07.2017 KJ
%
% Mean curves, sync on stim, in function of the success of the stim
% -> Plot
% 
%   see ClinicMeanCurveSpindleSuccess MeanCurvesSpindlePlot_VC1
%



%load
clear
eval(['load ' FolderPrecomputeDreem 'ClinicMeanCurveSpindleSuccess.mat'])

conditions = unique(curves_res.condition);
colori = {'b','k','r'};

%% Data
for cond=1:length(conditions)
    first.all.y{cond} = [];
    first.success.y{cond} = [];
    first.failed.y{cond} = [];
    second.all.y{cond} = [];
    second.success.y{cond} = [];
    second.failed.y{cond} = [];
    secondfirst.success.y{cond} = [];
    secondfirst.failed.y{cond} = [];
    
    %loop
    for p=1:length(curves_res.filename)
        
        %first all
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_first{p}>0
            
            first.all.x{cond} = curves_res.Ms_first{p}(:,1);
            
            if isempty(first.all.y{cond})
                first.all.y{cond} = curves_res.Ms_first{p}(:,2) * curves_res.nb_first{p};
                first.all.sem{cond} = curves_res.Ms_first{p}(:,4) * curves_res.nb_first{p};
                nb_first = curves_res.nb_first{p};
            else
                try
                    first.all.y{cond} = first.all.y{cond} + curves_res.Ms_first{p}(:,2) * curves_res.nb_first{p};
                    first.all.sem{cond} = first.all.sem{cond} + curves_res.Ms_first{p}(:,4) * curves_res.nb_first{p};
                    nb_first = nb_first + curves_res.nb_first{p};
                catch
                    first.all.y{cond} = first.all.y{cond} + [curves_res.Ms_first{p}(:,2);0] * curves_res.nb_first{p};
                    first.all.sem{cond} = first.all.sem{cond} + [curves_res.Ms_first{p}(:,4);0] * curves_res.nb_first{p};
                    nb_first = nb_first + curves_res.nb_first{p};
                end
            end
        end
        
        %first success
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_first_success{p}>0
            
            first.success.x{cond} = curves_res.Ms_first_success{p}(:,1);
            
            if isempty(first.success.y{cond})
                first.success.y{cond} = curves_res.Ms_first_success{p}(:,2) * curves_res.nb_first_success{p};
                first.success.sem{cond} = curves_res.Ms_first_success{p}(:,4) * curves_res.nb_first_success{p};
                nb_first_success = curves_res.nb_first_success{p};
            else
                try
                    first.success.y{cond} = first.success.y{cond} + curves_res.Ms_first_success{p}(:,2) * curves_res.nb_first_success{p};
                    first.success.sem{cond} = first.success.sem{cond} + curves_res.Ms_first_success{p}(:,4) * curves_res.nb_first_success{p};
                    nb_first_success = nb_first_success + curves_res.nb_first_success{p};
                catch
                    first.success.y{cond} = first.success.y{cond} + [curves_res.Ms_first_success{p}(:,2);0] * curves_res.nb_first_success{p};
                    first.success.sem{cond} = first.success.sem{cond} + [curves_res.Ms_first_success{p}(:,4);0] * curves_res.nb_first_success{p};
                    nb_first_success = nb_first_success + curves_res.nb_first_success{p};
                end
            end
        end
        
        %first failed
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_first_failed{p}>0
            
            first.failed.x{cond} = curves_res.Ms_first_failed{p}(:,1);
            
            if isempty(first.failed.y{cond})
                first.failed.y{cond} = curves_res.Ms_first_failed{p}(:,2) * curves_res.nb_first_failed{p};
                first.failed.sem{cond} = curves_res.Ms_first_failed{p}(:,4) * curves_res.nb_first_failed{p};
                nb_first_failed = curves_res.nb_first_failed{p};
            else
                try
                    first.failed.y{cond} = first.failed.y{cond} + curves_res.Ms_first_failed{p}(:,2) * curves_res.nb_first_failed{p};
                    first.failed.sem{cond} = first.failed.sem{cond} + curves_res.Ms_first_failed{p}(:,4) * curves_res.nb_first_failed{p};
                    nb_first_failed = nb_first_failed + curves_res.nb_first_failed{p};
                catch
                    first.failed.y{cond} = first.failed.y{cond} + [curves_res.Ms_first_failed{p}(:,2);0] * curves_res.nb_first_failed{p};
                    first.failed.sem{cond} = first.failed.sem{cond} + [curves_res.Ms_first_failed{p}(:,4);0] * curves_res.nb_first_failed{p};
                    nb_first_failed = nb_first_failed + curves_res.nb_first_failed{p};
                end
            end
        end
        
        %second all
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_second{p}>0
            
            second.all.x{cond} = curves_res.Ms_second{p}(:,1);
            
            if isempty(second.all.y{cond})
                second.all.y{cond} = curves_res.Ms_second{p}(:,2) * curves_res.nb_second{p};
                second.all.sem{cond} = curves_res.Ms_second{p}(:,4) * curves_res.nb_second{p};
                nb_second = curves_res.nb_second{p};
            else
                try
                    second.all.y{cond} = second.all.y{cond} + curves_res.Ms_second{p}(:,2) * curves_res.nb_second{p};
                    second.all.sem{cond} = second.all.sem{cond} + curves_res.Ms_second{p}(:,4) * curves_res.nb_second{p};
                    nb_second = nb_second + curves_res.nb_second{p};
                catch
                    second.all.y{cond} = second.all.y{cond} + [curves_res.Ms_second{p}(:,2);0] * curves_res.nb_second{p};
                    second.all.sem{cond} = second.all.sem{cond} + [curves_res.Ms_second{p}(:,4);0] * curves_res.nb_second{p};
                    nb_second = nb_second + curves_res.nb_second{p};
                end
            end
        end
        
        %second success
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_second_success{p}>0
            
            second.success.x{cond} = curves_res.Ms_second_success{p}(:,1);
            
            if isempty(second.success.y{cond})
                second.success.y{cond} = curves_res.Ms_second_success{p}(:,2) * curves_res.nb_second_success{p};
                second.success.sem{cond} = curves_res.Ms_second_success{p}(:,4) * curves_res.nb_second_success{p};
                nb_second_success = curves_res.nb_second_success{p};
            else
                try
                    second.success.y{cond} = second.success.y{cond} + curves_res.Ms_second_success{p}(:,2) * curves_res.nb_second_success{p};
                    second.success.sem{cond} = second.success.sem{cond} + curves_res.Ms_second_success{p}(:,4) * curves_res.nb_second_success{p};
                    nb_second_success = nb_second_success + curves_res.nb_second_success{p};
                catch
                    second.success.y{cond} = second.success.y{cond} + [curves_res.Ms_second_success{p}(:,2);0] * curves_res.nb_second_success{p};
                    second.success.sem{cond} = second.success.sem{cond} + [curves_res.Ms_second_success{p}(:,4);0] * curves_res.nb_second_success{p};
                    nb_second_success = nb_second_success + curves_res.nb_second_success{p};
                end
            end
        end
        
        
        %second failed
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_second_failed{p}>0
            
            second.failed.x{cond} = curves_res.Ms_second_failed{p}(:,1);
            
            if isempty(second.failed.y{cond})
                second.failed.y{cond} = curves_res.Ms_second_failed{p}(:,2) * curves_res.nb_second_failed{p};
                second.failed.sem{cond} = curves_res.Ms_second_failed{p}(:,4) * curves_res.nb_second_failed{p};
                nb_second_failed = curves_res.nb_second_failed{p};
            else
                try
                    second.failed.y{cond} = second.failed.y{cond} + curves_res.Ms_second_failed{p}(:,2) * curves_res.nb_second_failed{p};
                    second.failed.sem{cond} = second.failed.sem{cond} + curves_res.Ms_second_failed{p}(:,4) * curves_res.nb_second_failed{p};
                    nb_second_failed = nb_second_failed + curves_res.nb_second_failed{p};
                catch
                    second.failed.y{cond} = second.failed.y{cond} + [curves_res.Ms_second_failed{p}(:,2);0] * curves_res.nb_second_failed{p};
                    second.failed.sem{cond} = second.failed.sem{cond} + [curves_res.Ms_second_failed{p}(:,4);0] * curves_res.nb_second_failed{p};
                    nb_second_failed = nb_second_failed + curves_res.nb_second_failed{p};
                end
            end
        end
        
        
        %second stim, first success
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_second_success{p}>0
            
            secondfirst.success.x{cond} = curves_res.Ms_second_success{p}(:,1);
            
            if isempty(secondfirst.success.y{cond})
                secondfirst.success.y{cond} = curves_res.Ms_second_first_success{p}(:,2) * curves_res.nb_second_first_success{p};
                secondfirst.success.sem{cond} = curves_res.Ms_second_first_success{p}(:,4) * curves_res.nb_second_first_success{p};
                nb_secondfirst_success = curves_res.nb_second_first_success{p};
            else
                try
                    secondfirst.success.y{cond} = secondfirst.success.y{cond} + curves_res.Ms_second_first_success{p}(:,2) * curves_res.nb_second_first_success{p};
                    secondfirst.success.sem{cond} = secondfirst.success.sem{cond} + curves_res.Ms_second_first_success{p}(:,4) * curves_res.nb_second_first_success{p};
                    nb_secondfirst_success = nb_secondfirst_success + curves_res.nb_second_first_success{p};
                catch
                    secondfirst.success.y{cond} = secondfirst.success.y{cond} + [curves_res.Ms_second_first_success{p}(:,2);0] * curves_res.nb_second_success{p};
                    secondfirst.success.sem{cond} = secondfirst.success.sem{cond} + [curves_res.Ms_second_first_success{p}(:,4);0] * curves_res.nb_second_success{p};
                    nb_secondfirst_success = nb_secondfirst_success + curves_res.nb_second_first_success{p};
                end
            end
        end
        
        %second stim, first failed
        if strcmpi(curves_res.condition{p},conditions{cond}) && curves_res.nb_second_failed{p}>0
            
            secondfirst.failed.x{cond} = curves_res.Ms_second_failed{p}(:,1);
            
            if isempty(secondfirst.failed.y{cond})
                secondfirst.failed.y{cond} = curves_res.Ms_second_first_failed{p}(:,2) * curves_res.nb_second_first_failed{p};
                secondfirst.failed.sem{cond} = curves_res.Ms_second_first_failed{p}(:,4) * curves_res.nb_second_first_failed{p};
                nb_secondfirst_failed = curves_res.nb_second_first_failed{p};
            else
                try
                    secondfirst.failed.y{cond} = secondfirst.failed.y{cond} + curves_res.Ms_second_first_failed{p}(:,2) * curves_res.nb_second_first_failed{p};
                    secondfirst.failed.sem{cond} = secondfirst.failed.sem{cond} + curves_res.Ms_second_first_failed{p}(:,4) * curves_res.nb_second_first_failed{p};
                    nb_secondfirst_failed = nb_secondfirst_failed + curves_res.nb_second_first_failed{p};
                catch
                    secondfirst.failed.y{cond} = secondfirst.failed.y{cond} + [curves_res.Ms_second_first_failed{p}(:,2);0] * curves_res.nb_second_failed{p};
                    secondfirst.failed.sem{cond} = secondfirst.failed.sem{cond} + [curves_res.Ms_second_first_failed{p}(:,4);0] * curves_res.nb_second_failed{p};
                    nb_secondfirst_failed = nb_secondfirst_failed + curves_res.nb_second_first_failed{p};
                end
            end
        end
        
    end
    
    
    %first all
    first.all.nb{cond} = nb_first;
    first.all.y{cond} = first.all.y{cond} / nb_first;
    first.all.sem{cond} = first.all.sem{cond} / nb_first;
    %first success
    first.success.nb{cond} = nb_first_success;
    first.success.y{cond} = first.success.y{cond} / nb_first_success;
    first.success.sem{cond} = first.success.sem{cond} / nb_first_success;
    %first failed
    first.failed.nb{cond} = nb_first_failed;
    first.failed.y{cond} = first.failed.y{cond} / nb_first_failed;
    first.failed.sem{cond} = first.failed.sem{cond} / nb_first_failed;
    
    %second all
    second.all.nb{cond} = nb_second;
    second.all.y{cond} = second.all.y{cond} / nb_second;
    second.all.sem{cond} = second.all.sem{cond} / nb_second;
    %second success
    second.success.nb{cond} = nb_second_success;
    second.success.y{cond} = second.success.y{cond} / nb_second_success;
    second.success.sem{cond} = second.success.sem{cond} / nb_second_success;
    %second failed
    second.failed.nb{cond} = nb_second_failed;
    second.failed.y{cond} = second.failed.y{cond} / nb_second_failed;
    second.failed.sem{cond} = second.failed.sem{cond} / nb_second_failed;
    
    %second stim, first success
    secondfirst.success.nb{cond} = nb_secondfirst_success;
    secondfirst.success.y{cond} = secondfirst.success.y{cond} / nb_secondfirst_success;
    secondfirst.success.sem{cond} = secondfirst.success.sem{cond} / nb_secondfirst_success;
    %second stim, first failed
    secondfirst.failed.nb{cond} = nb_secondfirst_failed;
    secondfirst.failed.y{cond} = secondfirst.failed.y{cond} / nb_secondfirst_failed;
    secondfirst.failed.sem{cond} = secondfirst.failed.sem{cond} / nb_secondfirst_failed;
    
end


%% PLOT

figure, hold on

%first all
subplot(3,3,1), hold on
for cond=1:length(conditions)
    
    shadedErrorBar(first.all.x{cond}, first.all.y{cond}, first.all.sem{cond}, colori{cond});
    h(cond) = plot(first.all.x{cond}, first.all.y{cond}, colori{cond},'Linewidth', 2); hold on

    ylim([2 7]), xlim([-4 4]), hold on
    plot(first.all.x{cond},zeros(length(first.all.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)'),
    label_legend{cond} = [conditions{cond} ' (' num2str(first.all.nb{cond}) ' stim)'];
end
legend(h,label_legend{:});
title('On first stim ALL');

%first success
subplot(3,3,2), hold on
for cond=1:length(conditions)
    
    shadedErrorBar(first.success.x{cond}, first.success.y{cond}, first.success.sem{cond}, colori{cond});
    h(cond) = plot(first.success.x{cond}, first.success.y{cond}, colori{cond},'Linewidth', 2); hold on

    ylim([2 7]), xlim([-4 4]), hold on
    plot(first.success.x{cond},zeros(length(first.success.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)'),
    label_legend{cond} = [conditions{cond} ' (' num2str(first.success.nb{cond}) ' stim)'];
end
legend(h,label_legend{:});
title('On first stim SUCCESS');

%first failed
subplot(3,3,3), hold on
for cond=1:length(conditions)
    
    shadedErrorBar(first.failed.x{cond}, first.failed.y{cond}, first.failed.sem{cond}, colori{cond});
    h(cond) = plot(first.failed.x{cond}, first.failed.y{cond}, colori{cond},'Linewidth', 2); hold on

    ylim([2 7]), xlim([-4 4]), hold on
    plot(first.failed.x{cond},zeros(length(first.failed.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)'),
    label_legend{cond} = [conditions{cond} ' (' num2str(first.failed.nb{cond}) ' stim)'];
end
legend(h,label_legend{:});
title('On first stim FAILED');

%second all
subplot(3,3,4), hold on
for cond=1:length(conditions)
    
    shadedErrorBar(second.all.x{cond}, second.all.y{cond}, second.all.sem{cond}, colori{cond});
    h(cond) = plot(second.all.x{cond}, second.all.y{cond}, colori{cond},'Linewidth', 2); hold on

    ylim([2 7]), xlim([-4 4]), hold on
    plot(second.all.x{cond},zeros(length(second.all.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)'),
    label_legend{cond} = [conditions{cond} ' (' num2str(second.all.nb{cond}) ' stim)'];
end
legend(h,label_legend{:});
title('On second stim ALL');

%second success
subplot(3,3,5), hold on
for cond=1:length(conditions)
    
    shadedErrorBar(second.success.x{cond}, second.success.y{cond}, second.success.sem{cond}, colori{cond});
    h(cond) = plot(second.success.x{cond}, second.success.y{cond}, colori{cond},'Linewidth', 2); hold on

    ylim([2 7]), xlim([-4 4]), hold on
    plot(second.success.x{cond},zeros(length(second.success.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)'),
    label_legend{cond} = [conditions{cond} ' (' num2str(second.success.nb{cond}) ' stim)'];
end
legend(h,label_legend{:});
title('On second stim SUCCESS');

%second failed
subplot(3,3,6), hold on
for cond=1:length(conditions)
    
    shadedErrorBar(second.failed.x{cond}, second.failed.y{cond}, second.failed.sem{cond}, colori{cond});
    h(cond) = plot(second.failed.x{cond}, second.failed.y{cond}, colori{cond},'Linewidth', 2); hold on

    ylim([2 7]), xlim([-4 4]), hold on
    plot(second.failed.x{cond},zeros(length(second.failed.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)'),
    label_legend{cond} = [conditions{cond} ' (' num2str(second.failed.nb{cond}) ' stim)'];
end
legend(h,label_legend{:});
title('On second stim FAILED');


%second stim, first success
subplot(3,3,7), hold on
for cond=1:length(conditions)
    
    shadedErrorBar(secondfirst.success.x{cond}, secondfirst.success.y{cond}, secondfirst.success.sem{cond}, colori{cond});
    h(cond) = plot(secondfirst.success.x{cond}, secondfirst.success.y{cond}, colori{cond},'Linewidth', 2); hold on

    ylim([2 7]), xlim([-4 4]), hold on
    plot(secondfirst.success.x{cond},zeros(length(secondfirst.success.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)'),
    label_legend{cond} = [conditions{cond} ' (' num2str(secondfirst.success.nb{cond}) ' stim)'];
end
legend(h,label_legend{:});
title('On second stim if FIRST SUCCESS');

%second stim, first failed
subplot(3,3,8), hold on
for cond=1:length(conditions)
    
    shadedErrorBar(secondfirst.failed.x{cond}, secondfirst.failed.y{cond}, secondfirst.failed.sem{cond}, colori{cond});
    h(cond) = plot(secondfirst.failed.x{cond}, secondfirst.failed.y{cond}, colori{cond},'Linewidth', 2); hold on

    ylim([2 7]), xlim([-4 4]), hold on
    plot(secondfirst.failed.x{cond},zeros(length(secondfirst.failed.x{cond}),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stimulations'); xlabel('Time (s)'),
    label_legend{cond} = [conditions{cond} ' (' num2str(secondfirst.failed.nb{cond}) ' stim)'];
end
legend(h,label_legend{:});
title('On second stim if FIRST FAILED');

