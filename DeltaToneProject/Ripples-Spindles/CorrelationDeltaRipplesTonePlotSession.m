% CorrelationDeltaRipplesTonePlotSession
% 11.12.2016 KJ
%
% Plot correlograms concerning tones, delta and SPW-Rs, PER SESSION
% 
% 
%   see CorrelationDeltaRipplesTone Figure4RipplesDeltaPlot2 CorrelationDeltaRipplesTonePlot
%


clear
load([FolderProjetDelta 'Data/CorrelationDeltaRipplesTone.mat']) 

conditions = unique(deltarip_res.manipe);
labels_sessions = {'S1','S2','S3','S4','S5'};
sessions_colors = {'k','b','k','b','k'};

%params
sessions_ind = 1:5;
weighted_average = 1; %weighted average of correlograms, in function of the number of delta

%% CORRELOGRAMS SUMMED

%Ripples vs Delta onset
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(deltarip_res.path)
            if strcmpi(deltarip_res.manipe{p}, conditions{cond})
                %weighted or simple average
                if weighted_average==1
                    coeff = deltarip_res.session.number.delta(p,s);
                else
                    coeff = 1;
                end
                
                %sum correlograms
                if isempty(correlo)
                    correlo = Data(deltarip_res.session.correlogram.delta.onset{p,s}) * coeff;
                else
                    correlo = correlo + Data(deltarip_res.session.correlogram.delta.onset{p,s}) * coeff;
                end
                nb_event = nb_event + coeff;
            end
        end
        time_correlo = Range(deltarip_res.session.correlogram.delta.onset{p,s})/10;
        correlograms.delta.onset{cond,s} = correlo / nb_event;
    end
end

%Ripples vs Delta offset
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(deltarip_res.path)
            if strcmpi(deltarip_res.manipe{p}, conditions{cond})
                %weighted or simple average
                if weighted_average==1
                    coeff = deltarip_res.session.number.delta(p,s);
                else
                    coeff = 1;
                end
                
                %sum correlograms
                if isempty(correlo)
                    correlo = Data(deltarip_res.session.correlogram.delta.offset{p,s}) * coeff;
                else
                    correlo = correlo + Data(deltarip_res.session.correlogram.delta.offset{p,s}) * coeff;
                end
                nb_event = nb_event + coeff;
            end
        end
        time_correlo = Range(deltarip_res.session.correlogram.delta.offset{p,s})/10;
        correlograms.delta.offset{cond,s} = correlo / nb_event;
    end
end

%Ripples-Delta vs Tones
for cond=1:length(conditions)
    for s=sessions_ind
        correlo = [];
        nb_event = 0;
        for p=1:length(deltarip_res.path)
            if strcmpi(deltarip_res.manipe{p}, conditions{cond})
                %weighted or simple average
                if weighted_average==1
                    coeff = deltarip_res.session.number.event(p,s);
                else
                    coeff = 1;
                end
                
                %sum correlograms
                if isempty(correlo)
                    correlo = Data(deltarip_res.session.correlogram.event.deltarip{p,s}) * coeff;
                else
                    correlo = correlo + Data(deltarip_res.session.correlogram.event.deltarip{p,s}) * coeff;
                end
                nb_event = nb_event + coeff;
            end
        end
        time_correlo = Range(deltarip_res.session.correlogram.event.deltarip{p,s})/10;
        correlograms.event.deltarip{cond,s} = correlo / nb_event;
    end
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% PLOT

figure,hold on
for cond=1:length(conditions)
    %onset
    subplot(3,3,cond), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.delta.onset{cond,s}, sessions_colors{s}), hold on
    end
    legend(labels_sessions), ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('delta onset (ms)')
    title(conditions{cond})
    
    %offset
    subplot(3,3,cond+3), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.delta.offset{cond,s}, sessions_colors{s}), hold on
    end
    legend('S1','S2','S3','S4','S5'), ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('delta offset (ms)')
    
    %offset
    subplot(3,3,cond+6), hold on
    for s=sessions_ind
        plot(time_correlo, correlograms.event.deltarip{cond,s}, sessions_colors{s}), hold on
    end
    legend('S1','S2','S3','S4','S5'), ylim([0 0.3]), hold on
    ylabel('SPW-Rs-Delta occurence'), xlabel('Event (sham/tone) (ms)')
    
end






