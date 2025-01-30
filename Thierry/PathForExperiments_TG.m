function Dir=PathForExperiments_TG(experiment)

% input:
% name of the experiment.
% possible choices:
%'atropine_Baseline','atropine_Atropine','atropine_Saline'
%'box_rat_Baseline1','box_rat_Exposure','box_rat_Baseline2'
%'box_rat_72h_Baseline1','box_rat_72h_Exposure','box_rat_72h_Baseline2'
%'CNO_CRFcre_session1_Baseline1','CNO_CRFcre_session1_CNO','CNO_CRFcre_session1_Baseline3','CNO_CRFcre_session1_Saline'
%'CNO_CRFcre_session2_Baseline2','CNO_CRFcre_session2_CNO','CNO_CRFcre_session2_Baseline3','CNO_CRFcre_session2_Saline'


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

%'atropine_Baseline','atropine_Atropine','atropine_Saline'
%'box_rat_Baseline1','box_rat_Exposure','box_rat_Baseline2'
%%
if strcmp(experiment,'atropine_Baseline')   

    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-09-24_08h51_M923_Baseline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-09-24_08h51_M926_Baseline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-09-24_08h51_M927_Baseline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-09-24_08h51_M928_Baseline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    
elseif strcmp(experiment,'atropine_Atropine')   

    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-09-26_09h48_M923_injection_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-09-26_09h48_M926_injection_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-09-26_09h48_M927_injection_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-09-26_09h48_M928_injection_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'atropine_Saline')   

    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-09-27_09h08_M923_Saline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-09-27_09h08_M926_Saline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-09-27_09h08_M927_Saline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-09-27_09h08_M928_Saline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_Baseline1')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-10-08_10h35_M927_Baseline1_box_rat/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-10-08_10h35_M928_Baseline1_box_rat/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_Exposure')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-10-09_10h07_M927_Exposure_box_rat/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-10-09_10h07_M928_Exposure_box_rat/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_Baseline2')
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-10-10_10h02_M927_Baseline2_box_rat/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-10-10_10h02_M928_Baseline2_box_rat/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_72h_Baseline1')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-10-30_10h26_M923_Baseline1_box_rat_72h/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-10-30_10h26_M926_Baseline1_box_rat_72h/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_72h_Exposure')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-10-31_10h01_M923_Exposure_box_rat_72h/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-10-31_10h01_M926_Exposure_box_rat_72h/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'box_rat_72h_Baseline2')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-11-01_10h14_M923_Baseline2_box_rat_72h/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-11-01_10h14_M926_Baseline2_box_rat_72h/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    
elseif strcmp(experiment,'CNO_CRFcre_session2_Baseline2')    
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-08-13_08h58_M929_Baseline2_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-08-13_08h58_M930_Baseline2_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    

elseif strcmp(experiment,'CNO_CRFcre_session2_CNO')    
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='//media/nas5/Thierry_DATA/M929_processed/2019-08-14_9h15_M929_CNOinjection_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-08-14_9h15_M930_CNOinjection_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    

elseif strcmp(experiment,'CNO_CRFcre_session2_Baseline3')    
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-08-15_08h58_M929_Baseline3_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-08-15_08h58_M930_Baseline3_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'CNO_CRFcre_session2_Saline')    
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-08-16_09h09_M929_Saline_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-08-16_09h09_M930_Saline_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'PFC-VLPO_dreadd-ex_Baseline1')    
    
    %Mouse1035
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1035_processed/2019-11-26_09h41_1035_Baseline1_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1036
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1036_processed/2019-11-26_09h41_1036_Baseline1_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1037
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1037_processed/2019-11-26_09h41_1037_Baseline1_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'PFC-VLPO_dreadd-ex_Saline')    
    
    %Mouse1035
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1035_processed/2019-11-27_09h19_1035_Saline_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1036
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1036_processed/2019-11-27_09h19_1036_Saline_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1037
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1037_processed/2019-11-27_09h19_1037_Saline_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'PFC-VLPO_dreadd-ex_Baseline2')    
    
    %Mouse1035
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1035_processed/2019-11-28_09h12_1035_Baseline2_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1036
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1036_processed/2019-11-28_09h12_1036_Baseline2_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1037
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1037_processed/2019-11-28_09h12_1037_Baseline2_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'PFC-VLPO_dreadd-ex_CNO')    
    
    %Mouse1035
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1035_processed/2019-11-29_09h25_1035_CNO_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1036
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1036_processed/2019-11-29_09h25_1036_CNO_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1037
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1037_processed/2019-11-29_09h25_1037_CNO_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
 
elseif strcmp(experiment,'CNO-CRFcre_Session1_Baseline2')    
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-07-09_9h15_M929_Baseline2_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-07-09_9h15_M930_Baseline2_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    
elseif strcmp(experiment,'CNO-CRFcre_Session1_CNO')    
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-07-10_9h15_M929_CNOinjection_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-07-10_9h15_M930_CNOinjection_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'CNO-CRFcre_Session1_Baseline3')    
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-07-11_9h15_M929_Baseline3_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-07-11_9h15_M930_Baseline3_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'CNO-CRFcre_Session1_Saline')    
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-07-12_9h15_M929_Saline_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-07-12_9h15_M930_Saline_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
 
    
elseif strcmp(experiment,'ExchangeCage_session2_Baseline2')    
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-08-06_09h15_M923_Baseline2_ExchangeCage_Session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-08-06_09h15_M926_Baseline2_ExchangeCage_Session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-08-06_09h15_M927_Baseline2_ExchangeCage_Session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-08-06_09h15_M928_Baseline2_ExchangeCage_Session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'ExchangeCage_session2_ExchangeCage')    
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-08-07_09h15_M923_Exchange_ExchangeCage_Session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-08-07_09h15_M926_Exchange_ExchangeCage_Session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-08-07_09h15_M927_Exchange_ExchangeCage_Session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-08-07_09h15_M928_Exchange_ExchangeCage_Session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'Basal')    
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M923_processed/2019-09-24_08h51_M923_Baseline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 926
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M926_processed/2019-09-24_08h51_M926_Baseline_atropine';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M927_processed/2019-09-24_08h51_M927_Baseline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse 928
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M928_processed/2019-09-24_08h51_M928_Baseline_atropine/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-08-13_08h58_M929_Baseline2_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-08-13_08h58_M930_Baseline2_CNO-CRFcre_session2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M929_processed/2019-07-09_9h15_M929_Baseline2_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse930
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M930_precessed/2019-07-09_9h15_M930_Baseline2_CNO-CRFcre_session1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1035
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1035_processed/2019-11-26_09h41_1035_Baseline1_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1036
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1036_processed/2019-11-26_09h41_1036_Baseline1_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse1037
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1037_processed/2019-11-26_09h41_1037_Baseline1_PFC-VLPO_dreadd-ex/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
else
    error('Invalid name of experiment')
end


%% Get mice names

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