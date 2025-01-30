function Dir=PathForExperiments_MC(experiment)

% input:
% name of the experiment.
% possible choices:
%'Baseline_OptoSleep','Stim_OptoSleep','Baseline2_OptoSleep'
%'Stim2_OptoSleep','Baseline3_OptoSleep','Stim3_OptoSleep'

% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperimentsTG('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%lHav
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

MICEgroups={'Ephys','Behaviour'};

% Animals that were recorded
Ephys={'Mouse711' 'Mouse712' 'Mouse714' 'Mouse741' 'Mouse742', 'Mouse753', 'Mouse797', 'Mouse798'};

% Animals with only behaviour
Behaviour={'Mouse621' 'Mouse626' 'Mouse627' 'Mouse703' 'Mouse708' 'Mouse743'};

%% Groups

% Concatenated
LFP = [1 2 4 5 6 7 8 9 10 11 12 13 14 15]; % Good LFP
Neurons = [1 6 7 8 10 12 13 14 15]; % Good Neurons
ECG = [1 3 5 7 9 10 11 14 15]; % Good ECG

% The rest
LFP1 = [1 2 4 5 6 7 8 9 10 11 12 13 14 15]; % Good LFP
Neurons1 = [1 6 7 8 10 12 13 14 15]; % Good Neurons
ECG1 = [1 3 5 7 9 10 11 14 15]; % Good ECG

%% Path
a=0;
I_CA=[];


%%
if strcmp(experiment,'Baseline_OptoSleep') 
    
    %Mouse645
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M645_processed/2017-12-15_VLPO-645-baseline1_15122017_091533/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/2017-11-29_VLPO-648-baseline1_171129_090338/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M675/Baseline/22032018/M675_M645_Baseline_protoSleep_1min_180322_104439/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M711/Baseline/17042018/M711_M675_Baseline_ProtoSleep_1min_180417_101952/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M733/Baseline/24052018/M733_Baseline_ProtoSleep_1min_180524_103728/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
        
elseif strcmp(experiment,'Baseline2_OptoSleep')
    
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/2017-11-30_VLPO_648_sleepbaseline2_171130_090822/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M675/Baseline/28032018/M675_M711_Baseline_ProtoSleep_1min_180328_111302/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M711/Baseline/28032018/M711_Baseline_ProtoSleep_1min_28032018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M733/Baseline/28052018/M733_Baseline_ProtoSleep_1min_180528_110038/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
       
        
elseif strcmp(experiment,'Baseline3_OptoSleep')
    
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/2017-12-12_VLPO-sleep Baseline day3_171212_093259/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
   
    
    
elseif strcmp(experiment,'Stim_OptoSleep')
        
    %Mouse645
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M645_processed/2017-12-19_VLPO-645-opto1_171219_094920/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/2017-12-01_VLPO_648_stimopto_day1_171201_101253/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M675/OptoSleep_1min_20Hz/21032018/M675_ProtoStimSleep_1min_180321_102404/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M711/OptoSleep_1min_20Hz/04042018/M711_Stim_ProtoSleep_1min_180404_102816/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M733/OptoSleep_1min_20Hz/04062018/M733_Stim_ProtoSleep_1min_180604_100548/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;


elseif strcmp(experiment,'Stim2_OptoSleep') 
        
    %Mouse645
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M645_processed/2017-12-21_VLPO-645-opto2_171221_101703/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/2017-12-07_VLPO-648-Stimopto-day2_171207_101708/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M675/OptoSleep_1min_20Hz/23032018/M675_Stim_ProtoSleep_1min_180323_103305/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M711/OptoSleep_1min_20Hz/10042018/M711_Stim2_ProtoSleep_1min_180410_103027/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M733/OptoSleep_1min_20Hz/11052018/M733_Stim_ProtoSleep_1min_180511_103535/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'Stim3_OptoSleep') 
                
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/2017-12-14_VLPO-648-optostim-day3_171214_093218/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
        
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/Project_PFC_VLPO/M733/OptoSleep_1min_20Hz/23052018/M733_Stim_ProtoSleep_1min_180523_102236/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    
    
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