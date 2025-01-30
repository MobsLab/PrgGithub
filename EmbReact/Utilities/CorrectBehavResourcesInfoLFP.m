AllSess={'EPM' 'Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' 'TestPost' 'Extinction' ...
    'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest'...
    'CtxtHab' 'SleepPreCtxt' 'CtxtCond' 'SleepPostCtxt' 'CtxtTest' 'CtxtTestCtrl' 'BaselineSleep' ...
    'HabituationNight' 'SleepPreNight' 'TestPreNight' 'UMazeCondNight' 'SleepPostNight' 'TestPostNight' 'ExtinctionNight' ...
    'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' ...
    'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt' 'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' ...
    'WallExtSafe_EyeShockTempProt' 'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock' ...
    'SleepPre_EyeShock' 'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' 'SleepPost_EyeShock'...
    'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};


for ss=36:length(AllSess)
    AllSess{ss}
    Dir=PathForExperimentsEmbReact(AllSess{ss});
    for p=1:length(Dir.path)
        for pp=1:length(Dir.path{p})
            cd(Dir.path{p}{pp})
            
            % Correct mistaken InfoLFP naming
            load('LFPData/InfoLFP.mat')
            ToReplace=find(~cellfun(@isempty,strfind(InfoLFP.structure,'OB')));
            if not(isempty(ToReplace))
                for rr=1:length(ToReplace)
                    InfoLFP.structure{ToReplace(rr)}='Bulb';
                end
                save('LFPData/InfoLFP.mat','InfoLFP')
            end
            
            % Use common file structure for behavResources
            if exist('behavResources.mat')>0
                Tempbehav=load('behavResources.mat');
                if isfield(Tempbehav,'Behav')
                    copyfile('behavResources.mat','OldBehavFiles/behavResourcesSaveInCase.mat')
                    Tempbehav.Behav.Vtsd=tsd(Range(Tempbehav.Behav.Movtsd)*1e4,sqrt(diff(Data(Tempbehav.Behav.Xtsd)).^2+diff(Data(Tempbehav.Behav.Ytsd)).^2));
                    Tempbehav.Behav=rmfield(Tempbehav.Behav,'Movtsd');
                    Tempbehav.Behav.Imdifftsd=Tempbehav.Behav.ImDiffTsd;
                    Tempbehav.Behav=rmfield(Tempbehav.Behav,'ImDiffTsd');
                    Tempbehav.Params.Ratio_IMAonREAL=1./Tempbehav.Params.pixratio;
                    save('behavResources_SB.mat','-struct','Tempbehav')
                    B=Tempbehav.Behav;
                    P=Tempbehav.Params;
                    save('behavResources.mat','-struct','B')
                    save('behavResources.mat','-struct','P','-append')
                    clear B P Tempbehav 
                end
            end
        end
    end
end