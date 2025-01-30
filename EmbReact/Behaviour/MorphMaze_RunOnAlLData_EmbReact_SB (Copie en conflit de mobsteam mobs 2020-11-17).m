clear all
% SessNames={  'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt' ,...
%     'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt'};


%%%};

% SessNames={'Habituation24HPre_EyeShock','Habituation_EyeShock','HabituationBlockedSafe_EyeShock','HabituationBlockedShock_EyeShock',...
%     'TestPre_EyeShock','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock',...
%     'TestPost_EyeShock','Extinction_EyeShock','ExtinctionBlockedShock_EyeShock','ExtinctionBlockedSafe_EyeShock',...
%     'Habituation', 'TestPre', 'UMazeCond','TestPost','Extinction','HabituationNight','TestPreNight',...
%     'UMazeCondNight','TestPostNight', 'ExtinctionNight'};

% SessNames={ 'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
%     'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
%     'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%     'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

SessNames={'ExtinctionBlockedShock_PostDrug'};
MouseNameToDo = 892;

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        TotTime=0;TotFz=0;TotStims=0;
        MouseName{ss,d}=num2str(Dir.ExpeInfo{d}{1}.nmouse);
        disp(MouseName{ss,d})
        if Dir.ExpeInfo{d}{1}.nmouse > MouseNameToDo
            
            clear XYOutput
            for dd=1:length(Dir.path{d})
                cd(Dir.path{d}{dd})
                
                clear Behav Params Results TTLInfo AlignedXtsd AlignedYtsd ZoneEpochAligned
                clear Vtsd Xtsd Ytsd Imdifftsd FreezeEpoch FreezeAccEpoch MovAcctsd
                MazeCoordDone = 0;
                    
                load('behavResources_SB.mat')
                if isfield(Params,'XYOutput')
                    disp('Already calculated and right place')
                    MazeCoordDone=1;
                end
                
                if not(MazeCoordDone)
                    disp('Need to calculate')
                    
                    load('behavResources_SB.mat')
                    
                    if isfield(Params,'Ratio_IMAonREAL')
                        Ratio_IMAonREAL = Params.Ratio_IMAonREAL;
                    else
                        Ratio_IMAonREAL = 1./Params.pixratio;
                        Params.Ratio_IMAonREAL = Ratio_IMAonREAL;
                    end
                    
                    if dd==1 | not(exist('XYOutput'))
                        [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_SB(Behav.Xtsd,Behav.Ytsd,Params.Zone{1},Params.ref,Ratio_IMAonREAL);
                    else
                        [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_SB(Behav.Xtsd,Behav.Ytsd,Params.Zone{1},Params.ref,Ratio_IMAonREAL,XYOutput);
                    end
                    
                    Behav.AlignedXtsd = AlignedXtsd;
                    Behav.AlignedYtsd = AlignedYtsd;
                    Behav.ZoneEpochAligned = ZoneEpochAligned;
                    Params.XYOutput = XYOutput;
                    
                    keyboard
                    save('behavResources_SB.mat','Behav','Params','-append')
                    clear Behav Params
                end
            end
            clear XYOutput
        end
    end
end


