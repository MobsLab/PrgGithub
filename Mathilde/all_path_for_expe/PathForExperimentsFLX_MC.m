function Dir = PathForExperimentsFLX_MC(experiment)

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
    
elseif strcmp(experiment,'dreadd_PFC_saline_flx')
    %%PFC inhibition mice
    % mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20211214/Sleep_Saline_Fluoxetine/DREADD_PFC_1196_Saline_fluoxetine_211214_085234/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211214/Sleep_Saline_Fluoxetine/DREADD_PFC_1237_Saline_fluoxetine_211214_085234/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211214/Sleep_Saline_Fluoxetine/DREADD_PFC_1238_Saline_fluoxetine_211214_085234/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%PFC-VLPO pathway inhibition mice
    % mouse 1245
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS160/DREADD_PFC_VLPO_1245_1247_1248_Saline_fluoxetine_220330_085522/1245/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     % mouse 1248
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS160/DREADD_PFC_VLPO_1245_1247_1248_Saline_fluoxetine_220330_085522/1248/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     % mouse 1247
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS160/DREADD_PFC_VLPO_1245_1247_1248_Saline_fluoxetine_220330_085522/1247/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
   
    
    
    %==========================================================================
    %                        inhibitory DREADD in PFC
    %              saline OR cno (2.5MG/KG) + FLUOXETINE AT 1PM
    %==========================================================================
    
elseif strcmp(experiment,'dreadd_PFC_cno_flx')
    % mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20211123/Sleep_CNO_fluoxetine_injection/DREADD_PFC_1196_CNO_fluoxetine_211123_085716/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211123/Sleep_CNO_fluoxetine_injection/DREADD_PFC_1237_CNO_fluoxetine_211123_085716/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211123/Sleep_CNO_fluoxetine_injection/DREADD_PFC_1238_CNO_fluoxetine_211123_085716/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
    %==========================================================================
    %                    retro-cre for PFC-VLPO inhibition
    %              saline OR cno (2.5MG/KG) + FLUOXETINE AT 1PM
    %==========================================================================
    
elseif strcmp(experiment,'retro_cre_cno_flx') %% update quand sur serveur
    % mouse 1245
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1245/20220510/Sleep_CNO_Fluoxetine/DREADD_PFC_VLPO_1245_CNO_FLX_220510_085935/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1247
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1247/20220510/Sleep_CNO_Fluoxetine/DREADD_PFC_VLPO_1247_CNO_FLX_220510_085935/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1248
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS160/DREADD_PFC_VLPO_1245_1247_1248_CNO_FLX_1254_CNO_220510_085935/1248/';
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

