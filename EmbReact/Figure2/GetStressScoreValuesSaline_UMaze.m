function AllDat = GetStressScoreValuesSaline_UMaze

%% Outputs the elements of the stresssocre for saline animals
% AllDAT : prop wake, prop rem, HR, thigmo

Sleep = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/All_Eyelid_Sleep.mat','Prop');
HR = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_Eyelid.mat');
Thigmo = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_Eyelid.mat');

% 668 bad recording of sleep post
HR.HR_Wake_First5min{1}(7)=NaN;
Sleep.Prop.REM_s_l_e_e_p{2}(7)=NaN;
Sleep.Prop.Wake{2}(7)=NaN;

AllDat = [Sleep.Prop.Wake{2};Sleep.Prop.REM_s_l_e_e_p{2};HR.HR_Wake_First5min{1};Thigmo.Thigmo_score{1}];
AllDat = AllDat(:,sum(isnan(AllDat))==0);


end
