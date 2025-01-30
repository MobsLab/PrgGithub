function Dir=PathForExperiments_TG(experiment)

% input:
% name of the experiment.
% possible choices:
%'atropine_Baseline','atropine_Atropine','atropine_Saline'
%'box_rat_Baseline1','box_rat_Exposure','box_rat_Baseline2'
%'box_rat_72h_Baseline1','box_rat_72h_Exposure','box_rat_72h_Baseline2'
%

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

%'atropine_Baseline','atropine_Atropine','atropine_Saline'
%'box_rat_Baseline1','box_rat_Exposure','box_rat_Baseline2'
%%
if strcmp(experiment,'atropine_Baseline')   

    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M923/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M926/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M927/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M928/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    
elseif strcmp(experiment,'atropine_Atropine')   

    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M923/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M926/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M927/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M928/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'atropine_Saline')   

    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M923/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M926/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M927/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M928/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_Baseline1')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box/927_928_Baseline1_box_rat_08102019_191008_103545/M927/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box/927_928_Baseline1_box_rat_08102019_191008_103545/M928/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_Exposure')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box/927_928_Exposure_box_rat_09102019_191009_100751/M927/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box/927_928_Exposure_box_rat_09102019_191009_100751/M928/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_Baseline2')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box/927_928_Baseline2_box_rat_10102019_191010_100238/M927/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box/927_928_Baseline2_box_rat_10102019_191010_100238/M928/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_72h_Baseline1')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box_72h/923_926_Baseline1_box_rat_72h_30102019_191030_102649/M923/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box_72h/923_926_Baseline1_box_rat_72h_30102019_191030_102649/M926/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_72h_Exposure')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box_72h/923_926_Exposure_box_rat_72h_31102019_191031_100146/M923/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box_72h/923_926_Exposure_box_rat_72h_31102019_191031_100146/M926/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_72h_Baseline2')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box_72h/923_926_Baseline2_box_rat_72h_01112019_191101_101432/M923/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Rat_box_72h/923_926_Baseline2_box_rat_72h_01112019_191101_101432/M926/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    
elseif strcmp(experiment,'BASAL')    
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M923/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M926/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M927/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M928/';
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