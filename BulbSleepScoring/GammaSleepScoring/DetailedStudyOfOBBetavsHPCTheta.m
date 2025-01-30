    clear all, close all
    AllSlScoringMice_SleepScoringArticle_SB;

    for mm=1:m
        cd(filename2{mm})
        load('StateEpochSBAllOB.mat','REMEpoch','SWSEpoch','smooth_1015','TenFif_thresh');
        REMEpoch1=REMEpoch;SWSEpoch1=SWSEpoch;
        load('StateEpochSB','REMEpoch','Sleep','SWSEpoch','smooth_Theta');
        a=size(Data(Restrict(smooth_1015,REMEpoch)),1);
        b=size(Data(Restrict(smooth_1015,and(REMEpoch1,REMEpoch))),1);
        Ratio(mm,1)=b/a;
        a=size(Data(Restrict(smooth_1015,SWSEpoch)),1);
        b=size(Data(Restrict(smooth_1015,and(SWSEpoch,SWSEpoch1))),1);
        Ratio(mm,2)=b/a;
        [Y{mm},X{mm}]=hist(log(Data(Restrict(smooth_1015,Sleep))),100);
        Thresh(mm)=TenFif_thresh;

        % Trigger on REM onset and offset
        Times=round(Start(REMEpoch)/1000)/10;
        [M,T]=PlotRipRaw(smooth_1015,Times,3000);close;
        BetaTriggeredREM_Start(mm,:)=M(:,2)';
        [M,T]=PlotRipRaw(smooth_Theta,Times,3000);close;
        ThetaTriggeredREM_Start(mm,:)=M(:,2)';

        Times=round(Stop(REMEpoch)/1000)/10;
        [M,T]=PlotRipRaw(smooth_1015,Times,3000);close;
        BetaTriggeredREM_Stop(mm,:)=M(:,2)';
        [M,T]=PlotRipRaw(smooth_Theta,Times,3000);close;
        ThetaTriggeredREM_Stop(mm,:)=M(:,2)';

        Times=round(Start(REMEpoch1)/1000)/10;
        [M,T]=PlotRipRaw(smooth_1015,Times,3000);close;
        BetaTriggeredREM_Start1(mm,:)=M(:,2)';
        [M,T]=PlotRipRaw(smooth_Theta,Times,3000);close;
        ThetaTriggeredREM_Start1(mm,:)=M(:,2)';

        Times=round(Stop(REMEpoch1)/1000)/10;
        [M,T]=PlotRipRaw(smooth_1015,Times,3000);close;
        BetaTriggeredREM_Stop1(mm,:)=M(:,2)';
        [M,T]=PlotRipRaw(smooth_Theta,Times,3000);close;
        ThetaTriggeredREM_Stop1(mm,:)=M(:,2)';

        a=size(Data(Restrict(smooth_1015,REMEpoch)),1);
        b=size(Data(Restrict(smooth_1015,and(REMEpoch1,REMEpoch))),1);
        TotalOverlap(mm) = b./a;

        for r = 1:length(Start(REMEpoch))
            LocalEpoch = subset(REMEpoch,r);
            % Find closest REM Start
            DistStart = Start(LocalEpoch) - Start(REMEpoch1);
            [val,ind] = min(abs(DistStart));
            CloseRemStart{mm}(r) = DistStart(ind)/1e4;
            a=size(Data(Restrict(smooth_1015,LocalEpoch)),1);
            b=size(Data(Restrict(smooth_1015,and(subset(REMEpoch1,ind),LocalEpoch))),1);
            REMDurOverlapStart{mm}(r) = b./a;


            % Find closest REM Stop
            DistStart = Stop(LocalEpoch) - Stop(REMEpoch1);
            [val,ind] = min(abs(DistStart));
            CloseRemStp{mm}(r) = DistStart(ind)/1e4;
            a=size(Data(Restrict(smooth_1015,LocalEpoch)),1);
            b=size(Data(Restrict(smooth_1015,and(subset(REMEpoch1,ind),LocalEpoch))),1);
            REMDurOverlapStop{mm}(r) = b./a;

            a=size(Data(Restrict(smooth_1015,LocalEpoch)),1);
            b=size(Data(Restrict(smooth_1015,and(REMEpoch1,LocalEpoch))),1);

            REMDurOverlap{mm}(r) = b./a;

            DurEp{mm}(r) = Stop(LocalEpoch,'s')-Start(LocalEpoch,'s');

        end

    end

AllCloseRemStp = [CloseRemStp{:}];
AllCloseRemStart = [CloseRemStart{:}];
AllREMDurOverlap = [REMDurOverlap{:}];
AllREMDurOverlapStart = [REMDurOverlapStart{:}];
AllREMDurOverlapStop = [REMDurOverlapStop{:}];
AllDur = [DurEp{:}];

BetaTriggeredREM_Start1 = BetaTriggeredREM_Start1(:,10:7501-10);
BetaTriggeredREM_Stop1 = BetaTriggeredREM_Stop1(:,10:7501-10);
ThetaTriggeredREM_Start1 = ThetaTriggeredREM_Start1(:,10:7501-10);
ThetaTriggeredREM_Stop1 = ThetaTriggeredREM_Stop1(:,10:7501-10);
tps = M(10:7501-10,1);

figure
subplot(211)
hold on
g=shadedErrorBar(tps,nanmean(zscore(ThetaTriggeredREM_Start')'),stdError(zscore(ThetaTriggeredREM_Start')'));
g.patch.FaceColor='r';
shadedErrorBar(tps,nanmean(zscore(BetaTriggeredREM_Start')'),stdError(zscore(BetaTriggeredREM_Start')'))
subplot(212)
g=shadedErrorBar(tps,nanmean(zscore(ThetaTriggeredREM_Stop')'),stdError(zscore(ThetaTriggeredREM_Stop')'));
g.patch.FaceColor='r';
hold on
shadedErrorBar(tps,nanmean(zscore(BetaTriggeredREM_Stop')'),stdError(zscore(BetaTriggeredREM_Stop')'))

figure
subplot(211)
hold on
g=shadedErrorBar(tps,nanmean(zscore(ThetaTriggeredREM_Start1')'),stdError(zscore(ThetaTriggeredREM_Start1')'));
g.patch.FaceColor='r';
shadedErrorBar(tps,nanmean(zscore(BetaTriggeredREM_Start1')'),stdError(zscore(BetaTriggeredREM_Start1')'))
subplot(212)
g=shadedErrorBar(tps,nanmean(zscore(ThetaTriggeredREM_Stop1')'),stdError(zscore(ThetaTriggeredREM_Stop1')'));
g.patch.FaceColor='r';
hold on
shadedErrorBar(tps,nanmean(zscore(BetaTriggeredREM_Stop1')'),stdError(zscore(BetaTriggeredREM_Stop1')'))


figure
clf
cols=gray(m+2);
for mm=1:m
    [val,ind]=max(Y{mm});
    Limit = X{mm}(ind);
    plot(X{mm}-Limit,Y{mm}./sum(Y{mm}),'color','k','linewidth',2),hold on
plot(log(Thresh(mm))-Limit,0.002*mm+0.015,'k*')
end

figure
bar([1,2],mean(Ratio),'Facecolor',[0.6 0.6 0.6]), hold on
errorbar([1,2],mean(Ratio),stdError(Ratio),'k.'), xlim([0.5 2.5])
set(gca,'XTick',[1,2],'XTickLabel',{'REM','SWS'})
box off



cd /media/DataMOBSSlSc/SleepScoringMice/M251/21052015
load('StateEpochSBAllOB','REMEpoch','smooth_1015','TenFif_thresh');
load('StateEpochSB','REMEpoch','Sleep','SWSEpoch','smooth_Theta','theta_thresh');
timestamps=Range(Restrict(smooth_Theta,Sleep));
ThetaData=Data(smooth_Theta);
timestamps=ts(timestamps(1:1000:end));
smooth_ThetaDwnS=Restrict(smooth_Theta,timestamps);
smooth_1015DwnS=Restrict(smooth_1015,timestamps);
clf
plot(log(Data(smooth_ThetaDwnS)),log(Data(smooth_1015DwnS)),'.','color',[0.6 0.6 0.6])
hold on
line(log([theta_thresh theta_thresh]),ylim,'color','k','linewidth',3)
line(xlim,log([TenFif_thresh TenFif_thresh]),'color','k','linewidth',3)
box off
set(gca,'XTick',[-1:1:2],'YTick',[4.5:0.5:6.5])

timestamps=Range((smooth_Theta));
ThetaData=Data(smooth_Theta);
timestamps=ts(timestamps(1:1000:end));
smooth_ThetaDwnS=Restrict(smooth_ghi,timestamps);
smooth_1015DwnS=Restrict(smooth_1015,timestamps);
clf
plot(log(Data(smooth_ThetaDwnS)),log(Data(smooth_1015DwnS)),'.','color',[0.6 0.6 0.6])



