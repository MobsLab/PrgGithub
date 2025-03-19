% function [sp_WAKE_pre,sp_WAKE_post,sp_SWS_pre,sp_SWS_post,sp_REM_pre,sp_REM_post,frq] = CRH_GetLFP_SingleMouse_MC(Wake,SWSEpoch,REMEpoch,Spectro)
%
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%

function [C_WAKE_pre,C_WAKE_post,C_SWS_pre,C_SWS_post,C_REM_pre,C_REM_post,f] = CRH_GetCoherence_SingleMouse_MC(Wake,SWSEpoch,REMEpoch,LFP_struct1,LFP_struct2)

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% define period pre and post injection
durtotal = max([max(End(Wake)),max(End(SWSEpoch))]);
epoch_pre = intervalSet(0,en_epoch_preInj);
epoch_post = intervalSet(st_epoch_postInj,durtotal);

%3h post injection
epoch_3hPostSD=intervalSet(0,3*3600*1E4);
        
rem_epoch_post = and(REMEpoch,epoch_post);
Nb_rem_epoch_post = size(Start(rem_epoch_post),1);

%% parameters
params.Fs=1/median(diff(Range(LFP_struct1,'s')));
% params.tapers=[3,5];
params.tapers=[5,9];
params.fpass=[0 25];
params.err=[2,0.05];
params.pad=0;
movingwin=[3,0.5];

%% coherence for each state (pre and post injection)
[C_WAKE_pre,phi,S12,S1,S2,t,f,confC,phistd,Cerr]=cohgramc(Data(Restrict(LFP_struct1,and(Wake,epoch_pre))),Data(Restrict(LFP_struct2,and(Wake,epoch_pre))),movingwin,params);
[C_WAKE_post,phi,S12,S1,S2,t,f,confC,phistd,Cerr]=cohgramc(Data(Restrict(LFP_struct1,and(Wake,epoch_post))),Data(Restrict(LFP_struct2,and(Wake,epoch_post))),movingwin,params);

[C_SWS_pre,phi,S12,S1,S2,t,f,confC,phistd,Cerr]=cohgramc(Data(Restrict(LFP_struct1,and(SWSEpoch,epoch_pre))),Data(Restrict(LFP_struct2,and(SWSEpoch,epoch_pre))),movingwin,params);
[C_SWS_post,phi,S12,S1,S2,t,f,confC,phistd,Cerr]=cohgramc(Data(Restrict(LFP_struct1,and(SWSEpoch,epoch_post))),Data(Restrict(LFP_struct2,and(SWSEpoch,epoch_post))),movingwin,params);

[C_REM_pre,phi,S12,S1,S2,t,f,confC,phistd,Cerr]=cohgramc(Data(Restrict(LFP_struct1,and(REMEpoch,epoch_pre))),Data(Restrict(LFP_struct2,and(REMEpoch,epoch_pre))),movingwin,params);
if Nb_rem_epoch_post==0
    C_REM_post=zeros(1,82);
    C_REM_post(:)=NaN;
else
    [C_REM_post,phi,S12,S1,S2,t,f,confC,phistd,Cerr]=cohgramc(Data(Restrict(LFP_struct1,and(REMEpoch,epoch_post))),Data(Restrict(LFP_struct2,and(REMEpoch,epoch_post))),movingwin,params);
end

%%
%wake pre
% figure
% subplot(277),plot(f,mean(C_WAKE_pre),'color','b','linewidth',2), hold on
% plot(f,mean(C_SWS_pre),'color','r','linewidth',2)
% plot(f,mean(C_REM_pre),'color','g','linewidth',2)
% title('PRE injection')
% subplot(2,7,14),plot(f,mean(C_WAKE_post),'color','b','linewidth',2), hold on
% plot(f,mean(C_SWS_post),'color','r','linewidth',2)
% % plot(mean(C_REM_post),'color','g','linewidth',2)
% title('POST injection')
% legend({'WAKE','NREM','REM'})
% 
% %wake
% subplot(2,7,[1,2,8,9]),plot(f,mean(C_WAKE_pre),'color','k','linewidth',2), hold on
% plot(f,mean(C_WAKE_post),'color','b','linewidth',2)
% title('WAKE')
% legend({'PRE','POST'})
% %sws
% subplot(2,7,[3,4,10,11]),plot(f,mean(C_SWS_pre),'color','k','linewidth',2), hold on
% plot(f,mean(C_SWS_post),'color','r','linewidth',2)
% title('NREM')
% legend({'PRE','POST'})
% %rem
% subplot(2,7,[5,6,12,13]),plot(f,mean(C_REM_pre),'color','k','linewidth',2), hold on
% % plot(mean(C_REM_post),'color','g','linewidth',2)
% title('REM')
% legend({'PRE','POST'})





