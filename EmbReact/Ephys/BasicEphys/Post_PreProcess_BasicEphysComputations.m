
clear all

% LONG PROTOCOL
SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
    'TestPre_PreDrug' 'UMazeCondExplo_PreDrug'  'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
    'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'Extinction_PostDrug'};

MouseToDo = 1614;
Mouse_names{1}=['M' num2str(MouseToDo)];


%%
% Do the Sess.mat
clearvars -except MouseToDo SessNames
cd('/media/nas6/ProjetEmbReact/transfer')
Mouse_names{1}=['M' num2str(MouseToDo)];
Sess.(Mouse_names{1}) = GetAllMouseTaskSessions(MouseToDo)
Sess2.(Mouse_names{1}) = Sess.(Mouse_names{1});
load('Sess.mat', 'Sess')
Sess.(Mouse_names{1}) = Sess2.(Mouse_names{1});
save('Sess.mat', 'Sess')

%%
if 1
    GetAllBasicSpectra_EmbReact_SB
end
%%
% Spectra new format
if 1
%     GetAllSpectra_NewFormat_EmbReact_SB
end
%%
% get noise for all sessions
if 1
    CheckForNoise_EmbReact_BM
end
%%
% sleep scoring sleep sessions
if 1
    AllSessionsSleepSessions_EmbReact_SB
end


%%
% check for sleepy periods
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
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
for sess=1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    load('ExpeInfo.mat')
    
    if ExpeInfo.SleepSession==1
        CreateRipplesSleep('stim',0,'restrict',1,'sleep',1)
    else
        if isempty(strfind(Sess.(Mouse_names{1}){sess},'Cond'))
            CreateRipplesSleep('stim',0,'restrict',1,'sleep',0)
        else
            CreateRipplesSleep('stim',1,'restrict',1,'sleep',0)
        end
    end
end

%%
% if ripples inhibition
% Ripples_Inhibition_CheckStims_BM(CondSess.(Mouse_names{1}),1)


%%
% Instantaneous phase and frequency
if 1
    GetInstPhaseAndFreq_EmbReact_SB
end

if 1
    GetInstPhaseAndFreq_LocalActivity_EmbReact_SB
end


%% other behaviour codes

edit MorphMaze_RunOnAlLData_EmbReact_SB.m

edit LinearizeTrackWithDoors.m

edit FindJumpsWithAccelerometer_SB.m

% edit FindRiskAssessmentFromAVI.m

edit GetEscapeLatency_EmbReact_SB.m

%% trash ?
    %     GetRipplesSessionThreshold
% %%
% 
% % ripples - sleep threshold
% if 1
%     GetRipplesWithSleepThresholds
% end


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
% 
% DRUG EXPERIMENT
% SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
% 'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
% 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
% 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'SleepPre_PreDrug' 'SleepPost_PreDrug' 'SleepPost_PostDrug'};

% %BM DRUG EXPERIMENT

% SessNames={'TestPost_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
%     'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%     'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

%% Correct any session from scratch

for f=12:20
    
    cd(FolderName{f})
    disp(FolderName{f})
    load('ExpeInfo.mat')
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
    
    delete([NewFolderName '.dat'])
    delete([NewFolderName '.lfp'])
    %     delete('B_Low_Spectrum.mat')
    delete('B_High_Spectrum.mat')
    %     delete('H_Low_Spectrum.mat')
    delete('H_VHigh_Spectrum.mat')
    %     delete('PFCx_Low_Spectrum.mat')
    %     delete('HeartBeatInfo.mat')
    %     delete('EKGCheck.fig')
    %     delete('EKGCheck.png')
    %     delete('InstFreqAndPhase_B.mat')
    %     delete('InstantaneousFrequencyEstimate_B.png')
    
    cd('./OpenEphys')
    RefChannel = ExpeInfo.ChannelToAnalyse.Ref;
    ChanToSub = [0 : ExpeInfo.PreProcessingInfo.NumWideband-1];
    ChanToSub(ChanToSub==RefChannel) = [];
    
    ChanToSave = [0 :ExpeInfo.PreProcessingInfo.TotalChannels-1];
    ChanToSave(ChanToSub+1) = [];
    
    copyfile(fullfile([pwd '/continuous/Rhythm_FPGA-100.0'], 'continuous.dat'),...
        fullfile([pwd '/continuous/Rhythm_FPGA-100.0'],...
        [NewFolderName  '.dat']));
    movefile(fullfile([pwd '/continuous/Rhythm_FPGA-100.0'],...
        [NewFolderName  '.dat']), FolderName{f});
    
    cd('..')
    
    RefSubtraction_multi_BM([NewFolderName '.dat'],ExpeInfo.PreProcessingInfo.TotalChannels,1,...
        ['M' num2str(ExpeInfo.nmouse)],ChanToSub,RefChannel,ChanToSave);
    
    disp(['file is merged and ref subtracted - copying ...'])

    
    movefile([NewFolderName '_M' num2str(ExpeInfo.nmouse) '.dat'] , [NewFolderName '.dat']);
    delete([NewFolderName '_original.dat']);
    
    
    
    % make lfp
    system(['ndm_lfp ' FolderName{f} '/' NewFolderName])
    
    
    cd('./LFPData')
    for i=0:34
        delete(['LFP' num2str(i) '.mat'])
    end
    
    cd('..')
    
    FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
    if isempty(findstr(FileName,'ProjectEmbReact'))
        All=regexp(FolderName{f},filesep);
        FileName=FolderName{f}(All(end-1)+1:end);
        FileName=strrep(FileName,filesep,'_');
    end
    
    SetCurrentSession(FileName)
    MakeData_Main_SB
    clear FileName NewFolderName
    
    
    %
    %     if exist('B_Low_Spectrum.mat')==0
    %         disp('calculating OB')
    %         clear channel
    %         load('ChannelsToAnalyse/Bulb_deep.mat')
    %         channel;
    %         LowSpectrumSB([cd filesep],channel,'B')
    %     end
    %
    if exist('B_High_Spectrum.mat')==0
        disp('calculating OBhigh')
        clear channel
        try
            load('ChannelsToAnalyse/Bulb_gamma.mat')
        catch
            load('ChannelsToAnalyse/Bulb_deep.mat')
        end
        channel;
        HighSpectrum([cd filesep],channel,'B');
    end
    
    %     if exist('H_Low_Spectrum.mat')==0
    %         disp('calculating H')
    %         clear channel
    %         try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
    %             try,load('ChannelsToAnalyse/dHPC_deep.mat'),
    %             catch
    %                 try,load('ChannelsToAnalyse/dHPC_sup.mat'),
    %                 end
    %             end
    %         end
    %         channel;
    %         LowSpectrumSB([cd filesep],channel,'H')
    %     end
    
    if exist('H_VHigh_Spectrum.mat')==0
        disp('calculating H_high')
        clear channel
        try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
            try,load('ChannelsToAnalyse/dHPC_sup.mat')
            catch
                try,load('ChannelsToAnalyse/dHPC_deep.mat'),
                end
            end
        end
        channel;
        VeryHighSpectrum([cd filesep],channel,'H')
    end
    
    %     if exist('PFCx_Low_Spectrum.mat')==0
    %         disp('calculating PFC')
    %         clear channel
    %         load('ChannelsToAnalyse/PFCx_deep.mat')
    %         channel;
    %         LowSpectrumSB([cd filesep],channel,'PFCx')
    %     end
    
    CreateRipplesSleep_BM
    
end


%% correct to return to amplifier_original.dat


for f=2:5
    cd(FolderName{f})
    
    load('ExpeInfo.mat')
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
    
    delete([NewFolderName '.dat'])
    delete([NewFolderName '.lfp'])
    cd('./LFPData')
    for i=0:35
        delete(['LFP' num2str(i) '.mat'])
    end
    for i=1:4
        delete(['DigInfo' num2str(i) '.mat'])
    end
    cd('..')
    
    movefile('amplifier_original.dat' , [NewFolderName '.dat']);
    system(['ndm_lfp ' FolderName{f} '/' NewFolderName])
    
    FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
    if isempty(findstr(FileName,'ProjectEmbReact'))
        All=regexp(FolderName{f},filesep);
        FileName=FolderName{f}(All(end-1)+1:end);
        FileName=strrep(FileName,filesep,'_');
    end
    
    SetCurrentSession(FileName)
    MakeData_Main_SB
    clear FileName NewFolderName
    
end



%% damaged ExpeInfo
% Put an underscore after the date of Maze

clear all; load('ExpeInfo.mat');
ExpeInfo.PreProcessingInfo.TypeOfSystem='Intan';
save('ExpeInfo.mat')
% GenerateAllFolders_NewProcessin_SB % 
GenerateAllFolders_Maze_RipInhib_BM
disp('all folder should contain amplifier_MXXX.xml,amplifier_MXXX.dat,digitalin.dat ')
cd ..
save('AllFolderNames.mat','FolderName')

load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end


for f=1:length(FolderName)
        
    FolderName_modif{f} = [FolderName{f}(1:45) '_' FolderName{f}(46:end)];
    delete([FolderName_modif{f} filesep 'ExpeInfo.mat'])
    copyfile([FolderName{f} filesep 'ExpeInfo.mat'],FolderName_modif{f})
end


%% correct mouse number in ExpeInfo
load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end

for f=1:length(FolderName)
    cd(FolderName{f})
    
    load('ExpeInfo.mat')
    ExpeInfo.nmouse=41531;
    save('ExpeInfo.mat','ExpeInfo')
end


%% correct xml templates
% cd mouse folder in EmbReact
Mouse_Num = 1502;
load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end

for f=1:length(FolderName)
    
    FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
    if isempty(findstr(FileName,'ProjectEmbReact'))
        All=regexp(FolderName{f},filesep);
        FileName=FolderName{f}(All(end-1)+1:end);
        FileName=strrep(FileName,filesep,'_');
    end
    
    delete([FolderName{f} filesep FileName '.xml'])
    %
    %     copyfile(['/media/nas7/ProjetEmbReact/amplifier_templates/after_merge/Omnetics.xml'] , FolderName{f})
    %     movefile([FolderName{f} '/Omnetics.xml'] , [FolderName{f} filesep FileName '.xml'])
    %
    %     copyfile(['/media/nas7/ProjetEmbReact/amplifier_templates/after_merge/Mini_amp.xml'] , FolderName{f})
    %     movefile([FolderName{f} '/Mini_amp.xml'] , [FolderName{f} filesep FileName '.xml'])
    
    copyfile(['/media/nas7/ProjetEmbReact/Mouse' num2str(Mouse_Num) '/amplifier_M' num2str(Mouse_Num) '.xml'] , FolderName{f})
    movefile([FolderName{f} '/amplifier_M' num2str(Mouse_Num) '.xml'] , [FolderName{f} filesep FileName '.xml'])
end


%% back to ExpeInfo xml
for f=1:length(FolderName)
    cd(FolderName{f})
    
    FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
    if isempty(findstr(FileName,'ProjectEmbReact'))
        All=regexp(FolderName{f},filesep);
        FileName=FolderName{f}(All(end-1)+1:end);
        FileName=strrep(FileName,filesep,'_');
    end
    
    load('ExpeInfo.mat')
    WriteExpeInfoToXml(ExpeInfo)
    delete([FileName '.xml'])
    movefile('amplifier.xml' , [FolderName{f} filesep FileName '.xml'])
    
end


