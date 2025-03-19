%solveWithTWPCA -
%	From a file with neuronal data, uses python twpca library to align this data and saves the result to another file.
%	You can use checkPyModules to verify that you have everything you need to use this function (in terms of python libraries).
%
%----INPUT----
% pathToFile						path to a file containing a single matlab structure called jitteredData with one field called Data. This should be a 3D array which dimensions represents (nTrials, nSamples, nNeurons). This file MUST be saved in Matlab using the '-v7.3' option.
% nComponents						(optional) number of components of the analysis. Not really sure what that is. Safe to set it between 1 and 3 for most problems.
% learningRate 						(optional) learning rate of the analysis, scale 1e-3 or 1e-2
% nIter 							(optional) number of iterations of convergence, scale of 1e3
% warpStrength						(optional) not sure what that is. The more this is high, the less data will be warped
% timeStrength						(optional) not sure what that is.
%
%----OUTPUT----
% ()			 					saves a file with a path identical to pathToFile but with '_aligned' added at the end of the name. This file will contain
%
%
% Warning
%	If one optional argument is given, they whould all be given




function solveWithTWPCA(pathToFile, nComponents, learningRate, nIter, warpStrength, timeStrength)

if ~exist('nComponents', 'var')
    nComponents = 1;
end
if ~exist('learningRate','var')
    learningRate = 0.01;
end
if ~exist('nIter','var')
    nIter = 1000;
end
if ~exist('warpStrength','var')
    warpStrength = 0.01;
end
if ~exist('timeStrength','var')
    timeStrength = 1.0;
end

username = getenv('USER');


pathToScript = fullfile(strcat('/home/',username,'/Dropbox/Kteam/PrgMatlab/TimeWarp/','solveWithTWPCA.sh'));
cmdStr = [pathToScript ' ' num2str(pathToFile) ' ' num2str(nComponents) ' ' num2str(learningRate) ' ' num2str(nIter) ' ' num2str(warpStrength) ' ' num2str(timeStrength) ' ' num2str(username)];





system(cmdStr);
end
