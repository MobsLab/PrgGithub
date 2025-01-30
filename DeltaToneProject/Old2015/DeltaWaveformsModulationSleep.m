function DeltaWaveformsModulationSleep(struct,detail)
res=pwd;
load([res,'/newDelta',struct])

eval(['load(''ChannelsToAnalyse/',struct,'_deep.mat'')'])
ch=channel;
eval(['load(''ChannelsToAnalyse/',struct,'_sup.mat'')'])
ch2=channel;

eval(['load(''LFPData/LFP',num2str(ch),'.mat'')'])
eegDeep=LFP;
eval(['load(''LFPData/LFP',num2str(ch2),'.mat'')'])
eegSup=LFP;

figure, hist(tDelta,1000)
title('delta occurence across all recording time')

%--------------------------------------------------------------------------
% Delta during all SWS, and between begin/end of SWS
%--------------------------------------------------------------------------
% compared Delta Waveforms
num=500;
tot=length(tDelta);
Md=PlotRipRaw(eegDeep,tDelta(1:num)/1E4,1000); close
Ms=PlotRipRaw(eegSup,tDelta(1:num)/1E4,1000); close 
Mdf=PlotRipRaw(eegDeep,tDelta(tot-num:tot)/1E4,1000); close
Msf=PlotRipRaw(eegSup,tDelta(tot-num:tot)/1E4,1000); close 
err=4;

figure('color',[1 1 1]),
subplot(2,2,1), hold on 
plot(Md(:,1),Md(:,2),'k','linewidth',2)
plot(Md(:,1),Md(:,2)+Md(:,err),'k','linewidth',1)
plot(Md(:,1),Md(:,2)-Md(:,err),'k','linewidth',1)
plot(Ms(:,1),Ms(:,2),'r','linewidth',2)
plot(Ms(:,1),Ms(:,2)+Ms(:,err),'r','linewidth',1)
plot(Ms(:,1),Ms(:,2)-Ms(:,err),'r','linewidth',1)
hold on, title('deep(k) vs sup(r) : sleep begining')

subplot(2,2,2), hold on
plot(Mdf(:,1),Mdf(:,2),'k','linewidth',2)
plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'k','linewidth',1)
plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'k','linewidth',1)
plot(Msf(:,1),Msf(:,2),'r','linewidth',2)
plot(Msf(:,1),Msf(:,2)+Msf(:,err),'r','linewidth',1)
plot(Msf(:,1),Msf(:,2)-Msf(:,err),'r','linewidth',1)
hold on, title('deep(k) vs sup(r) : sleep end')

subplot(2,2,3), hold on
plot(Md(:,1),Md(:,2),'b','linewidth',2)
plot(Md(:,1),Md(:,2)+Md(:,err),'b','linewidth',1)
plot(Md(:,1),Md(:,2)-Md(:,err),'b','linewidth',1)
plot(Mdf(:,1),Mdf(:,2),'m','linewidth',2)
plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'m','linewidth',1)
plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'m','linewidth',1)
hold on, title('deep layer : sleep begining(b) vs end(m)')

subplot(2,2,4), hold on
plot(Ms(:,1),Ms(:,2),'b','linewidth',2)
plot(Ms(:,1),Ms(:,2)+Ms(:,err),'b','linewidth',1)
plot(Ms(:,1),Ms(:,2)-Ms(:,err),'b','linewidth',1)
plot(Msf(:,1),Msf(:,2),'m','linewidth',2)
plot(Msf(:,1),Msf(:,2)+Msf(:,err),'m','linewidth',1)
plot(Msf(:,1),Msf(:,2)-Msf(:,err),'m','linewidth',1)
hold on, title('sup layer : sleep begining(b) vs end(m)')





%--------------------------------------------------------------------------
% Discriminate intra Sleep Periods
%--------------------------------------------------------------------------
if detail==1
    % compared Delta Waveforms
    Delta=ts(tDelta);
    Epoch1=intervalSet(1.5E7,3.5E7);
    Epoch2=intervalSet(6.7E7,8.3E7);
    t1=Range(Restrict(Delta,Epoch1),'s');
    t2=Range(Restrict(Delta,Epoch2),'s');
    
    Md=PlotRipRaw(eegDeep,t1,1000);close
    Ms=PlotRipRaw(eegSup,t1,1000);close
    Mdf=PlotRipRaw(eegDeep,t2,1000);close
    Msf=PlotRipRaw(eegSup,t2,1000);close
    err=4;
    
    figure('color',[1 1 1]),
    subplot(2,2,1), hold on
    plot(Md(:,1),Md(:,2),'k','linewidth',2)
    plot(Md(:,1),Md(:,2)+Md(:,err),'k','linewidth',1)
    plot(Md(:,1),Md(:,2)-Md(:,err),'k','linewidth',1)
    plot(Ms(:,1),Ms(:,2),'r','linewidth',2)
    plot(Ms(:,1),Ms(:,2)+Ms(:,err),'r','linewidth',1)
    plot(Ms(:,1),Ms(:,2)-Ms(:,err),'r','linewidth',1)
    
    subplot(2,2,2), hold on
    plot(Mdf(:,1),Mdf(:,2),'k','linewidth',2)
    plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'k','linewidth',1)
    plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'k','linewidth',1)
    plot(Msf(:,1),Msf(:,2),'r','linewidth',2)
    plot(Msf(:,1),Msf(:,2)+Msf(:,err),'r','linewidth',1)
    plot(Msf(:,1),Msf(:,2)-Msf(:,err),'r','linewidth',1)
    
    subplot(2,2,3), hold on
    plot(Md(:,1),Md(:,2),'b','linewidth',2)
    plot(Md(:,1),Md(:,2)+Md(:,err),'b','linewidth',1)
    plot(Md(:,1),Md(:,2)-Md(:,err),'b','linewidth',1)
    plot(Mdf(:,1),Mdf(:,2),'m','linewidth',2)
    plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'m','linewidth',1)
    plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'m','linewidth',1)
    
    subplot(2,2,4), hold on
    plot(Ms(:,1),Ms(:,2),'b','linewidth',2)
    plot(Ms(:,1),Ms(:,2)+Ms(:,err),'b','linewidth',1)
    plot(Ms(:,1),Ms(:,2)-Ms(:,err),'b','linewidth',1)
    plot(Msf(:,1),Msf(:,2),'m','linewidth',2)
    plot(Msf(:,1),Msf(:,2)+Msf(:,err),'m','linewidth',1)
    plot(Msf(:,1),Msf(:,2)-Msf(:,err),'m','linewidth',1)
   
end
