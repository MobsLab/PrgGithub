

% same thing for 11200

load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end

for sess=1:length(FolderName)
    cd(FolderName{sess})
    clear ExpeInfo
    load('ExpeInfo.mat')
    ExpeInfo.DigID{1, 1} = 'ONOFF';
    ExpeInfo.DigID{1, 2} = 'CAMERASYNC';
    ExpeInfo.DigID{1, 3} = 'STIM';
    ExpeInfo.DigID{1, 4} = 'NaN';
    save('ExpeInfo.mat','ExpeInfo')
end

for f=1:length(FolderName)
    cd([FolderName{f}])
    try
        FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
        if isempty(findstr(FileName,'ProjectEmbReact'))
            All=regexp(FolderName{f},filesep);
            FileName=FolderName{f}(All(end-1)+1:end);
            FileName=strrep(FileName,filesep,'_');
        end
        load('ExpeInfo.mat')
        SetCurrentSession(FileName)
        spk = ExpeInfo.PreProcessingInfo.DoSpikes;
        doaccelero = ExpeInfo.PreProcessingInfo.NumAccelero>0;
        dodigitalin = ExpeInfo.PreProcessingInfo.NumDigChan>0;
        doanalogin = ExpeInfo.PreProcessingInfo.NumAnalog>0;
        answerdigin{1} = num2str(find(~cellfun(@isempty,strfind(ExpeInfo.InfoLFP.structure,'Digin')))-1);
        answerdigin{2} = ExpeInfo.PreProcessingInfo.NumDigInput;
        spk = 0;
        MakeData_Digin
        clear FileName NewFolderName
    end
end


clearvars -except Mouse_numb FolderName
%FileNames=GetAllMouseTaskSessions(Mouse_numb);
disp('getting stims into shape')
for ss=1:length(FolderName)
    disp(FolderName{f})
    cd([FolderName{f}])
    clear TTLInfo
    GetStims
    try,save('behavResources_SB.mat','TTLInfo','-append')
    catch
        keyboard
    end
end













