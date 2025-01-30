function DeltaModulationSleep(struct,detail)
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

% compared Delta AutoCorrelograms
num=1000;
tot=length(tDelta);
sbin=80;
nbin=200;
smo=2;

[C,B]=CrossCorr(tDelta,tDelta,sbin,nbin); C(B==0)=0;
figure, subplot(2,1,1)
hold on, plot(B/1E3,smooth(C,smo))
hold on, title('Parietal Delta - all SWS epoch')
[C1,B1]=CrossCorr(tDelta(1:num),tDelta(1:num),sbin,nbin); C1(B1==0)=0;
[C2,B2]=CrossCorr(tDelta(tot-num:tot),tDelta(tot-num:tot),sbin,nbin); C2(B2==0)=0;
hold on, subplot(2,1,2)
hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
hold on, title(['nDelta=',num2str(num),' - SWS begin(k) vs SWS end(r)'])



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
    
    
    % compared Delta AutoCorrelograms
    num=1000;
    tot=length(tDelta);
    % choose t1 and t2
    Delta=ts(tDelta);
    % first sleep episode
    Epoch1=intervalSet(1.5E7,2.6E7);
    Epoch2=intervalSet(7.4E7,8.4E7);
    t1=Range(Restrict(Delta,Epoch1));
    t2=Range(Restrict(Delta,Epoch2));
    % last sleep episode
    Epoch3=intervalSet(2.4E8,2.7E8);
    Epoch4=intervalSet(2.75E8,2.95E8);
    t3=Range(Restrict(Delta,Epoch3));
    t4=Range(Restrict(Delta,Epoch4));
    sbin=80;
    nbin=200;
    smo=2;
    
    [C,B]=CrossCorr(tDelta,tDelta,sbin,nbin); C(B==0)=0;
    figure, subplot(4,1,1)
    hold on, plot(B/1E3,smooth(C,smo))
    hold on, title('Parietal Delta - all SWS epoch')
    [C1,B1]=CrossCorr(tDelta(1:num),tDelta(1:num),sbin,nbin); C1(B1==0)=0;
    [C2,B2]=CrossCorr(tDelta(tot-num:tot),tDelta(tot-num:tot),sbin,nbin); C2(B2==0)=0;
    hold on, subplot(4,1,2)
    hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
    hold on, title(['nDelta=',num2str(num),' - SWS begin(k) vs SWS end(r)'])
    [C1,B1]=CrossCorr(t1,t1,sbin,nbin); C1(B1==0)=0;
    [C2,B2]=CrossCorr(t2,t2,sbin,nbin); C2(B2==0)=0;
    hold on, subplot(4,1,3)
    hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
    hold on, title(['begin versus end of first sleep episode'])
    [C3,B3]=CrossCorr(t3,t3,sbin,nbin); C3(B3==0)=0;
    [C4,B4]=CrossCorr(t4,t4,sbin,nbin); C4(B4==0)=0;
    hold on, subplot(4,1,4)
    hold on, plot(B3/1E3,smooth(C3,smo),'k'), hold on, plot(B4/1E3,smooth(C4,smo),'r')
    hold on, title(['begin versus end of last sleep episode'])
end
