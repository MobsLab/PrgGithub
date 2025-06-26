%% CH way

clear all

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
Mouse_names={'M1747'}; mouse=1;
Hab_24_Sess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation24H'))));
HabSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation_P'))));
HabBlockedShockSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'HabituationBlockedShock'))));
TestPreSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre'))));
TestPostPreSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost_Pre'))));
TestPostPostSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost_Post'))));
SleepSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep'))));


for cond = 1:7
    if cond==1
        start=Hab_24_Sess(1); stop=HabSess(1)-1;
    elseif cond==2
        start=HabSess(1); stop=HabBlockedShockSess(1)-1;
    elseif cond==3
        start=HabBlockedShockSess(1); stop=TestPreSess(1)-1;
    elseif cond==4
        start=TestPreSess(1); stop=TestPostPreSess(1)-1;
    elseif cond==5
        start=TestPostPreSess(1); stop=TestPostPostSess(1)-1;
    elseif cond==6
        start=TestPostPostSess(1); stop=length(Sess.(Mouse_names{mouse}));
    elseif cond==7
        start=SleepSess(1); stop=SleepSess(3);
    end
    
    clear XYOutput
    for f=start:stop
        
        cd(Sess.(Mouse_names{mouse}){f})
        
        load('ExpeInfo.mat')
        
        TotTime=0;TotFz=0;TotStims=0;
        
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
            
            if isfield(Params,'Ratio_IMAonREAL')
                Ratio_IMAonREAL = Params.Ratio_IMAonREAL;
            else
                Ratio_IMAonREAL = 1./Params.pixratio;
                Params.Ratio_IMAonREAL = Ratio_IMAonREAL;
            end
            
            if ExpeInfo.SleepSession==0
                
                if f==start | not(exist('XYOutput'))
                    disp(cd)
                    [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_SB(Behav.Xtsd,Behav.Ytsd,Params.Zone{1},Params.ref,Ratio_IMAonREAL);
                else
                    disp(cd)
                    [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_SB(Behav.Xtsd,Behav.Ytsd,Params.Zone{1},Params.ref,Ratio_IMAonREAL,XYOutput);
                end
                            Behav.ZoneEpochAligned = ZoneEpochAligned;

            elseif ExpeInfo.SleepSession == 1
                    disp(cd)
                    [AlignedXtsd,AlignedYtsd,XYOutput] = MorphCageToSingleShape_EmbReact_CH(Behav.Xtsd,Behav.Ytsd,Params.ref,Ratio_IMAonREAL);
            end
            Behav.AlignedXtsd = AlignedXtsd;
            Behav.AlignedYtsd = AlignedYtsd;
            Params.XYOutput = XYOutput;
            
            keyboard
            save('behavResources_SB.mat','Behav','Params','-append')
            clear Behav Params
        end
        
    end
    clear XYOutput
end




%% BM way
clear all

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
Mouse_names={'M688'}; mouse=1;
Hab_24_Sess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation24H'))));
HabSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation_P'))));
HabBlockedShockSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'HabituationBlockedShock'))));
TestPreSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre'))));
TestPostSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost'))));
CondSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond'))));


for cond = 1:5
    if cond==1
        start=Hab_24_Sess(1); stop=HabSess(1)-1;
    elseif cond==2
        start=HabSess(1); stop=HabBlockedShockSess(1)-1;
    elseif cond==3
        start=HabBlockedShockSess(1); stop=TestPreSess(1)-1;
    elseif cond==4
        start=TestPreSess(1); stop=TestPostSess(1)-1;
    elseif cond==5
        start=TestPostSess(1); stop=length(Sess.(Mouse_names{mouse}));
    end
 
    clear XYOutput
    for f=start:stop
        
        cd(Sess.(Mouse_names{mouse}){f})
                
        load('ExpeInfo.mat')
        if ExpeInfo.SleepSession==0
            
            TotTime=0;TotFz=0;TotStims=0;
            
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
                
                if isfield(Params,'Ratio_IMAonREAL')
                    Ratio_IMAonREAL = Params.Ratio_IMAonREAL;
                else
                    Ratio_IMAonREAL = 1./Params.pixratio;
                    Params.Ratio_IMAonREAL = Ratio_IMAonREAL;
                end
                
                if f==start | not(exist('XYOutput'))
                    disp(cd)
                    [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_SB(Behav.Xtsd,Behav.Ytsd,Params.Zone{1},Params.ref,Ratio_IMAonREAL);
                else
                    disp(cd)
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
    end
    clear XYOutput
end

    %     if cond==1
    %         start=Hab_24_Sess(1); stop=HabSess(1)-1;
    %     elseif cond==2
    %         start=HabSess(1); stop=HabBlockedShockSess(1)-1;
    %     elseif cond==3
    %         start=HabBlockedShockSess(1); stop=TestPreSess(1)-1;
    %     elseif cond==4
    %         start=TestPreSess(1); stop=length(Sess.(Mouse_names{mouse}));
    %     end
%% SB way

clear all
% SessNames={  'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt' ,...
%     'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt'};


%%%};

% SessNames={'Habituation24HPre_EyeShock','Habituation_EyeShock','HabituationBlockedSafe_EyeShock','HabituationBlockedShock_EyeShock',...
%     'TestPre_EyeShock','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock',...
%     'TestPost_EyeShock','Extinction_EyeShock','ExtinctionBlockedShock_EyeShock','ExtinctionBlockedSafe_EyeShock',...
%     'Habituation', 'TestPre', 'UMazeCond','TestPost','Extinction','HabituationNight','TestPreNight',...
%     'UMazeCondNight','TestPostNight', 'ExtinctionNight'};

SessNames={ 'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
    'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
    'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

% SessNames={'ExtinctionBlockedShock_PostDrug'};  11225 11226
MouseNameToDo = [1253]% 1253 1254 11251 11252 11253 11254];

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        TotTime=0;TotFz=0;TotStims=0;
        MouseName{ss,d}=num2str(Dir.ExpeInfo{d}{1}.nmouse);
        disp(MouseName{ss,d})
        if Dir.ExpeInfo{d}{1}.nmouse == MouseNameToDo
            
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
                    
                    % load('behavResources_SB.mat')
                    
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


