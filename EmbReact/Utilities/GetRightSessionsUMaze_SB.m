function SessionNames = GetRightSessionsUMaze_SB(SessType)

switch SessType
    
    case 'AllProtocol_PAG'
        
        SessionNames = {'Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' 'TestPost' 'Extinction'};
        
    case 'AllProtocol_Eyeshock'
        
        SessionNames = {'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock',...
            'SleepPre_EyeShock' 'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' 'SleepPost_EyeShock',...
            'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};
        
    case 'AllProtocol_EyeshockDrug'
        
        SessionNames = {'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug',...
            'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
            'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
            'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
            'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
        
    case 'AllProtocol_Night'
        
        SessionNames = { 'HabituationNight' 'SleepPreNight' 'TestPreNight' 'UMazeCondNight'
            'SleepPostNight' 'TestPostNight' 'ExtinctionNight'};
        
    case 'AllBehaviour_PAG'
        
        SessionNames = {'Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction'};
        
    case 'AllBehaviour_Eyeshock'
        
        SessionNames = {'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock',...
            'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock',...
            'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};
        
    case 'AllBehaviour_EyeshockDrug'
        
        SessionNames = {'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug',...
            'HabituationBlockedSafe_PreDrug',...
            'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
            'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
            'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
        
    case 'AllBehaviour_Night'
        
        SessionNames = { 'HabituationNight' 'TestPreNight' 'UMazeCondNight',...
            'TestPostNight' 'ExtinctionNight'};
        
    case 'AllCondSessions'
        
        SessionNames = { 'UMazeCond',...
            'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock',...
            'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
            'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
            'UMazeCondNight'};
        
    case 'AllCondSessions_Eyeshock'
        
        SessionNames = {'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock',...
            'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
            'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};
        
    case 'AllCond_EyeShock_NoDoors'
        
        SessionNames = {'UMazeCondExplo_PreDrug' 'UMazeCondExplo_PostDrug',...
            'UMazeCond_EyeShock'};
        
    case 'TestSessionDoors_EyeShock'
        
        SessionNames = {'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
        
    case 'AllFreezingSessions'
        SessionNames = { 'UMazeCond',...
            'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock',...
            'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
            'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
            'UMazeCondNight',...
            'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
        
end