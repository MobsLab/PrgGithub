%EvolMarie


%     Ep2=intervalSet(Start(Ep),Start(Ep)+limitSWS/2*1E4);
%     Ep3=and(Ep,Ep2);
%     Sp3=Data(Restrict(Stsd,Ep3));
%     
%     Ep4=intervalSet(Start(Ep)+15E4,Start(Ep)+limitSWS*1E4);
%     Ep5=and(Ep,Ep4);
%     Sp4=Data(Restrict(Stsd,Ep5));
%     M(i,1)=mean(mean(Sp2(:,find(f>lim1&f<lim2)),2));
%     M(i,2)=std(mean(Sp2(:,find(f>lim1&f<lim2)),2));
%     M(i,3)=sum(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'));
%     M(i,4)=std(mean(Sp3(:,find(f>lim1&f<lim2)),2));
%     M(i,5)=std(mean(Sp4(:,find(f>lim1&f<lim2)),2));

%     temp=(Data(Restrict(Sle,ts(st-350))));
%     StateBef(:,1)=temp;
%     ctrl=(Data(Restrict(Sle,intervalSet(st(i)-10*60E4,st(i)))));
%     StateBef(i,2)=length(find(ctrl==4))/length(ctrl)*100;
%     StateBef(i,3)=length(find(ctrl==3))/length(ctrl)*100;
%     
%     ctrl=(Data(Restrict(Sle,intervalSet(st(i)-2*60E4,st(i)))));
%     StateBef(i,4)=length(find(ctrl==4))/length(ctrl)*100;
%     StateBef(i,5)=length(find(ctrl==3))/length(ctrl)*100;
% 
%     stSWS=Start(SWSEpoch,'s');

legendStateBef{1}='State before SWS';
legendStateBef{2}='% of wake before SWS (10 min)';
legendStateBef{3}='% of REM before SWS (10 min)';
legendStateBef{4}='% of wake before SWS (1 min)';
legendStateBef{5}='% of REM before SWS (1 min)';

legendM{1}='Power Bulb 2-4Hz';
legendM{2}='std Power Bulb 2-4Hz';
legendM{3}='Duration SWS (s)';
legendM{4}='Power Bulb 2-4Hz (0-15s)';
legendM{5}='Power Bulb 2-4Hz (15-30s)';


cho=1; %Bulb

RemoveShortSWSEpoch=0;
RemovePreEpoch=0;
limitSWS=30;
lim1=2;
lim2=4;

%SleepScoreFigure

if cho==1
    res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    disp('*****************  Bulb *********************')
elseif cho==2
    res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    disp('*****************  PFC *********************')
    
    else
    res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/PaCx_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    disp('*****************  PAR *********************')
    
end

try
    
    try
        load SpindlesPFCxSup
        SpiTot;
        disp('Spindles PFC sup')
    catch
        load SpindlesPFCxDeep
        SpiTot;
        disp('Spindles PFC deep')
    end
% load SpindlesPaCxSup
% load SpindlesPaCxDeep

%Spitsd=ts(SpiTot(:,2)*1E4);  
%Spitsd=ts(SpiLow(:,2)*1E4);
Spitsd=ts(SpiHigh(:,2)*1E4);

end

disp(' ')

%----------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------



load behavResources PreEpoch

Stsd=tsd(t*1E4,Sp);
SlowTsd=tsd(t*1E4,mean(Sp(:,find(f>lim1&f<lim2)),2));

try
load StateEpochSB SWSEpoch REMEpoch Wake wakeper
[Wake,SWSEpoch,REMEpoch]=StateEpochMLtoSB;
            if RemovePreEpoch
                try
                SWSEpoch=and(SWSEpoch,PreEpoch);
                Wake=and(Wake,PreEpoch);
                REMEpoch=and(REMEpoch,PreEpoch);
                end
            end
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1,[10 12]);close
figure, imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 75])
PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,10,Epoch{9});
hold on, plot(Range(Restrict(SlowTsd,SWSEpoch),'s'),rescale(Data(Restrict(SlowTsd,SWSEpoch)),16,20),'k')
end

load StateEpochSB SWSEpoch REMEpoch Wake wakeper
            if RemovePreEpoch
                try
                SWSEpoch=and(SWSEpoch,PreEpoch);
                Wake=and(Wake,PreEpoch);
                REMEpoch=and(REMEpoch,PreEpoch);
                end
            end
            
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1,[10 12]);close
figure, imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 75])
PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,10,Epoch{9});
hold on, plot(Range(Restrict(SlowTsd,SWSEpoch),'s'),rescale(Data(Restrict(SlowTsd,SWSEpoch)),16,20),'k')


load StateEpochSB SWSEpoch REMEpoch Wake wakeper TotalNoiseEpoch GndNoiseEpoch
if RemoveShortSWSEpoch
    
                if RemovePreEpoch
                    try
                SWSEpoch=and(SWSEpoch,PreEpoch);
                Wake=and(Wake,PreEpoch);
                REMEpoch=and(REMEpoch,PreEpoch);
                    end
                end
                
    SWSEpoch=mergeCloseIntervals(SWSEpoch,5E4);
    % Wake=dropShortIntervals(Wake,5E4);
    % REMEpoch=dropShortIntervals(REMEpoch,5E4);
end

Sle=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1,10); 





clear A
clear B
 for i=1:length(Start(SWSEpoch))
    A(i,:)=mean(Data(Restrict(Stsd,subset(SWSEpoch,i))));
 end

a=1;
 for i=1:length(Start(SWSEpoch))
    if sum(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'))>limitSWS
    B(a,:)=mean(Data(Restrict(Stsd,subset(SWSEpoch,i))));
    a=a+1;
    end
 end

 figure('color',[1 1 1]),
 subplot(2,2,1), imagesc(1:size(A,1),f,A'), axis xy
 subplot(2,2,3), imagesc(1:size(B,1),f,B'), axis xy, title(['Above limit SWS: ',num2str(limitSWS),' s'])
 subplot(2,2,[2,4]), hist((End(SWSEpoch,'s')-Start(SWSEpoch,'s')),200)
 title([num2str(mean((End(SWSEpoch,'s')-Start(SWSEpoch,'s')))),' s'])
 yl=ylim;
 hold on, line([limitSWS limitSWS],yl,'color','r')
%set(gca,'xscale','log')






clear M
 for i=1:length(Start(SWSEpoch))
    Sp2=Data(Restrict(Stsd,subset(SWSEpoch,i)));
    Ep=subset(SWSEpoch,i);
    Ep2=intervalSet(Start(Ep),Start(Ep)+limitSWS/2*1E4);
    Ep3=and(Ep,Ep2);
    Sp3=Data(Restrict(Stsd,Ep3));
    
    Ep4=intervalSet(Start(Ep)+15E4,Start(Ep)+limitSWS*1E4);
    Ep5=and(Ep,Ep4);
    Sp4=Data(Restrict(Stsd,Ep5));
    
    M(i,1)=mean(mean(Sp2(:,find(f>lim1&f<lim2)),2));
    M(i,2)=std(mean(Sp2(:,find(f>lim1&f<lim2)),2));
    M(i,3)=sum(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'));
    M(i,4)=mean(mean(Sp3(:,find(f>lim1&f<lim2)),2));
    M(i,5)=mean(mean(Sp4(:,find(f>lim1&f<lim2)),2));
 end



figure('color',[1 1 1]),
subplot(3,2,1), plot(M(:,1),'k','linewidth',2)
hold on, plot(M(:,1)+M(:,2),'k','linewidth',1)
hold on, plot(M(:,1)-M(:,2),'k','linewidth',1)
hold on, plot(M(:,3)*1E3,'color',[0.7 0.7 0.7])
[r,p]=corrcoef(1:size(M,1),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power 2-4 Hz')

id=find(M(:,3)>limitSWS);
subplot(3,2,2), plot(M(id,1),'k','linewidth',2)
hold on, plot(M(id,1)+M(id,2),'k','linewidth',1)
hold on, plot(M(id,1)-M(id,2),'k','linewidth',1)
hold on, plot(M(id,3)*1E3,'color',[0.7 0.7 0.7])
[r,p]=corrcoef(1:length(id),M(id,1));title(['Long periods, r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])

subplot(3,2,3), plot(M(:,4),'k','linewidth',2)
hold on, plot(M(:,3)*1E3,'color',[0.7 0.7 0.7])
[r,p]=corrcoef(1:size(M,1),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power 15 first sec')

id=find(M(:,4)>limitSWS);
subplot(3,2,4), plot(M(id,4),'k','linewidth',2)
hold on, plot(M(id,3)*1E3,'color',[0.7 0.7 0.7])
[r,p]=corrcoef(1:length(id),M(id,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])

subplot(3,2,5), plot(M(:,5),'k','linewidth',2)
hold on, plot(M(:,3)*1E3,'color',[0.7 0.7 0.7])
[r,p]=corrcoef(1:size(M,1),M(:,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power periods 15-30 sec')

id=find(M(:,4)>limitSWS);
subplot(3,2,6), plot(M(id,5),'k','linewidth',2)
hold on, plot(M(id,3)*1E3,'color',[0.7 0.7 0.7])
[r,p]=corrcoef(1:length(id),M(id,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])

clear C

figure('color',[1 1 1]),
a=1;
for i=1:length(Start(SWSEpoch))
C{i}=(Data(Restrict(SlowTsd,subset(SWSEpoch,i))));
le(i)=length(C{i});
end

D=[];
for i=1:length(Start(SWSEpoch))
    try
        D=[D;C{i}(1:50)'];
    end
end
subplot(1,3,1), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)

D=[];
for i=1:length(Start(SWSEpoch))
    try
        D=[D;C{i}(1:100)'];
    end
end
subplot(1,3,2), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)

D=[];
for i=1:length(Start(SWSEpoch))
    try
        D=[D;C{i}(1:200)'];
    end
end
subplot(1,3,3), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)





clear StateBef


load behavResources Movtsd
st=Start(SWSEpoch);
%t=Range(Movtsd);
%temp=(Data(Restrict(Sle,ts(st-600))));
for i=1:length(Start(SWSEpoch))
    temp=(Data(Restrict(Sle,intervalSet(st(i)-650,st(i)))));
    try
        StateBef(i,1)=temp(1);
    catch
        StateBef(i,1)=-1;
    end
    
end

for i=1:length(Start(SWSEpoch))
    ctrl=(Data(Restrict(Sle,intervalSet(st(i)-10*60E4,st(i)))));
    StateBef(i,2)=length(find(ctrl==4))/length(ctrl)*100;
    StateBef(i,3)=length(find(ctrl==3))/length(ctrl)*100;

    ctrl=(Data(Restrict(Sle,intervalSet(st(i)-2*60E4,st(i)))));
    StateBef(i,4)=length(find(ctrl==4))/length(ctrl)*100;
    StateBef(i,5)=length(find(ctrl==3))/length(ctrl)*100;
end

figure('color',[1 1 1]), hist(StateBef(:,1),[-1:5])


stSWS=Start(SWSEpoch,'s');

figure('color',[1 1 1]),
subplot(3,2,1), scatter(StateBef(:,2),M(:,1),50,stSWS,'filled')
[r,p]=corrcoef(StateBef(:,2),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power in 2-4Hz')
xlim([0 100])

subplot(3,2,2), scatter(StateBef(:,3),M(:,1),50,stSWS,'filled')
[r,p]=corrcoef(StateBef(:,3),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlim([0 100])

subplot(3,2,3), scatter(StateBef(:,2),M(:,4),50,stSWS,'filled')
[r,p]=corrcoef(StateBef(:,2),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power in 2-4Hz in the 15 first sec')
xlim([0 100])

subplot(3,2,4), scatter(StateBef(:,3),M(:,4),50,stSWS,'filled')
[r,p]=corrcoef(StateBef(:,3),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlim([0 100])

idx=find(~isnan(M(:,5)));
subplot(3,2,5), scatter(StateBef(idx,2),M(idx,5),50,stSWS(idx),'filled')
[r,p]=corrcoef(StateBef(idx,2),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlabel('% of Wake in the 10 min before SWS')
ylabel('Power in 2-4Hz in the periods 15-30 sec')
xlim([0 100])

subplot(3,2,6), scatter(StateBef(idx,3),M(idx,5),50,stSWS(idx),'filled')
[r,p]=corrcoef(StateBef(idx,3),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlabel('% of REM in the 10 min before SWS')
xlim([0 100])

figure('color',[1 1 1]),
subplot(3,2,1), scatter(StateBef(:,4),M(:,1),50,stSWS,'filled')
[r,p]=corrcoef(StateBef(:,4),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power in 2-4Hz')
xlim([0 100])

subplot(3,2,2), scatter(StateBef(:,5),M(:,1),50,stSWS,'filled')
[r,p]=corrcoef(StateBef(:,5),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlim([0 100])

subplot(3,2,3), scatter(StateBef(:,4),M(:,4),50,stSWS,'filled')
[r,p]=corrcoef(StateBef(:,4),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power in 2-4Hz in the 15 first sec')
xlim([0 100])

subplot(3,2,4), scatter(StateBef(:,5),M(:,4),50,stSWS,'filled')
[r,p]=corrcoef(StateBef(:,5),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlim([0 100])

idx=find(~isnan(M(:,5)));
subplot(3,2,5), scatter(StateBef(idx,4),M(idx,5),50,stSWS(idx),'filled')
[r,p]=corrcoef(StateBef(idx,4),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlabel('% of Wake in the 2 min before SWS')
ylabel('Power in 2-4Hz in the periods 15-30 sec')
xlim([0 100])

subplot(3,2,6), scatter(StateBef(idx,5),M(idx,5),50,stSWS(idx),'filled')
[r,p]=corrcoef(StateBef(idx,5),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlabel('% of REM in the 2 min before SWS')
xlim([0 100])







figure('color',[1 1 1]),
subplot(3,2,1), scatter(stSWS,M(:,1),50,StateBef(:,2),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS,M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power in 2-4Hz')
% xlim([0 100])

subplot(3,2,2), scatter(stSWS,M(:,1),50,StateBef(:,3),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS,M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
% xlim([0 100])

subplot(3,2,3), scatter(stSWS,M(:,4),50,StateBef(:,2),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS,M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power in 2-4Hz in the 15 first sec')
% xlim([0 100])

subplot(3,2,4), scatter(stSWS,M(:,4),50,StateBef(:,3),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS,M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
% xlim([0 100])

idx=find(~isnan(M(:,5)));
subplot(3,2,5), scatter(stSWS(idx),M(idx,5),50,StateBef(idx,2),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS(idx),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlabel('Time of SWS (caxis: % wake before)')
ylabel('Power in 2-4Hz in the periods 15-30 sec')
% xlim([0 100])

subplot(3,2,6), scatter(stSWS(idx),M(idx,5),50,StateBef(idx,3),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS(idx),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlabel('Time of SWS (caxis: % REM Before)'), caxis([0 100])
% xlim([0 100])


figure('color',[1 1 1]),
subplot(3,2,1), scatter(stSWS,M(:,1),50,StateBef(:,4),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS,M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power in 2-4Hz'), caxis([0 100])
% xlim([0 100])

subplot(3,2,2), scatter(stSWS,M(:,1),50,StateBef(:,5),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS,M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
% xlim([0 100])

subplot(3,2,3), scatter(stSWS,M(:,4),50,StateBef(:,4),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS,M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power in 2-4Hz in the 15 first sec')
% xlim([0 100])

subplot(3,2,4), scatter(stSWS,M(:,4),50,StateBef(:,5),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS,M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
% xlim([0 100])
% 
idx=find(~isnan(M(:,5)));
subplot(3,2,5), scatter(stSWS(idx),M(idx,5),50,StateBef(idx,4),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS(idx),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlabel('Time of SWS (caxis: % wake before)')
ylabel('Power in 2-4Hz in the periods 15-30 sec')
% xlim([0 100])

subplot(3,2,6), scatter(stSWS(idx),M(idx,5),50,StateBef(idx,5),'filled'), caxis([0 100])
[r,p]=corrcoef(stSWS(idx),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
xlabel('Time of SWS (caxis: % REM before)')
% xlim([0 100])




% 
% figure('color',[1 1 1]), 
% subplot(2,2,4), dis=PlotLine3D(stSWS,M(:,1),StateBef(:,2),0);
% subplot(2,2,1), scatter(stSWS,M(:,1),30,dis,'filled')
% xlabel('Start SWS')
% ylabel(legendM{1})
% subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,dis,'filled')
% xlabel(legendStateBef{2})
% ylabel('Start SWS')
% subplot(2,2,3), scatter(StateBef(:,2),M(:,1),30,dis,'filled')
% xlabel(legendStateBef{2})
% ylabel(legendM{1})
% 
% 
% figure('color',[1 1 1]), 
% subplot(2,2,4), dis=PlotLine3D(stSWS,M(:,4),StateBef(:,2),0);
% subplot(2,2,1), scatter(stSWS,M(:,4),30,dis,'filled')
% xlabel('Start SWS')
% ylabel(legendM{4})
% subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,dis,'filled')
% xlabel(legendStateBef{2})
% ylabel('Start SWS')
% subplot(2,2,3), scatter(StateBef(:,2),M(:,4),30,dis,'filled')
% xlabel(legendStateBef{2})
% ylabel(legendM{4})
% 
% 
% figure('color',[1 1 1]), 
% subplot(2,2,4), dis=PlotLine3D(stSWS,M(:,1),StateBef(:,4),0);
% subplot(2,2,1), scatter(stSWS,M(:,1),30,dis,'filled')
% xlabel('Start SWS')
% ylabel(legendM{1})
% subplot(2,2,2), scatter(StateBef(:,4),stSWS,30,dis,'filled')
% xlabel(legendStateBef{4})
% ylabel('Start SWS')
% subplot(2,2,3), scatter(StateBef(:,4),M(:,1),30,dis,'filled')
% xlabel(legendStateBef{4})
% ylabel(legendM{1})
% 
% figure('color',[1 1 1]), 
% subplot(2,2,4), dis=PlotLine3D(stSWS,M(:,4),StateBef(:,3),0);
% subplot(2,2,1), scatter(stSWS,M(:,4),30,dis,'filled')
% xlabel('Start SWS')
% ylabel(legendM{4})
% subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,dis,'filled')
% xlabel(legendStateBef{2})
% ylabel('Start SWS')
% subplot(2,2,3), scatter(StateBef(:,2),M(:,4),30,dis,'filled')
% xlabel(legendStateBef{2})
% ylabel(legendM{4})
% 
% 


figure('color',[1 1 1]), 
subplot(2,2,4), dis=PlotLine3D(stSWS,StateBef(:,2),M(:,1),0);
xlabel('Start SWS')
zlabel(legendM{1})
ylabel(legendStateBef{2})
subplot(2,2,1), scatter(stSWS,M(:,1),30,StateBef(:,2),'filled')
xlabel('Start SWS')
ylabel(legendM{1})
subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,M(:,1),'filled')
xlabel(legendStateBef{2})
ylabel('Start SWS')
subplot(2,2,3), scatter(StateBef(:,2),M(:,1),30,stSWS,'filled')
xlabel(legendStateBef{2})
ylabel(legendM{1})

  figure('color',[1 1 1]), 
subplot(2,2,4), dis=PlotLine3D(stSWS,StateBef(:,2),M(:,4),0);
xlabel('Start SWS')
zlabel(legendM{4})
ylabel(legendStateBef{2})
subplot(2,2,1), scatter(stSWS,M(:,4),30,StateBef(:,2),'filled')
xlabel('Start SWS')
ylabel(legendM{4})
subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,M(:,4),'filled')
xlabel(legendStateBef{2})
ylabel('Start SWS')
subplot(2,2,3), scatter(StateBef(:,2),M(:,4),30,stSWS,'filled')
xlabel(legendStateBef{2})
ylabel(legendM{4})






idW=find(StateBef(:,1)==4);
idR=find(StateBef(:,1)==3);



E=C(idW);
F=C(idR);

figure('color',[1 1 1]),

D=[];
for i=1:length(E)
    try
        D=[D;E{i}(1:50)'];
    end
end
subplot(2,3,1), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)

D=[];
for i=1:length(E)
    try
        D=[D;E{i}(1:100)'];
    end
end
subplot(2,3,2), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)

D=[];
for i=1:length(E)
    try
        D=[D;E{i}(1:200)'];
    end
end
subplot(2,3,3), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)



D=[];
for i=1:length(F)
    try
        D=[D;F{i}(1:50)'];
    end
end
subplot(2,3,4), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)

D=[];
for i=1:length(F)
    try
        D=[D;F{i}(1:100)'];
    end
end
subplot(2,3,5), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)

D=[];
for i=1:length(F)
    try
        D=[D;F{i}(1:200)'];
    end
end
subplot(2,3,6), imagesc(D), axis xy
hold on, plot(rescale(nanmean(D),1,size(D,1)),'k','linewidth',2)



 %     M(i,1)=mean(mean(Sp2(:,find(f>lim1&f<lim2)),2));
%     M(i,2)=std(mean(Sp2(:,find(f>lim1&f<lim2)),2));
%     M(i,3)=sum(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'));
%     M(i,4)=std(mean(Sp3(:,find(f>lim1&f<lim2)),2));
%     M(i,5)=std(mean(Sp4(:,find(f>lim1&f<lim2)),2));

%     ctrl=(Data(Restrict(Sle,intervalSet(st(i)-10*60E4,st(i)))));
%     StateBef(i,2)=length(find(ctrl==4))/length(ctrl)*100;
%     StateBef(i,3)=length(find(ctrl==3))/length(ctrl)*100;
%     
%     ctrl=(Data(Restrict(Sle,intervalSet(st(i)-2*60E4,st(i)))));
%     StateBef(i,4)=length(find(ctrl==4))/length(ctrl)*100;
%     StateBef(i,5)=length(find(ctrl==3))/length(ctrl)*100;
% 
%     stSWS=Start(SWSEpoch,'s');






try
    
id=find(M(:,3)>100);

for i=1:length(Start(SWSEpoch))
stemp(i,1)=length(Range(Restrict(Spitsd,subset(SWSEpoch,i))));
stemp(i,2)=sum(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'));
stemp(i,3)=stemp(i,1)/stemp(i,2);
end

figure('color',[1 1 1]), 
a=1;
for i=1:5
subplot(2,3,a), hold on
plot(M(:,i),stemp(:,3),'ko','markerfacecolor','k')
plot(M(id,i),stemp(id,3),'ro','markerfacecolor','r')
ylabel('Freq Spindles Hz')
xlabel(legendM{a})
a=a+1;
end
 
figure('color',[1 1 1]), hold on,
plot(stSWS/60,stemp(:,3),'ko','markerfacecolor','k')
plot(stSWS(id)/60,stemp(id,3),'ro','markerfacecolor','r')
ylabel('Freq Spindles Hz')
xlabel('Start SWS period (min)')

figure('color',[1 1 1]), 
a=1;
for i=1:5
subplot(2,3,a), hold on,
plot(StateBef(:,i),stemp(:,3),'ko','markerfacecolor','k')
plot(StateBef(id,i),stemp(id,3),'ro','markerfacecolor','r')
ylabel('Freq Spindles Hz')
xlabel(legendStateBef{a})
a=a+1;
end








clear NbSpi
clear NbSpiR
clear NbSpiW

rg=Range(Movtsd);
TotalEpoch=intervalSet(0,rg(end));
try
TotalEpoch=TotalEpoch-TotalNoiseEpoch;
end

EpochTest=SWSEpoch;

NbSpi(1,1)=length(Range(Restrict(Spitsd,TotalEpoch)));
NbSpi(1,2)=sum(End(TotalEpoch,'s')-Start(TotalEpoch,'s'));
NbSpi(1,3)=NbSpi(1,1)/NbSpi(1,2);
NbSpi(1,4)=nan;
NbSpi(1,5)=nan;
NbSpi(1,6)=nan;

clear Epoch
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,EpochTest,1,[10 12]);close

NbSpi(2,1)=length(Range(Restrict(Spitsd,EpochTest)));
NbSpi(2,2)=sum(End(EpochTest,'s')-Start(EpochTest,'s'));
NbSpi(2,3)=NbSpi(2,1)/NbSpi(2,2);
NbSpi(2,4)=nan;
NbSpi(2,5)=nan;
NbSpi(2,6)=nan;

for i=1:9
NbSpi(i+2,1)=length(Range(Restrict(Spitsd,Epoch{i})));
NbSpi(i+2,2)=sum(End(Epoch{i},'s')-Start(Epoch{i},'s'));
NbSpi(i+2,3)=NbSpi(i+2,1)/NbSpi(i+2,2);

NbSpi(i+2,4)=length(Range(Restrict(Spitsd,EpochTest-Epoch{i})));
NbSpi(i+2,5)=sum(End(EpochTest-Epoch{i},'s')-Start(EpochTest-Epoch{i},'s'));
NbSpi(i+2,6)=NbSpi(i+2,4)/NbSpi(i+2,5);
end


EpochTest=Wake;

NbSpiW(1,1)=length(Range(Restrict(Spitsd,TotalEpoch)));
NbSpiW(1,2)=sum(End(TotalEpoch,'s')-Start(TotalEpoch,'s'));
NbSpiW(1,3)=NbSpiW(1,1)/NbSpiW(1,2);
NbSpiW(1,4)=nan;
NbSpiW(1,5)=nan;
NbSpiW(1,6)=nan;

clear Epoch
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,EpochTest,1,[10 12]);close

NbSpiW(2,1)=length(Range(Restrict(Spitsd,EpochTest)));
NbSpiW(2,2)=sum(End(EpochTest,'s')-Start(EpochTest,'s'));
NbSpiW(2,3)=NbSpi(2,1)/NbSpi(2,2);
NbSpiW(2,4)=nan;
NbSpiW(2,5)=nan;
NbSpiW(2,6)=nan;

for i=1:9
NbSpiW(i+2,1)=length(Range(Restrict(Spitsd,Epoch{i})));
NbSpiW(i+2,2)=sum(End(Epoch{i},'s')-Start(Epoch{i},'s'));
NbSpiW(i+2,3)=NbSpiW(i+2,1)/NbSpiW(i+2,2);

NbSpiW(i+2,4)=length(Range(Restrict(Spitsd,EpochTest-Epoch{i})));
NbSpiW(i+2,5)=sum(End(EpochTest-Epoch{i},'s')-Start(EpochTest-Epoch{i},'s'));
NbSpiW(i+2,6)=NbSpi(i+2,4)/NbSpi(i+2,5);

end




EpochTest=REMEpoch;

NbSpiR(1,1)=length(Range(Restrict(Spitsd,TotalEpoch)));
NbSpiR(1,2)=sum(End(TotalEpoch,'s')-Start(TotalEpoch,'s'));
NbSpiR(1,3)=NbSpiR(1,1)/NbSpiR(1,2);
NbSpiR(1,4)=nan;
NbSpiR(1,5)=nan;
NbSpiR(1,6)=nan;

clear Epoch
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,EpochTest,1,[10 12]);close

NbSpiR(2,1)=length(Range(Restrict(Spitsd,EpochTest)));
NbSpiR(2,2)=sum(End(EpochTest,'s')-Start(EpochTest,'s'));
NbSpiR(2,3)=NbSpiR(2,1)/NbSpiR(2,2);
NbSpiR(2,4)=nan;
NbSpiR(2,5)=nan;
NbSpiR(2,6)=nan;

for i=1:9
NbSpiR(i+2,1)=length(Range(Restrict(Spitsd,Epoch{i})));
NbSpiR(i+2,2)=sum(End(Epoch{i},'s')-Start(Epoch{i},'s'));
NbSpiR(i+2,3)=NbSpiR(i+2,1)/NbSpiR(i+2,2);
NbSpiR(i+2,4)=length(Range(Restrict(Spitsd,EpochTest-Epoch{i})));
NbSpiR(i+2,5)=sum(End(EpochTest-Epoch{i},'s')-Start(EpochTest-Epoch{i},'s'));
NbSpiR(i+2,6)=NbSpiR(i+2,4)/NbSpiR(i+2,5);

end


figure('color',[1 1 1]), 
subplot(3,4,1), plot(NbSpi(:,1),'ko-'),title('SWSEpoch')
hold on, plot(1,NbSpi(1,1),'ko','markerfacecolor','r')
hold on, plot(2,NbSpi(2,1),'ko','markerfacecolor','k')
plot(NbSpi(:,4),'ro-')
subplot(3,4,2), plot(NbSpi(:,2)/60,'ko-')
hold on, plot(1,NbSpi(1,2)/60,'ko','markerfacecolor','r')
hold on, plot(2,NbSpi(2,2)/60,'ko','markerfacecolor','k')
plot(NbSpi(:,5)/60,'ro-')
subplot(3,4,3), plot(NbSpi(:,3),'ko-')
hold on, plot(1,NbSpi(1,3),'ko','markerfacecolor','r')
hold on, plot(2,NbSpi(2,3),'ko','markerfacecolor','k')
plot(NbSpi(:,6),'ro-')
ylim([0 0.12])
subplot(3,4,4), plot(NbSpi(:,3)./NbSpi(:,6)*100,'bo-')

subplot(3,4,5), plot(NbSpiW(:,1),'ko-'),title('Wake')
hold on, plot(1,NbSpiW(1,1),'ko','markerfacecolor','r')
hold on, plot(2,NbSpiW(2,1),'ko','markerfacecolor','k')
plot(NbSpiW(:,4),'ro-')
subplot(3,4,6), plot(NbSpiW(:,2)/60,'ko-')
hold on, plot(1,NbSpiW(1,2)/60,'ko','markerfacecolor','r')
hold on, plot(2,NbSpiW(2,2)/60,'ko','markerfacecolor','k')
plot(NbSpiW(:,5)/60,'ro-')
subplot(3,4,7), plot(NbSpiW(:,3),'ko-')
hold on, plot(1,NbSpiW(1,3),'ko','markerfacecolor','r')
hold on, plot(2,NbSpiW(2,3),'ko','markerfacecolor','k')
plot(NbSpiW(:,6),'ro-')
ylim([0 0.12])
subplot(3,4,8), plot(NbSpiW(:,3)./NbSpiW(:,6)*100,'bo-')

subplot(3,4,9), 
hold on, plot(NbSpiR(:,1),'ko-'),title('REM')
hold on, plot(1,NbSpiR(1,1),'ko','markerfacecolor','r')
hold on, plot(2,NbSpiR(2,1),'ko','markerfacecolor','k')
plot(NbSpiR(:,4),'ro-')
subplot(3,4,10), plot(NbSpiR(:,2)/60,'ko-')
hold on, plot(1,NbSpiR(1,2)/60,'ko','markerfacecolor','r')
hold on, plot(2,NbSpiR(2,2)/60,'ko','markerfacecolor','k')
plot(NbSpiR(:,5)/60,'ro-')
subplot(3,4,11), plot(NbSpiR(:,3),'ko-')
hold on, plot(1,NbSpiR(1,3),'ko','markerfacecolor','r')
hold on, plot(2,NbSpiR(2,3),'ko','markerfacecolor','k')
plot(NbSpiR(:,6),'ro-')
ylim([0 0.12])
subplot(3,4,12), hold on
plot(NbSpiR(:,3)./NbSpiR(:,6)*100,'bo-')











end


