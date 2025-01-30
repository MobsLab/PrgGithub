%%ParcoursHomeostasieLocalDeltaOccupancyPlot
% 08.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    ParcoursHomeostasieLocalDeltaDensityPlot ParcoursHomeostasieLocalDeltaOccupancy
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasieLocalDeltaOccupancy.mat'))

rescaleslope = 0;

%% concatenate
down.global.slope0  = []; down.global.slope1  = []; down.global.slope2  = [];
down.local.slope0   = []; down.local.slope1   = []; down.local.slope2   = [];
delta.global.slope0 = []; delta.global.slope1 = []; delta.global.slope2 = [];
delta.local.slope0  = []; delta.local.slope1  = []; delta.local.slope2  = [];
delta.fake.slope0   = []; delta.fake.slope1   = []; delta.fake.slope2   = [];

tt = 2;

for p=1:length(homeo_res.path)
    
    %slope all night
    down.global.slope0(p,1)  = homeo_res.down.global.p2{p}(1);
    slope0 = [];
    for tt=1:length(homeo_res.nb.tetrodes{p})
        slope0 = [slope0 homeo_res.down.local.p2{p,tt}(1)];
    end
    down.local.slope0(p,1) = mean(slope0);
 
    
    %slope beginning
    

end