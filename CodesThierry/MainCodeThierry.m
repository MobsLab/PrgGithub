% Preprocessing pour Thierry
% se mettre dans le dossier d'intéret
BaseName='ProjectVLPOPFcx_M';
GetBasicInfoTG

disp('copy files into intan folder then press any key to continue')
pause

% go into intan folder

% Get Folder Name
load('ExpeInfo.mat')
NewFolderName=[BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date)];

load('LFPData/InfoLFP.mat')
RefChan=InfoLFP.channel(find(~cellfun(@isempty,strfind(InfoLFP.structure,'Ref'))));
RefSubtraction_multi('amplifier.dat',16,1,'RefSub',[0:15],RefChan,[]);
% merge files
system(['mv digitalin.dat ' NewFolderName '-digin.dat'])
system(['mv amplifier_RefSub.dat ' NewFolderName '-wideband.dat'])
system(['mv amplifier.xml ' NewFolderName '.xml'])
system(['ndm_mergedat ' NewFolderName])

disp(' getting lfp')
system(['ndm_lfp ' NewFolderName])

% Load in to matlab
SetCurrentSession([NewFolderName,'.xml'])
MakeData_Main

