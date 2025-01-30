
%LoadPATH


res=pwd;
try
cd('C:\Users\MOBs\Dropbox\Kteam\PrgMatlab')
addpath(genpath('C:\Users\MOBs\Dropbox\Kteam\PrgMatlab'))
addpath(genpath('C:\Users\MOBs\Dropbox\Kteam\PrgMatlab\MatFilesMarie'))
end

try
    cd('/home/mobsmorty/Dropbox/Kteam/PrgMatlab')
    addpath(genpath('/home/mobsmorty/Dropbox/Kteam/PrgMatlab'))
    addpath(genpath('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/AnalyseLFP_ML'))
    
    addpath(genpath('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/MatFilesMarie'))
end
eval(['cd(''',res,''')'])


clear res

% res=pwd;
%     
% cd('/home/vador/Dropbox/Kteam/PrgMatlab/')
% addpath(genpath('/home/vador/Dropbox/Kteam/PrgMatlab/'))
% addpath(genpath('/home/vador/Dropbox/Kteam/PrgMatlab/MatFilesMarie'))
% eval(['cd(''',res,''')'])
% 
% clear res
