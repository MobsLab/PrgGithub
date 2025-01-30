function [M,T] = PlotMeanRipples_MC(plo)

try
    plo;
catch
    plo=0;
end

%%
windowsize=400; %in ms

res=pwd;
nam='dHPC_rip';
eval(['tempchHPCrip=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chHPCrip=tempchHPCrip.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHPCrip),'.mat'');'])
LFPHPCrip=LFP;
load('Ripples.mat')

[tRipples, RipplesEpoch] = GetRipples;

ripples_tmp = Range(tRipples,'s');

[M,T] = PlotRipRaw(LFPHPCrip, ripples_tmp, windowsize, 0,0);
%%
if plo
    figure,plot(M(:,1),mean(T))
end

end

