clear all

SessNames={'ClosedArm','OpenArm','Sleep'};

MouseToDo =1393;
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
% % ripples - on session
% cd('/media/nas6/ProjetEmbReact/transfer')
% load('Sess.mat')
% for sess=1:length(Sess.(Mouse_names{1}))
%     cd(Sess.(Mouse_names{1}){sess})
%     
%     try
%         load('ChannelsToAnalyse/dHPC_rip.mat')
%         CreateRipplesSleep_BM
%     end
% end

%%
% Instantaneous phase and frequency
if 1
    GetInstPhaseAndFreq_EmbReact_SB
end

if 1
    GetInstPhaseAndFreq_LocalActivity_EmbReact_SB
end

%%
% % other behaviour codes
% 
% edit MorphMaze_RunOnAlLData_EmbReact_SB.m
% 
% edit LinearizeTrackWithDoors.m
% 
% edit FindJumpsWithAccelerometer_SB.m
% 
% edit FindRiskAssessmentFromAVI.m
% 
% edit GetEscapeLatency_EmbReact_SB.m

% 
% 
% %% Correct any session from scratch
% 
% for f=12:20
%     
%     cd(FolderName{f})
%     disp(FolderName{f})
%     load('ExpeInfo.mat')
%     NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
%     
%     delete([NewFolderName '.dat'])
%     delete([NewFolderName '.lfp'])
%     %     delete('B_Low_Spectrum.mat')
%     delete('B_High_Spectrum.mat')
%     %     delete('H_Low_Spectrum.mat')
%     delete('H_VHigh_Spectrum.mat')
%     %     delete('PFCx_Low_Spectrum.mat')
%     %     delete('HeartBeatInfo.mat')
%     %     delete('EKGCheck.fig')
%     %     delete('EKGCheck.png')
%     %     delete('InstFreqAndPhase_B.mat')
%     %     delete('InstantaneousFrequencyEstimate_B.png')
%     
%     cd('./OpenEphys')
%     RefChannel = ExpeInfo.ChannelToAnalyse.Ref;
%     ChanToSub = [0 : ExpeInfo.PreProcessingInfo.NumWideband-1];
%     ChanToSub(ChanToSub==RefChannel) = [];
%     
%     ChanToSave = [0 :ExpeInfo.PreProcessingInfo.TotalChannels-1];
%     ChanToSave(ChanToSub+1) = [];
%     
%     copyfile(fullfile([pwd '/continuous/Rhythm_FPGA-100.0'], 'continuous.dat'),...
%         fullfile([pwd '/continuous/Rhythm_FPGA-100.0'],...
%         [NewFolderName  '.dat']));
%     movefile(fullfile([pwd '/continuous/Rhythm_FPGA-100.0'],...
%         [NewFolderName  '.dat']), FolderName{f});
%     
%     cd('..')
%     
%     RefSubtraction_multi_BM([NewFolderName '.dat'],ExpeInfo.PreProcessingInfo.TotalChannels,1,...
%         ['M' num2str(ExpeInfo.nmouse)],ChanToSub,RefChannel,ChanToSave);
%     
%     disp(['file is merged and ref subtracted - copying ...'])
%     % copy the file
%     movefile([NewFolderName '_M' num2str(ExpeInfo.nmouse) '.dat'] , [NewFolderName '.dat']);
%     delete([NewFolderName '_original.dat']);
%     
%     
%     
%     % make lfp
%     system(['ndm_lfp ' FolderName{f} '/' NewFolderName])
%     
%     
%     cd('./LFPData')
%     for i=0:34
%         delete(['LFP' num2str(i) '.mat'])
%     end
%     
%     cd('..')
%     
%     FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
%     if isempty(findstr(FileName,'ProjectEmbReact'))
%         All=regexp(FolderName{f},filesep);
%         FileName=FolderName{f}(All(end-1)+1:end);
%         FileName=strrep(FileName,filesep,'_');
%     end
%     
%     SetCurrentSession(FileName)
%     MakeData_Main_SB
%     clear FileName NewFolderName
%     
%     
%     %
%     %     if exist('B_Low_Spectrum.mat')==0
%     %         disp('calculating OB')
%     %         clear channel
%     %         load('ChannelsToAnalyse/Bulb_deep.mat')
%     %         channel;
%     %         LowSpectrumSB([cd filesep],channel,'B')
%     %     end
%     %
%     if exist('B_High_Spectrum.mat')==0
%         disp('calculating OBhigh')
%         clear channel
%         try
%             load('ChannelsToAnalyse/Bulb_gamma.mat')
%         catch
%             load('ChannelsToAnalyse/Bulb_deep.mat')
%         end
%         channel;
%         HighSpectrum([cd filesep],channel,'B');
%     end
%     
%     %     if exist('H_Low_Spectrum.mat')==0
%     %         disp('calculating H')
%     %         clear channel
%     %         try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
%     %             try,load('ChannelsToAnalyse/dHPC_deep.mat'),
%     %             catch
%     %                 try,load('ChannelsToAnalyse/dHPC_sup.mat'),
%     %                 end
%     %             end
%     %         end
%     %         channel;
%     %         LowSpectrumSB([cd filesep],channel,'H')
%     %     end
%     
%     if exist('H_VHigh_Spectrum.mat')==0
%         disp('calculating H_high')
%         clear channel
%         try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
%             try,load('ChannelsToAnalyse/dHPC_sup.mat'),Type search text (ex: *.m)
%             catch
%                 try,load('ChannelsToAnalyse/dHPC_deep.mat'),
%                 end
%             end
%         end
%         channel;
%         VeryHighSpectrum([cd filesep],channel,'H')
%     end
%     
%     %     if exist('PFCx_Low_Spectrum.mat')==0
%     %         disp('calculating PFC')
%     %         clear channel
%     %         load('ChannelsToAnalyse/PFCx_deep.mat')
%     %         channel;
%     %         LowSpectrumSB([cd filesep],channel,'PFCx')
%     %     end
%     
%     CreateRipplesSleep_BM
%     
% end
% 
% 
% %% correct to return to amplifier_original.dat
% 
% 
% for f=2:5
%     cd(FolderName{f})
%     
%     load('ExpeInfo.mat')
%     NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
%     
%     delete([NewFolderName '.dat'])
%     delete([NewFolderName '.lfp'])
%     cd('./LFPData')
%     for i=0:35
%         delete(['LFP' num2str(i) '.mat'])
%     end
%     for i=1:4
%         delete(['DigInfo' num2str(i) '.mat'])
%     end
%     cd('..')
%     
%     movefile('amplifier_original.dat' , [NewFolderName '.dat']);
%     system(['ndm_lfp ' FolderName{f} '/' NewFolderName])
%     
%     FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
%     if isempty(findstr(FileName,'ProjectEmbReact'))
%         All=regexp(FolderName{f},filesep);
%         FileName=FolderName{f}(All(end-1)+1:end);
%         FileName=strrep(FileName,filesep,'_');
%     end
%     
%     SetCurrentSession(FileName)
%     MakeData_Main_SB
%     clear FileName NewFolderName
%     
% end
% 
% 
% 


