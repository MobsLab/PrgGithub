% Figure4RipplesDeltaPlot2
% 10.12.2016 KJ
%
% Plot the figures from the Figure4.pdf of Gaetan PhD
% 
% 
%   see Figure4RipplesDelta Figure4RipplesDeltaPlot1
%


clear
load([FolderProjetDelta 'Data/Figure4RipplesDelta.mat']) 

conditions = unique(figure4_res.manipe);
labels_sessions = {'S1','S2','S3','S4','S5'};
sessions_colors = {'k','b','k','b','k'};

%params
sessions_ind = 1:5;
averaged_nb_event = 1; %weighted average of correlograms, in function of the number of delta

%% CORRELOGRAMS SUMMED

%Delta onset
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(figure4_res.path)
            if strcmpi(figure4_res.manipe{p}, conditions{cond})
                if isempty(correlo)
                    correlo = Data(figure4_res.session.correlogram.delta.onset{p,s}) * figure4_res.session.number.delta(p,s);
                else
                    correlo = correlo + Data(figure4_res.session.correlogram.delta.onset{p,s}) * figure4_res.session.number.delta(p,s);
                end
                nb_event = nb_event + figure4_res.session.number.delta(p,s); 
            end
        end
        time_correlo = Range(figure4_res.session.correlogram.delta.onset{p,s})/10;
        correlograms.delta.onset{cond,s} = correlo / nb_event;
    end
end

% Delta offset
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(figure4_res.path)
            if strcmpi(figure4_res.manipe{p}, conditions{cond})
                if isempty(correlo)
                    correlo = Data(figure4_res.session.correlogram.delta.offset{p,s}) * figure4_res.session.number.delta(p,s);
                else
                    correlo = correlo + Data(figure4_res.session.correlogram.delta.offset{p,s}) * figure4_res.session.number.delta(p,s);
                end
                nb_event = nb_event + figure4_res.session.number.delta(p,s); 
            end
        end
        time_correlo = Range(figure4_res.session.correlogram.delta.offset{p,s})/10;
        correlograms.delta.offset{cond,s} = correlo / nb_event;
    end
end

%Down onset
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(figure4_res.path)
            if strcmpi(figure4_res.manipe{p}, conditions{cond})
                if isempty(correlo)
                    correlo = Data(figure4_res.session.correlogram.down.onset{p,s}) * figure4_res.session.number.down(p,s);
                else
                    correlo = correlo + Data(figure4_res.session.correlogram.down.onset{p,s}) * figure4_res.session.number.down(p,s);
                end
                nb_event = nb_event + figure4_res.session.number.down(p,s); 
            end
        end
        time_correlo = Range(figure4_res.session.correlogram.down.onset{p,s})/10;
        correlograms.down.onset{cond,s} = correlo / nb_event;
    end
end

%Down offset
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(figure4_res.path)
            if strcmpi(figure4_res.manipe{p}, conditions{cond})
                if isempty(correlo)
                    correlo = Data(figure4_res.session.correlogram.down.offset{p,s}) * figure4_res.session.number.down(p,s);
                else
                    correlo = correlo + Data(figure4_res.session.correlogram.down.offset{p,s}) * figure4_res.session.number.down(p,s);
                end
                nb_event = nb_event + figure4_res.session.number.down(p,s); 
            end
        end
        time_correlo = Range(figure4_res.session.correlogram.down.offset{p,s})/10;
        correlograms.down.offset{cond,s} = correlo / nb_event;
    end
end


%Down corrected onset (no down in the 500ms before these down)
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(figure4_res.path)
            if strcmpi(figure4_res.manipe{p}, conditions{cond})
                if isempty(correlo)
                    correlo = Data(figure4_res.session.correlogram.down_corr.onset{p,s}) * figure4_res.session.number.down_corr.onset(p,s);
                else
                    correlo = correlo + Data(figure4_res.session.correlogram.down_corr.onset{p,s}) * figure4_res.session.number.down_corr.onset(p,s);
                end
                nb_event = nb_event + figure4_res.session.number.down_corr.onset(p,s); 
            end
        end
        time_correlo = Range(figure4_res.session.correlogram.down.onset{p,s})/10;
        correlograms.down_corr.onset{cond,s} = correlo / nb_event;
    end
end

%Down offset (no down in the 500ms before these down)
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(figure4_res.path)
            if strcmpi(figure4_res.manipe{p}, conditions{cond})
                if isempty(correlo)
                    correlo = Data(figure4_res.session.correlogram.down_corr.offset{p,s}) * figure4_res.session.number.down_corr.offset(p,s);
                else
                    correlo = correlo + Data(figure4_res.session.correlogram.down_corr.offset{p,s}) * figure4_res.session.number.down_corr.offset(p,s);
                end
                nb_event = nb_event + figure4_res.session.number.down_corr.offset(p,s); 
            end
        end
        time_correlo = Range(figure4_res.session.correlogram.down.offset{p,s})/10;
        correlograms.down_corr.offset{cond,s} = correlo / nb_event;
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% PLOT

%delta
figure,hold on
for cond=1:length(conditions)
    %onset
    subplot(2,3,cond), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.delta.onset{cond,s}, sessions_colors{s}), hold on
    end
    legend(labels_sessions), ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('delta onset (ms)')
    title(conditions{cond})
    
    %offset
    subplot(2,3,cond+3), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.delta.offset{cond,s}, sessions_colors{s}), hold on
    end
    legend('S1','S2','S3','S4','S5'), ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('delta offset (ms)')
    title(conditions{cond})
    
end
suplabel('Delta wave detections','t');

%down
figure,hold on
for cond=1:length(conditions)
    %onset
    subplot(2,3,cond), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.down.onset{cond,s}, sessions_colors{s}), hold on
    end
    legend('S1','S2','S3','S4','S5'), ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('down onset (ms)')
    title(conditions{cond})
    
    %offset
    subplot(2,3,cond+3), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.down.offset{cond,s}, sessions_colors{s}), hold on
    end
    legend('S1','S2','S3','S4','S5'), ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('down offset (ms)')
    title(conditions{cond})
    
end
suplabel('Down state detections','t');


%down corrected
figure,hold on
for cond=1:length(conditions)
    %onset
    subplot(2,3,cond), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.down_corr.onset{cond,s}, sessions_colors{s}), hold on
    end
    legend('S1','S2','S3','S4','S5'), ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('down onset (ms)')
    title(conditions{cond})
    
    %offset
    subplot(2,3,cond+3), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.down_corr.offset{cond,s}, sessions_colors{s}), hold on
    end
    legend('S1','S2','S3','S4','S5'), ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('down offset (ms)')
    title(conditions{cond})
    
end
suplabel('Down state (corrected) detections','t');




