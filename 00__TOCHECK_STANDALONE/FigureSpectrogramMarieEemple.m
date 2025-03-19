

%FigureSpectrogramMarieEemple


% cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243/
cd %/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130513/BULB-Mouse-65-13052013


cd /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130515/BULB-Mouse-65-15052013
a= 7650;

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251

res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    SpBulb=Sp;
    fBulb=f;
    tBulb=t;
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
    chHPC=tempchHPC.channel;
    chHPC=2;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
    SpHpc=Sp;
    fHpc=f;
    tHpc=t;
    tempchPFC=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
    chPFC=tempchPFC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chPFC),'.mat'');'])
    SpPfc=Sp;
    fPfc=f;
    tPfc=t;

load('B_High_Spectrum.mat')
SBu=SmoothDec(Spectro{1}',[0.1,35]);

[WAKE,REM,N1,N2,N3]=RunSubstages;
SWS=or(N1,or(N2,N3));figure('color',[1 1 1]), numfig=gcf;
subplot(5,1,1), plot(Range(SleepStages,'s'),Data(SleepStages),'k'), 
hold on, plot(rg1,2*ones(length(rg1),1),'.','color',colori(3,:))
hold on, plot(rg2,1.5*ones(length(rg2),1),'.','color',colori(4,:))
hold on, plot(rg3,1*ones(length(rg3),1),'.','color',colori(5,:))
hold on, plot(rgR,3*ones(length(rgR),1),'.','color',colori(2,:))
hold on, plot(rgW,4*ones(length(rgW),1),'.','color',colori(1,:))
set(gca,'ytick',[1:0.5:4])
set(gca,'yticklabel',{'N3','N2','N1',' ','REM',' ','Wake'})
xlim([a a+2200]), ylim([0 5])
subplot(5,1,3), imagesc(tPfc,fPfc,10*log10(SpPfc')), axis xy, caxis([20 48]),xlim([a a+2200])
subplot(5,1,2), imagesc(tHpc,fHpc,10*log10(SpHpc')), axis xy,caxis([20 50]),xlim([a a+2200])
subplot(5,1,4), imagesc(tBulb,fBulb,10*log10(SpBulb')), axis xy, caxis([17 58]),xlim([a a+2200])
subplot(5,1,5), imagesc(Spectro{2},Spectro{3},10*log10(SBu)), axis xy, caxis([20 37]),xlim([a a+2200])
colormap(jet)  


a=7600;
[SleepStages,Epochs,NamesStages]=PlotPolysomnoML(N1,N2,N3,SWS,REM,WAKE,1);close
%SleepStages2=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);
figure('color',[1 1 1]),
hold on, plot(Range(SleepStages,'s'),Data(SleepStages),'k')
xlim([a a+2200])

rg1=Range(Restrict(SleepStages,N1),'s');
rg2=Range(Restrict(SleepStages,N2),'s');
rg3=Range(Restrict(SleepStages,N3),'s');
rgR=Range(Restrict(SleepStages,REM),'s');
rgW=Range(Restrict(SleepStages,WAKE),'s');
colori=[0.5 0.2 0.1; 0.1 0.7 0 ; 0.5 0.3 1; 1 0.5 1 ;0.8 0 0.7 ];


a=7600;
figure('color',[1 1 1]), numfig=gcf;
subplot(5,1,1), plot(Range(SleepStages,'s'),Data(SleepStages),'k'), 
hold on, plot(rg1,2*ones(length(rg1),1),'.','color',colori(3,:))
hold on, plot(rg2,1.5*ones(length(rg2),1),'.','color',colori(4,:))
hold on, plot(rg3,1*ones(length(rg3),1),'.','color',colori(5,:))
hold on, plot(rgR,3*ones(length(rgR),1),'.','color',colori(2,:))
hold on, plot(rgW,4*ones(length(rgW),1),'.','color',colori(1,:))
set(gca,'ytick',[1:0.5:4])
set(gca,'yticklabel',{'N3','N2','N1',' ','REM',' ','Wake'})
xlim([a a+2200]), ylim([0 5])
subplot(5,1,3), imagesc(tPfc,fPfc,10*log10(SpPfc')), axis xy, caxis([20 48]),xlim([a a+2200])
subplot(5,1,2), imagesc(tHpc,fHpc,10*log10(SpHpc')), axis xy,caxis([20 50]),xlim([a a+2200])
subplot(5,1,4), imagesc(tBulb,fBulb,10*log10(SpBulb')), axis xy, caxis([17 58]),xlim([a a+2200])
subplot(5,1,5), imagesc(Spectro{2},Spectro{3},10*log10(SBu)), axis xy, caxis([20 37]),xlim([a a+2200])
colormap(jet)    

a=16970;

figure('color',[1 1 1]), numfig=gcf;
subplot(5,1,1), plot(Range(SleepStages,'s'),Data(SleepStages),'k'), 
hold on, plot(rg1,2*ones(length(rg1),1),'.','color',colori(3,:))
hold on, plot(rg2,1.5*ones(length(rg2),1),'.','color',colori(4,:))
hold on, plot(rg3,1*ones(length(rg3),1),'.','color',colori(5,:))
hold on, plot(rgR,3*ones(length(rgR),1),'.','color',colori(2,:))
hold on, plot(rgW,4*ones(length(rgW),1),'.','color',colori(1,:))
set(gca,'ytick',[1:0.5:4])
set(gca,'yticklabel',{'N3','N2','N1',' ','REM',' ','Wake'})
xlim([a a+1800]), ylim([0 5])
subplot(5,1,3), imagesc(tPfc,fPfc,10*log10(SpPfc')), axis xy, caxis([20 48]),xlim([a a+1800])
subplot(5,1,2), imagesc(tHpc,fHpc,10*log10(SpHpc')), axis xy,caxis([20 50]),xlim([a a+1800])
subplot(5,1,4), imagesc(tBulb,fBulb,10*log10(SpBulb')), axis xy, caxis([17 58]),xlim([a a+1800])
subplot(5,1,5), imagesc(Spectro{2},Spectro{3},10*log10(SBu)), axis xy, caxis([20 37]),xlim([a a+1800])
colormap(jet) 


figure('color',[1 1 1]), numfig=gcf;
subplot(4,1,2), imagesc(tPfc,fPfc,10*log10(SpPfc')), axis xy, caxis([20 48]),xlim([a a+1800])
subplot(4,1,1), imagesc(tHpc,fHpc,10*log10(SpHpc')), axis xy,caxis([20 50]),xlim([a a+1800])
subplot(4,1,3), imagesc(tBulb,fBulb,10*log10(SpBulb')), axis xy, caxis([17 58]),xlim([a a+1800])
subplot(4,1,4), imagesc(Spectro{2},Spectro{3},10*log10(SBu)), axis xy, caxis([20 37]),xlim([a a+1800])
colormap(jet) 




























