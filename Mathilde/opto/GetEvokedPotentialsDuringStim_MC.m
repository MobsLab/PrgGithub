function [MALL] = GetEvokedPotentialsDuringStim_MC(stim,WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,struct,plo)

try
    plo;
catch
    plo=0;
end

%%
REMEp  = mergeCloseIntervals(REMEpochWiNoise,4E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

%% load LFP
if strcmp(lower(struct),'pfc')
    res=pwd;
    nam='PFCx_deep';
    eval(['tempchPFC=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
    chPFC=tempchPFC.channel;
    eval(['load(''',res,'','/LFPData/LFP',num2str(chPFC),'.mat'');'])
elseif strcmp(lower(struct),'hpc')
    res=pwd;
%     nam='dHPC_deep';
    nam='ThetaREM';
    eval(['tempchHPC=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
    chHPC=tempchHPC.channel;
    eval(['load(''',res,'','/LFPData/LFP',num2str(chHPC),'.mat'');'])
elseif strcmp(lower(struct),'ob')
    res=pwd;
    nam='Bulb_deep';
    eval(['tempchOB=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
    chOB=tempchOB.channel;
    eval(['load(''',res,'','/LFPData/LFP',num2str(chOB),'.mat'');'])
elseif strcmp(lower(struct),'vlpo')
    res=pwd;
    nam='VLPO';
    eval(['tempchVLPO=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
    chVLPO=tempchVLPO.channel;
    eval(['load(''',res,'','/LFPData/LFP',num2str(chVLPO),'.mat'');'])
end


%get LFP trace triggered on stim
% [MREM,TREM] = PlotRipRaw(LFP, stim.StimREM/1e4, 30000, 0, 0);
% [MSWS,TSWS] = PlotRipRaw(LFP, stim.StimSWS/1e4, 30000, 0, 0);
% [MWAKE,TWAKE] = PlotRipRaw(LFP, stim.StimWake/1e4, 30000, 0, 0);
% [MALL,TALL] = PlotRipRaw(LFP, Range(stim.Stimts)/1e4, 30000, 0, 0);
% 
% [MREM,TREM] = PlotRipRaw(LFP, StimREM/1e4, 30000, 0, 0);
% [MSWS,TSWS] = PlotRipRaw(LFP, StimSWS/1e4, 30000, 0, 0);
% [MWAKE,TWAKE] = PlotRipRaw(LFP, StimWake/1e4, 30000, 0, 0);
% [MALL,TALL] = PlotRipRaw(LFP, Range(Stimts)/1e4, 30000, 0, 0);

[MALL,TALL] = PlotRipRaw(LFP, stim/1e4, 30000, 0, 0);

end