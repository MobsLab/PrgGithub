%
%
% This script will tell you what you need to install to use twpca python library. 
% Particularly, this is useful to use the solveWithTWPCA.m matlab function. (you need to set your username in matlab first).
%
% On linux, python should be already install. To install python libraries, you can use pip.
% On general, all dependencies are generic, and you can google how to install them. 
%
%




username = getenv('USER');

pathToScript = fullfile(strcat('/home/',username,'/Dropbox/Kteam/PrgMatlab/TimeWarp/','checkPyModules.sh'));
cmdStr = [pathToScript];

system(cmdStr);