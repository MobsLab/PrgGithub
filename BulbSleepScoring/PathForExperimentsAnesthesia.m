function Dir=PathForExperimentsAnesthesia(experiment)

% input:
% name of the experiment.
% possible choices:
% 'Sleep_Pre_Ketamine'
% 'Ketamine'
% 'Isoflurane_WakeUp'
% 'Isoflurane_08'
% 'Isoflurane_10'
% 'Isoflurane_12'
% 'Isoflurane_15'
% 'Isoflurane_18'

% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperimentsML('EPM');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentFEAR.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m
% PathForExperimentsML.m

%% strains inputs


%% Path
a=0;
I_CA=[];

if strcmp(experiment,'Sleep_Pre_Ketamine')
   
    %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse666/Mouse666_20180331_PreKetamine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse667/Mouse667_20180402_PreKetamine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse668/Mouse668_20180402_PreKetamine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse669/Mouse669_20180331_PreKetamine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

elseif strcmp(experiment,'Ketamine')

    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse667/Mouse667_20180402_PostKetamine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse666/Mouse666_20180331_PostKetamine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse668/Mouse668_20180402_PostKetamine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse669/Mouse669_20180331_PostKetamine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

elseif strcmp(experiment,'Isoflurane_WakeUp')
    
    %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_WakeUp/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_WakeUp/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_WakeUP/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_WakeUp/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'Isoflurane_08')
    
    %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_08/baseline/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
          Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_08/stims/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_08/baseline/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
          Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_08/stims/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_08/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_08/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

elseif strcmp(experiment,'Isoflurane_10')
    
    %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_10/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_10/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_10/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_10/Baseline/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
          Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_10/Stim/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;

elseif strcmp(experiment,'Isoflurane_12')
    
    %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_12/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_12/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_12/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_12/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

elseif strcmp(experiment,'Isoflurane_15')
    
    
    %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_15/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_15/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_15/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_15/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

elseif strcmp(experiment,'Isoflurane_18')
    
    %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_18/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_18/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_18/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_18/Baseline/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
          Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_18/Stim/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;

elseif strcmp(experiment,'BaselineSleep')
    
  
  
   %Mouse666
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse667
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse668
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse669
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
else
    error('Invalid name of experiment')
end

end