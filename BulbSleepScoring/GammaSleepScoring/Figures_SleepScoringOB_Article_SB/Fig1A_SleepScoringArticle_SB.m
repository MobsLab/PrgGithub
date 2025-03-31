%% Code used for fig 1 in draft for april 11th
%% Example Data
close all
cd('/media/DataMOBsRAIDN/ProjetAstro/Mouse148/20140828/BULB-Mouse-148-28082014/')
%clear all
sws=figure; 
Eps=intervalSet(4460.8*1e4,4462.8*1e4);
rem=figure;
Epr=intervalSet(10330*1e4,10332*1e4);
Epr=intervalSet(13540*1e4,13542*1e4);
wake=figure;
Epw=intervalSet(1158*1e4,1160*1e4);

col(1,:)=[30,144,255]/255; %B
col(3,:)=[65,105,225]/255; %Pi
col(6,:)=[123,104,238]/255; %Amyg
col(5,:)=[255,69,0]/255; %Pa
col(2,:)=[255,127,80]/255; %Hpc
col(4,:)=[60,179,113]/255; %pf

load('LFPData/LFP4.mat')
 FilLFP=FilterLFP(LFP,[40,70],1024)
figure(sws), hold off
plot(Range(Restrict(LFP,Eps),'s'),Data(Restrict(LFP,Eps)),'color',col(1,:),'linewidth',1.5);,hold on
plot(Range(Restrict(FilLFP,Eps),'s'),Data(Restrict(FilLFP,Eps))-2*1e4,'color',col(1,:),'linewidth',1.5);,hold on
figure(rem), hold off
plot(Range(Restrict(LFP,Epr),'s'),Data(Restrict(LFP,Epr)),'color',col(1,:)*0.8,'linewidth',1.5);,hold on
plot(Range(Restrict(FilLFP,Epr),'s'),Data(Restrict(FilLFP,Epr))-2*1e4,'color',col(1,:),'linewidth',1.5);,hold on
figure(wake), hold off
plot(Range(Restrict(LFP,Epw),'s'),Data(Restrict(LFP,Epw)),'color',col(1,:)*0.8,'linewidth',1.5);,hold on
plot(Range(Restrict(FilLFP,Epw),'s'),Data(Restrict(FilLFP,Epw))-2*1e4,'color',col(1,:),'linewidth',1.5);,hold on

load('LFPData/LFP11.mat')
figure(sws)
plot(Range(Restrict(LFP,Eps),'s'),Data(Restrict(LFP,Eps))+2*1e4,'color',col(2,:),'linewidth',1.5);
figure(rem)
plot(Range(Restrict(LFP,Epr),'s'),Data(Restrict(LFP,Epr))+2*1e4,'color',col(2,:),'linewidth',1.5);
figure(wake)
plot(Range(Restrict(LFP,Epw),'s'),Data(Restrict(LFP,Epw))+2*1e4,'color',col(2,:),'linewidth',1.5);

 load('LFPData/LFP7.mat')
 FLFP=FilterLFP(LFP,[50,500],1024)
figure(sws)
plot(Range(Restrict(FLFP,Eps),'s'),Data(Restrict(FLFP,Eps))+4*1e4,'color','k','linewidth',1.5);
set(gca,'XTickLabel',{},'XTick',[],'YTickLabel',{},'YTick',[])
figure(rem)
plot(Range(Restrict(FLFP,Epr),'s'),Data(Restrict(FLFP,Epr))+4*1e4,'color','k','linewidth',1.5);
set(gca,'XTickLabel',{},'XTick',[],'YTickLabel',{},'YTick',[])
figure(wake)
plot(Range(Restrict(FLFP,Epw),'s'),Data(Restrict(FLFP,Epw))+4*1e4,'color','k','linewidth',1.5);
set(gca,'XTickLabel',{},'XTick',[],'YTickLabel',{},'YTick',[])

