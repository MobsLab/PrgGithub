 function Dir=PathForExperimentsERC_Dima(experiment)

% input:
% name of the experiment.
% possible choices:
% 'UMazePAG' for the whole day concatenated
% 
% 'HabBehav', 'TestPreBehav'
% 'Hab' 'PreSleep' 'TestPre' 'Cond' 'PostSleep' 'TestPost' 'TestPost24h'
% 'FindSleep', TestPrePooled', TestPostPooled' 'TestPost24hPooled'
% 'NeutralContextDay1' 'NeutralContextDay2' 'AversiveContextDay1' 'AversiveContextDay2'
% 'Calib', 'FirstExplo'

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

% MICEgroups={'Ephys','Behaviour'};
% 
% % Animals that were recorded
% Ephys={'Mouse711' 'Mouse712' 'Mouse714' 'Mouse741' 'Mouse742', 'Mouse753', 'Mouse797', 'Mouse798'};
% 
% % Animals with only behaviour
% Behaviour={'Mouse621' 'Mouse626' 'Mouse627' 'Mouse703' 'Mouse708' 'Mouse743'};

%% Groups

% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];

% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG

% The rest
LFP_fuit = [1 2 4 5 6 7 8 9 10 11 12 13 14 15]; % Good LFP
Neurons_fuit = [1 6 7 8 10 12 13 14 15]; % Good Neurons
ECG1_fuit = [1 3 5 6 9 10 14 15]; % Good ECG

%% Path
a=0;
I_CA=[];
% 'ERC'
% 'Hab' 'PreSleep' 'TestPre' 'Cond' 'PostSleep' 'TestPost' 'TestPost24h' 'FindSleep' 'UMaze'
%%
if strcmp(experiment,'UMazePAG')
    
    % Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse828
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-828/20190305/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse861
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse882
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse905
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse906
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse911
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-911/20190508/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse912
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse977
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse994
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-994/20191106/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1117
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1124
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1161
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1162
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1168
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1182
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1186
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1230
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1239
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'Reversal')
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
elseif strcmp(experiment,'UMazePAGPCdriven')
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
    
elseif strcmp(experiment,'FirstExplo')
    
    % Mouse828
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse861
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse882
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%     
%     % Mouse905
%     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse912
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse977
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse979
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % MouseK016
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M1016/FirstExplo-New/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'Calib')
    %Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib/Calib-0.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib/Calib-1.0V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib/Calib-2.0V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib/Calib-0.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib/Calib-1.0V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib/Calib-2.0V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib/Calib-3.0V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calib/Calib-0.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calib/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calib/Calib-1.0V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calib/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calib/Calib-2.0V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calib/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse741
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-0.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-1.0V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-2.0V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-3.0V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-3.5V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-4.0V/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/30052018/Calib/Calib-4.5V/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-0.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-1.0V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-2.0V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-3.0V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-0.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-1.0V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-2.0V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/Calib/Calib-0.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/Calib/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/Calib/Calib-1.0V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/Calib/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/Calib/Calib-2.0V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/Calib/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/Calib/Calib-3.0V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-0.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{3}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-1.0V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{4}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{5}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-2.0V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{6}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{7}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-3.0V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{8}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-3.5V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{9}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-4.0V/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    Dir.path{a}{10}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-4.5V/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'NeutralContextDay1')
    
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/NeutralContextDay1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/NeutralContextDay1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'NeutralContextDay2')
    
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/NeutralContextDay2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/11112018/NeutralContextDay2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'AversiveContextDay1')
    
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/10112018/Calib/Calib-3.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/10112018/Calib/Calib-4.0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'AversiveContextDay2')
    
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/AversiveContextDay2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/11112018/AversiveContextDay2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'HabBehav')
    
    % Mouse621
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-621/UMaze-Hab-11102017/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-621/UMaze-Hab-23102017/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    % Mouse626
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/02022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-03022018-Hab_00/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/06022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-06022018-Hab_00/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/08022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-08022018-Hab_00/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    % Mouse627
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/15022018_Mouse-627-UMaze/FEAR-Mouse-627-15022018-Hab_00/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/16022018_Mouse-627-UMaze/FEAR-Mouse-627-16022018-Hab_00/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/17022018_Mouse-627-UMaze/FEAR-Mouse-627-17022018-Hab_00/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    % Mouse703
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/07022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-07022018-Hab_00/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/08022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-08022018-Hab_00/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/10022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-10022018-Hab_00/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    % Mouse708
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/07022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-07022018-Hab_00/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/08022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-08022018-Hab_00/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    % Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/15032018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Hab/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/01042018/UMaze/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/01042018/UMaze2/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    %Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/Hab/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/20022018-UMaze/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/20022018-UMaze/Hab2/raw/FEAR-Mouse-714-20022018-Hab_01/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/Hab/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    %Mouse741
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse743
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-743/30052018/1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-743/30052018/2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-743/30052018/3/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-743/31052018/Hab/4/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-743/31052018/Hab/5/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-743/01062018/Hab/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    %Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'Hab')
    
    % Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/Hab/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse741
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse828
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-828/20190305/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse861
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse882
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse905
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse906
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-906/20190418/PAGExp/6-Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse911
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-911/20190508/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse912
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/07-Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse977
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-977/20190812/PAGexp/Hab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse994
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-994/20191013/PagExp/Hab/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1081
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs113/Mouse-K081/20200925/02 Maze2/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1115
    a=a+1;Dir.path{a}{1}='/media/mobsrick/Mouse-K115/20201006/02 Maze2/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1117
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs129/Mouse-K117/20201109/Hab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1124
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs129/Mouse-K124/20201120/Hab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1161
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs129/Mouse-K161/20201224/Hab/ERC-Mouse-1161-24122020-Hab_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs129/Mouse-K161/20201224/Hab/ERC-Mouse-1161-24122020-Hab_01/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1162
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/Hab/ERC-Mouse-1162-21012021-Hab_00/';
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Hab/ERC-Mouse-1162-13012021-Hab_00/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1168
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/Hab/ERC-Mouse-1168-22012021-Hab_00/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1182
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/Hab/ERC-Mouse-1182-01032021-Hab_00/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1186
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/Hab/ERC-Mouse-1186-09042021-Hab_00/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1199
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K199/20210408/Hab/ERC-Mouse-1199-08042021-Hab_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K199/20210408/Hab/ERC-Mouse-1199-08042021-Hab_01/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1228
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Hab_00/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%     %Mouse1230
% %     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/Hab/ERC-Mouse-1230-27092021-Hab_00/';
% %     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/Hab/ERC-Mouse-1230-04102021-Hab_01/';
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/Hab/ERC-Mouse-1230-12102021-Hab_00/';
%     %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1230
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Hab_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Hab_01/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%     %Mouse1230
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/Hab/ERC-Mouse-1239-27102021-Hab_00/';
%     %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1239
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/Hab/ERC-Mouse-1239-10112021-Hab_01/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/Hab/ERC-Mouse-1239-10112021-Hab_03/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPreFakeStim')
    
    %Mouse1081
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs113/Mouse-K081/20200925/04 TestPreFake/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    %Mouse1115
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs129/Mouse-K115/20201006/04 TestPreFakeSleep/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'PreSleep')
    
    %Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse741
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'TestPreBehav')
    
    % Mouse626
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/02022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-03022018-TestPre_00/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/02022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-03022018-TestPre_01/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/02022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-03022018-TestPre_02/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/02022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-03022018-TestPre_03/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/06022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-06022018-TestPre_00/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/06022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-06022018-TestPre_01/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/06022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-06022018-TestPre_02/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/06022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-06022018-TestPre_03/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/08022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-08022018-TestPre_00/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/08022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-08022018-TestPre_01/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    Dir.path{a}{11}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/08022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-08022018-TestPre_02/';
    load([Dir.path{a}{11},'ExpeInfo.mat']),Dir.ExpeInfo{a}{11}=ExpeInfo;
    Dir.path{a}{12}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-626/08022018_Mouse-626-UMaze-Behavior/FEAR-Mouse-626-08022018-TestPre_03/';
    load([Dir.path{a}{12},'ExpeInfo.mat']),Dir.ExpeInfo{a}{12}=ExpeInfo;
    
    % Mouse627
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/15022018_Mouse-627-UMaze/FEAR-Mouse-627-15022018-TestPre_00/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/15022018_Mouse-627-UMaze/FEAR-Mouse-627-15022018-TestPre_01/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/15022018_Mouse-627-UMaze/FEAR-Mouse-627-15022018-TestPre_02/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/15022018_Mouse-627-UMaze/FEAR-Mouse-627-15022018-TestPre_03/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/16022018_Mouse-627-UMaze/FEAR-Mouse-627-16022018-TestPre_00/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/16022018_Mouse-627-UMaze/FEAR-Mouse-627-16022018-TestPre_01/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/16022018_Mouse-627-UMaze/FEAR-Mouse-627-16022018-TestPre_02/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/16022018_Mouse-627-UMaze/FEAR-Mouse-627-16022018-TestPre_03/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/17022018_Mouse-627-UMaze/FEAR-Mouse-627-17022018-TestPre_00/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/17022018_Mouse-627-UMaze/FEAR-Mouse-627-17022018-TestPre_01/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    Dir.path{a}{11}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/17022018_Mouse-627-UMaze/FEAR-Mouse-627-17022018-TestPre_02/';
    load([Dir.path{a}{11},'ExpeInfo.mat']),Dir.ExpeInfo{a}{11}=ExpeInfo;
    Dir.path{a}{12}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-627/17022018_Mouse-627-UMaze/FEAR-Mouse-627-17022018-TestPre_03/';
    load([Dir.path{a}{12},'ExpeInfo.mat']),Dir.ExpeInfo{a}{12}=ExpeInfo;
    
    % Mouse703
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/07022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-07022018-TestPre_00/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/07022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-07022018-TestPre_01/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/07022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-07022018-TestPre_02/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/07022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-07022018-TestPre_03/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/08022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-08022018-TestPre_00/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/08022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-08022018-TestPre_01/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/08022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-08022018-TestPre_02/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/08022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-08022018-TestPre_03/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/10022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-10022018-TestPre_00/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/10022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-10022018-TestPre_01/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    Dir.path{a}{11}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/10022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-10022018-TestPre_02/';
    load([Dir.path{a}{11},'ExpeInfo.mat']),Dir.ExpeInfo{a}{11}=ExpeInfo;
    Dir.path{a}{12}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-703/10022018_Mouse-703-UMaze-Behavior/FEAR-Mouse-703-10022018-TestPre_03/';
    load([Dir.path{a}{12},'ExpeInfo.mat']),Dir.ExpeInfo{a}{12}=ExpeInfo;
      
    % Mouse708
    a=a+1; Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/07022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-07022018-TestPre_00/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/07022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-07022018-TestPre_01/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/07022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-07022018-TestPre_02/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/07022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-07022018-TestPre_03/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/08022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-08022018-TestPre_00/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/08022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-08022018-TestPre_01/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/08022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-08022018-TestPre_02/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-708/08022018_Mouse-708-UMaze-Behavior/FEAR-Mouse-708-08022018-TestPre_03/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    
    % Mouse711
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse712
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse714
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse741
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse742
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse753
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse797
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse798
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end

elseif strcmp(experiment,'TestPre')
    
    % Mouse711
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse712
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse714
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse741
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse742
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse753
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse797
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse798
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse828
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-828/20190305/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse861
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse882
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse905
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse906
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-906/20190418/PAGExp/7-TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse911
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-911/20190508/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse912
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/08-TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse977
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-977/20190812/PAGexp/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse994
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-994/20191013/PagExp/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1081
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs113/Mouse-K081/20200925/05 TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1115
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K115/20201006/05 TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1117
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K117/20201109/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1124
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K124/20201120/TestPre/TestPre',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1161
    a=a+1;
    cc=0;
    for c=1:4
        Dir.path{a}{c}=['/media/mobsrick/DataMOBs129/Mouse-K161/20201224/TestPre/ERC-Mouse-1161-24122020-TestPre_0',num2str(cc),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1162
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/TestPre/TestPre1/ERC-Mouse-1162-21012021-TestPre_00/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/TestPre/TestPre2/ERC-Mouse-1162-21012021-TestPre_03/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/TestPre/TestPre3/ERC-Mouse-1162-21012021-TestPre_04/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/TestPre/TestPre4/ERC-Mouse-1162-21012021-TestPre_05/';
    
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PreTests/ERC-Mouse-1162-13012021-TestPre_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PreTests/ERC-Mouse-1162-13012021-TestPre_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PreTests/ERC-Mouse-1162-13012021-TestPre_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PreTests/ERC-Mouse-1162-13012021-TestPre_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PreTests/ERC-Mouse-1162-13012021-TestPre_04/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PreTests/ERC-Mouse-1162-13012021-TestPre_05/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PreTests/ERC-Mouse-1162-13012021-TestPre_06/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PreTests/ERC-Mouse-1162-13012021-TestPre_07/';
    
    % Mouse1168
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/TestPre/TestPre1/ERC-Mouse-1168-22012021-TestPre_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/TestPre/TestPre2/ERC-Mouse-1168-22012021-TestPre_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/TestPre/TestPre3/ERC-Mouse-1168-22012021-TestPre_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/TestPre/TestPre4/ERC-Mouse-1168-22012021-TestPre_03/';
    
    % Mouse1182
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/TestPre/ERC-Mouse-1182-01032021-TestPre_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/TestPre/ERC-Mouse-1182-01032021-TestPre_02/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/TestPre/ERC-Mouse-1182-01032021-TestPre_03/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/TestPre/ERC-Mouse-1182-01032021-TestPre_04/';
    
    % Mouse1186
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/TestPre/ERC-Mouse-1186-09042021-TestPre_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/TestPre/ERC-Mouse-1186-09042021-TestPre_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/TestPre/ERC-Mouse-1186-09042021-TestPre_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/TestPre/ERC-Mouse-1186-09042021-TestPre_03/';

    % Mouse1199
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/PreTests/ERC-Mouse-1199-08042021-TestPre_02/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/PreTests/ERC-Mouse-1199-08042021-TestPre_03/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/PreTests/ERC-Mouse-1199-08042021-TestPre_04/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/PreTests/ERC-Mouse-1199-08042021-TestPre_05/';
    
    % Mouse1228 - Novel
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPre_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPre_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPre_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPre_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPre_04/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPre_05/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPre_06/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPre_07/';
    
%     % Mouse1230
% %     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/TestPre/ERC-Mouse-1230-27092021-TestPre_00/';
% %     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/TestPre/ERC-Mouse-1230-27092021-TestPre_01/';
% %     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/TestPre/ERC-Mouse-1230-27092021-TestPre_02/';
% %     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/TestPre/ERC-Mouse-1230-27092021-TestPre_03/';
% %     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/TestPre/ERC-Mouse-1230-04102021-TestPre_00/';
% %     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/TestPre/ERC-Mouse-1230-04102021-TestPre_01/';
% %     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/TestPre/ERC-Mouse-1230-04102021-TestPre_02/';
% %     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/TestPre/ERC-Mouse-1230-04102021-TestPre_03/';
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/TestPre/ERC-Mouse-1230-12102021-TestPre_00/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/TestPre/ERC-Mouse-1230-12102021-TestPre_01/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/TestPre/ERC-Mouse-1230-12102021-TestPre_02/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/TestPre/ERC-Mouse-1230-12102021-TestPre_03/';
    
    % Mouse1230
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPre_01/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPre_02/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPre_03/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPre_04/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPre_05/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPre_06/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPre_07/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPre_08/';
    
%     % Mouse1239
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/TestPre/ERC-Mouse-1239-27102021-TestPre_00/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/TestPre/ERC-Mouse-1239-27102021-TestPre_01/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/TestPre/ERC-Mouse-1239-27102021-TestPre_02/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/TestPre/ERC-Mouse-1239-27102021-TestPre_03/';
    
    % Mouse1239
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/TestPre/ERC-Mouse-1239-10112021-TestPre_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/TestPre/ERC-Mouse-1239-10112021-TestPre_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/TestPre/ERC-Mouse-1239-10112021-TestPre_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/TestPre/ERC-Mouse-1239-10112021-TestPre_03/';
    
elseif strcmp(experiment,'Cond')
    
    % Mouse711
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse712
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse714
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse741
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse742
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse753
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse797
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse798
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse828
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-828/20190305/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse861
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse882
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse905
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse906
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-906/20190418/PAGExp/8-Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse911
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-911/20190508/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse912
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/09-Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse977
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-977/20190812/PAGexp/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse994
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-994/20191013/PagExp/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1081
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs113/Mouse-K081/20200925/06 Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1117
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K117/20201109/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1124
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K124/20201120/Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1161
    a=a+1;
    cc=0;
    for c=1:4
        Dir.path{a}{c}=['/media/mobsrick/DataMOBs129/Mouse-K161/20201224/Cond/ERC-Mouse-1161-24122020-Cond_0',num2str(cc),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1162
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/Cond/Cond1/ERC-Mouse-1162-21012021-Cond_01/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/Cond/Cond2/ERC-Mouse-1162-21012021-Cond_02/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/Cond/Cond3/ERC-Mouse-1162-21012021-Cond_04/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/Cond/Cond4/ERC-Mouse-1162-21012021-Cond_05/';
    
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Cond/ERC-Mouse-1162-13012021-Cond_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Cond/ERC-Mouse-1162-13012021-Cond_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Cond/ERC-Mouse-1162-13012021-Cond_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Cond/ERC-Mouse-1162-13012021-Cond_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Cond/ERC-Mouse-1162-13012021-Cond_04/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Cond/ERC-Mouse-1162-13012021-Cond_05/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Cond/ERC-Mouse-1162-13012021-Cond_06/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/Cond/ERC-Mouse-1162-13012021-Cond_07/';
    
    % Mouse1168
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/Cond/Cond1/ERC-Mouse-1168-22012021-Cond_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/Cond/Cond2/ERC-Mouse-1168-22012021-Cond_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/Cond/Cond3/ERC-Mouse-1168-22012021-Cond_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/Cond/Cond4/ERC-Mouse-1168-22012021-Cond_03/';
    
    % Mouse1182
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/Cond/ERC-Mouse-1182-01032021-Cond_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/Cond/ERC-Mouse-1182-01032021-Cond_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/Cond/ERC-Mouse-1182-01032021-Cond_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/Cond/ERC-Mouse-1182-01032021-Cond_03/';
    
    % Mouse1186
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/Cond/ERC-Mouse-1186-09042021-Cond_01/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/Cond/ERC-Mouse-1186-09042021-Cond_02/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/Cond/ERC-Mouse-1186-09042021-Cond_03/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/Cond/ERC-Mouse-1186-09042021-Cond_04/';

    % Mouse1199
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/Cond/ERC-Mouse-1199-08042021-Cond_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/Cond/ERC-Mouse-1199-08042021-Cond_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/Cond/ERC-Mouse-1199-08042021-Cond_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/Cond/ERC-Mouse-1199-08042021-Cond_03/';
    
    % Mouse1228 - Novel
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Cond_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Cond_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Cond_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Cond_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Cond_04/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Cond_05/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Cond_06/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Cond_07/';
    
%     % Mouse1230
% %     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/Cond/ERC-Mouse-1230-27092021-Cond_00/';
% %     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/Cond/ERC-Mouse-1230-27092021-Cond_01/';
% %     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/Cond/ERC-Mouse-1230-27092021-Cond_02/';
% %     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/Cond/ERC-Mouse-1230-27092021-Cond_03/';
% %     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/Cond/ERC-Mouse-1230-04102021-Cond_00/';
% %     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/Cond/ERC-Mouse-1230-04102021-Cond_01/';
% %     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/Cond/ERC-Mouse-1230-04102021-Cond_02/';
% %     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/Cond/ERC-Mouse-1230-04102021-Cond_03/';
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/Cond/ERC-Mouse-1230-12102021-Hab_01/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/Cond/ERC-Mouse-1230-12102021-Hab_02/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/Cond/ERC-Mouse-1230-12102021-Hab_04/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/Cond/ERC-Mouse-1230-12102021-Hab_06/';
    
    % Mouse1230
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Cond_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Cond_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Cond_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Cond_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Cond_04/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Cond_05/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Cond_06/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Cond_07/';
    
%     % Mouse1239
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/Cond/ERC-Mouse-1239-27102021-Hab_01/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/Cond/ERC-Mouse-1239-27102021-Hab_02/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/Cond/ERC-Mouse-1239-27102021-Hab_03/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/Cond/ERC-Mouse-1239-27102021-Hab_05/';

   % Mouse1239
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/Cond/ERC-Mouse-1239-10112021-Cond_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/Cond/ERC-Mouse-1239-10112021-Cond_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/Cond/ERC-Mouse-1239-10112021-Cond_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/Cond/ERC-Mouse-1239-10112021-Cond_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/Cond/ERC-Mouse-1239-10112021-Cond_04/';
    
elseif strcmp(experiment, 'CondPCDriven')
    
    % Mouse1115
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K115/20201006/06 Cond/Cond',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'PostSleep')
    
    %Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/PostSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/PostSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/PostSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse741
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/PostSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/PostSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/PostSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/PostSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/PostSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'TestPost')
    
    % Mouse711
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse712
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse714
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse742
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse753
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse797
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse798
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse828
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-828/20190305/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse861
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse882
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse905
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse906
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-906/20190418/PAGExp/10-TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse911
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-911/20190508/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse912
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/11-TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse977
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-977/20190812/PAGexp/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse994
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-994/20191013/PagExp/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1081
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs113/Mouse-K081/20200925/08 TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1115
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K115/20201006/08 TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1117
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K117/20201109/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1124
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/mobsrick/DataMOBs129/Mouse-K124/20201120/TestPost/TestPost',num2str(c),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1161
    a=a+1;
    cc=0;
    for c=1:4
        Dir.path{a}{c}=['/media/mobsrick/DataMOBs129/Mouse-K161/20201224/TestPost/ERC-Mouse-1161-24122020-TestPost_0',num2str(cc),'/'];
%         load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1162
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/TestPost/TestPost1/ERC-Mouse-1162-21012021-TestPost_00/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/TestPost/TestPost2/ERC-Mouse-1162-21012021-TestPost_01/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/TestPost/TestPost3/ERC-Mouse-1162-21012021-TestPost_02/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/TestPost/TestPost4/ERC-Mouse-1162-21012021-TestPost_03/';
    
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PostTests/ERC-Mouse-1162-13012021-TestPost_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PostTests/ERC-Mouse-1162-13012021-TestPost_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PostTests/ERC-Mouse-1162-13012021-TestPost_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PostTests/ERC-Mouse-1162-13012021-TestPost_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PostTests/ERC-Mouse-1162-13012021-TestPost_04/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PostTests/ERC-Mouse-1162-13012021-TestPost_05/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PostTests/ERC-Mouse-1162-13012021-TestPost_06/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBs139/Mouse-K162/20210113/PostTests/ERC-Mouse-1162-13012021-TestPost_07/';
    
    % Mouse1168
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/TestPost/TestPost1/ERC-Mouse-1168-22012021-TestPost_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/TestPost/TestPost2/ERC-Mouse-1168-22012021-TestPost_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/TestPost/TestPost3/ERC-Mouse-1168-22012021-TestPost_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/TestPost/TestPost4/ERC-Mouse-1168-22012021-TestPost_03/';
    
    % Mouse1182
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/TestPost/ERC-Mouse-1182-01032021-TestPost_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/TestPost/ERC-Mouse-1182-01032021-TestPost_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/TestPost/ERC-Mouse-1182-01032021-TestPost_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/TestPost/ERC-Mouse-1182-01032021-TestPost_03/';
    
    % Mouse1186
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/TestPost/ERC-Mouse-1186-09042021-TestPost_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/TestPost/ERC-Mouse-1186-09042021-TestPost_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/TestPost/ERC-Mouse-1186-09042021-TestPost_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/TestPost/ERC-Mouse-1186-09042021-TestPost_03/';

    % Mouse1199
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/PostTests/ERC-Mouse-1199-08042021-TestPost_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/PostTests/ERC-Mouse-1199-08042021-TestPost_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/PostTests/ERC-Mouse-1199-08042021-TestPost_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K199/20210408/PostTests/ERC-Mouse-1199-08042021-TestPost_03/';
    
    % Mouse1228 - Novel
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPost_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPost_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPost_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPost_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPost_04/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPost_05/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPost_06/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-TestPost_07/';
    
%     % Mouse1230
% %     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/TestPost/ERC-Mouse-1230-27092021-TestPost_00/';
% %     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/TestPost/ERC-Mouse-1230-27092021-TestPost_01/';
% %     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/TestPost/ERC-Mouse-1230-27092021-TestPost_02/';
% %     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/TestPost/ERC-Mouse-1230-27092021-TestPost_03/';
% %     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/TestPost/ERC-Mouse-1230-04102021-TestPost_00/';
% %     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/TestPost/ERC-Mouse-1230-04102021-TestPost_01/';
% %     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/TestPost/ERC-Mouse-1230-04102021-TestPost_02/';
% %     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/TestPost/ERC-Mouse-1230-04102021-TestPost_03/';
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/TestPost/ERC-Mouse-1230-12102021-TestPost_00/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/TestPost/ERC-Mouse-1230-12102021-TestPost_01/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/TestPost/ERC-Mouse-1230-12102021-TestPost_02/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/TestPost/ERC-Mouse-1230-12102021-TestPost_03/';
    
    % Mouse1230
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPost_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPost_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPost_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPost_03/';
    Dir.path{a}{5}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPost_04/';
    Dir.path{a}{6}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPost_05/';
    Dir.path{a}{7}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPost_06/';
    Dir.path{a}{8}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-TestPost_07/';
    
%     % Mouse1239
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/TestPost/ERC-Mouse-1239-27102021-TestPost_00/';
%     Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/TestPost/ERC-Mouse-1239-27102021-TestPost_01/';
%     Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/TestPost/ERC-Mouse-1239-27102021-TestPost_02/';
%     Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K239/20211027/TestPost/ERC-Mouse-1239-27102021-TestPost_03/';
    
    % Mouse1239
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/TestPost/ERC-Mouse-1239-10112021-TestPost_00/';
    Dir.path{a}{2}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/TestPost/ERC-Mouse-1239-10112021-TestPost_01/';
    Dir.path{a}{3}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/TestPost/ERC-Mouse-1239-10112021-TestPost_02/';
    Dir.path{a}{4}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/TestPost/ERC-Mouse-1239-10112021-TestPost_03/';
    
elseif strcmp(experiment,'TestPost24h')
    
    % Mouse711
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/18032018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse712
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/13042018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse714
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/28022018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse753
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/18072018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse797
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetERC2/12112018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse798
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8/mobs/ProjetERC2/Mouse-798/13112018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
elseif strcmp(experiment,'BaselineSleep')
    
    %Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/15032018/BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/11042018/PreSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse714
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/19022018/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/20022018/BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse741
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/13052018/BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/29052018/BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/16052018/BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/29052018/BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
elseif strcmp(experiment,'ExploAfter')
    
    %Mouse861
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/ExploAfter/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse882
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/ExploAfter/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse905
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/ExploAfter/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse906
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-906/20190418/PAGExp/11-ExploAfter/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse912
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/12-ExploAfter/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse977
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-977/20190812/PAGexp/ExploAfter/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse994
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-994/20191013/PagExp/ExploAfter/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1081
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs113/Mouse-K081/20200925/09 Extinction/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1115
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs129/Mouse-K115/20201006/09 Ext/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1117
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs129/Mouse-K117/20201109/Ext/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1124
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs129/Mouse-K124/20201120/Extinction/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1161
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs129/Mouse-K161/20201224/Extinction/ERC-Mouse-1161-24122020-Hab_02/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1162
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K162/20210121/Extinction/ERC-Mouse-1162-21012021-Hab_01/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1168
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K168/20210122/Extinction/ERC-Mouse-1168-22012021-Hab_01/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1182
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K182/20210301/Extinction/ERC-Mouse-1182-01032021-Hab_01/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1186
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K186/20210409/Ext/ERC-Mouse-1186-09042021-Hab_01/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1199
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs139/Mouse-K199/20210408/Ext/ERC-Mouse-1199-08042021-Hab_02/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1228
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K228/20210809/behavior/ERC-Mouse-1228-09082021-Ext_01/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1230
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20210927/Extinction/ERC-Mouse-1230-27092021-Hab_01/';
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211004/Extinction/ERC-Mouse-1230-04102021-Hab_00/';
%     a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K230/20211012/Ext/ERC-Mouse-1230-12102021-Hab_07/';
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS141/Mouse-K230/20210826/behavior/ERC-Mouse-1230-26082021-Hab_02/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse1239
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBs144/Mouse-K239/20211110/Ext/ERC-Mouse-1239-10112021-Hab_04/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;

    
    
elseif strcmp(experiment,'TestPrePooled')
    
    % Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse741
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse828
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-828/20190305/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse861
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse882
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse905
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse906
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS101/Mouse-906/20190418/PAGExp/7-TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse911
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-911/20190508/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse912
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/08-TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'CondPooled')
    
    % Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse741
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-741/31052018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse828
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-828/20190305/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse861
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse882
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse905
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse906
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS101/Mouse-906/20190418/PAGExp/8-Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse911
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-911/20190508/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse912
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/09-Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'TestPostPooled')
    
    % Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse742
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/12112018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse828
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-828/20190305/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse861
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-861/20190313/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse882
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-882/20190409/PAGexp/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse905
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse906
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS101/Mouse-906/20190418/PAGExp/10-TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse911
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-911/20190508/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse912
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-912/20190515/PAGexp/11-TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'TestPost24hPooled')
    
    % Mouse711
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/18032018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse712
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/13042018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse714
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/28022018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse753
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/18072018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse797
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/12112018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse798
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/ProjetERC2/Mouse-798/13112018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
else
    error('Invalid name of experiment')
end


%% Get mice names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i}{1},'Mouse-');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
    else
        if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
            Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
        else
            Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
        end
    end
    %fprintf(Dir.name{i});
end


%% Get Groups

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    if strcmp(Dir.manipe{i},'UMazePAG')
        % Allocate
        Dir.group{1} = cell(length(Dir.path),1);
        Dir.group{2} = cell(length(Dir.path),1);
        Dir.group{3} = cell(length(Dir.path),1);
        Dir.group{4} = cell(length(Dir.path),1);
        Dir.group{5} = cell(length(Dir.path),1);
        Dir.group{6} = cell(length(Dir.path),1);
        
        for j=1:length(LFP)
            Dir.group{1}{LFP(j)} = 'LFP';
        end
        for j=1:length(Neurons)
            Dir.group{2}{Neurons(j)} = 'Neurons';
        end
        for j=1:length(ECG)
            Dir.group{3}{ECG(j)} = 'ECG';
        end
        for j=1:length(OB_resp)
            Dir.group{4}{OB_resp(j)} = 'OB_resp';
        end
        for j=1:length(OB_gamma)
            Dir.group{5}{OB_gamma(j)} = 'OB_gamma';
        end
        for j=1:length(PFC)
            Dir.group{6}{PFC(j)} = 'PFC';
        end
    end
    
    if strcmp(Dir.manipe{i},'Hab') || strcmp(Dir.manipe{i},'TestPrePooled') ||strcmp(Dir.manipe{i},'CondPooled') ||...
            strcmp(Dir.manipe{i},'TestPostPooled')
        for j=1:length(LFP_All)
            Dir.group{1}{LFP_All(j)} = 'LFP';
        end
        for j=1:length(Neurons_All)
            Dir.group{2}{Neurons_All(j)} = 'Neurons';
        end
        for j=1:length(ECG_All)
            Dir.group{3}{ECG_All(j)} = 'ECG';
        end
    end
end

end