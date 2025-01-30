%% Identification of transition zones
clear all, close all
% Load Mice File Names
AllSlScoringMice_SleepScoringArticle_SB

%% First Make Maps

% Parameters
MatXEMG=[-2:8/99:6];
MatYEMG=[-2:4/99:2];
MatXGam=[-0.7:3.2/99:2.5];
MatYGam=[-1.5:3.5/99:2];
lim=[1,2,3,5,7,10,15,20];
jtouse=3;


% Get Maps and Transition Zones for all mice and save

for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat')
    disp('Gamma Calculations')
    Val=MakeTransitionMaps(smooth_ghi,smooth_Theta,MatXGam,MatYGam,SWSEpoch,REMEpoch,lim,'Gam');
    load('MapsTransitionProbaGam.mat')
    GetTransitionZone(smooth_ghi,Val,jtouse,'Gam',gamma_thresh,MatXGam,MatYGam,SWSEpoch)
    clear smooth_ghi
    if ismember(mm,GoodForEMG)
        load('StateEpochEMGSB.mat')
        disp('EMG Calculations')
        Val=MakeTransitionMaps(EMGData,smooth_Theta,MatXEMG,MatYEMG,SWSEpoch,REMEpoch,lim,'EMG');
        load('MapsTransitionProbaEMG.mat')
        GetTransitionZone(EMGData,Val,jtouse,'EMG',EMG_thresh,MatXEMG,MatYEMG,SWSEpoch)
        clear EMGData
    end
end


