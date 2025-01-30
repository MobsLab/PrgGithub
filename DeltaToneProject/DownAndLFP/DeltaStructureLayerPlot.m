%%DeltaStructureLayerPlot
% 24.01.2018 KJ
%
% plot the relation, for different layers, between LFP amplitude during down
% and MUA min during deltas
%
%
%   see 
%       DeltaStructureLayer
%

%load
clear
eval(['load ' FolderProjetDelta 'Data/DeltaStructureLayer.mat'])

%params
scattersize = 25;
animals = unique(layer_res.name);
% colorlist = {'b','k','r','g','c','m',[0.5 0.5 0.5]};


%% data
mua_trough = [];
peak_lfp = [];
group = [];

for p=1:length(layer_res.path)
        
    mua_trough = [mua_trough layer_res.mua_trough{p}];
    peak_lfp = [peak_lfp layer_res.peak_lfp{p}];
    group = [group ones(1,length(layer_res.peak_lfp{p}))*find(strcmpi(layer_res.name{p},animals)) ];
        
end


%% PLOT
figure, hold on

gscatter(peak_lfp, mua_trough, group)
xlabel('LFP amplitude on down states')
ylabel('MUA mean value on delta waves')








