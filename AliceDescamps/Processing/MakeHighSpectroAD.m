    function MakeHighSpectroAD
% adapted from MakeLowSpectroMC

clear all

%Calcul du spectre PFCx
load('ChannelsToAnalyse/PFCx_deep.mat')
HighSpectrum_AD([cd filesep],channel,'PFCx_deep');

% load('ChannelsToAnalyse/PFCx_sup.mat')
% HighSpectrum_AD([cd filesep],channel,'PFCx_sup');

% % load('ChannelsToAnalyse/PFCx_spindle.mat')
% HighSpectrum_AD([cd filesep],channel,'PFCx_sup');


%%Pour les plots Spectre du dHPC_deep
% load('ChannelsToAnalyse/dHPC_deep.mat')
% HighSpectrum_AD([cd filesep],channel,'dHPC_deep');
% 
% load('ChannelsToAnalyse/ThetaREM.mat')
% HighSpectrum_AD([cd filesep],channel,'H');

%%Bulb_deep (à modifier si autres channels)
% load('ChannelsToAnalyse/Bulb_deep.mat')
% HighSpectrum_AD([cd filesep],channel,'Bulb_deep');

end
