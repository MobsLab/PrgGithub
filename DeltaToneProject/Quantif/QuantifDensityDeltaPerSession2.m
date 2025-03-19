% QuantifDensityDeltaPerSession2
% 18.11.2016 KJ
%
%   Use QuantifDensityDeltaPerSessionPlot to plot data
%
% See
%   QuantifDensityDeltaPerSession QuantifDensityDeltaPerSession3 QuantifDensityDeltaPerSessionPlot
%


%params
substages_plot = 1:5;
sessions_plot = 1:5;
delays_ind = [1 2 4 5 6];


%% Delta Median Density
% - One figure per substage
% - Subplot per sessions
for sub=substages_plot
    maintitle = ['Delta (medians) - ' NameSubstages{sub}];
    QuantifDensityDeltaPerSessionPlot('delta', 'median', 'density', 'session','sessions_plot',sessions_plot,'substages_plot',sub,'delays_ind',delays_ind);
end

%% Delta Total Density
% - One figure per substage
% - Subplot per sessions
for sub=substages_plot
    maintitle = ['Delta - ' NameSubstages{sub}];
    QuantifDensityDeltaPerSessionPlot('delta', 'total', 'density', 'session','sessions_plot',sessions_plot,'substages_plot',sub,'delays_ind',delays_ind);
end

QuantifDensityDeltaPerSessionPlot('delta', 'total', 'density', 'session','sessions_plot',sessions_plot,'substages_plot',substages_plot,'delays_ind',delays_ind);


%% Down Median Density
% - One figure per substage
% - Subplot per sessions
for sub=substages_plot
    maintitle = ['Down (medians) - ' NameSubstages{sub}];
    QuantifDensityDeltaPerSessionPlot('down', 'median', 'density', 'session','sessions_plot',sessions_plot,'substages_plot',sub,'delays_ind',delays_ind,'maintitle',maintitle);
end

%% Down Total Density
% - One figure per substage
% - Subplot per sessions
for sub=substages_plot
    QuantifDensityDeltaPerSessionPlot('down', 'total', 'density', 'session','sessions_plot',sessions_plot,'substages_plot',sub,'delays_ind',delays_ind);
end

%% Delta Total Density
% - One figure per session
% - Subplot per substages
for sess=sessions_plot
    maintitle = ['Delta - ' NameSubstages{sub}];
    QuantifDensityDeltaPerSessionPlot('delta', 'total', 'density', 'substage','sessions_plot',sess,'substages_plot',substages_plot,'delays_ind',delays_ind,'maintitle',maintitle);
end

%% Subplot per substage, on the whole night

QuantifDensityDeltaPerSessionPlot('delta', 'total', 'density', 'substage','sessions_plot',sessions_plot);
QuantifDensityDeltaPerSessionPlot('delta', 'total', 'number', 'substage','sessions_plot',sessions_plot,'samescale',1);
QuantifDensityDeltaPerSessionPlot('down', 'total', 'number', 'substage','sessions_plot',sessions_plot);


%% Subplot per session, all substages gathered

QuantifDensityDeltaPerSessionPlot('delta', 'total', 'density', 'session','substages_plot',substages_plot,'samescale',1);
QuantifDensityDeltaPerSessionPlot('delta', 'total', 'number', 'session','substages_plot',substages_plot);
QuantifDensityDeltaPerSessionPlot('down', 'total', 'number', 'session','substages_plot',substages_plot);


%% Session ratio of duration
substages_plot2 = 1:5;
sessions_plot2 = 1:5;
for ssp=substages_plot2
    %ratio of the substage 'ssp' over each sessions (subplot: sessions)
    QuantifDensityDeltaPerSessionPlot('duration ratio', 'total', '', 'session','sessions_plot',sessions_plot,'substages_plot',ssp,'delays_ind',delays_ind, 'samescale',1);
end

%percentage of each substage, computed on the whole night (subplot: substage)
QuantifDensityDeltaPerSessionPlot('duration ratio', 'total', '', 'substage','sessions_plot',sessions_plot);


% NB :  this one return 100% for each value
%       -> it is a ratio between two same values: the total duration of
%       all substages, for each session
% QuantifDensityDeltaPerSessionPlot('duration ratio', 'total', '', 'session','substages_plot',substages_plot);



