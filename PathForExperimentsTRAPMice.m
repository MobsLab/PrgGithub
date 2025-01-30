function Dir=PathForExperimentsTRAPMice(experiment)

% input:
% name of the experiment.
% possible choices:

% 'SleepPreHab' 'HabA' 'HabB' 'SleepPostHab'
% Conditionning
% 'SleepPreTest' 'TestA' 'TestB' TestC' 'SleepPostTest'

% 'HabA_behav' 'HabB_behav'
% 'Conditionning_behav'
% 'TestA_behav' 'TestB_behav' TestC_behav'


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

%% strains inputs


%% Path
a=0;
I_CA=[];

if strcmp(experiment,'SleepPreHab')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D1/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D1/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D1/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D1/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D1/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'HabA')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D1/HabituationA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D1/HabituationA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D1/HabituationA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D1/HabituationA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D1/HabituationA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'HabB')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D1/HabituationB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D1/HabituationB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D1/HabituationB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D1/HabituationB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D1/HabituationB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPostHab')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D1/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D1/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D1/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D1/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D1/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPreCond')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D2/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D2/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D2/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D2/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D2/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPostCond')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D2/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D2/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D2/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D2/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D2/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPreTest')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D3/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse923/D4/SleepPre/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse923/D5/SleepPre/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D3/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse926/D4/SleepPre/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse926/D5/SleepPre/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D3/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse927/D4/SleepPre/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse927/D5/SleepPre/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D3/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse928/D4/SleepPre/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse928/D5/SleepPre/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D3/SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse929/D4/SleepPre/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse929/D5/SleepPre/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
elseif strcmp(experiment,'TestA')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D3/TestA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse923/D4/TestA/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse923/D5/TestA/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D3/TestA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse926/D4/TestA/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse926/D5/TestA/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D3/TestA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse927/D4/TestA/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse927/D5/TestA/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D3/TestA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse928/D4/TestA/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse928/D5/TestA/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D3/TestA/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse929/D4/TestA/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse929/D5/TestA/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
elseif strcmp(experiment,'TestB')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D3/TestB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse923/D4/TestB/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse923/D5/TestB/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D3/TestB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse926/D4/TestB/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse926/D5/TestB/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D3/TestB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse927/D4/TestB/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse927/D5/TestB/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D3/TestB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse928/D4/TestB/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse928/D5/TestB/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D3/TestB/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse929/D4/TestB/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse929/D5/TestB/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
elseif strcmp(experiment,'TestC')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D3/TestC/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse923/D4/TestC/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse923/D5/TestC/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D3/TestC/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse926/D4/TestC/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse926/D5/TestC/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D3/TestC/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse927/D4/TestC/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse927/D5/TestC/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D3/TestC/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse928/D4/TestC/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse928/D5/TestC/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D3/TestC/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse929/D4/TestC/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse929/D5/TestC/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPostTest')
    
    %Mouse923
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse923/D3/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse923/D4/SleepPost/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse923/D5/SleepPost/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse926
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse926/D3/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse926/D4/SleepPost/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse926/D5/SleepPost/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse927
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse927/D3/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse927/D4/SleepPost/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse927/D5/SleepPost/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse928
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse928/D3/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse928/D4/SleepPost/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse928/D5/SleepPost/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse929
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse929/D3/SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/TrapMice/Mouse929/D4/SleepPost/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/TrapMice/Mouse929/D5/SleepPost/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
elseif strcmp(experiment,'HabA_behav')
    
    %Mouse1038
    a=a+1;Dir.path{a}{1}='/media/nas4/TrapMice/Mouse1038/D1/HabituationA/M1038/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %Mouse1039
    a=a+1;Dir.path{a}{1}='//';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
else
    error('Invalid name of experiment')
end

end


% 'HabA_behav' 'HabB_behav'
% 'Conditionning_behav'
% 'TestA_behav' 'TestB_behav' TestC_behav'
