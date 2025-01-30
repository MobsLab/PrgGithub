% AddPrefixFilesOfFolder
% 03.05.2019 KJ
%
%
% Info
%   see 
%

function status = AddPrefixFilesOfFolder(prefixe, foldername)


if nargin < 1
  error('Incorrect number of parameters.');
elseif nargin==1
    foldername = pwd;
end

status = 0;

%go to folder and come back later
res = pwd;
cd(foldername)

x = '*';
filelist = dir(x);
for i=3:length(filelist)
    oldName = filelist(i).name;
    newName = [prefixe oldName];
    movefile(oldName, newName);
end


cd(res)


end