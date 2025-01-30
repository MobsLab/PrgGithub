cd /media/DataMOBsRAIDN/ProjetAstro/Mouse051/20121227/BULB-Mouse-51-27122012/

ChToDo=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
load('StateEpochSB.mat','NoiseEpoch','GndNoiseEpoch')
load(['LFPData/LFP',num2str(ChToDo(1))])
TotEpoch=intervalSet(0,max(Range(LFP)));
TotEpoch=TotEpoch-GndNoiseEpoch-NoiseEpoch;
smootime=3;

% figure
% for cc=8:length(ChToDo)
%     load(['LFPData/LFP',num2str(ChToDo(cc))])
%     FilGamma=FilterLFP(LFP,[50 70],1024);
%     HilGamma=hilbert(Data(FilGamma));
%     H=abs(HilGamma);
%     tot_ghi=Restrict(tsd(Range(LFP),H),TotEpoch);
%     smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
%     clear FilGamma HilGamma
%     sm_ghi=Data(Restrict(smooth_ghi,TotEpoch));
%     save(['Gamma_ch_',num2str(ChToDo(cc)),'.mat'],'smooth_ghi','-v7.3')
%     clear smooth_ghi
%     subplot(5,3,cc)
%     hist(log(sm_ghi),500)
%     clear sm_ghi
% end


ChToDoOrder=[10,13,5,2,6,1,7,0,4,3,8,15,9,14,11,12];
figure
for cc=1:length(ChToDoOrder)
cc
load(['Gamma_ch_',num2str(ChToDoOrder(cc)),'.mat'])
    sm_ghi=Data(Restrict(smooth_ghi,TotEpoch));
    [Y{cc},X{cc}]=hist((sm_ghi),1000);
    [YL{cc},XL{cc}]=hist(log(sm_ghi),1000);
    
end

x=[-1:0.001:2.5];
clear Histresample
cols=jet(length(ChToDoOrder));
for cc=1:length(ChToDoOrder)
    [C,I]=max(YL{cc});
    Histresample(cc,:)=interp1(XL{cc}-XL{cc}(I),YL{cc}./sum(YL{cc}),x);
    
    st_ = [1.0e-2 XL{cc}(find(YL{cc}==max(YL{cc}))) 0.101 5e-3 XL{cc}(find(YL{cc}==max(YL{cc})))+1 0.21];
    [cf2,goodness2,output]=createFit2gaussWiOutPut(XL{cc},YL{cc}/sum(YL{cc}),st_);   

    a= coeffvalues(cf2);
    % overlap
    d=([min(XL{cc}):max(XL{cc})/1000:max(XL{cc})]);
    Y1=normpdf(d,a(2),max(a(3)/sqrt(2),mean(diff(d))));
    Y2=normpdf(d,a(5),max(a(6)/sqrt(2),mean(diff(d))));
    Overlap(cc)=sum(min(Y1,Y2)*mean(diff(d)));
    Ashman(cc)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
    PeakDist(cc)=a(5)-a(2);
    Trough(cc)=sum(abs(output.residuals(find(XL{cc}<a(2),1,'last'):find(XL{cc}>a(5),1,'first'))))./sum(abs(YL{cc}/sum(YL{cc})));

end


figure
subplot(4,1,1)
plot(Overlap)
subplot(4,1,2)
plot(Ashman)
subplot(4,1,3)
plot(PeakDist)
subplot(4,1,4)
plot(Trough)

figure
cols=gray(16);
for t=1:16
   plot(runmean(zMat(:,t),10),'color',cols(t,:),'linewidth',2) , hold on
end


%// Define the x values
x = x.';
xMat = repmat(x, 1, 16); %// For plot3
%// Define y values
y = 1:2:32;
yMat = repmat(y, numel(x), 1); %//For plot3
figure
%// Define z values
zMat=Histresample';
plot3(xMat, yMat, zMat,'linewidth',3,'color',[0.4 0.4 0.4]); %// Make all traces blue
grid;
xlabel('x'); ylabel('y'); zlabel('z');
view(40,40); %// Adjust viewing angle so you can clearly see data


figure
for t=1:5
   plot(runmean(zMat(:,t),10),'color',[0.8 0 0],'linewidth',2) , hold on
end
for t=6:12
   plot(runmean(zMat(:,t),10),'color',[0.6 0 0.5],'linewidth',2) , hold on
end
for t=13:16
   plot(runmean(zMat(:,t),10),'color',[0.4 0.1 0.2],'linewidth',2) , hold on
end



ChToDoOrder=[10,13,5,2,6,1,7,0,4,3,8,15,9,14,11,12];
mindur=3;
figure
clear Ep
for cc=1:length(ChToDoOrder)
    cc
    load(['Gamma_ch_',num2str(ChToDoOrder(cc)),'.mat'])
    sm_ghi=Data(Restrict(smooth_ghi,TotEpoch));
     gamma_thresh(cc)=GetGammaThresh(sm_ghi);
     gamma_thresh(cc)=exp(gamma_thresh(cc));
    sleepper=thresholdIntervals(smooth_ghi,gamma_thresh(cc),'Direction','Below');
    sleepper=and(TotEpoch,sleepper);
    sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
    sleepper=dropShortIntervals(sleepper,mindur*1e4);
    wakeper=TotEpoch-sleepper;
    Ep{cc,1}=sleepper;
    Ep{cc,2}=wakeper;    
end

clear MatAgree
for cc=1:length(ChToDoOrder)
    for cc2=1:length(ChToDoOrder)
        MatAgree(cc,cc2)=(length(Data(Restrict(smooth_ghi,and(Ep{cc,1},Ep{cc2,1}))))+length(Data(Restrict(smooth_ghi,and(Ep{cc,2},Ep{cc2,2})))))./...
            length(Data(Restrict(smooth_ghi,TotEpoch)));
    end
end



%% Compare with MvmtBased
load('StateEpoch.mat')
SleepMov=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
SleepMov=and(TotEpoch,SleepMov);
SleepMov=mergeCloseIntervals(SleepMov,mindur*1e4);
SleepMov=dropShortIntervals(SleepMov,mindur*1e4);
WakeMov=TotEpoch-SleepMov;

clear MatAgreeMov
for cc=1:length(ChToDoOrder)
        MatAgreeMov(cc,1)=(length(Data(Restrict(smooth_ghi,and(Ep{cc,1},SleepMov))))+length(Data(Restrict(smooth_ghi,and(Ep{cc,2},WakeMov)))))./...
            length(Data(Restrict(smooth_ghi,TotEpoch)));
    
end


% Make nice figure wi CSD
NiceInterval=intervalSet(18*1e4,21*1e4);
ChToDoOrder=[10,13,5,2,6,7,1,0,4,3,8,15,9,14,11,12];
AllChans=sort(ChToDoOrder);
clear templfp
for cc=1:length(ChToDoOrder)
    load(['LFPData/LFP',num2str(ChToDoOrder(cc))])
    ChToDoOrder(cc)
    if cc==1
   t=Range(Restrict(LFP,NiceInterval));
    end
    templfp{cc}=Restrict(LFP,ts(t));
end

clear lfp lfp2 lfp3 lfp4
for cc=1:length(ChToDoOrder)
    cc
    lfp(:,cc)=Data(templfp{(cc)});
    lfpFil=FilterLFP(templfp{(cc)},[2 8],1024);
    lfp2(:,cc)=Data(lfpFil);
    lfpFil=FilterLFP(templfp{(cc)},[50 70],1024);
    HilGamma=hilbert(Data(lfpFil));
    H=abs(HilGamma);
    tot_ghi=tsd(Range(lfpFil),H);
    smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(0.2/median(diff(Range(tot_ghi,'s'))))));
    lfp3(:,cc)=Data(smooth_ghi);
    lfp4(:,cc)=Data(lfpFil);
    
end
y = lfp - repmat(mean(lfp),length(t),1);
d = -diff(y,2,2);
y2 = lfp2 - repmat(mean(lfp2),length(t),1);
d2 = -diff(y2,2,2);
y3 = lfp3 - repmat(mean(lfp3),length(t),1);
d3 = -diff(y3,2,2);
y4 = lfp4 - repmat(mean(lfp4),length(t),1);
d4 = -diff(y4,2,2);


clf
figure
imagesc(t,[1:14],(SmoothDec(d2',[2,50]))), hold on
for cc=1:length(ChToDoOrder)
plot(t,-y2(:,cc)/20000+cc,'k'), hold on
end


clf
imagesc(t,[1:14],(SmoothDec(d4',[2,10]))), hold on
for cc=2:length(ChToDoOrder)-1
plot(t,y4(:,cc)/5000+cc-1,'k'), hold on
end


clf
tbeg=18*1e4;tend=20.9*1e4;
dtemp=d3(find(t>tbeg,1,'first'):find(t>tend,1,'first'),:);
clear dtempint
for d=1:size(dtemp,1)
    dtempint(d,:)=interp1([1:14],dtemp(d,:),[1:0.1:14]);
end
figure,imagesc(t(find(t>tbeg,1,'first'):find(t>tend,1,'first')),[1:14],(SmoothDec(dtemp',[3,30]))), hold on
for cc=2:length(ChToDoOrder)-1
plot(t(find(t>tbeg,1,'first'):find(t>tend,1,'first')),y4(find(t>tbeg,1,'first'):find(t>tend,1,'first'),cc)/std(y4(find(t>tbeg,1,'first'):find(t>tend,1,'first'),cc))/5+cc-1,'k'), hold on
end


clf
tbeg=18*1e4;tend=20.9*1e4;
dtemp=d4(find(t>tbeg,1,'first'):find(t>tend,1,'first'),:);
clear dtempint
for d=1:size(dtemp,1)
    dtempint(d,:)=interp1([1:14],dtemp(d,:),[1:0.1:14]);
end
figure,
%imagesc(t(find(t>tbeg,1,'first'):find(t>tend,1,'first')),[1:14],(SmoothDec(dtemp',[3,10]))), hold on
for cc=1:length(ChToDoOrder)
plot(t(find(t>tbeg,1,'first'):find(t>tend,1,'first')),y(find(t>tbeg,1,'first'):find(t>tend,1,'first'),cc)/20000+cc-1,'k','linewidth',2), hold on
end
caxis([-4.5 4.5])
xlim([1.8981 1.93]*1e5)
box off
set(gca,'Xtick',[],'Ytick',[])


ChToDoOrder=[10,13,5,2,6,1,7,0,4,3,8,15,9,14,11,12];
figure
for cc=1:length(ChToDoOrder)
cc
load(['Gamma_ch_',num2str(ChToDoOrder(cc)),'.mat'])
    sm_ghi=Data(Restrict(smooth_ghi,TotEpoch));
    [Y{cc},X{cc}]=hist((sm_ghi),1000);
    [YL{cc},XL{cc}]=hist(log(sm_ghi),1000);
    
end
