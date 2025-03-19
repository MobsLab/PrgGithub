function [h,hc,he,hce,rg,rgc,rge,rgce,vec]=HistoSleepStagesMathilde(var,lim,num,vec)

% [h,hc,he,hce]=HistoSleepStagesMathilde(var,contrl,lim,num,vec)
% [h,hc,he,hce]=HistoSleepStagesMathilde(4,0,1,10,-60:60)
%
% var=4;
% contrl=1;
% lim=1;
% num=20;
% vec=-60:60;

%%

load DataHistoSleepStagesMathilde

eval(['sleepst=PlotSleepStage(Wake',num2str(var),',SWS',num2str(var),',REM',num2str(var),');'])
close
eval(['Wake=Wake',num2str(var),';'])
eval(['SWS=SWS',num2str(var),';'])
eval(['REM=REM',num2str(var),';'])
REMext=intervalSet(Start(REM)-lim*1E4,End(REM)+lim*1E4);REMext=mergeCloseIntervals(REMext,1);
SWSext=intervalSet(Start(SWS)-lim*1E4,End(SWS)+lim*1E4);SWSext=mergeCloseIntervals(SWSext,1);
Wakeext=intervalSet(Start(Wake)-lim*1E4,End(Wake)+lim*1E4);Wakeext=mergeCloseIntervals(Wakeext,1);

tps=Range(sleepst,'s');

eval(['Stim=Stim',num2str(var),';'])
eval(['stim=ts(Stim',num2str(var),'*1E4);'])

Stimc = sort(tps(end) * rand(num*length(Range(stim)),1));
Stimc(diff(Stimc)<2)=[];
stimc=ts(Stimc*1E4);

epochstim=intervalSet(Range(stim)-20*1E4,Range(stim)+40*1E4);
totalEpoch=intervalSet(tps(1)*1E4,tps(end)*1E4);
%stimc=Restrict(stimc,totalEpoch-epochstim);

% 
% yl=ylim;
% line([Stimc Stimc],[0 yl(2)/2],'color',[0 0.4 0])
% line([Stim Stim],[yl(2)/2 yl(2)],'color',[0 0.4 0])

%%

stimr=Restrict(stim,REM);
stimre=Restrict(stim,REMext);
stimcr=Restrict(stimc,REM);
stimcre=Restrict(stimc,REMext);

% stimr=Restrict(stim,or(SWS,REM));
% stimre=Restrict(stim,REM);
% stimcr=Restrict(stimc,or(SWS,REM));
% stimcre=Restrict(stimc,REM);


% stimr=Restrict(stim,SWS);
% stimre=Restrict(stim,SWSext);
% stimcr=Restrict(stimc,SWS);
% stimcre=Restrict(stimc,SWSext);

% stimr=Restrict(stim,Wake);
% stimre=Restrict(stim,Wakeext);
% stimcr=Restrict(stimc,Wake);
% stimcre=Restrict(stimc,Wakeext);


%%

rg=Range(stimr);
rge=Range(stimre);
rgc=Range(stimcr);
rgce=Range(stimcre);
clear h he
a=1;
for j=vec
epoch=intervalSet(rg+j*1E4,rg+(j+median(diff(vec)))*1E4);
h(a,1)=length(find(Data(Restrict(sleepst,epoch))==1))/length(Data(Restrict(sleepst,epoch)))*100;
h(a,2)=length(find(Data(Restrict(sleepst,epoch))==3))/length(Data(Restrict(sleepst,epoch)))*100;
h(a,3)=length(find(Data(Restrict(sleepst,epoch))==4))/length(Data(Restrict(sleepst,epoch)))*100;
epoche=intervalSet(rge+j*1E4,rge+(j+1)*1E4);
he(a,1)=length(find(Data(Restrict(sleepst,epoche))==1))/length(Data(Restrict(sleepst,epoche)))*100;
he(a,2)=length(find(Data(Restrict(sleepst,epoche))==3))/length(Data(Restrict(sleepst,epoche)))*100;
he(a,3)=length(find(Data(Restrict(sleepst,epoche))==4))/length(Data(Restrict(sleepst,epoche)))*100;
epochc=intervalSet(rgc+j*1E4,rgc+(j+1)*1E4);
hc(a,1)=length(find(Data(Restrict(sleepst,epochc))==1))/length(Data(Restrict(sleepst,epochc)))*100;
hc(a,2)=length(find(Data(Restrict(sleepst,epochc))==3))/length(Data(Restrict(sleepst,epochc)))*100;
hc(a,3)=length(find(Data(Restrict(sleepst,epochc))==4))/length(Data(Restrict(sleepst,epochc)))*100;
epochce=intervalSet(rgce+j*1E4,rgce+(j+1)*1E4);
hce(a,1)=length(find(Data(Restrict(sleepst,epochce))==1))/length(Data(Restrict(sleepst,epochce)))*100;
hce(a,2)=length(find(Data(Restrict(sleepst,epochce))==3))/length(Data(Restrict(sleepst,epochce)))*100;
hce(a,3)=length(find(Data(Restrict(sleepst,epochce))==4))/length(Data(Restrict(sleepst,epochce)))*100;
a=a+1;
end



figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot(vec,h,'linewidth',2)
plot(vec,hc(:,2),'linewidth',1,'color',[0.6 0 0],'linestyle',':')
line([0 0],[0 100],'color','k','linestyle',':'), title([num2str(var),', n=',num2str(length(rg))])
xlim([vec(1) vec(end)])
subplot(2,2,2), hold on
plot(vec,he,'linewidth',2)
plot(vec,hce(:,2),'linewidth',1,'color',[0.6 0 0],'linestyle',':')
line([0 0],[0 100],'color','k','linestyle',':'), 
xlim([vec(1) vec(end)])
subplot(2,2,3), 
plot(vec,hc,'linewidth',2)
line([0 0],[0 100],'color','k','linestyle',':'), title([num2str(var),', ctrl, n=',num2str(length(rgc))])
xlim([vec(1) vec(end)])
subplot(2,2,4), 
plot(vec,hce,'linewidth',2)
line([0 0],[0 100],'color','k','linestyle',':'), 
xlim([vec(1) vec(end)])
