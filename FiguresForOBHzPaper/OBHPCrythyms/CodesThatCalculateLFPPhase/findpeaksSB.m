function [Ypk,Xpk,Wpk,Ppk] = findpeaksSB(Yin,varargin)

rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous')
[Ypk,Xpk,Wpk,Ppk] = findpeaks(Yin,varargin);
addpath('/home/vador/Dropbox/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous')

end