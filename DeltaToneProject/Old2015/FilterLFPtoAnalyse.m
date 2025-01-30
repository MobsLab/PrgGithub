% FilterLFPtoAnalyse

res=pwd;
try
    mkdir([res,'/FilterLFPtoAnalyse']);
end
load([res,'/LFPData/InfoLFP']);


% Olfactory Bulb
load([res,'/ChannelsToAnalyse/Bulb_deep']);
clear LFP
load([res,'/LFPData/LFP',num2str(channel)]);
Fil=FilterLFP(LFP,[2 4],2048);
save FilterLFPtoAnalyse/FilLFPBulb_deep Fil

load([res,'/ChannelsToAnalyse/Bulb_sup']);
clear LFP
load([res,'/LFPData/LFP',num2str(channel)]);
Fil=FilterLFP(LFP,[2 4],2048);
save FilterLFPtoAnalyse/FilLFPBulb_sup Fil     
        
% Motor Cortex
load([res,'/ChannelsToAnalyse/MoCx_deep']);
clear LFP
load([res,'/LFPData/LFP',num2str(channel)]);
Fil=FilterLFP(LFP,[2 4],2048);
save FilterLFPtoAnalyse/FilLFPMoCx_deep Fil

load([res,'/ChannelsToAnalyse/MoCx_sup']);
clear LFP
load([res,'/LFPData/LFP',num2str(channel)]);
Fil=FilterLFP(LFP,[2 4],2048);
save FilterLFPtoAnalyse/FilLFPMoCx_sup Fil