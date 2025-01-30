function Dir=PathForExperiments_Opto_Septum(experiment)

% input:
% name of the experiment.
% possible choices:
%'Baseline_20Hz'
%'Stim_20Hz' : opto stim 20Hz during REM or Wake periods (last 1min)


% output
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

%'Baseline_20Hz','Stim_20Hz'
%%
if strcmp(experiment,'Baseline_20Hz')   

%  

elseif strcmp(experiment,'Sham_20Hz')
    
%     %Mouse1055 02 juin 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1055_processed/M1055_Sham_60Hz_20Hz_interstim120sSleep_200602_100150/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     
%     %Mouse1052 26 mai 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1052_processed/M1052Sham200526/1052_Baseline3_200526_095043/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     
%     %Mouse1076 01 juillet 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1076_processed/Sham_1076_200701_095350/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     
%     %Mouse1075 03 juillet 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1075_processed/Opto_PFC_VLPO_1075_OptoSleep_Control_200703_092733/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     
%     %Mouse1076 16 juillet 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1076_processed/20200716/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    
elseif strcmp(experiment,'Stim_20Hz')

%     %Mouse1052
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1052_processed/M1052_OptoStim20Hz60s_REM_200527_125247/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     
%     %Mouse1052 27 mai 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1052_processed/M1052_OptoStim20Hz60s_REM_200527_125247/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     
%     %Mouse1052 05 juin 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1052_processed/M1052_OptoStim20Hz60s_REM_200605_092136/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     
%     %Mouse1052 12 juin 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1052_processed/M1052_OptoStim20Hz60s_REM_200612_103911/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     
%     %Mouse1055 22 mai 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1055_processed/M1055_OptoStimSleep20Hz60sInter2min_200522_092650/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
%    
%     %Mouse1055 29 mai 2020
%     a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1055_processed/M1055_OpotoStim_20Hz_60s_REM_1055_day4/OpotoStim_20Hz_60s_REM_1055_SleepBaseline_1052_day4_200529_122122/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']);
%     Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse

    
else
    error('Invalid name of experiment')
end


%% Get mice names
% for i=1:length(Dir.path)
%     Dir.manipe{i}=experiment;
%     temp=strfind(Dir.path{i}{1},'Mouse-');
%     if isempty(temp)
%         Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
%     else
%         Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+6:temp+8)];
%     end
%     %fprintf(Dir.name{i});
% end


% %% Get Groups
% 
% for i=1:length(Dir.path)
%     Dir.manipe{i}=experiment;
%     if strcmp(Dir.manipe{i},'UMazePAG')
%         for j=1:length(LFP)
%             Dir.group{1}{LFP(j)} = 'LFP';
%         end
%         for j=1:length(Neurons)
%             Dir.group{2}{Neurons(j)} = 'Neurons';
%         end
%         for j=1:length(ECG)
%             Dir.group{3}{ECG(j)} = 'ECG';
%         end
%     end
%     
%     if strcmp(Dir.manipe{i},'Hab') || strcmp(Dir.manipe{i},'TestPrePooled') ||strcmp(Dir.manipe{i},'CondPooled') ||...
%             strcmp(Dir.manipe{i},'TestPostPooled')
%         for j=1:length(LFP1)
%             Dir.group{1}{LFP1(j)} = 'LFP';
%         end
%         for j=1:length(Neurons1)
%             Dir.group{2}{Neurons1(j)} = 'Neurons';
%         end
%         for j=1:length(ECG1)
%             Dir.group{3}{ECG1(j)} = 'ECG';
%         end
%     end
% end

end