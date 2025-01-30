% ClinicalTrialSleepArchitecturePlot
% 06.07.2017 KJ
%
% Sleep architecture data
% -> Collect and save data 
%
%   see 
%       [data, conditions]= ClinicQuantitySleepPlotNew 
%



%% load
clear
cd([FolderClinicFigures '/SleepStat/20170711'])


%% TST
[data, conditions]= ClinicQuantitySleepPlotNew(1:4, -1, 'pascal','pascal', 'show_sig','sig','paired',1);
saveas(gcf,'TST_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(1:4, -1, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'TST.png','png'); close all;

%% N1
[data, conditions]= ClinicQuantitySleepPlotNew(1, -1, 'pascal','pascal', 'show_sig','sig','paired',1);
saveas(gcf,'N1_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(1, -1, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'N1.png','png'); close all;

%% N1 / TST
[data, conditions]= ClinicQuantitySleepPlotNew(1, 1:4, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'N1_percentage_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(1, 1:4, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'N1_percentage.png','png'); close all;

%% N2
[data, conditions]= ClinicQuantitySleepPlotNew(2, -1, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'N2_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(2, -1, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'N2.png','png'); close all;

%% N2 / TST
[data, conditions]= ClinicQuantitySleepPlotNew(2, 1:4, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'N2_percentage_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(2, 1:4, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'N2_percentage.png','png'); close all;

%% N3
[data, conditions]= ClinicQuantitySleepPlotNew(3, -1, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'N3_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(3, -1, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'N3.png','png'); close all;

%% N3 / TST
[data, conditions]= ClinicQuantitySleepPlotNew(3, 1:4, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'N3_percentage_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(3, 1:4, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'N3_percentage.png','png'); close all;

%% REM
[data, conditions]= ClinicQuantitySleepPlotNew(4, -1, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'REM_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(4, -1, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'REM.png','png'); close all;

%% REM / TST
[data, conditions]= ClinicQuantitySleepPlotNew(4, 1:4, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'REM_percentage_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(4, 1:4, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'REM_percentage_paired.png','png'); close all;

%% SOL
[data, conditions]= ClinicQuantitySleepPlotNew(7, 0, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'SOL_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(7, 0, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'SOL.png','png'); close all;

%% WASO
[data, conditions]= ClinicQuantitySleepPlotNew(8, 0, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'WASO_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(8, 0, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'WASO.png','png'); close all;

%% SLEEP EFFICIENCY
[data, conditions]= ClinicQuantitySleepPlotNew(9, 0, 'pascal','pascal', 'show_sig','sig','paired',1);  
saveas(gcf,'Sleepeff_paired.png','png'); close all;
[data, conditions]= ClinicQuantitySleepPlotNew(9, 0, 'pascal','pascal', 'show_sig','sig','paired',0);
saveas(gcf,'Sleepeff.png','png'); close all;
%[p,tbl,stats] = Anova1Data_KJ(data, conditions);


