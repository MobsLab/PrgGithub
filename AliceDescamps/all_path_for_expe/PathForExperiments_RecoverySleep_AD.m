function Dir=PathForExperiments_RecoverySleep_AD(experiment)

% INPUT:
% name of the experiment.
% possible choices:

% OUTPUT
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
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
if strcmp(experiment,'noVirus_AfterSD_RecoverySleep')
    %After First Social Defeat of one sensory exposure in CD1 cage
%     %Mouse 1539
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240105/RecoverySleep/tetrodes_PFC_1540_sleeprecovery_240105_095742/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1541
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %After Second Social Defeat
%     %Mouse 1542
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1543
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'mCherry_CRH_VLPO_AfterCNOInjection_RecoverySleep')
%     %Mouse 1566
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1567
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'mCherry_CRH_VLPO_AfterSD_RecoverySleep')
%     %Mouse 1566
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1567
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1568
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1569
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_AfterCNOInjection_RecoverySleep')
    % Mouse 1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210129/Sleep_Recovery/DREADD_1148_recov_210129_090255/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1149
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210129/Sleep_Recovery/DREADD_1149_recov_210129_090255/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210129/Sleep_Recovery/DREADD_1150_recov_210129_090255/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'inhibDREADD_CRH_VLPO_RecoverySleep')

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
