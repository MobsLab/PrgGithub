function Dir=PathForExperiments_Opto(experiment)

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

    %Mouse645
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M645_processed/20180322/M675_M645_Baseline_protoSleep_1min_180322_104439/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/20180215/M648_Baseline sleep_180215_095425/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M675_processed/20180215/M675_Baseline_180215/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M733_processed/20180524/M733_Baseline_ProtoSleep_1min_180524_103728/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1076
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1076_processed/20200727/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'Stim_20Hz')
% 
    %Mouse645
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M645_processed/20180213/M645-opto-20Hz_180213_095308/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
 
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/20180216/M648_opto20Hz_180216_094032/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M675_processed/20180219/M675_Optostim20Hz_180219/VLPO_675_Optostim20Hz_180219_102539/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M733_processed/20180511/M733_Stim_ProtoSleep_1min_180511_103535/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
   
    %Mouse1074
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1074_processed/20200630/Opto_PFC_VLPO_1074_OptoSleep_200630_091210/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
%     
    %Mouse1076
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1076_processed/20200702/Opto_PFC_VLPO_1076_OptoSleep_200702_094338/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
 
    
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