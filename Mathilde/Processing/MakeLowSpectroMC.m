    function MakeLowSpectroMC

clear all
%Calcul du spectre PFCx
load('ChannelsToAnalyse/PFCx_deep.mat')
LowSpectrum_MC([cd filesep],channel,'PFCx_deep');

% load('ChannelsToAnalyse/PFCx_sup.mat')
% LowSpectrum_MC([cd filesep],channel,'PFCx_sup');


% % load('ChannelsToAnalyse/PFCx_spindle.mat')
% LowSpectrum_MC([cd filesep],channel,'PFCx_sup');
%%Pour les plots Spectre du dHPC_deep

load('ChannelsToAnalyse/dHPC_deep.mat')
LowSpectrum_MC([cd filesep],channel,'dHPC_deep');


load('ChannelsToAnalyse/ThetaREM.mat')
LowSpectrum_MC([cd filesep],channel,'H');

%%Bulb_deep (à modifier si autres channels)
load('ChannelsToAnalyse/Bulb_deep.mat')
LowSpectrum_MC([cd filesep],channel,'Bulb_deep');



% %%Pour les plots Spectre du dHPC_deep
% load('ChannelsToAnalyse/dHPC_deep.mat')
% LowSpectrum_MC([cd filesep],channel,'H');
%%Pour les plots Spectre du VLPO
load('ChannelsToAnalyse/VLPO.mat')
LowSpectrum_MC([cd filesep],channel,'VLPO');

end
