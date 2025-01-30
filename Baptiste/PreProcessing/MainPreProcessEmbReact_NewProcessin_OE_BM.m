
%% How to process Open Ephys data for Maze

% 1) run StepOne as usual
% Launch step one
clear all
rmpath([dropbox '/Kteam/PrgMatlab/EmbReact/PreProcessing'])
GUI_StepOne_ExperimentInfo

% 2) add the .mat file for OE files
% in Konsole or terminal, for continuous folders and events folders
~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat -p /path/to/your/recording/experimentN/recordingN/events/
~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat -p /path/to/your/recording/experimentN/recordingN/continuous/

% 3) run Step two
clear all; load('ExpeInfo.mat');
ExpeInfo.PreProcessingInfo.TypeOfSystem='Intan';
save('ExpeInfo.mat')
GenerateAllFolders_NewProcessin_SB % 
disp('all folder should contai, amplifier_MXXX.xml,amplifier_MXXX.dat,digitalin.dat ')
cd ..
save('AllFolderNames.mat','FolderName')

% 4) correct ExpeInfo for OE infos
load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end

% all sessions numbers for which we want to correct ExpeInfo
for f=[12:20] % check if good cond sessions number
    cd(FolderName{f})
    load('ExpeInfo.mat')
    ExpeInfo.PreProcessingInfo.TypeOfSystem = 'OpenEphys';
    ExpeInfo.PreProcessingInfo.NumDigChan = 0;
    ExpeInfo.PreProcessingInfo.TotalChannels = 35;
    ExpeInfo.InfoLFP.channel = ExpeInfo.InfoLFP.channel(1:end-1);
    ExpeInfo.InfoLFP.structure = ExpeInfo.InfoLFP.structure(1:end-1);
    ExpeInfo.InfoLFP.depth = ExpeInfo.InfoLFP.depth(1:end-1);
    ExpeInfo.InfoLFP.hemisphere = ExpeInfo.InfoLFP.hemisphere(1:end-1);
    WriteExpeInfoToXml(ExpeInfo)
    save('ExpeInfo.mat','ExpeInfo')
end

% 5) distribute .dat & things in the good folders

% 6) Step three
% Now call relevant NDM functions
ExecuteNDM_BM

% 7) Launch step four
% % Now make matlab compatible files
for f=1:length(FolderName)
    
    cd([FolderName{f}])
    try
        %   NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
        
        FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
        if isempty(findstr(FileName,'ProjectEmbReact'))
            All=regexp(FolderName{f},filesep);
            FileName=FolderName{f}(All(end-1)+1:end);
            FileName=strrep(FileName,filesep,'_');
        end
        
%         WriteExpeInfoToXml(ExpeInfo)
%         movefile('amplifier.xml',[FileName,'.xml'])
%         
        SetCurrentSession(FileName)
        MakeData_Main_SB
        clear FileName NewFolderName
    catch
        disp('error for this folder')
    end
end







%% if went wrong

for f=[1:11 21:32]
    GoodToGo=0;
    cd(FolderName{f})
    disp(FolderName{f})
    load('ExpeInfo.mat')
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
    
    delete([NewFolderName '.lfp'])
    RefSubtraction_multi([NewFolderName '.dat'],36,3,'trash',[],[],[0:31],'accelero',[],[],[32:34],'digin',[],[],[35])
    delete([NewFolderName '_original.dat'])
    delete([NewFolderName '_trash.dat'])
    movefile('amplifier_original.dat',[NewFolderName '-wideband.dat'])
    movefile([NewFolderName '_accelero.dat'],[NewFolderName '-accelero.dat'])
    movefile([NewFolderName '_digin.dat'],[NewFolderName '-digin.dat'])
    
    system(['ndm_mergedat ' NewFolderName])
    
    
end




for f=[12:20]
    GoodToGo=0;
    cd(FolderName{f})
    disp(FolderName{f})
    load('ExpeInfo.mat')
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
    
    delete([NewFolderName '.lfp'])
    RefSubtraction_multi_BM([NewFolderName '.dat'],36,3,'trash',[],[],[0:31],'accelero',[],[],[32:34],'digin',[],[],[35])

    system(['ndm_mergedat ' NewFolderName])
    system(['ndm_lfp ' NewFolderName])
    
end




for f=[1:11 21:26 29 32:36] % check if good cond sessions number
    cd(FolderName{f})
    load('ExpeInfo.mat')
    ExpeInfo.ChannelToAnalyse.Ref=NaN;
    save('ExpeInfo.mat','ExpeInfo')
end








