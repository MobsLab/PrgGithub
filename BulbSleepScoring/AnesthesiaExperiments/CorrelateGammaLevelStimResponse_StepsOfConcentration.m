clear all, close all
%% Figure for 668
colormap jet
UniqueVoltage = [0,2,4,6,8];
%
Vals = {'08','10','12','15','18'};
cols2 = jet(length(Vals));
cols = summer(length(UniqueVoltage));
BaselineEpoch = intervalSet(0,10*60*1e4);
for v = 1:length(Vals)
    clear MovAcctsd smooth_ghi
    cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_',Vals{v}])
    load('behavResources.mat')
    UniqueVoltage = unique(StimVolt);
    StartTimes = Start(StimEpoch,'s');
    %     figure(1)
    %     subplot(1,5,v)
    for k = 1:length(UniqueVoltage)
        [M{k},T]=PlotRipRaw(MovAcctsd,StartTimes(find(StimVolt==UniqueVoltage(k))),1*1000,0,0);
        %         plot(M{k}(:,1),M{k}(:,2),'linewidth',2,'color',cols(k,:)), hold on
        Peak(v,k) = max(M{k}(:,2));
        PeakStd(v,k) = stdError(max(T'));
        MeanVal(v,k) = nanmean(M{k}(51:70,2));
        MeanValStd(v,k) = stdError(nanmean(T(:,51:70)));
        
    end
    %     box off
    %     ylim([0 4*1e8])
    %     line([0 0],ylim,'color','k')
    
    load('StateEpochSB.mat')
    %     figure(2)
    %     plot(Range(Restrict(smooth_ghi,BaselineEpoch),'s'),Data(Restrict(smooth_ghi,BaselineEpoch)),'color',cols2(v,:)), hold on
    MeanGamma(v) = nanmean(Data(Restrict(smooth_ghi,BaselineEpoch)));
    StdGamma(v) = std(Data(Restrict(smooth_ghi,BaselineEpoch)));
    
end

figure
subplot(221)
for v = 1:length(Vals)
    errorbar(UniqueVoltage,MeanVal(v,:),MeanValStd(v,:),'linewidth',2,'color',cols2(v,:)), hold on
end
xlabel('Stim voltage')
legend(Vals)
ylabel('Mean Resp')
box off
subplot(223)
v=3;
errorbar([0.8,1,1.2,1.5,1.8],MeanVal(v,:),MeanValStd(v,:),'linewidth',2,'color','k'), hold on
scatter([0.8,1,1.2,1.5,1.8],MeanVal(v,:),80,cols2,'filled')
xlabel('Isoflurane level')
ylabel('Mean Resp')
box off
subplot(222)
errorbar([0.8,1,1.2,1.5,1.8],MeanGamma,StdGamma,'linewidth',2,'color','k'), hold on
scatter([0.8,1,1.2,1.5,1.8],MeanGamma,80,cols2,'filled')
xlabel('Isoflurane level')
ylabel('gamma power')
box off
subplot(224)
v=3;
plot(MeanVal(v,:),MeanGamma,'linewidth',3,'color','k'), hold on
scatter(MeanVal(v,:),MeanGamma,80,cols2,'filled')
xlabel('Mean Resp (4V)')
ylabel('Gamma Power')
box off

%% Figure for 669
%
Vals = {'08','10','12','15','18'};
cols2 = jet(length(Vals));
cols = summer(length(UniqueVoltage));
BaselineEpoch = intervalSet(0,10*60*1e4);
for v = 1:length(Vals)
    clear MovAcctsd smooth_ghi
    if v==2
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_10/Stim/'])
    elseif v==5
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_18/Stim/'])
        
    else
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_',Vals{v}])
    end
    load('behavResources.mat')
    UniqueVoltage = unique(StimVolt);
    StartTimes = Start(StimEpoch,'s');
    %     figure(10)
    %     subplot(1,5,v)
    for k = 1:length(UniqueVoltage)
        [M{k},T]=PlotRipRaw(MovAcctsd,StartTimes(find(StimVolt==UniqueVoltage(k))),1*1000,0,0);
        %         plot(M{k}(:,1),M{k}(:,2),'linewidth',2,'color',cols(k,:)), hold on
        Peak(v,k) = max(M{k}(:,2));
        PeakStd(v,k) = stdError(max(T'));
        MeanVal(v,k) = nanmean(M{k}(51:70,2));
        MeanValStd(v,k) = stdError(nanmean(T(:,51:70)));
        
    end
    %     box off
    %     ylim([0 4*1e8])
    %     line([0 0],ylim,'color','k')
    if v==2
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_10/Baseline/'])
    elseif v==5
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_18/Baseline/'])
    end
    
    load('StateEpochSB.mat')
    %     figure(20)
    %     plot(Range(Restrict(smooth_ghi,BaselineEpoch),'s'),Data(Restrict(smooth_ghi,BaselineEpoch)),'color',cols2(v,:)), hold on
    MeanGamma(v) = nanmean(Data(Restrict(smooth_ghi,BaselineEpoch)));
    StdGamma(v) = std(Data(Restrict(smooth_ghi,BaselineEpoch)));
    
end

figure
subplot(221)
for v = 1:length(Vals)
    errorbar(UniqueVoltage,MeanVal(v,:),MeanValStd(v,:),'linewidth',2,'color',cols2(v,:)), hold on
end
xlabel('Stim voltage')
legend(Vals)
ylabel('Mean Resp')
box off
subplot(223)
v=2;
errorbar([0.8,1,1.2,1.5,1.8],MeanVal(v,:),MeanValStd(v,:),'linewidth',2,'color','k'), hold on
scatter([0.8,1,1.2,1.5,1.8],MeanVal(v,:),80,cols2,'filled')
xlabel('Isoflurane level')
ylabel('Mean Resp')
box off
subplot(222)
errorbar([0.8,1,1.2,1.5,1.8],MeanGamma,StdGamma,'linewidth',2,'color','k'), hold on
scatter([0.8,1,1.2,1.5,1.8],MeanGamma,80,cols2,'filled')
xlabel('Isoflurane level')
ylabel('gamma power')
box off
subplot(224)
v=3;
plot(MeanVal(v,:),MeanGamma,'linewidth',3,'color','k'), hold on
scatter(MeanVal(v,:),MeanGamma,80,cols2,'filled')
xlabel('Mean Resp (4V)')
ylabel('Gamma Power')
box off