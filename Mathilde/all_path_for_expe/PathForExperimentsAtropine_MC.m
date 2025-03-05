function Dir = PathForExperimentsAtropine_MC(experiment)

% OUTPUT
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperiments_MC('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%lHav
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

%% Path
a=0;
I_CA=[];

%%

if strcmp(experiment,'BaselineSleep')
    % mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1105/20201201/BaselineSleep/DREADD_Atropine_1105_Baseline_201201_092803/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1106/20201201/BaselineSleep/DREADD_Atropine_1106_Baseline_201201_092803/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1107
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1107/20201201/BaselineSleep/DREADD_Atropine_1107_Baseline_201201_092803/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1112
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1112/20201201/BaselineSleep/DREADD_Atropine_1112_Baseline_201201_092803/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'Atropine') %%corrections (sleep scoring/sleep events/substages) ok
    % mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1105/20201204/Sleep_AtropineInjection/DREADD_Atropine_1105_Atropine_201204_091815/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1106/20201204/Sleep_AtropineInjection/DREADD_Atropine_1106_Atropine_201204_091815/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1107
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1107/20201204/Sleep_AtropineInjection/DREADD_Atropine_1107_Atropine_201204_091815/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1112
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1112/20201204/Sleep_AtropineInjection/DREADD_Atropine_1112_Atropine_201204_091815/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    
    % mouse 1245
    a=a+1;Dir.path{a}{1}='/media/ratatouille/DataMOBS160/DREADD_PFC_VLPO_1245_1247_1248_atropine_220407_090451/1245/';%% à updater quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1247
    a=a+1;Dir.path{a}{1}='/media/ratatouille/DataMOBS160/DREADD_PFC_VLPO_1245_1247_1248_atropine_220407_090451/1247/';%% à updater quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1248
    a=a+1;Dir.path{a}{1}='/media/ratatouille/DataMOBS160/DREADD_PFC_VLPO_1245_1247_1248_atropine_220407_090451/1248/';%% à updater quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
elseif strcmp(experiment,'CNO_Atropine_DreaddMouse') %%corrections à faire
    % mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1105/20201126/Sleep_CNOandAtropineInjection/DREADD_Atropine_1105_CNOAtrop_201126_090100/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1106/20201126/Sleep_CNOandAtropineInjection/DREADD_Atropine_1106_CNOAtrop_201126_090100/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'CNO_Saline_CtrlMouse') %%corrections à faire
    % mouse 1107
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1107/20201126/Sleep_CNOandAtropineInjection/DREADD_Atropine_1107_CNONacl_201126_090100/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1112
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1112/20201126/Sleep_CNOandAtropineInjection/DREADD_Atropine_1112_CNONacl_201126_090100/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo;Dir.nMice{a}=ExpeInfo.nmouse;
    

else
    error('Invalid name of experiment')
    
    
end


%% Get mice names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i}{1},'M');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
    else
        Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+4)];
        if sum(isstrprop(Dir.path{i}{1}(temp+1:temp+4),'alphanum'))<4
            Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+3)];
        end
    end
end

end
