function [M_pre,M_post,M_all, T_pre,T_post,T_all] = PlotWaveformRipples_MC(Wake,SWSEpoch,REMEpoch,tRipples,state,plo)
% 
% % INPUT
% % state : 'rem', 'sws', 'wake', 'wakeLowMov' or 'wakeHighMov'
% 
try
    plo;
catch
    plo=0;
end

% load('SWR.mat')

% load('SleepScoring_Accelero.mat', 'REMEpoch','SWSEpoch','Wake')

res=pwd;
nam='dHPC_rip';
eval(['tempchHPCrip=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chHPCrip=tempchHPCrip.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHPCrip),'.mat'');'])
LFPHPCrip=LFP;

windowsize=400; %in ms

%%injection time period (to take off injection time (1pm))
en_epoch_preInj = 1.35*1E8;
st_epoch_postInj = 1.7*1E8;

%%separate recording before/after injection
durtotal = max([max(End(Wake)),max(End(SWSEpoch))]);
epoch_pre = intervalSet(0,en_epoch_preInj);
epoch_post = intervalSet(st_epoch_postInj,durtotal);


if strcmp(lower(state),'rem')

    tRipples_all = Restrict(tRipples,REMEpoch);
    tRipples_pre = Restrict(tRipples,and(REMEpoch,epoch_pre));
    tRipples_post = Restrict(tRipples,and(REMEpoch,epoch_post));
    
    ripples_tmp_all = Range(tRipples_all,'s');
    ripples_tmp_pre = Range(tRipples_pre,'s');
    ripples_tmp_post = Range(tRipples_post,'s');
    
    [M_all,T_all] = PlotRipRaw(LFPHPCrip, ripples_tmp_all, windowsize, 0,0);
    [M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
    
    if length(tRipples_post)>1
        [M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);
    else
        M_post(1:1001,1:4)=NaN;
        T_post(1,1:1001)=NaN;
    end


elseif strcmp(lower(state),'sws')
tRipples_all = Restrict(tRipples,SWSEpoch);
tRipples_pre = Restrict(tRipples,and(SWSEpoch,epoch_pre));
tRipples_post = Restrict(tRipples,and(SWSEpoch,epoch_post));

ripples_tmp_all = Range(tRipples_all,'s');
ripples_tmp_pre = Range(tRipples_pre,'s');
ripples_tmp_post = Range(tRipples_post,'s');

[M_all,T_all] = PlotRipRaw(LFPHPCrip, ripples_tmp_all, windowsize, 0,0);
[M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
[M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);

elseif strcmp(lower(state),'wake')

    tRipples_all = Restrict(tRipples,Wake);
tRipples_pre = Restrict(tRipples,and(Wake,epoch_pre));
tRipples_post = Restrict(tRipples,and(Wake,epoch_post));

ripples_tmp_all = Range(tRipples_all,'s');
ripples_tmp_pre = Range(tRipples_pre,'s');
ripples_tmp_post = Range(tRipples_post,'s');

[M_all,T_all] = PlotRipRaw(LFPHPCrip, ripples_tmp_all, windowsize, 0,0);
[M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
[M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);

else
end

if plo
figure,
subplot(131), plot(M_all(:,1),mean(T_all))
subplot(132), plot(M_pre(:,1),mean(T_pre))
subplot(133), plot(M_post(:,1),mean(T_post))
end


% 
% %% parameter
% windowsize=400; %in ms
% 
% %%injection time period (to take off injection time (1pm))
% en_epoch_preInj = 1.4*1E8;
% st_epoch_postInj = 1.65*1E8;
% 
% %%separate recording before/after injection
% durtotal = max([max(End(Wake)),max(End(SWSEpoch))]);
% epoch_pre = intervalSet(0,en_epoch_preInj);
% epoch_post = intervalSet(st_epoch_postInj,durtotal);
% epoch_3h=intervalSet(0*3600*1E4,3*3600*1E4);
% 
% %%threshold on speed to get period of high/low activity
% % behav = load('behavResources.mat', 'Vtsd','FreezeAccEpoch');
% % thresh = mean(Data(behav.Vtsd))+std(Data(behav.Vtsd));
% % highMov = thresholdIntervals(behav.Vtsd, thresh, 'Direction', 'Above');
% % lowMov = thresholdIntervals(behav.Vtsd, thresh, 'Direction', 'Below');
% 
% %%load LFP of ripp channel
% res=pwd;
% nam='dHPC_rip';
% eval(['tempchHPCrip=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
% chHPCrip=tempchHPCrip.channel;
% eval(['load(''',res,'','/LFPData/LFP',num2str(chHPCrip),'.mat'');'])
% LFPHPCrip=LFP;
% 
% %%
% if strcmp(lower(state),'rem')
% %     [tRipples, RipplesEpoch] = GetRipples;
% [tRipples] = GetRipplesDensityTSD_MC(RipplesEpoch);
%     tRipples_pre = Restrict(tRipples,and(REMEpoch,epoch_pre));
%     tRipples_post = Restrict(tRipples,and(REMEpoch,epoch_post));
%     tRipples_3h = Restrict(tRipples,and(REMEpoch,epoch_3h));
%     tRipples_all = Restrict(tRipples,REMEpoch);
%     
%     ripples_tmp_pre = Range(tRipples_pre,'s');
%     ripples_tmp_post = Range(tRipples_post,'s');
%     ripples_tmp_3h = Range(tRipples_3h,'s');
%     ripples_tmp_all = Range(tRipples_all,'s');
%     
%     [M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
%     [M_3h,T_3h] = PlotRipRaw(LFPHPCrip, ripples_tmp_3h, windowsize, 0,0);
%     [M_all,T_all] = PlotRipRaw(LFPHPCrip, ripples_tmp_all, windowsize, 0,0);
%     
%     if isempty(tRipples_post)==0 % in case there is no REM after injection
% %         M_post = zeros(1001,4);
% %         M_post(:,:) = NaN;
% %         T_post = NaN;
% %     else
%         [M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);
%     else
%                 M_post = zeros(1001,4);
%         M_post(:,:) = NaN;
%         T_post = NaN;
%     end
%     
% elseif strcmp(lower(state),'sws')
%     [tRipples, RipplesEpoch] = GetRipples;
%     tRipples_pre = Restrict(tRipples,and(SWSEpoch,epoch_pre));
%     tRipples_post = Restrict(tRipples,and(SWSEpoch,epoch_post));
%     tRipples_3h = Restrict(tRipples,and(SWSEpoch,epoch_3h));
%     tRipples_all = Restrict(tRipples,SWSEpoch);
%     ripples_tmp_pre = Range(tRipples_pre,'s');
%     ripples_tmp_post = Range(tRipples_post,'s');
%     ripples_tmp_3h = Range(tRipples_3h,'s');
%     ripples_tmp_all = Range(tRipples_all,'s');
%     [M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
%     [M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);
%     [M_3h,T_3h] = PlotRipRaw(LFPHPCrip, ripples_tmp_3h, windowsize, 0,0);
%     [M_all,T_all] = PlotRipRaw(LFPHPCrip, ripples_tmp_all, windowsize, 0,0);
% 
% elseif strcmp(lower(state),'wake')
%     [tRipples, RipplesEpoch] = GetRipples;
%     tRipples_pre = Restrict(tRipples,and(Wake,epoch_pre));
%     tRipples_post = Restrict(tRipples,and(Wake,epoch_post));
%     tRipples_3h = Restrict(tRipples,and(Wake,epoch_3h));
%     tRipples_all = Restrict(tRipples,Wake);
%     ripples_tmp_pre = Range(tRipples_pre,'s');
%     ripples_tmp_post = Range(tRipples_post,'s');
%     ripples_tmp_3h = Range(tRipples_3h,'s');
%     ripples_tmp_all = Range(tRipples_all,'s');
%     [M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
%     [M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);
%     [M_3h,T_3h] = PlotRipRaw(LFPHPCrip, ripples_tmp_3h, windowsize, 0,0);
%     [M_all,T_all] = PlotRipRaw(LFPHPCrip, ripples_tmp_all, windowsize, 0,0);
% 
% elseif strcmp(state,'wakeLowMov')
%     [tRipples, RipplesEpoch] = GetRipples;
%     tRipples_pre = Restrict(tRipples,and(Wake,and(lowMov,epoch_pre)));
%     tRipples_post = Restrict(tRipples,and(Wake,and(lowMov,epoch_post)));
%     ripples_tmp_pre = Range(tRipples_pre,'s');
%     ripples_tmp_post = Range(tRipples_post,'s');
%     [M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
%     [M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);
%     
% elseif strcmp(state,'wakeHighMov')
%     [tRipples, RipplesEpoch] = GetRipples;
%     tRipples_pre = Restrict(tRipples,and(Wake,and(highMov,epoch_pre)));
%     tRipples_post = Restrict(tRipples,and(Wake,and(highMov,epoch_post)));
%     ripples_tmp_pre = Range(tRipples_pre,'s');
%     ripples_tmp_post = Range(tRipples_post,'s');
%     [M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
%     [M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);
% else
%     %     [tRipples, RipplesEpoch] = GetRipples;
%     %     ripples_tmp_before = Range(tRipples,'s');
%     %     [M_pre,T] = PlotRipRaw(LFPHPCrip, ripples_tmp_before, windowsize, 0,0);
% end
% %%
% if plo
% figure,
% subplot(131), plot(M_all(:,1),mean(T_all))
% subplot(132), plot(M_pre(:,1),mean(T_pre))
% subplot(133), plot(M_post(:,1),mean(T_post))
% end
% 
% end
