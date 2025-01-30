function [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(Wake,SWSEpoch,REMEpoch,alldeltas_PFCx,state,plo)
% function [Mdeep_all,Msup_all,Tdeep_all,Tsup_all] = PlotWaveformDeltas_MC(Wake,SWSEpoch,REMEpoch,alldeltas_PFCx,state,plo)

try
    plo;
catch
    plo=0;
end

%% get data
%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;
%separate recording before/after injection
durtotal = max([max(End(Wake)),max(End(SWSEpoch))]);
Epoch1 = intervalSet(0,en_epoch_preInj);
Epoch2 = intervalSet(st_epoch_postInj,durtotal);

windowsize=400; % in ms

% get LFP PFC deep
res=pwd;
nam='PFCx_deep';
eval(['tempchPFCdeep=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chPFCdeep=tempchPFCdeep.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCdeep),'.mat'');'])
LFPPFCdeep=LFP;
% get LFP PFC sup
res=pwd;
nam='PFCx_sup';
eval(['tempchPFCsup=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chPFCsup=tempchPFCsup.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCsup),'.mat'');'])
LFPPFCsup=LFP;

%%
if strcmp(lower(state),'wake')
    delta_pre = and(alldeltas_PFCx,and(Wake,Epoch1));
    delta_post = and(alldeltas_PFCx,and(Wake,Epoch2));
    delta_all = and(alldeltas_PFCx,Wake);
    %%pre
    if isempty(Start(delta_pre))==0
        [Mdeep_pre,Tdeep_pre] = PlotRipRaw(LFPPFCdeep, Start(delta_pre)/1E4, windowsize, 0,0);
        [Msup_pre,Tsup_pre] = PlotRipRaw(LFPPFCsup, Start(delta_pre)/1E4, windowsize, 0,0);
    else
        Mdeep_pre(1:1001,1:4)=NaN;
        Msup_pre(1:1001,1:4)=NaN;
        Tdeep_pre(1,1:1001)=NaN;
        Tsup_pre(1,1:1001)=NaN;
    end
    %%post
    if isempty(Start(delta_post))==0
        [Mdeep_post,Tdeep_post] = PlotRipRaw(LFPPFCdeep, Start(delta_post)/1E4, windowsize, 0,0);
        [Msup_post,Tsup_post] = PlotRipRaw(LFPPFCsup, Start(delta_post)/1E4, windowsize, 0,0);
    else
        Mdeep_post(1:1001,1:4)=NaN;
        Msup_post(1:1001,1:4)=NaN;
        Tdeep_post(1,1:1001)=NaN;
        Tsup_post(1,1:1001)=NaN;
    end
    %%all session
    if isempty(Start(delta_all))==0
        [Mdeep_all,Tdeep_all] = PlotRipRaw(LFPPFCdeep, Start(delta_all)/1E4, windowsize, 0,0);
        [Msup_all,Tsup_all] = PlotRipRaw(LFPPFCsup, Start(delta_all)/1E4, windowsize, 0,0);
    else
        Mdeep_all(1:1001,1:4)=NaN;
        Msup_all(1:1001,1:4)=NaN;
        Tdeep_all(1,1:1001)=NaN;
        Tsup_all(1,1:1001)=NaN;
    end
    
elseif strcmp(lower(state),'sws')
    delta_pre = and(alldeltas_PFCx,and(SWSEpoch,Epoch1));
    delta_post = and(alldeltas_PFCx,and(SWSEpoch,Epoch2));
    delta_all = and(alldeltas_PFCx,SWSEpoch);
    %
    [Mdeep_pre,Tdeep_pre] = PlotRipRaw(LFPPFCdeep, Start(delta_pre)/1E4, windowsize, 0,0);
    [Mdeep_post,Tdeep_post] = PlotRipRaw(LFPPFCdeep, Start(delta_post)/1E4, windowsize, 0,0);
    [Mdeep_all,Tdeep_all] = PlotRipRaw(LFPPFCdeep, Start(delta_all)/1E4, windowsize, 0,0);
    
    [Msup_pre,Tsup_pre] = PlotRipRaw(LFPPFCsup, Start(delta_pre)/1E4, windowsize, 0,0);
    [Msup_post,Tsup_post] = PlotRipRaw(LFPPFCsup, Start(delta_post)/1E4, windowsize, 0,0);
    [Msup_all,Tsup_all] = PlotRipRaw(LFPPFCsup, Start(delta_all)/1E4, windowsize, 0,0);
    
    
elseif strcmp(lower(state),'rem')
    delta_pre = and(alldeltas_PFCx,and(REMEpoch,Epoch1));
    delta_post = and(alldeltas_PFCx,and(REMEpoch,Epoch2));
    delta_all = and(alldeltas_PFCx,REMEpoch);
    
    %%pre
    if isempty(Start(delta_pre))==0
        [Mdeep_pre,Tdeep_pre] = PlotRipRaw(LFPPFCdeep, Start(delta_pre)/1E4, windowsize, 0,0);
        [Msup_pre,Tsup_pre] = PlotRipRaw(LFPPFCsup, Start(delta_pre)/1E4, windowsize, 0,0);
    else
        Mdeep_pre(1:1001,1:4)=NaN;
        Msup_pre(1:1001,1:4)=NaN;
        Tdeep_pre(1,1:1001)=NaN;
        Tsup_pre(1,1:1001)=NaN;
    end
    %%post
    if isempty(Start(delta_post))==0
        [Mdeep_post,Tdeep_post] = PlotRipRaw(LFPPFCdeep, Start(delta_post)/1E4, windowsize, 0,0);
        [Msup_post,Tsup_post] = PlotRipRaw(LFPPFCsup, Start(delta_post)/1E4, windowsize, 0,0);
    else
        Mdeep_post(1:1001,1:4)=NaN;
        Msup_post(1:1001,1:4)=NaN;
        Tdeep_post(1,1:1001)=NaN;
        Tsup_post(1,1:1001)=NaN;
    end
    %%all session
    if isempty(Start(delta_all))==0
        [Mdeep_all,Tdeep_all] = PlotRipRaw(LFPPFCdeep, Start(delta_all)/1E4, windowsize, 0,0);
        [Msup_all,Tsup_all] = PlotRipRaw(LFPPFCsup, Start(delta_all)/1E4, windowsize, 0,0);
    else
        Mdeep_all(1:1001,1:4)=NaN;
        Msup_all(1:1001,1:4)=NaN;
        Tdeep_all(1,1:1001)=NaN;
        Tsup_all(1,1:1001)=NaN;
    end
    
    
end
%%
% if plo
%     figure,plot(Mdeep(:,1),mean(Tdeep))
%     xlim([-0.1 0.4])
% end

% end
