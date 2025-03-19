SessNames={'EPM' 'Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' ...
    'TestPost' 'Extinction' 'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest',...
    'HabituationNight' 'SleepPreNight' 'TestPreNight' 'UMazeCondNight' 'SleepPostNight' 'TestPostNight' 'ExtinctionNight',...
    'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt',...
    'TestPost_EyeShockTempProt','WallExtShock_EyeShockTempProt','WallExtSafe_EyeShockTempProt'...
    'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock',...
    'SleepPre_EyeShock' 'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' 'SleepPost_EyeShock',...
    'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock',...
    'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
    'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
    'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug',...
    'Habituation24HPre_PreDrug_TempProt' 'Habituation_PreDrug_TempProt' 'HabituationBlockedSafe_PreDrug_TempProt' 'HabituationBlockedShock_PreDrug_TempProt',...
    'SleepPre_PreDrug_TempProt' 'TestPre_PreDrug_TempProt' 'UMazeCond_PreDrug_TempProt' 'UMazeCondBlockedShock_PreDrug_TempProt' 'UMazeCondBlockedSafe_PreDrug_TempProt' 'SleepPost_PreDrug_TempProt',...
    'TestPost_PreDrug_TempProt' 'Extinction_PostDrug_TempProt' 'ExtinctionBlockedShock_PostDrug_TempProt' 'ExtinctionBlockedSafe_PostDrug_TempProt'};

a=1;
for ss=5:length(SessNames)
    disp(SessNames{ss})
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            
            try
            if exist([cd filesep 'behavResources.mat'])==0
%                 load('ExpeInfo.mat')
                %                 if not(ExpeInfo.SleepSession==1)
%                 keyboard
                % %                 end
            else
                %                 if exist([cd filesep 'SpeedCorrected.mat'])==0
                %% corect Vtsd
                disp(['Correction ' Dir.path{d}{dd}])
                clear Behav Vtsd Xtsd Ytsd
                load([cd filesep 'behavResources.mat'],'Xtsd','Ytsd','Vtsd')
                tps = Range(Ytsd);
                Vtsd=tsd(tps(2:end),sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2)./diff(Range(Ytsd,'s')));
                save([cd filesep 'behavResources.mat'],'Vtsd','Xtsd','Ytsd','-append')
                
                load([cd filesep 'behavResources_SB.mat'],'Behav')
                Behav.Vtsd = Vtsd;
                save([cd filesep 'behavResources_SB.mat'],'Behav','-append')
                
                clear Vtsd Xtsd Ytsd Behav
                
                SpeedCorrected=1;
                save('SpeedCorrected.mat','SpeedCorrected')
                %                 end
            end
            catch
                
            end
        end
    end
end