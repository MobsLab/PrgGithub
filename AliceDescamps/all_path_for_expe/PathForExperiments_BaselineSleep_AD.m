function Dir=PathForExperiments_BaselineSleep_AD(experiment)

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
if strcmp(experiment,'noVirus_BaselineSleep')
    %Mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240108/BaselineSleep/tetrodes_PFC_1539_baselineSleep_240108_092543/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240103/BaselineSleep/tetrodes_PFC_1540_BaselineSleep_240103_091129/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240108/BaselineSleep/tetrodes_PFC_1541_baselineSleep_240108_092543/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240110/BaselineSleep/tetrodes_PFC_1542_BaselineSleep_240110_093549/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240110/BaselineSleep/tetrodes_PFC_1543_BaselineSleep_240110_093549/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'mCherry_CRH_VLPO_BaselineSleep')
    %Mouse 1566
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS195/mCherry_CRH_1566_1567_1568_1569_BaselineSleep_240319_090534/M1566/';%sleep Scoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1567
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS195/mCherry_CRH_1566_1567_1568_1569_BaselineSleep_240319_090534/M1567/';%sleep Scoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1568
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS195/mCherry_CRH_1566_1567_1568_1569_BaselineSleep_240319_090534/M1568/';%sleep Scoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1569
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS195/mCherry_CRH_1566_1567_1568_1569_BaselineSleep_240326_085229/M1569/';%sleep Scoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_BaselineSleep') %%Mathilde DATA
    %%big volume of virus injection in the  VLPO (100nl)
    %Mouse 1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210203/BaselineSleep/DREADD_1148_Baseline4_210203_090602/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1149 %%%%COMMENT FOR BASALINE VS SALINE CODE
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210203/BaselineSleep/'; %% !! sleep scoring à corriger
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210203/BaselineSleep/DREADD_1150_Baseline4_210203_090602/'; %% !! sleep scoring à corriger
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%small volume of virus injection in the  VLPO (50nl)
    %Mouse 1217
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1217/20210720/BaselineSleep/DREADD_1217_Baseline3_210720_090213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1218
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1218/20210720/BaselineSleep/DREADD_1218_Baseline3_210720_090213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1219
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1219/20210720/BaselineSleep/DREADD_1219_Baseline3_210720_090213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1220
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1220/20210720/BaselineSleep/DREADD_1220_Baseline3_210720_090213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%small volume of virus injection in the  VLPO (50nl) %Mathilde and Alice experiments %find disk ??
    %Mouse 1371
    %Mouse 1372
    %Mouse 1373
    %Mouse 1374
    
    
    
elseif strcmp(experiment,'inhibDREADD_CRH_VLPO_BaselineSleep')
    %Mouse 1488 %%%%COMMENT FOR BASALINE VS SALINE CODE
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231017/BaselineSleep/CRH_inhi_1488_baselineSleep5_231017_083842/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231017/BaselineSleep/CRH_inhi_1489_baselineSleep5_231017_083842/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS182/CRH_inhi_1488_1510_1511_1512_baselineSleep_231026_084141/M1510/'; %sleepscoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS182/CRH_inhi_1488_1510_1511_1512_baselineSleep_231026_084141/M1511/'; %sleepscoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS182/CRH_inhi_1488_1510_1511_1512_baselineSleep_231026_084141/M1512/'; %sleepscoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

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
