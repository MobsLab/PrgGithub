%% Almost every code in this script is derived from those present in Post_PreProcess_BasicEphysComputations
% Which was written by SB and BM

clear all

% RIP SLEEP PROTOCOL
SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
    'TestPre_PreDrug' 'UMazeCondExplo_PreDrug'  'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
    'SleepPost_PreDrug' ' TestPost_PreDrug' 'ExtinctionBlockedShock_PreDrug' 'ExtinctionBlockedSafe_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

MouseToDo = 1713;
Mouse_names{1}=['M' num2str(MouseToDo)];


%% Do the Sess.mat and the AllSessions.mat


if MouseToDo >= 1685
    clearvars -except MouseToDo SessNames
    cd('/media/nas6/ProjetEmbReact/transfer')
    Mouse_names{1}=['M' num2str(MouseToDo)];
    Sess.(Mouse_names{1}) = GetAllMouseTaskSessions_CH(MouseToDo);
    Sess2.(Mouse_names{1}) = Sess.(Mouse_names{1});
    load('Sess.mat', 'Sess')
    Sess.(Mouse_names{1}) = Sess2.(Mouse_names{1});
    save('Sess.mat', 'Sess')
    GetEmbReactMiceFolderList_CH
else
    clearvars -except MouseToDo SessNames
    cd('/media/nas6/ProjetEmbReact/transfer')
    Mouse_names{1}=['M' num2str(MouseToDo)];
    Sess.(Mouse_names{1}) = GetAllMouseTaskSessions_CH(MouseToDo);
    Sess2.(Mouse_names{1}) = Sess.(Mouse_names{1});
    load('Sess.mat', 'Sess')
    Sess.(Mouse_names{1}) = Sess2.(Mouse_names{1});
    save('Sess.mat', 'Sess')
    GetEmbReactMiceFolderList_BM
end

cd('/media/nas8-2/ProjetEmbReact/transfer')
save('AllSessions.mat','CondExploSess','CondPostSess','CondPreSess','CondSafeSess','CondSess','CondShockSess','LastCondPreSess',...
    'ExtSafeSess','ExtSess', 'ExtShockSess','FearSess','FirstExtSess','ExtPreSess','ExtPostSess',...
    'HabSess','HabSess24','HabSessPre',...
    'SleepPostPostSess','SleepPostPreSess','SleepPostSess','SleepPreSess','SleepSess',...
    'TestPostPostSess','TestPostPreSess','TestPostSess','TestPreSess','TestSess')


%% Correct Tracking

n=1;
AllDat=[];
thtps_immob=2;
smoofact_Acc = 30;
th_immob_Acc = 1.7e7;

CreateFinalBehavVariables_EmbReact_CH

%%
if 1
    CorrectStim_TTLS
end

%%
% get spectras for all sessions
if 1
    GetAllBasicSpectra_EmbReact_CH
end

%%
% get noise for all sessions
if 1
    CheckForNoise_EmbReact_CH
end

%%
% sleep scoring sleep sessions
if 1
    AllSleepSessions_EmbReact_CH
end

%%
% check for sleepy periods
if 1
    SleepyPeriods_EmbReact_CH
end

%%
% heart rate
if 1
    GetAllHeartBeats_EmbReact_CH
end

%%
% ripples - on session
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
for sess=1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    disp(Sess.(Mouse_names{1}){sess})
    load('ExpeInfo.mat')
    
    if ExpeInfo.SleepSession==1
        CreateRipplesSleep('stim',0,'restrict',1,'sleep',1)
    else
        if isempty(strfind(Sess.(Mouse_names{1}){sess},'Cond'))
            CreateRipplesSleep('stim',0,'restrict',1,'sleep',0,'plotavg',0)
        else
            CreateRipplesSleep('stim',1,'restrict',1,'sleep',0,'plotavg',0)
        end
    end
end

%%
% Instantaneous phase and frequency
if 1
    GetInstFreqAndPhase_EmbReact_CH
end

% if 1
%     GetInstPhaseAndFreq_LocalActivity_EmbReact_SB
% end
% 

%% other behaviour codes

edit MorphMaze_RunOnAlLData_EmbReact_SB.m

edit LinearizeTrackWithDoors.m

edit FindJumpsWithAccelerometer_SB.m

% edit FindRiskAssessmentFromAVI.m

edit GetEscapeLatency_EmbReact_SB.m


%% ID card

edit IDcard_RipInhib_Sleep.m


%% Others

Mouse_names{1}=['M1501']

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
for sess=1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    disp(Sess.(Mouse_names{1}){sess})
    if exist('SWR.mat')>0
        disp('good')
    else
        disp('not good')
    end
end


%% Other protocols

% 
% % LONG PROTOCOL
% SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
%     'TestPre_PreDrug' 'UMazeCondExplo_PreDrug'  'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
%     'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%     'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'Extinction_PostDrug'};
% 

% ATROPINE PROTOCOL
% SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
%     'TestPre_PreDrug' 'UMazeCondExplo_PreDrug'  'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
%     'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%     'SleepPost_PostDrug' 'TestPost_PostDrug'  'UMazeCondExplo_Last' 'UMazeCondBlockedShock_Last' 'UMazeCondBlockedSafe_Last'};

