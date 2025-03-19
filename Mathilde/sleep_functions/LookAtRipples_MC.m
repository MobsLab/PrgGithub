load('SWR.mat')
load('SleepScoring_Accelero.mat', 'REMEpoch','SWSEpoch','Wake')
res=pwd;
nam='dHPC_rip';
eval(['tempchHPCrip=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chHPCrip=tempchHPCrip.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHPCrip),'.mat'');'])
LFPHPCrip=LFP;

windowsize=400; %in ms

%%injection time period (to take off injection time (1pm))
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%%separate recording before/after injection
durtotal = max([max(End(Wake)),max(End(SWSEpoch))]);
epoch_pre = intervalSet(0,en_epoch_preInj);
epoch_post = intervalSet(st_epoch_postInj,durtotal);


tRipples_all = Restrict(tRipples,REMEpoch);
tRipples_pre = Restrict(tRipples,and(REMEpoch,epoch_pre));
tRipples_post = Restrict(tRipples,and(REMEpoch,epoch_post));

ripples_tmp_all = Range(tRipples_all,'s');
ripples_tmp_pre = Range(tRipples_pre,'s');
ripples_tmp_post = Range(tRipples_post,'s');

[M_all,T_all] = PlotRipRaw(LFPHPCrip, ripples_tmp_all, windowsize, 0,0);
[M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_tmp_pre, windowsize, 0,0);
[M_post,T_post] = PlotRipRaw(LFPHPCrip, ripples_tmp_post, windowsize, 0,0);

figure,
subplot(131), plot(M_all(:,1),mean(T_all))
subplot(132), plot(M_pre(:,1),mean(T_pre))
subplot(133), plot(M_post(:,1),mean(T_post))
