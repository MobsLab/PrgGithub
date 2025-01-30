clear all

% After Preprocessing is run, calculate all needed signals
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update the list of session files you want to analyse


% MULTI TASK PROTOCOL
% SessNames={'EPM','Habituation', 'SleepPreUMaze', 'TestPre', 'UMazeCond', 'SleepPostUMaze', 'TestPost','Extinction','SoundHab',...
%     'SleepPreSound','SoundCond','SleepPostSound','SoundTest','CtxtHab','SleepPreCtxt','CtxtCond',...
%     'SleepPostCtxt','CtxtTest','CtxtTestCtrl','BaselineSleep','HabituationNight','SleepPreNight','TestPreNight',...
%     'UMazeCondNight', 'SleepPostNight', 'TestPostNight', 'ExtinctionNight'};
% 

% SessNames={'SleepPost_EyeShock_DRG','Habituation24HPre_EyeShock_DRG' 'Habituation_EyeShock_DRG' 'HabituationBlockedSafe_EyeShock_DRG' 'HabituationBlockedShock_EyeShock_DRG',...
% 'TestPre_EyeShock_DRG' 'UMazeCond_EyeShock_DRG' 'UMazeCondBlockedShock_EyeShock_DRG' 'UMazeCondBlockedSafe_EyeShock_DRG',...
% 'TestPost_EyeShock_DRG' 'Extinction_EyeShock_DRG' 'ExtinctionBlockedShock_EyeShock_DRG' 'ExtinctionBlockedSafe_EyeShock_DRG',...
% 'SleepPre_EyeShock_DRG'};

% DRUG TEMPORARY PROTOCOL
% SessNames={'Habituation24HPre_PreDrug_TempProt' 'Habituation_PreDrug_TempProt' 'HabituationBlockedSafe_PreDrug_TempProt' 'HabituationBlockedShock_PreDrug_TempProt',...
%     'TestPre_PreDrug_TempProt' 'UMazeCond_PreDrug_TempProt' 'UMazeCondBlockedShock_PreDrug_TempProt' 'UMazeCondBlockedSafe_PreDrug_TempProt',...
%     'TestPost_PreDrug_TempProt' 'Extinction_PostDrug_TempProt' 'ExtinctionBlockedShock_PostDrug_TempProt' 'ExtinctionBlockedSafe_PostDrug_TempProt'};

% EYESHOCK EXPERIMENT
% SessNames={'Habituation24HPre_EyeShock','Habituation_EyeShock','HabituationBlockedSafe_EyeShock',...
% 'HabituationBlockedShock_EyeShock','TestPre_EyeShock','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock',...
% 'UMazeCondBlockedSafe_EyeShock','TestPost_EyeShock','Extinction_EyeShock'};

% DRUG EXPERIMENT
SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'SleepPre_PreDrug' 'SleepPost_PreDrug' 'SleepPost_PostDrug'};

MouseToDo = 739;
% SessNames = {'SleepPreEPM','SleepPostEPM'};
% Basic Spectra
%%
if 1
GetAllBasicSpectra_EmbReact_SB
end
%%
% Spectra new format
if 1
GetAllSpectra_NewFormat_EmbReact_SB
end
%%
% get noise for all sessions
if 1
CheckForNoise_EmbReact_SB
end
%%
% sleep scoring sleep sessions
if 1
   AllSessionsSleepSessions_EmbReact_SB 
end
%%
% check for sleep periods
if 1
CheckForSleepyPeriods_EmbReact_SB
end
%%
% heart rate
if 1
GetAllHEartBeats_EmbReact_SB
end
%%
% ripples - on session
if 1
GetRipplesSessionThreshold
end
%%

% ripples - sleep threshold
if 1
GetRipplesWithSleepThresholds
end

%%
% Instantaneous phase and frequency
if 1
GetInstPhaseAndFreq_EmbReact_SB
end

if 1
GetInstPhaseAndFreq_LocalActivity_EmbReact_SB
end


