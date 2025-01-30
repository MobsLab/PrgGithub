%% Compress frames
clear all
Options.DownSample=1;
Options.RemoveMask=1;
Options.Visualization=0;
MouseToAvoid=[560,117]; % mice with noisy data to exclude
SessNames={'Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction',...
    'SoundHab' 'SoundCond' 'SoundTest',...
    'CtxtHab' 'CtxtCond' 'CtxtTest' 'CtxtTestCtrl',...
    'HabituationNight' 'TestPreNight' 'UMazeCondNight' 'TestPostNight' 'ExtinctionNight',...
    'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt' ,...
    'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt',...
    'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock',...
    'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock',...
    'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};
pb=1;

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            if not(exist('CompressedFrames.mat'))
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})
                try
                    SaveFolder=Dir.path{d}{dd};
                    load('behavResources.mat')
                    Options.Mask=Params.mask;
                    cd('raw')
                    AllDir=dir;
                    ToUse=[];
                    for k=1:length(AllDir)
                        if findstr(AllDir(k).name,'FEAR')
                            ToUse=k;
                        end
                    end
                    cd(AllDir(ToUse).name)
                    AllDir=dir;
                    ToUse=[];
                    for k=1:length(AllDir)
                        if findstr(AllDir(k).name,'F') & AllDir(k).isdir
                            ToUse=k;
                            
                        end
                    end
                    FrameFolder=[cd filesep AllDir(ToUse).name];
                    cd(Dir.path{d}{dd})
                    
                    CompressFrames(FrameFolder,SaveFolder,Options);
                    clear FrameFolder SaveFolder
                catch
                    disp('problem')
                    Problem{pb}=Dir.path{d}{dd};
                    pb=pb+1;
                end
            end
        end
    end
    end
    
