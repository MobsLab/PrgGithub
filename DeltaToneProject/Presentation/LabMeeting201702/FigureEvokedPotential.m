% FigureEvokedPotential
% 14.02.2017 KJ
%
% analysis of the evoked potential in the PFCx
%
% see 
%    ToneEvokedPotential AnalysisEvokedPotential
%  



%% load
clear
load([FolderProjetDelta 'Data/AnalysisEvokedPotential.mat']) 


%params
animals = unique(evoked_res.name);
channels = {'deep','sup','pfc1','pfc2'};
ColorAnimals = {'k','b','r',[0.5 0.5 0.5]};
ColorsChannel = {'b','r','k',[0.5 0.5 0.5]};



%% loop
for m=1:length(animals)
    for ch=1:length(channels)
        x_met = [];
        y_met = [];
        nb_tones = 0;
        
        for p=1:length(evoked_res.path) 
            if strcmpi(evoked_res.name{p},animals{m})
                if isempty(y_met)
                    y_met = evoked_res.(channels{ch}).y{p} * evoked_res.nb_tones{p};
                else
                    y_met = y_met + evoked_res.(channels{ch}).y{p} * evoked_res.nb_tones{p};
                end
                x_met = evoked_res.(channels{ch}).x{p};
                nb_tones = evoked_res.nb_tones{p};
            end
        end
        
        met_x.(channels{ch}){m} = x_met;
        met_y.(channels{ch}){m} = y_met / nb_tones;
        
    end
end


%% plot

%per channel
figure, hold on
for ch=1:length(channels)
    subplot(2,2,ch), hold on
    for m=1:2
        plot(met_x.(channels{ch}){m},met_y.(channels{ch}){m},'color',ColorAnimals{m}), hold on
    end
    ylim([-2000 2000]), hold on
    legend(animals);
    line([0 0],get(gca,'YLim')), hold on
    title(['channel ' channels{ch}]);
    
end
suplabel('Evoked response to Tones in SWS','t');


%per mouse
figure, hold on
for m=1:2
    subplot(2,1,m), hold on
    for ch=1:length(channels)
        plot(met_x.(channels{ch}){m},met_y.(channels{ch}){m},'color',ColorsChannel{ch}), hold on
    end
    ylim([-2000 2000]), hold on
    legend(channels);
    line([0 0],get(gca,'YLim')), hold on
    title(animals{m});
    
end
suplabel('Evoked response to Tones in SWS','t');
















