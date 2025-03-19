% QuantifDetectionDeltaDown2
% 28.11.2016 KJ
%
% plot the data for precision and recall
%
%   see QuantifDetectionDeltaDown
%

%% load
clear
eval(['load ' FolderProjetDelta 'Data/QuantifDetectionDeltaDown.mat'])

%% Concatenate
animals = unique(quantif_res.name); %Mice


% data for each mice and delays
for m=1:length(animals)
    
    nb_deltas_alone = [];
    nb_down_alone = [];
    nb_both = [];
    
    for p=1:length(quantif_res.path) 
        if strcmpi(quantif_res.name{p},animals(m))
            
            deltas = sum(cell2mat(quantif_res.nb_delta(p,:)));
            downs = sum(cell2mat(quantif_res.nb_down(p,:)));
            boths = sum(cell2mat(quantif_res.nb_delta_down(p,:)));
            
            nb_deltas_alone = [nb_deltas_alone deltas-boths];
            nb_down_alone = [nb_down_alone downs-boths];
            nb_both = [nb_both boths];
            
        end
    end
    
    quantif.deltas{m} = nb_deltas_alone;
    quantif.downs{m} = nb_down_alone;
    quantif.boths{m} = nb_both;

end


%% plot
labels = {'deltas alone','delta and down','down alone'};
figure, hold on
for m=1:length(animals)
    
    data = [quantif.deltas{m}' quantif.downs{m}' quantif.boths{m}'];
    subplot(3,3,m), hold on,
        PlotErrorBarN_KJ(data,'newfig',0, 'ShowSigstar','none');
    title(animals{m}), ylabel('number'), hold on,
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
            
end








