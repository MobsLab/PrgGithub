clear all,
EMGmice;

for mm=1:m
    cd(filename{mm,1})
load('StateEpochSB.mat','smooth_ghi','Wake','sleepper')
Wake=mergeCloseIntervals(Wake,5*1e4);
WKEpochs=[Start(Wake,'s'),Stop(Wake,'s')];
DurWKEpochs=WKEpochs(:,2)-WKEpochs(:,1);
WKEpochs=WKEpochs(DurWKEpochs>15,:);
clear XCFG LagsG
NewWake=intervalSet(WKEpochs(:,1)*1e4,WKEpochs(:,2)*1e4);
num=1;
for kk=1:length((WKEpochs))
    try
    kk/length((WKEpochs))
    dat=Data(Restrict(smooth_ghi,subset(NewWake,kk)));
    tps=Range(Restrict(smooth_ghi,subset(NewWake,kk)),'s');
    tps=tps(1:10:end);
    if kk==1
        nLags= ceil(10/median(diff(tps)));
    end
    dat=dat(1:10:end);
    %200*median(diff(tps)))
    [XCFG(num,:), LagsG(num,:), Bounds] = autocorr(dat,nLags);
    num=num+1;
    end
end
HalfTimeG(mm)=LagsG(1,find(mean(XCFG)<0.5,1,'first'))*median(diff(tps));

load('StateEpochEMGSB.mat','EMGData','Wake','sleepper')
Wake=mergeCloseIntervals(Wake,5*1e4);
WKEpochs=[Start(Wake,'s'),Stop(Wake,'s')];
DurWKEpochs=WKEpochs(:,2)-WKEpochs(:,1);
WKEpochs=WKEpochs(DurWKEpochs>15,:)
NewWake=intervalSet(WKEpochs(:,1)*1e4,WKEpochs(:,2)*1e4);
clear XCFE LagsE
num=1;
for kk=1:length((WKEpochs))
    try
    kk/length((WKEpochs))
    dat=Data(Restrict(EMGData,subset(NewWake,kk)));
    tps=Range(Restrict(EMGData,subset(NewWake,kk)),'s');
    tps=tps(1:10:end);
    dat=dat(1:10:end);
    if kk==1
        nLags= ceil(10/median(diff(tps)));
    end
    %200*median(diff(tps))
    [XCFE(num,:), LagsE(num,:), Bounds] = autocorr(dat,nLags);
    num=num+1;
    end

end
HalfTimeE(mm)=LagsE(1,find(mean(XCFE)<0.5,1,'first'))*median(diff(tps));
num=1;
for kk=1:length((WKEpochs))
    try
    kk/length((WKEpochs))
    dat=Data(Restrict(EMGData,subset(NewWake,kk)));
    dat2=Data(Restrict(smooth_ghi,subset(NewWake,kk)));
    tps=Range(Restrict(EMGData,subset(NewWake,kk)),'s');
    tps=tps(1:10:end);
    dat=dat(1:10:end);
    dat2=dat2(1:10:end);
    if kk==1
        nLags= ceil(8/median(diff(tps)));
    end
    %200*median(diff(tps))
    [XCFEG(num,:), LagsEG(num,:), Bounds] = crosscorr(dat,dat2,nLags);
    num=num+1;
    end
end

figure(1);
subplot(121)
plot(LagsE(1,:),mean(XCFE),'b'),hold on
plot(LagsG(1,:),mean(XCFG),'r'),hold on
g=shadedErrorBar(LagsE(1,:),mean(XCFE),[stdError(XCFE);stdError(XCFE)],'b');
hold on
g=shadedErrorBar(LagsG(1,:),mean(XCFG),[stdError(XCFG);stdError(XCFG)],'r');
legend('EMG','Gamma')
xlabel('s')
subplot(122)
g=shadedErrorBar(LagsEG(1,:),mean(XCFEG),[stdError(XCFEG);stdError(XCFEG)],'r');
hold on
line([0 0],ylim,'color','k')
title('crosscorr EMG and Gamma')
xlabel('EMG time (s)')
saveFigure(1,'CrossCorrEMGGamma',cd)
saveas(1,'CrossCorrEMGGamma.fig')
close all

AllCrossCorr{mm,1}=LagsE;
AllCrossCorr{mm,2}=LagsG;
AllCrossCorr{mm,3}=LagsEG;
AllCrossCorr{mm,4}=XCFE;
AllCrossCorr{mm,5}=XCFG;
AllCrossCorr{mm,6}=XCFEG;

end


figure
tempE=[]; tempG=[];
for mm=1:m
   plot(AllCrossCorr{mm,1}(1,:)*median(diff(tps)),mean(AllCrossCorr{mm,4}),'k'), hold on
   plot(AllCrossCorr{mm,2}(1,:)*median(diff(tps)),mean(AllCrossCorr{mm,5}),'r'), hold on
   tempE=[tempE;mean(AllCrossCorr{mm,4}(:,1:1251))];
   tempG=[tempG;mean(AllCrossCorr{mm,5}(:,1:1251))];
   if isempty(find(mean(AllCrossCorr{mm,5})<0.2))
        CharTimeG(mm)=10;
   else
 CharTimeG(mm)=AllCrossCorr{mm,2}(1,find(mean(AllCrossCorr{mm,5})<0.2,1,'first'))*median(diff(tps));
   end
 CharTimeE(mm)=AllCrossCorr{mm,1}(1,find(mean(AllCrossCorr{mm,4})<0.2,1,'first'))*median(diff(tps));

end

   plot(AllCrossCorr{mm,1}(1,1:1251)*median(diff(tps)),mean(tempE),'k','linewidth',3), hold on
   plot(AllCrossCorr{mm,2}(1,1:1251)*median(diff(tps)),mean(tempG),'r','linewidth',3), hold on





