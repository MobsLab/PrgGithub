% clear all
% BaseName='NicotineETM_M';
% To fill in - general mouse information
% SaveFolderName=uigetdir('','please provide Save Folder')
% cd(SaveFolderName)
% load('ExpeInfo.mat')
% 
% if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end
% 
% Response = inputdlg({'WithdrawDay','ControlDay'},...
%     'Inputs for NicotineETMFolders',1,{'YYYYMMDD','YYYYMMDD'});
% 
% Mouse and date info
% Dates.Withdraw=(Response{1});
% Dates.Control=(Response{2});
% 
% % Create folders for Withdraw
% 
% if not(isempty(Dates.Withdraw))
%     cd(SaveFolderName)
%     ExpeInfo.date=Dates.Withdraw;
%     mkdir(num2str(ExpeInfo.date))
%     ExpeInfo.SleepSession=0;
%     ExpeInfo.RecordingRoom =  'ETM';
%     FolderName=OrganizeFilesNicotineETMCH(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
% end
% 
% AllFold1=length(FolderName)+1;
% 
% for f=1:length(FolderName)
%     FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
% end
% 
% 
% if not(isempty(Dates.Control))
%     cd(SaveFolderName)
%     ExpeInfo.date=Dates.Control;
%     mkdir(num2str(ExpeInfo.date))
%     ExpeInfo.SleepSession=0;
%     ExpeInfo.RecordingRoom =  'ETM';
%     FolderName=OrganizeFilesNicotineETMControlCH(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
% end
% 
% AllFold=length(FolderName)+1;
% 
% for f=1:length(FolderName)
%     FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
% end
% 
% 
% % Create folders for Control
% 
% if not(isempty(Dates.Control))
%     cd(SaveFolderName)
%     ExpeInfo.date=Dates.Control;
%     mkdir(num2str(ExpeInfo.date))
%     ExpeInfo.SleepSession=0;
%     ExpeInfo.RecordingRoom =  'ETM';
%     FolderName=OrganizeFilesNicotineETMControlCH(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
% end
% disp('Now fill in your folders with correct files')
% 
% for f=1:length(FolderName)
%     FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
% end

clear all
BaseName='NicotineETM_M';
% To fill in - general mouse information
SaveFolderName=uigetdir('','please provide Save Folder')
cd(SaveFolderName)
load('ExpeInfo.mat')

if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

Response = inputdlg({'Day Of Experiment'},...
    'Inputs for NicotineETMFolders',1,{'YYYYMMDD'});

% Mouse and date info
Dates.Date=(Response{1});

%% Create folders for Date
if not(isempty(Dates.Date))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.Date;
    mkdir(num2str(ExpeInfo.date))
    ExpeInfo.SleepSession=0;
    ExpeInfo.RecordingRoom =  'ETM';
    FolderName=OrganizeFilesNicotineETMCH(ExpeInfo.nmouse,ExpeInfo.date,SaveFolderName,ExpeInfo)
end

AllFold1=length(FolderName)+1;

for f=1:length(FolderName)
    FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
end

cd(SaveFolderName)

disp('Now fill in your folders with correct files')
disp('all folder should contain amplifier_MXXX.xml,amplifier_MXXX.dat,digitalin.dat')
