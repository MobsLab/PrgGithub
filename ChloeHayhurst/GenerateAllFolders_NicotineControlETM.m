clear all
BaseName='NicotineETM_M';
% To fill in - general mouse information
SaveFolderName=uigetdir('','please provide Save Folder')
cd(SaveFolderName)
load('ExpeInfo.mat')

if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

Response = inputdlg({'ControlDay'},...
    'Inputs for NicotineETMFolders',1,{'YYYYMMDD'});

% Mouse and date info
Dates.Control=(Response{1});

%% Create folders for Withdraw

if not(isempty(Dates.Control))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.Control;
    mkdir(num2str(ExpeInfo.date))
    ExpeInfo.SleepSession=0;
    ExpeInfo.RecordingRoom =  'ETM';
    FolderName=OrganizeFilesNicotineETMControlCH(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
end

AllFold=length(FolderName)+1;

for f=1:length(FolderName)
    FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
end


%% Create folders for Control

% if not(isempty(Dates.Control))
%     cd(SaveFolderName)
%     ExpeInfo.date=Dates.Control;
%     mkdir(num2str(ExpeInfo.date))
%     ExpeInfo.SleepSession=0;
%     ExpeInfo.RecordingRoom =  'ETM';
%     FolderName=OrganizeFilesNicotineETMControlCH(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
% end
disp('Now fill in your folders with correct files')
% 
% for f=1:length(FolderName)
%     FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
% end
