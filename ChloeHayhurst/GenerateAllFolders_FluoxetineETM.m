clear all
BaseName='FluoxetineETM_M';
% To fill in - general mouse information
SaveFolderName=uigetdir('','please provide Save Folder')
cd(SaveFolderName)
load('ExpeInfo.mat')

if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

Response = inputdlg({'ExperimentDay'},...
    'Inputs for FluoxetineETMFolders',1,{'YYYYMMDD'});

% Mouse and date info
Dates.Expe=(Response{1});

%% Create folders

if not(isempty(Dates.Expe))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.Expe;
    mkdir(num2str(ExpeInfo.date))
    ExpeInfo.SleepSession=0;
    ExpeInfo.RecordingRoom =  'ETM';
    FolderName=OrganizeFilesFluoxetineETMCH(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
end

AllFold=length(FolderName)+1;

for f=1:length(FolderName)
    FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
end

cd(SaveFolderName)

disp('Now fill in your folders with correct files')

