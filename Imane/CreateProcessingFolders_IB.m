
clear all 

%get list of subfolders
getFolder = dir(uigetdir('', 'pick the folder you want'));
isub = [getFolder(:).isdir];
subFolderList = {getFolder(isub).name};

%get rid of unnecessary subfolders
%subFolderList(ismember(subFolderList,{'.','..'}))=[];

% other way to do it
    idc = strfind(subFolderList,'.');
    idx = ~cellfun('isempty',idc);
    subFolder = subFolderList(~idx);

