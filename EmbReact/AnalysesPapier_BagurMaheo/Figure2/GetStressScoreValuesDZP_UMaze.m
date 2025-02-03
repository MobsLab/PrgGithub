function [AllDat_Ctrl,AllDat_DZP] = GetStressScoreValuesDZP_UMaze

%% Outputs the elements of the stresssocre for rip control and inhib animals
% AllDAT : prop wake, prop rem, HR, thigmo

Sleep = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/DZP_Sleep.mat','Prop');
HR = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_DZP.mat');
Thigmo = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_DZP.mat');


% Normalize thigmo score by controls
Thigmo.Thigmo_score{2} = Thigmo.Thigmo_score{2}./mean(Thigmo.Thigmo_score{1});
Thigmo.Thigmo_score{1} = Thigmo.Thigmo_score{1}./mean(Thigmo.Thigmo_score{1});

AllDat_Ctrl = [Sleep.Prop.Wake{1};Sleep.Prop.REM_s_l_e_e_p{1};HR.HR_Wake_First5min{1};Thigmo.Thigmo_score{1}];
AllDat_DZP = [Sleep.Prop.Wake{2};Sleep.Prop.REM_s_l_e_e_p{2};HR.HR_Wake_First5min{2};Thigmo.Thigmo_score{2}]; % Check this!!
