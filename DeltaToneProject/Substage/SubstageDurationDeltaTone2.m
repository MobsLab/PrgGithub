% SubstageDurationDeltaTone2
% 29.11.2016 KJ
%
% effect of stimulation on substage duration
%
%   see 
%


%load
clear
eval(['load ' FolderProjetDelta 'Data/SubstageDurationDeltaTone.mat'])

%params
scattersize = 20;
NameSubstages = {'N1','N2', 'N3','REM','Wake','SWS'}; % Sleep substages
MouseColors = {'b','r','k','g','m',[0.75 0.75 0.75],'y',[255 127 0],'c'};

%% plot

for sub=substages_ind
    figure, hold on
    for cond=1:length(conditions)
        subplot(2,3,cond), hold on
        
        for m=1:length(animals)
            try
                y = subdur_res.epoch.duration{m,cond,sub};
                x = subdur_res.epoch.nb_stim{m,cond,sub};
                scatter(x,y,scattersize,MouseColors{m},'filled');
            end
        end
        title(conditions{cond});
        ylabel('duration'); xlabel('tone');
        
    end
    suplabel(NameSubstages{sub},'t');
end