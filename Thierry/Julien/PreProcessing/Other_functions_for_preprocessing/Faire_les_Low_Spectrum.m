function Faire_les_Low_Spectrum

%%Pour les plots Spectre du PFCx_deep (à modifier si autres channels)
clear all
load('ChannelsToAnalyse/PFCx_deep.mat')
%Calcul du spectre PFCx
LowSpectrumjulien([cd filesep],channel,'PFCx_deep');
load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PFCx_spindle.mat')
LowSpectrumjulien([cd filesep],channel,'PFCx_sup');
%%Bulb_deep (à modifier si autres channels)
load('ChannelsToAnalyse/Bulb_deep.mat')
LowSpectrumjulien([cd filesep],channel,'Bulb_deep');
%%Pour les plots Spectre du dHPC_sup (à modifier si autres channels)
%load('ChannelsToAnalyse/dHPC_sup.mat')
%LowSpectrumjulien([cd filesep],channel,'dHPC_sup');

%%Pour les plots Spectre du dHPC_deep
load('ChannelsToAnalyse/dHPC_deep.mat')
LowSpectrumjulien([cd filesep],channel,'dHPC_deep');

load('ChannelsToAnalyse/dHPC_deep.mat')
LowSpectrumjulien([cd filesep],channel,'H');
%%Pour les plots Spectre du VLPO
load('ChannelsToAnalyse/VLPO.mat')
LowSpectrumjulien([cd filesep],channel,'VLPO');
end