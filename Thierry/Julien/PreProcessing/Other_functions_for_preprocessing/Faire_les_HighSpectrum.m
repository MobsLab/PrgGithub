%%Pour les plots Spectre du PFCx_deep (à modifier si autres channels)
clear all
load('ChannelsToAnalyse/PFCx_deep.mat')
%Calcul du spectre PFCx
HighSpectrum([cd filesep],channel,'PFCx_deep');
load('ChannelsToAnalyse/PFCx_sup.mat')
HighSpectrum([cd filesep],channel,'PFCx_sup');
%%Bulb_deep (à modifier si autres channels)
load('ChannelsToAnalyse/Bulb_deep.mat')
LowSpectrumSB([cd filesep],channel,'Bulb_deep');
%%Pour les plots Spectre du dHPC_sup (à modifier si autres channels)
load('ChannelsToAnalyse/dHPC_sup.mat')
LowSpectrumSB([cd filesep],channel,'dHPC_sup');
%%Pour les plots Spectre du VLPO
load('ChannelsToAnalyse/VLPO.mat')
LowSpectrumSB([cd filesep],channel,'VLPO');
%%Pour les plots Spectre du dHPC_deep
load('ChannelsToAnalyse/dHPC_deep.mat')
LowSpectrumSB([cd filesep],channel,'dHPC_deep');
