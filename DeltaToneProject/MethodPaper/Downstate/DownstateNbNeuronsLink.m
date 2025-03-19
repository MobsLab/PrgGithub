%%DownstateNbNeuronsLink
%
% 13.03.2018 KJ
%
% see
%   DownstatesSubpopulationAnalysis DownstatesSubpopulationAnalysis_perm
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DownstatesSubpopulationAnalysis_perm.mat'))

%data from all neurons of each night
x_all  = cell2mat(allneur.nb_neuron);
fr_all = cell2mat(allneur.sws.fr);
y_all  = cell2mat(allneur.sws.perm_effect);
    

%data from subpopulation
x_sub  = [];
fr_sub = [];
y_sub  = [];

for p=1:size(subneur.nb_neuron,1)
    
    x_sub  = [x_sub cell2mat(subneur.nb_neuron(p,:))];
    fr_sub = [fr_sub cell2mat(subneur.sws.fr(p,:))];
    y_sub  = [y_sub cell2mat(subneur.sws.perm_effect(p,:))];
end


figure, hold on

subplot(2,1,1), hold on
scatter(x_all,y_all,'b','filled')
scatter(x_sub,y_sub,'k','filled')

subplot(2,1,2), hold on
scatter(fr_all,y_all,'b','filled')
scatter(fr_sub,y_sub,'k','filled')




