

%LoadPATHGV

res=pwd;


try
addpath(genpath('/home/karim/Dropbox/Kteam/PrgMatlab'))

addpath('/home/karim/Dropbox/Kteam/PrgMatlab')
addpath('/home/karim/Dropbox/Kteam/PrgMatlab/MatFilesMarie/')
catch
addpath('/media/DISK_1/Dropbox/Kteam/PrgMatlab')
addpath('/media/DISK_1/Dropbox/Kteam/PrgMatlab/MatFilesMarie/')
end
eval(['cd(''',res,''')'])

clear res


