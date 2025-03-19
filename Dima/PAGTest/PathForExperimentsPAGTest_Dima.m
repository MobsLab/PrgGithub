function Dir=PathForExperimentsPAGTest_Dima(experiment)

% input:
% name of the experiment.
% possible choices:
% 'PAG' 'CalibB' 'CalibC'
% 'ContextADay1', 'ContextADay2', 'ContextBDay1', 'ContextBDay2', 'ContextCDay1', 'ContextCDay2'
% 'Hab' 'TestPre' 'Cond' 'TestPost' 'TestPost24h', 'TestImmediat'
% 'TestPrePooled', 'CondPooled', TestPostPooled', 'TestPost24hPooled'
% 'ExperimentDay'
% 'CalibB', 'CalibC'

% Groups:
% 'ContextB', 'ContextC' - Sophie's room and maze: ContextB; our maze and room: Context C 
% 'Anterior', 'Posterior' - Anterior and posterior electrodes
% 'First', 'Second' - First time in UMaze for the mouse, or the second time

% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperimentsPAGTest_Dima('CalibB');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperimentPAGTest_Dima(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentsERC_Dima.m
% PathForExperimentFEAR.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m

%% strains inputs

MICEgroups={'Ephys'};

% Animals that were recorded
Ephys={'Mouse783' 'Mouse785' 'Mouse786' 'Mouse787' 'Mouse788'};

% Groups
ContextB = [3 4 7 8]; % 785post, 786ant, 787post, 788ant
ContextC = [1 2 5 6]; % 783post, 785ant, 786post, 787ant

Anterior = [2 4 6 8]; %785ant, 786ant, 787ant, 788ant
Posterior = [1 3 5 7]; %783post, 785post, 786post, 787post

First = [1 2 5 7 8]; % 783post, 785ant, 786post, 787post, 788ant
Second = [3 4 6]; % 785post, 786ant, 787ant

ContextBImmediat = [3 4 6 7]; % 785post, 786post, 787post, 788ant
ContextCImmediat = [1 2 5]; % 783post, 785ant, 786ant

AnteriorImmediat = [2 4 6 7]; %785ant, 786ant, 787ant, 788ant
PosteriorImmediat = [1 3 5]; %783post, 785post, 786post

FirstImmediat = [1 2 5 7]; % 783post, 785ant, 786post, 788ant
SecondImmediat = [3 4 6]; % 785post, 786ant, 787ant

ContextB24 = [3 4]; % 787post, 788ant
ContextC24 = [1 2]; % 783post, 786post

Anterior24 = 4; % 788ant
Posterior24 = [1 2 3]; %783post, 786post, 787post

First24 = [1 2 3 4]; % 783post, 786post, 787post, 788ant
Second24 = []; % N/A

%% Path
a=0;
I_CA=[];
%%
if strcmp(experiment,'PAG')
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest//Mouse-786/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
elseif strcmp(experiment,'CalibB')
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-0,5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-1,5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-2,5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-3V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-4V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-5V/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationB/Calib-6V/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationB/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationB/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationB/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationB/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationB/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationB/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationB/Calib-3V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationB/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationB/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationB/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationB/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationB/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationB/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationB/Calib-3V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationB/Calib-3.5V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationB/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationB/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationB/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationB/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationB/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationB/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationB/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationB/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationB/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationB/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationB/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    
elseif strcmp(experiment,'CalibC')
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-0,5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-1,5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-2,5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-3V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-4V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-5V/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/09092018/CalibrationC/Calib-6V/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-3V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-3.5V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-4V/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-4.5V/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    Dir.path{a}{11}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-5V/';
    load([Dir.path{a}{11},'ExpeInfo.mat']),Dir.ExpeInfo{a}{11}=ExpeInfo;
    Dir.path{a}{12}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/09092018/CalibrationC/Calib-6V/';
    load([Dir.path{a}{12},'ExpeInfo.mat']),Dir.ExpeInfo{a}{12}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-3V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-3.5V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-4V/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-4.5V/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    Dir.path{a}{11}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/09092018/CalibrationC/Calib-5V/';
    load([Dir.path{a}{11},'ExpeInfo.mat']),Dir.ExpeInfo{a}{11}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-3V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-4V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-5V/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/09092018/CalibrationC/Calib-6V/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{11}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-0V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-0.5V/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-1V/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-1.5V/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    Dir.path{a}{5}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-2V/';
    load([Dir.path{a}{5},'ExpeInfo.mat']),Dir.ExpeInfo{a}{5}=ExpeInfo;
    Dir.path{a}{6}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-2.5V/';
    load([Dir.path{a}{6},'ExpeInfo.mat']),Dir.ExpeInfo{a}{6}=ExpeInfo;
    Dir.path{a}{7}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-3V/';
    load([Dir.path{a}{7},'ExpeInfo.mat']),Dir.ExpeInfo{a}{7}=ExpeInfo;
    Dir.path{a}{8}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-4V/';
    load([Dir.path{a}{8},'ExpeInfo.mat']),Dir.ExpeInfo{a}{8}=ExpeInfo;
    Dir.path{a}{9}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-5V/';
    load([Dir.path{a}{9},'ExpeInfo.mat']),Dir.ExpeInfo{a}{9}=ExpeInfo;
    Dir.path{a}{10}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-6V/';
    load([Dir.path{a}{10},'ExpeInfo.mat']),Dir.ExpeInfo{a}{10}=ExpeInfo;
    Dir.path{a}{11}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/09092018/CalibrationC/Calib-8V/';
    load([Dir.path{a}{11},'ExpeInfo.mat']),Dir.ExpeInfo{a}{11}=ExpeInfo;
    
elseif strcmp(experiment,'ContextADay1')
    
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-783/09092018/ContextANeutral/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-785/09092018/ContextANeutral/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-786/09092018/ContextANeutral/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-787/09092018/ContextANeutral/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'ContextADay2')
    
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextATest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextATest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextATest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextATest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextATest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'ContextBDay1')
    
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-6V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2.5V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-2V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2.5V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'ContextBDay2')
    
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextBTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextBTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextBTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextBTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextBTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'ContextCDay1')
    
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-3V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4.5V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-6V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-8V/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'ContextCDay2')
    
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextCTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextCTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextCTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextCTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextcTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
elseif strcmp(experiment,'Hab')
    
    %Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/Hab/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/Hab/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/Hab/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/Hab/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/Hab/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/Hab/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/11092018/Hab/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    %Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/Hab/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'TestPre')
    
    % Mouse783
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse785
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse786
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse787
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/11092018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse788
    a=a+1;
    cc=1;
    for c=1:4 %ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-9),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'Cond')
    
    % Mouse783
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse785
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse786
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse787
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/11092018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse788
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-6),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'TestImmediat')
    
    % Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/TestPost/TestPost0/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/TestPost/TestPost0/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/TestPost/TestPost0/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/TestPost/TestPost0/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/TestPost/TestPost0/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/TestPost/TestPost0/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/TestPost/TestPost0/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    

elseif strcmp(experiment,'TestPost')
    
    % Mouse783
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse785
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse786
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse787
    a=a+1;
    cc=1;
    for c=1:4 % ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/11092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse788
    a=a+1;
    cc=1;
    for c=1:4 %ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'TestPost24h')
    
    % Mouse783
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/12092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse786
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/11092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse787
    a=a+1;
    cc=1;
    for c=1:4 % post
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/Day4/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse788
    a=a+1;
    cc=1;
    for c=1:4 %ant
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/11092018/TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{1}(1:end-10),'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'TestPrePooled')
    
    % Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/TestPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/TestPre/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/TestPre/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/TestPre/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/TestPre/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/TestPre/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/11092018/TestPre/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/TestPre/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'CondPooled')
    
    % Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/Cond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/Cond/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/Cond/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/Cond/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/Cond/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/Cond/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/11092018/Cond/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/Cond/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
elseif strcmp(experiment,'TestPostPooled')
    
    % Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/TestPost/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/TestPost/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/TestPost/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/TestPost/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/TestPost/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/11092018/TestPost/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/TestPost/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPost24hPooled')
    
    % Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/12092018/TestPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/11092018/TestPost/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/Day4/TestPost/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/11092018/TestPost/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
    
    
elseif strcmp(experiment,'ExperimentDay')
    
    % Mouse783
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-783/11092018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse785
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/11092018/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-785/12092018/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse786
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/12092018/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-786/10092018/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse787
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/12092018/'; % ant
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-787/11092018/'; % post
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse788
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetPAGTest/Mouse-788/10092018/'; % ant
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
        Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+6:temp+8)];
    end
end

%% Get groups
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    if strcmp(Dir.manipe{i},'TestPre') || strcmp(Dir.manipe{i},'Cond') || strcmp(Dir.manipe{i},'TestPost')
        for j=1:length(ContextB)
            Dir.group{1}{ContextB(j)} = 'ContextB';
        end
        for j=1:length(ContextC)
            Dir.group{1}{ContextC(j)} = 'ContextC';
        end
        
        for j=1:length(Anterior)
            Dir.group{2}{Anterior(j)} = 'Anterior';
        end
        for j=1:length(Posterior)
            Dir.group{2}{Posterior(j)} = 'Posterior';
        end
        
        for j=1:length(First)
            Dir.group{3}{First(j)} = 'First';
        end
        for j=1:length(Second)
            Dir.group{3}{Second(j)} = 'Second';
        end
    end
    
    if strcmp(Dir.manipe{i},'Hab') || strcmp(Dir.manipe{i},'TestPrePooled') || strcmp(Dir.manipe{i},'CondPooled')
        for j=1:length(ContextB)
            Dir.group{1}{ContextB(j)} = 'ContextB';
        end
        for j=1:length(ContextC)
            Dir.group{1}{ContextC(j)} = 'ContextC';
        end
        
        for j=1:length(Anterior)
            Dir.group{2}{Anterior(j)} = 'Anterior';
        end
        for j=1:length(Posterior)
            Dir.group{2}{Posterior(j)} = 'Posterior';
        end
        
        for j=1:length(First)
            Dir.group{3}{First(j)} = 'First';
        end
        for j=1:length(Second)
            Dir.group{3}{Second(j)} = 'Second';
        end
    end
    
    if strcmp(Dir.manipe{i},'TestPostPooled') || strcmp(Dir.manipe{i},'ExperimentDay')
        for j=1:length(ContextB)
            Dir.group{1}{ContextB(j)} = 'ContextB';
        end
        for j=1:length(ContextC)
            Dir.group{1}{ContextC(j)} = 'ContextC';
        end
        
        for j=1:length(Anterior)
            Dir.group{2}{Anterior(j)} = 'Anterior';
        end
        for j=1:length(Posterior)
            Dir.group{2}{Posterior(j)} = 'Posterior';
        end
        
        for j=1:length(First)
            Dir.group{3}{First(j)} = 'First';
        end
        for j=1:length(Second)
            Dir.group{3}{Second(j)} = 'Second';
        end
    end
    
    if strcmp(Dir.manipe{i},'TestImmediat')
        for j=1:length(ContextBImmediat)
            Dir.group{1}{ContextBImmediat(j)} = 'ContextB';
        end
        for j=1:length(ContextCImmediat)
            Dir.group{1}{ContextCImmediat(j)} = 'ContextC';
        end
        
        for j=1:length(AnteriorImmediat)
            Dir.group{2}{AnteriorImmediat(j)} = 'Anterior';
        end
        for j=1:length(PosteriorImmediat)
            Dir.group{2}{PosteriorImmediat(j)} = 'Posterior';
        end
        
        for j=1:length(FirstImmediat)
            Dir.group{3}{FirstImmediat(j)} = 'First';
        end
        for j=1:length(SecondImmediat)
            Dir.group{3}{SecondImmediat(j)} = 'Second';
        end
    end
    
    if strcmp(Dir.manipe{i},'TestPost24h') || strcmp(Dir.manipe{i},'TestPost24hPooled')
        for j=1:length(ContextB24)
            Dir.group{1}{ContextB24(j)} = 'ContextB';
        end
        for j=1:length(ContextC24)
            Dir.group{1}{ContextC24(j)} = 'ContextC';
        end
        
        for j=1:length(Anterior24)
            Dir.group{2}{Anterior24(j)} = 'Anterior';
        end
        for j=1:length(Posterior24)
            Dir.group{2}{Posterior24(j)} = 'Posterior';
        end
        
        for j=1:length(First24)
            Dir.group{3}{First24(j)} = 'First';
        end
        for j=1:length(Second24)
            Dir.group{3}{Second24(j)} = 'Second';
        end
    end
end