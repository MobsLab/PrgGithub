clear all
mouse = 668;
if mouse == 669
% M669
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_SleepPre/StateEpochSB.mat')
AllDatSleepWake = [Data(smooth_ghi)];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_SleepPost/StateEpochSB.mat')
AllDatSleepWake = [AllDatSleepWake;Data(smooth_ghi)];


Vals = {'08','10','12','15','18'};
UniqueVoltage = [0,2,4,6,8];
cols2 = jet(length(Vals));
cols = summer(length(UniqueVoltage));
BaselineEpoch = intervalSet(0,10*60*1e4);
for v = 1:length(Vals)
    clear MovAcctsd smooth_ghi

    if v==2
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_10/Baseline/'])
    elseif v==5
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_18/Baseline/'])
    else
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_',Vals{v}])

    end

    load('StateEpochSB.mat')
    AllDatBaselines{v} =Data(Restrict(smooth_ghi,BaselineEpoch));
end


cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_WakeUp
load('HeartBeatInfo.mat')
load('StateEpochSB.mat')
load('behavResources.mat')
WakeUp = Data(smooth_ghi);
StartTimes = Start(StimEpoch,'s');
[M,T]=PlotRipRaw(MovAcctsd,StartTimes,1*1000,0,0);
PeakWakeUp= (nanmean(T(:,51:70)'));

elseif mouse == 668
%% 668
Vals = {'08','10','12','15','18'};
UniqueVoltage = [0,2,4,6,8];
cols2 = jet(length(Vals));
cols = summer(length(UniqueVoltage));
BaselineEpoch = intervalSet(0,10*60*1e4);
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_SleepPost/StateEpochSB.mat')
AllDatSleepWake = [Data(smooth_ghi)];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_SleepPre/StateEpochSB.mat')
AllDatSleepWake = [AllDatSleepWake;Data(smooth_ghi)];

for v = 1:length(Vals)
    clear MovAcctsd smooth_ghi
    cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_',Vals{v}])
    load('StateEpochSB.mat')
    load('HeartBeatInfo.mat')
    AllDatBaselines{v} =Data(Restrict(smooth_ghi,BaselineEpoch));
    AllHRBaselines{v} =Data(Restrict(EKG.HBRate,BaselineEpoch));

end

cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_WakeUP
load('StateEpochSB.mat')
load('HeartBeatInfo.mat')
load('behavResources.mat')
WakeUp = Data(smooth_ghi);
StartTimes = Start(StimEpoch,'s');
[M,T]=PlotRipRaw(MovAcctsd,StartTimes,1*1000,0,0);
PeakWakeUp= (nanmean(T(:,51:70)'));

end
%% Figures
% Histograms
figure
[Y,X] = hist(log(AllDatSleepWake),50);
Y = Y/sum(Y);
x = [X;X];
y = [Y;Y];
area(X([2:end end]),Y(1:end),'FaceColor',[0.6 0.6 0.6]), hold on
stairs(X,Y,'k','linewidth',3)

[Y,X] = hist(log(WakeUp),50);
Y = Y/sum(Y);
stairs(X,Y,'color','b','linewidth',3)

cols2 = jet(length(Vals));
for v = 1:length(Vals)
    [Y,X] = hist(log(AllDatBaselines{v}),50);
    Y = Y/sum(Y);
    stairs(X,Y,'color',cols2(v,:),'linewidth',2)
end
box off
ylabel('counts norm')
xlabel('gamma power log')

% gamma values in time
figure
subplot(211)
plot(Range((smooth_ghi),'s'),Data((smooth_ghi)),'color','k'), hold on
line(xlim,[1 1]*gamma_thresh)
tps = Range((smooth_ghi),'s');
tpswake = tps(find(Data((smooth_ghi))>gamma_thresh,1,'first'));
xlabel('time (s)')
ylabel('gamma power')

subplot(212)
St=StartTimes(2:2:end);
Pk = PeakWakeUp(2:2:end);
plot(St(St<tpswake),Pk(St<tpswake),'b','linewidth',3)
hold on
plot(St(St>tpswake),Pk(St>tpswake),'r','linewidth',3)

St=StartTimes(1:2:end);
Pk = PeakWakeUp(1:2:end);
plot(St(St<tpswake),Pk(St<tpswake),'b','linewidth',3)
hold on
plot(St(St>tpswake),Pk(St>tpswake),'r','linewidth',3)
xlabel('time (s)')
ylabel('Acc response')

figure
St=StartTimes(1:2:end);
StimEpochBef = intervalSet(St*1e4-5*1e4,St*1e4-4*1e4);
clear GammValBef
for k = 1:length(St)
    GammValBef(k)=mean(Data(Restrict(smooth_ghi,subset(StimEpochBef,k))));
    EKGValBef(k)=median(Data(Restrict(EKG.HBRate,subset(StimEpochBef,k))));
end

subplot(221)
Pk = PeakWakeUp(1:2:end);
plot(GammValBef(St<tpswake),Pk(St<tpswake),'b*')
hold on
plot(GammValBef(St>tpswake),Pk(St>tpswake),'r*')
xlabel('Gamm Power before')
ylabel('Acc response')
[R,P] = corrcoef(GammValBef,Pk);
title(['2V R=',num2str(R(1,2))])

subplot(223)
Pk = PeakWakeUp(1:2:end);
plot(EKGValBef(St<tpswake),Pk(St<tpswake),'b*')
hold on
plot(EKGValBef(St>tpswake),Pk(St>tpswake),'r*')
xlabel('HR before')
ylabel('Acc response')
Pk(isnan(EKGValBef))=[];
EKGValBef(isnan(EKGValBef))=[];
[R,P] = corrcoef(EKGValBef,Pk);
title(['2V R=',num2str(R(1,2))])


St=StartTimes(2:2:end);
StimEpochBef = intervalSet(St*1e4-5*1e4,St*1e4-4*1e4);
clear GammValBef EKGValBef
for k = 1:length(St)
    GammValBef(k)=mean((Data(Restrict(smooth_ghi,subset(StimEpochBef,k)))));
    EKGValBef(k)=median(Data(Restrict(EKG.HBRate,subset(StimEpochBef,k))));
    
end

subplot(222)
Pk = PeakWakeUp(2:2:end);
plot(GammValBef(St<tpswake),Pk(St<tpswake),'b*')
hold on
plot(GammValBef(St>tpswake),Pk(St>tpswake),'r*')
xlabel('Gamm Power before')
ylabel('Acc response')
Pk(isnan(GammValBef))=[];
GammValBef(isnan(GammValBef))=[];
[R,P] = corrcoef(GammValBef,Pk);
title(['4V R=',num2str(R(1,2))])

subplot(224)
Pk = PeakWakeUp(2:2:end);
plot(EKGValBef(St<tpswake),Pk(St<tpswake),'b*')
hold on
plot(EKGValBef(St>tpswake),Pk(St>tpswake),'r*')
xlabel('HR before')
ylabel('Acc response')
Pk(isnan(EKGValBef))=[];
EKGValBef(isnan(EKGValBef))=[];
[R,P] = corrcoef(EKGValBef,Pk);
title(['4V R=',num2str(R(1,2))])
