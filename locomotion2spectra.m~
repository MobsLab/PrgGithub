clear all
%% Look at breathing and Hpc depending on locomotor activity
pasTheta=100; 
params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0.5 20];
movingwin=[3 0.2];
params.tapers=[3 5];

load('BehavRessources.mat') %imdiff and position
load('Analysis.mat') %channel names
vitesse(3,:)=position(3,:);
vitesse(1,2:end)=(position(1,2:end)-position(1,1:end-1))./(position(3,2:end)-position(3,1:end-1));
vitesse(2,2:end)=(position(2,2:end)-position(2,1:end-1))./(position(3,2:end)-position(3,1:end-1));
vitesse(5,4:end)=(position(1,4:end)-position(1,1:end-3))./(position(3,4:end)-position(3,1:end-3));
vitesse(6,4:end)=(position(2,4:end)-position(2,1:end-3))./(position(3,4:end)-position(3,1:end-3));
vitesse(7,4:end)=sqrt(vitesse(5,4:end).^2+vitesse(6,4:end).^2);
vitesse(8,8:end)=(position(1,8:end)-position(1,1:end-7))./(position(3,8:end)-position(3,1:end-7));
vitesse(9,8:end)=(position(2,8:end)-position(2,1:end-7))./(position(3,8:end)-position(3,1:end-7));
vitesse(10,8:end)=sqrt(vitesse(9,8:end).^2+vitesse(8,8:end).^2);

figure
subplot(211)
plot(vitesse(3,:),smooth(vitesse(10,:),2))
hold on
line([0 vitesse(3,end)],[10 10],'color','r')
subplot(212)
plot(imdiff(2,:),imdiff(1,:))
hold on
line([0 vitesse(3,end)],[100 100],'color','r')

pause
clf

load(strcat('LFPData/LFP',num2str(chB),'.mat'));
[SpB,tB,fB]=mtspecgramc(Data(LFP),movingwin,params);
sptsdB=tsd(tB*1e4,SpB);


load(strcat('LFPData/LFP',num2str(chH),'.mat'));
[SpH,tH,fH]=mtspecgramc(Data(LFP),movingwin,params);
sptsdH=tsd(tH*1e4,SpH);

r=Range(LFP,'s');
for k=1:length(position)
    position(3,k)=r(end)/length(position)*(k-1);
end
vitesse(3,:)=position(3,:);
imdiff(2,:)=position(3,:);
TotEpoch=intervalSet(0,r(end)*1e4)

    save('BehavRessources.mat','imdiff','position','vitesse','TotEpoch');

Sp_tsd=tsd(vitesse(3,:)*1e4,smooth(vitesse(10,:),2));
Imd_tsd=tsd(imdiff(2,:)'*1e4,imdiff(1,:)');
MovEp=thresholdIntervals(Imd_tsd,100);
MovEp=dropShortIntervals(MovEp,0.3e4);
MovEp=mergeCloseIntervals(MovEp,2.5e4);
LocEp=thresholdIntervals(Sp_tsd,10);
LocEp=dropShortIntervals(LocEp,0.3e4);
LocEp=mergeCloseIntervals(LocEp,2.5e4);

CalmEp=MovEp-LocEp;
CalmEp=mergeCloseIntervals(CalmEp,0.5e4);
CalmEp=dropShortIntervals(CalmEp,0.5e4);
StillEp=TotEpoch-MovEp;
StillEp=mergeCloseIntervals(StillEp,0.5e4);
StillEp=mergeCloseIntervals(StillEp,1e4);
    
Rip=FindRipplesKarim(LFP,TotEpoch);
Rip_tsd=ts(Rip(:,2)*1E4);


params.Fs=1/median(diff(Range(LFP,'s')));
params.err=[1 0.0500];
params.pad=2;
params.trialave=0;
params.fpass=[20 100];
params.tapers=[1 2];
movingwin=[0.1 0.005];
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
[SpBH,tBH,fBH]=mtspecgramc(Data((Restrict(LFP,TotEpoch))),movingwin,params);
save('Analysis.mat','SpBH','tBH','fBH','-append')

sptsdG=tsd(tBH*10000,SpBH);
startg=find(fBH<50,1,'last');
stopg=find(fBH>70,1,'first');
startg2=find(fBH<25,1,'last');
stopg2=find(fBH>45,1,'first');
spdat=Data(sptsdG);

tot_ghi=tsd(Range(Restrict(sptsdG,TotEpoch)),sum(spdat(:,startg:stopg)')');
tot_ghi2=tsd(Range(Restrict(sptsdG,TotEpoch)),sum(spdat(:,startg2:stopg2)')');

tot_ghi=Restrict(tot_ghi,TotEpoch);
smooth_ghi=tsd(Range(tot_ghi),smooth(Data(tot_ghi),500));
tot_ghi2=Restrict(tot_ghi2,TotEpoch);
smooth_ghi2=tsd(Range(tot_ghi2),smooth(Data(tot_ghi2),500));


scrsz = get(0,'ScreenSize');
h=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)*0.8]),Gf=gcf;
subplot(3,5,1:4)
imagesc(tH,fH,10*log10(SpH)')
axis xy
caxis([25 50]);
colormap jet
hold on
plot(Range(Sp_tsd,'s'),Data(Sp_tsd)/10,'w','linewidth',2)
plot(Range(Imd_tsd,'s'),Data(Imd_tsd)/500,'k','linewidth',2)
plot(Range(Restrict(Imd_tsd,TotEpoch),'s'),18*ones(1,length(Range(Restrict(Imd_tsd,TotEpoch)))),'.w','MarkerSize',20)
plot(Range(Restrict(Imd_tsd,LocEp),'s'),18*ones(1,length(Range(Restrict(Imd_tsd,LocEp)))),'.r')
plot(Range(Restrict(Imd_tsd,CalmEp),'s'),18*ones(1,length(Range(Restrict(Imd_tsd,CalmEp)))),'.b')
plot(Range(Restrict(Imd_tsd,StillEp),'s'),18*ones(1,length(Range(Restrict(Imd_tsd,StillEp)))),'.c')
scatter(Rip(:,2),14*ones(1,size(Rip,1)),80,'k','filled')
scatter(Rip(:,2),14*ones(1,size(Rip,1)),20,'w','filled')
title('Hpc')
subplot(3,5,6:9)
imagesc(tB,fB,10*log10(SpB)')
axis xy
caxis([25 65]);
colormap jet
hold on
plot(Range(Sp_tsd,'s'),Data(Sp_tsd)/10,'w','linewidth',2)
plot(Range(Imd_tsd,'s'),Data(Imd_tsd)/500,'k','linewidth',2)
plot(Range(Imd_tsd,'s'),Data(Imd_tsd)/500,'k','linewidth',2)
plot(Range(Restrict(Imd_tsd,TotEpoch),'s'),18*ones(1,length(Range(Restrict(Imd_tsd,TotEpoch)))),'.w','MarkerSize',20)
plot(Range(Restrict(Imd_tsd,LocEp),'s'),18*ones(1,length(Range(Restrict(Imd_tsd,LocEp)))),'.r')
plot(Range(Restrict(Imd_tsd,CalmEp),'s'),18*ones(1,length(Range(Restrict(Imd_tsd,CalmEp)))),'.b')
plot(Range(Restrict(Imd_tsd,StillEp),'s'),18*ones(1,length(Range(Restrict(Imd_tsd,StillEp)))),'.c')
title('OB')
subplot(2,5,5)
plot(fH,log10(mean(Data(Restrict(sptsdH,LocEp)))),'r','linewidth',4)
hold on
plot(fH,log10(mean(Data(Restrict(sptsdH,CalmEp)))),'b','linewidth',4)
plot(fH,log10(mean(Data(Restrict(sptsdH,StillEp)))),'c','linewidth',4)
legend('locomoting','non locomoting','still')
title('Hpc')
subplot(2,5,10)
plot(fB,log10(mean(Data(Restrict(sptsdB,LocEp)))),'r','linewidth',4)
hold on
plot(fB,log10(mean(Data(Restrict(sptsdB,CalmEp)))),'b','linewidth',4)
plot(fB,log10(mean(Data(Restrict(sptsdB,StillEp)))),'c','linewidth',4)
legend('locomoting','non locomoting','still')
title('OB')
subplot(3,5,11:14)
plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'k','linewidth',2); 
line([0 r(end)],[8.59e4 8.59e4],'color','r')

save('Analysis.mat','sptsdH','sptsdB','fH','fB','StillEp','CalmEp','LocEp','Rip','-append')
saveas(h,'mvmtspectra.fig')
saveFigure(h,'mvmtspectra')
close all



%%%%%%%%%%%
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Explo_Pre_2/Mouse_117_LRExploPre2_26022014
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Explo_Pre_3/Mouse_117_LRExploPre3_26022014
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Explo_Pre_4/Mouse_117_LRExploPre4_26022014
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Free_Explo/Mouse_117_LRFreeExplo_26022014
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Session_1/Mouse_117_LRSession1_26022014
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Session_2/Mouse_117_LRSession2_26022014
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Session_3/Mouse_117_LRSession3_26022014
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Session_4/Mouse_117_LRSession4_26022014
/media/DataMOBs14/ProjetAversion/Mouse117/26022014/Aversion-Mouse-117-26022014-01-dPAGLR_bis/Session_6/Mouse_117_LRSession6_26022014/