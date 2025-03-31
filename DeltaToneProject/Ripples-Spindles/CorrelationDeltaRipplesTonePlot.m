% CorrelationDeltaRipplesTonePlot
% 11.12.2016 KJ
%
% Plot correlograms concerning tones, delta and SPW-Rs
% 
% 
%   see CorrelationDeltaRipplesTone Figure4RipplesDeltaPlot2
%


clear
load([FolderProjetDelta 'Data/CorrelationDeltaRipplesTone.mat']) 

conditions = unique(deltarip_res.manipe);
labels_sessions = {'S1','S2','S3','S4','S5'};
sessions_colors = {'k','b','k','b','k'};

%params
weighted_average = 0; %weighted average of correlograms, in function of the number of delta

%% CORRELOGRAMS SUMMED

%Ripples vs Delta onset
for cond=1:length(conditions)
    correlo = [];
    nb_event = 0;
    for p=1:length(deltarip_res.path)
        if strcmpi(deltarip_res.manipe{p}, conditions{cond})
            %weighted or simple average
            if weighted_average==1
                coeff = deltarip_res.all.number.delta(p);
            else
                coeff = 1;
            end

            %sum correlograms
            if isempty(correlo)
                correlo = Data(deltarip_res.all.correlogram.delta.onset{p}) * coeff;
            else
                correlo = correlo + Data(deltarip_res.all.correlogram.delta.onset{p}) * coeff;
            end
            nb_event = nb_event + coeff;
        end
    end
    time_correlo = Range(deltarip_res.all.correlogram.delta.onset{p})/10;
    correlograms.delta.onset{cond} = correlo / nb_event;
end

%Ripples vs Delta offset
for cond=1:length(conditions)
    correlo = [];
    nb_event = 0;
    for p=1:length(deltarip_res.path)
        if strcmpi(deltarip_res.manipe{p}, conditions{cond})
            %weighted or simple average
            if weighted_average==1
                coeff = deltarip_res.all.number.delta(p);
            else
                coeff = 1;
            end

            %sum correlograms
            if isempty(correlo)
                correlo = Data(deltarip_res.all.correlogram.delta.offset{p}) * coeff;
            else
                correlo = correlo + Data(deltarip_res.all.correlogram.delta.offset{p}) * coeff;
            end
            nb_event = nb_event + coeff;
        end
    end
    time_correlo = Range(deltarip_res.all.correlogram.delta.offset{p})/10;
    correlograms.delta.offset{cond} = correlo / nb_event;
end

%Ripples-Delta vs Tones
for cond=1:length(conditions)
    correlo = [];
    nb_event = 0;
    for p=1:length(deltarip_res.path)
        if strcmpi(deltarip_res.manipe{p}, conditions{cond})
            %weighted or simple average
            if weighted_average==1
                coeff = deltarip_res.all.number.event(p);
            else
                coeff = 1;
            end

            %sum correlograms
            if isempty(correlo)
                correlo = Data(deltarip_res.all.correlogram.event.deltarip{p}) * coeff;
            else
                correlo = correlo + Data(deltarip_res.all.correlogram.event.deltarip{p}) * coeff;
            end
            nb_event = nb_event + coeff;
        end
    end
    time_correlo = Range(deltarip_res.all.correlogram.event.deltarip{p})/10;
    correlograms.event.deltarip{cond} = correlo / nb_event;
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% PLOT

figure,hold on
for cond=1:length(conditions)
    %onset
    subplot(3,3,cond), hold on
    plot(time_correlo, correlograms.delta.onset{cond},'k'), hold on
    ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('delta onset (ms)')
    title(conditions{cond})
    
    %offset
    subplot(3,3,cond+3), hold on
    plot(time_correlo, correlograms.delta.offset{cond}, 'k'), hold on
    ylim([0 0.3]), hold on
    ylabel('SPW-Rs occurence'), xlabel('delta offset (ms)')
    
    %offset
    subplot(3,3,cond+6), hold on
    plot(time_correlo, correlograms.event.deltarip{cond}, 'k'), hold on
    ylim([0 0.3]), hold on
    ylabel('SPW-Rs-Delta occurence'), xlabel('Event (sham/tone) (ms)')
    
end






