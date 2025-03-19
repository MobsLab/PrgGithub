% CorrelogramToneDeltaSubstagePlot
% 27.11.2016 KJ
%
% compute correlograms, for the different substage
% 
% 
%   see CorrelogramToneDeltaSubstage
%


%% load
clear
eval(['load ' FolderProjetDelta 'Data/CorrelogramToneDeltaSubstage.mat'])


%% plot

%delta
smoothing = 0;
figure, hold on
for cond=1:length(conditions)
    h(cond) = subplot(2,3,cond); hold on
    leg = cell(0);
    for m=1:length(animals)
        try
            plot(mouseCrossCor.x{m,cond}/10, Smooth(mouseCrossCor.y{m,cond},smoothing)), hold on
            leg{end+1} = animals{m}; 
        end
    end
    legend(leg)
    title(conditions(cond))
    line([0 0],get(gca,'YLim')), hold on
end
suplabel('Correlograms Tones/Sham vs Delta Waves','t');



cond=2; %Rdm
figure, hold on
for m=1:length(animals)
    subplot(3,3,m); hold on
    plot(mouseCrossCor.x{m,cond}/10, Smooth(mouseCrossCor.y{m,cond},smoothing)), hold on
    line([0 0],get(gca,'YLim')), hold on
    title(animals{m}), hold on
end
suplabel(conditions{cond},'t');







% %down
% smoothing = 0;
% figure, hold on
% for cond=1:length(conditions)
%     h(cond) = subplot(2,3,cond); hold on
%     leg = cell(0);
%     for m=1:length(animals)
%         try
%             plot(mouseCrossCor.downs.x{m,cond}/10, Smooth(mouseCrossCor.downs.y{m,cond},smoothing)), hold on
%             leg{end+1} = animals{m}; 
%         end
%     end
%     legend(leg)
%     title(conditions(cond))
%     line([0 0],get(gca,'YLim')), hold on
% end
% suplabel('Correlograms Tones/Sham vs Down states','t');




