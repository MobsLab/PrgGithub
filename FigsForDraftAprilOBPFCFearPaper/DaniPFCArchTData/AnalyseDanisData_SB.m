clear all
cd /home/vador/Downloads
load('sophie.mat')

TimeThresh = 2;
FreezeThreshVals = sqrt([0.01:0.01:0.1];
stepsizeVals = [0.5:0.5:2];
StimTypeVals = {'JustCSPlStim','JustcCSMnStim','JustCSPlNoStim','JustCSMnNoStim','AllStim','AllNoStim'};

for StimType = 1:length(StimTypeVals)
    
    for frth = 1 : length(FreezeThreshVals)
        disp(num2str(frth))
        FreezeThresh = FreezeThreshVals(frth);
        for sts = 1:length(stepsizeVals)
            stepsize = stepsizeVals(sts);
            tps = [0:stepsize:1000]*1e4;
            for i = 1:length(dataOF)
                clear  NoFreezeEpoch FreezeEpoch StimEpoc StimEpoc2 FakeData BinData_FZ_ind BinData_FZ_val_Change
                
                % come back to this - dirty code
                Vtsd = tsd(dataOF(i).track(1:end-501,1)*1e4',((diff(dataOF(i).track(1:end-500,2))).^2+(diff(dataOF(i).track(1:end-500,3))).^2));
                NoiseEpoch = thresholdIntervals(Vtsd,3,'Direction','Above');
                TotEpoch = intervalSet(0,max(dataOF(i).track(1:end-1,1))*1e4)-NoiseEpoch;
                
                NoFreezeEpoch = thresholdIntervals(Vtsd,FreezeThresh,'Direction','Above');
                NoFreezeEpoch = dropShortIntervals(NoFreezeEpoch,0.1*1e4);
                NoFreezeEpoch = mergeCloseIntervals(NoFreezeEpoch ,TimeThresh*1e4);
                FreezeEpoch = (TotEpoch - NoFreezeEpoch)-NoiseEpoch;
                FreezeEpoch = dropShortIntervals(FreezeEpoch,TimeThresh*1e4);
                NoFreezeEpoch = NoFreezeEpoch-FreezeEpoch;
                
                if StimType==1
                    StimEpoc = intervalSet((dataOF(i).csPBeg(4:8)-2)*1e4,(dataOF(i).csPBeg(4:8)+7)*1e4);
                elseif StimType==2
                    StimEpoc = intervalSet((dataOF(i).csMBeg(4:8)-2)*1e4,(dataOF(i).csMBeg(4:8)+7)*1e4);
                elseif StimType==3
                    StimEpoc = intervalSet((dataOF(i).csPBeg(1:4)-2)*1e4,(dataOF(i).csPBeg(1:4)+7)*1e4);
                elseif StimType==4
                    StimEpoc = intervalSet((dataOF(i).csMBeg(1:4)-2)*1e4,(dataOF(i).csMBeg(1:4)+7)*1e4);
                elseif StimType==5
                    StimEpoc = intervalSet((dataOF(i).csPBeg(4:8)-2)*1e4,(dataOF(i).csPBeg(4:8)+7)*1e4);
                    StimEpoc2 = intervalSet((dataOF(i).csMBeg(4:8)-2)*1e4,(dataOF(i).csMBeg(4:8)+7)*1e4);
                    StimEpoc = or(StimEpoc2,StimEpoc);
                elseif StimType==6
                    StimEpoc = intervalSet((dataOF(i).csPBeg(1:4)-2)*1e4,(dataOF(i).csPBeg(1:4)+7)*1e4);
                    StimEpoc2 = intervalSet((dataOF(i).csMBeg(1:4)-2)*1e4,(dataOF(i).csMBeg(1:4)+7)*1e4);
                    StimEpoc = or(StimEpoc2,StimEpoc);
                end
                
                FakeData = tsd((tps),[1:length(tps)]');
                
                BinData_FZ_ind = Data(Restrict(FakeData,FreezeEpoch));
                BinData_FZ_val = zeros(1,length(tps));
                BinData_FZ_val(BinData_FZ_ind)=1;
                BinData_FZ_val_Change=diff(BinData_FZ_val);
                BinData_FZ_val(end)=[];
                
                BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),StimEpoc));
                BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),StimEpoc));
                
                StayAct.(StimTypeVals{StimType})(i,frth,sts) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
                ChangeAct.(StimTypeVals{StimType})(i,frth,sts) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
                StayFz.(StimTypeVals{StimType})(i,frth,sts)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
                ChangeFz.(StimTypeVals{StimType})(i,frth,sts) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
                
%                 if dataOF(i).isGFP
%                     plot(Range(Vtsd,'s'),Data(Vtsd),'color',[0.6 0.6 0.6])
%                 else
%                     plot(Range(Vtsd,'s'),Data(Vtsd),'r')
%                 end
%                 hold on
%                 line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]'*0+0.25,'color','k','linewidth',3)
%                 line([Start(NoFreezeEpoch,'s') Stop(NoFreezeEpoch,'s')]',[Start(NoFreezeEpoch,'s') Stop(NoFreezeEpoch,'s')]'*0+0.3,'color','b','linewidth',3)
%                 line(xlim,[FreezeThresh,FreezeThresh],'color','r')
%                 ylim([0 1])
%                 xlim([dataOF(i).csPBeg(4),dataOF(i).csPBeg(end)+30])
%                 pause
%                 clf

    
                FreezeEpoch = and(FreezeEpoch,StimEpoc);
                TotFzDur.(StimTypeVals{StimType})(i,frth,sts) = nansum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))./nansum(Stop(StimEpoc,'s')-Start(StimEpoc,'s'));
                
                IsGFP(i) = dataOF(i).isGFP;
            end
        end
    end
end

close all

for StimType = 1:length(StimTypeVals)
    
    fig = figure;
    fig.Name = StimTypeVals{StimType};
    subplot(231)
    Num = squeeze(nanmean(StayAct.(StimTypeVals{StimType})(IsGFP,:,:),1))-squeeze(nanmean(StayAct.(StimTypeVals{StimType})(not(IsGFP),:,:),1));
    Denom = (squeeze(nanstd(StayAct.(StimTypeVals{StimType})(IsGFP,:,:),1))+squeeze(nanstd(StayAct.(StimTypeVals{StimType})(not(IsGFP),:,:),1)))/2;
    imagesc(stepsizeVals,FreezeThreshVals,Num./Denom),colormap(redblue),clim([-1 1])
    ylabel('FreezingThresholds'), xlabel('StepSizeMarkovModel')
    title('Pact/act')
    freezeColors
    subplot(232)
    Num = squeeze(nanmean(StayFz.(StimTypeVals{StimType})(IsGFP,:,:),1))-squeeze(nanmean(StayFz.(StimTypeVals{StimType})(not(IsGFP),:,:),1));
    Denom = (squeeze(nanstd(StayFz.(StimTypeVals{StimType})(IsGFP,:,:),1))+squeeze(nanstd(StayFz.(StimTypeVals{StimType})(not(IsGFP),:,:),1)))/2;
    imagesc(stepsizeVals,FreezeThreshVals,Num./Denom),colormap(redblue),clim([-1 1])
    ylabel('FreezingThresholds'), xlabel('StepSizeMarkovModel')
    title('PFz/fz')
    freezeColors
    subplot(233)
    Num = squeeze(nanmean(TotFzDur.(StimTypeVals{StimType})(IsGFP,:,:),1))-squeeze(nanmean(TotFzDur.(StimTypeVals{StimType})(not(IsGFP),:,:),1));
    Denom = (squeeze(nanstd(TotFzDur.(StimTypeVals{StimType})(IsGFP,:,:),1))+squeeze(nanstd(TotFzDur.(StimTypeVals{StimType})(not(IsGFP),:,:),1)))/2;
    imagesc(stepsizeVals,FreezeThreshVals,Num./Denom),colormap(redblue),clim([-1 1])
    ylabel('FreezingThresholds'), xlabel('StepSizeMarkovModel')
    title('TotFz')
    freezeColors
    
    for frth = 1 : length(FreezeThreshVals)
        disp(num2str(frth))
        for sts = 1:length(stepsizeVals)
            P_StayAct(frth,sts) = ranksum(StayAct.(StimTypeVals{StimType})(IsGFP,frth,sts),StayAct.(StimTypeVals{StimType})(not(IsGFP),frth,sts));
            P_StayFz(frth,sts) = ranksum(StayFz.(StimTypeVals{StimType})(IsGFP,frth,sts),StayFz.(StimTypeVals{StimType})(not(IsGFP),frth,sts));
            P_TotFz(frth,sts) =ranksum(TotFzDur.(StimTypeVals{StimType})(IsGFP,frth,sts),TotFzDur.(StimTypeVals{StimType})(not(IsGFP),frth,sts));
        end
    end
    
    subplot(234)
    imagesc(stepsizeVals,FreezeThreshVals,P_StayAct),colormap(hot),clim([0 0.05])
    ylabel('FreezingThresholds'), xlabel('StepSizeMarkovModel')
    title('Pact/act')
    
    subplot(235)
    imagesc(stepsizeVals,FreezeThreshVals,P_StayFz),colormap(hot),clim([0 0.05])
    ylabel('FreezingThresholds'), xlabel('StepSizeMarkovModel')
    title('PFz/fz')
    
    subplot(236)
    imagesc(stepsizeVals,FreezeThreshVals,P_TotFz),colormap(hot),clim([0 0.05])
    ylabel('FreezingThresholds'), xlabel('StepSizeMarkovModel')
    title('TotFz')
    
end

%     StimEpoc = intervalSet((dataOF(i).csPBeg(4:8)-2)*1e4,(dataOF(i).csPBeg(4:8)+7)*1e4);


    if dataOF(i).isGFP
        plot(Range(Vtsd,'s'),Data(Vtsd),'color',[0.6 0.6 0.6])
    else
        plot(Range(Vtsd,'s'),Data(Vtsd),'r')
    end
    hold on
    line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]'*0+0.25,'color','k','linewidth',3)
    line([Start(NoFreezeEpoch,'s') Stop(NoFreezeEpoch,'s')]',[Start(NoFreezeEpoch,'s') Stop(NoFreezeEpoch,'s')]'*0+0.3,'color','b','linewidth',3)
    line(xlim,[FreezeThresh,FreezeThresh],'color','r')
    ylim([0 1])
    xlim([dataOF(i).csPBeg(4),dataOF(i).csPBeg(end)+30])
    pause
    clf
    
    
    FreezeEpoch = and(FreezeEpoch,StimEpoc);
    NoFreezeEpoch = and(NoFreezeEpoch,StimEpoc);
    
    AllMiceFz(i,:) = cumsum(hist(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'),[0:0.5:lim]))/sum(hist(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'),[0:0.5:lim]));
    MeanDurFz(i) = nanmean(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
    NumEpFz(i) = length(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
    TotFzDur(i) = nansum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))./nansum(Stop(StimEpoc,'s')-Start(StimEpoc,'s'));
    
    NoFreezeEpoch = and(TotEpoch-FreezeEpoch,StimEpoc);
    AllMiceNoFz(i,:) = cumsum(hist(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'),[0:0.5:lim]))/sum(hist(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'),[0:0.5:lim]));
    MeanDurNoFz(i) = nanmean(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'));
    NumEpNoFz(i) = length(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'));
    IsGFP(i) = dataOF(i).isGFP;
    
        
    
end

figure(3), clf
subplot(121), hold on
plot([0:0.5:lim],AllMiceFz(IsGFP,:)','k')
plot([0:0.5:lim],nanmedian(AllMiceFz((IsGFP),:)),'k','linewidth',3)
plot([0:0.5:lim],AllMiceFz(not(IsGFP),:)','r')
plot([0:0.5:lim],nanmedian(AllMiceFz(not(IsGFP),:)),'r','linewidth',3)
subplot(122), hold on
plot([0:0.5:lim],AllMiceNoFz(IsGFP,:)','k')
plot([0:0.5:lim],nanmedian(AllMiceNoFz((IsGFP),:)),'k','linewidth',3)
plot([0:0.5:lim],AllMiceNoFz(not(IsGFP),:)','r')
plot([0:0.5:lim],nanmedian(AllMiceNoFz(not(IsGFP),:)),'r','linewidth',3)


figure(4), clf
subplot(231)
PlotErrorBarN_KJ({MeanDurFz(IsGFP),MeanDurFz(not(IsGFP))},'paired',0,'newfig',0)
title('MeanDurFz')
subplot(232)
PlotErrorBarN_KJ({MeanDurNoFz(IsGFP),MeanDurNoFz(not(IsGFP))},'paired',0,'newfig',0)
title('MeanDurAct')
subplot(233)
PlotErrorBarN_KJ({NumEpFz(IsGFP),NumEpFz(not(IsGFP))},'paired',0,'newfig',0)
title('Num Fz')
subplot(234)
PlotErrorBarN_KJ({NumEpNoFz(IsGFP),NumEpNoFz(not(IsGFP))},'paired',0,'newfig',0)
title('Num Act')
subplot(235)
PlotErrorBarN_KJ({TotFzDur(IsGFP),TotFzDur(not(IsGFP))},'paired',0,'newfig',0), ylim([0 1.3])
title('Tot')


figure
for i = 5:length(dataOF)
Vtsd = tsd(dataOF(i).track(1:end-1,1)*1e4',((diff(dataOF(i).track(1:end,2))).^2+(diff(dataOF(i).track(1:end,3))).^2));
NoiseEpoch = thresholdIntervals(Vtsd,2,'Direction','Below');
TotEpoch = intervalSet(0,max(dataOF(i).track(1:end-1,1))*1e4)-NoiseEpoch;
FreezeEpoch = thresholdIntervals(Vtsd,FreezeThresh,'Direction','Below');
FreezeEpoch = dropShortIntervals(FreezeEpoch ,0.3*1e4);
FreezeEpoch = mergeCloseIntervals(FreezeEpoch ,0.1*1e4);
FreezeEpoch = dropShortIntervals(FreezeEpoch ,2*1e4);
if dataOF(i).isGFP
plot(Range(Vtsd,'s'),Data(Vtsd),'k')
else
    plot(Range(Vtsd,'s'),Data(Vtsd),'r')
end
hold on
line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]'*0+0.25,'color','k','linewidth',3)
ylim([0 1])
pause
clf
end


%% using Dani's parameters
clear all
cd /home/vador/Downloads
load('sophie.mat')

StimTypeVals = {'JustCSPlStim','JustcCSMnStim','JustCSPlNoStim','JustCSMnNoStim','AllStim','AllNoStim'};

minFreezeDur = 1;
FreezeThresh = 3;
DropnonFrDur = 0.1;
stepsize = 2;
tps = [0:stepsize:1000]*1e4;
for StimType = 1:6
    for i = 1:length(dataOF)
        clear  NoFreezeEpoch FreezeEpoch StimEpoc StimEpoc2 FakeData BinData_FZ_ind BinData_FZ_val_Change
        
        Num = sqrt(diff(dataOF(i).track(1:end-500,2)).^2+diff(dataOF(i).track(1:end-500,3)).^2);
        Denom = diff(dataOF(i).track(1:end-500,1));
        Speed = runmean(Num./Denom,2);
        Vtsd = tsd(dataOF(i).track(1:end-501,1)*1e4',Speed);
        
        NoiseEpoch = thresholdIntervals(Vtsd,100,'Direction','Above');
        TotEpoch = intervalSet(0,max(dataOF(i).track(1:end-1,1))*1e4)-NoiseEpoch;
        
        FreezeEpoch = thresholdIntervals(Vtsd,FreezeThresh,'Direction','Below');
        FreezeEpoch = mergeCloseIntervals(FreezeEpoch,DropnonFrDur*1e4);
        FreezeEpoch = dropShortIntervals(FreezeEpoch,minFreezeDur*1e4);
        NoFreezeEpoch = TotEpoch-FreezeEpoch;
        
        
%             if dataOF(i).isGFP
%                 plot(Range(Vtsd,'s'),Data(Vtsd),'color',[0.6 0.6 0.6])
%             else
%                 plot(Range(Vtsd,'s'),Data(Vtsd),'r')
%             end
%             hold on
%             line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]'*0+15,'color','k','linewidth',3)
%             line([Start(NoFreezeEpoch,'s') Stop(NoFreezeEpoch,'s')]',[Start(NoFreezeEpoch,'s') Stop(NoFreezeEpoch,'s')]'*0+10,'color','b','linewidth',3)
%             line(xlim,[FreezeThresh,FreezeThresh],'color','r')
%             ylim([0 100])
%         %     xlim([dataOF(i).csPBeg(4),dataOF(i).csPBeg(end)+30])
%             pause
%             clf
        
        if StimType==1
            StimEpoc = intervalSet((dataOF(i).csPBeg(4:8)-2)*1e4,(dataOF(i).csPBeg(4:8)+7)*1e4);
        elseif StimType==2
            StimEpoc = intervalSet((dataOF(i).csMBeg(4:8)-2)*1e4,(dataOF(i).csMBeg(4:8)+7)*1e4);
        elseif StimType==3
            StimEpoc = intervalSet((dataOF(i).csPBeg(1:4)-2)*1e4,(dataOF(i).csPBeg(1:4)+7)*1e4);
        elseif StimType==4
            StimEpoc = intervalSet((dataOF(i).csMBeg(1:4)-2)*1e4,(dataOF(i).csMBeg(1:4)+7)*1e4);
        elseif StimType==5
            StimEpoc = intervalSet((dataOF(i).csPBeg(4:8)-2)*1e4,(dataOF(i).csPBeg(4:8)+7)*1e4);
            StimEpoc2 = intervalSet((dataOF(i).csMBeg(4:8)-2)*1e4,(dataOF(i).csMBeg(4:8)+7)*1e4);
            StimEpoc = or(StimEpoc2,StimEpoc);
        elseif StimType==6
            StimEpoc = intervalSet((dataOF(i).csPBeg(1:4)-2)*1e4,(dataOF(i).csPBeg(1:4)+7)*1e4);
            StimEpoc2 = intervalSet((dataOF(i).csMBeg(1:4)-2)*1e4,(dataOF(i).csMBeg(1:4)+7)*1e4);
            StimEpoc = or(StimEpoc2,StimEpoc);
        end
        
        FakeData = tsd((tps),[1:length(tps)]');
        
        BinData_FZ_ind = Data(Restrict(FakeData,FreezeEpoch));
        BinData_FZ_val = zeros(1,length(tps));
        BinData_FZ_val(BinData_FZ_ind)=1;
        BinData_FZ_val_Change=diff(BinData_FZ_val);
        BinData_FZ_val(end)=[];
        
        BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),StimEpoc));
        BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),StimEpoc));
        
        StayAct.(StimTypeVals{StimType})(i) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
        ChangeAct.(StimTypeVals{StimType})(i) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
        StayFz.(StimTypeVals{StimType})(i)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
        ChangeFz.(StimTypeVals{StimType})(i) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
        
        FreezeEpoch = and(FreezeEpoch,StimEpoc);
        TotFzDur.(StimTypeVals{StimType})(i) = nansum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))./nansum(Stop(StimEpoc,'s')-Start(StimEpoc,'s'));
        
        IsGFP(i) = dataOF(i).isGFP;
        
        
    end
    
end


StimTypeVals = {'JustCSPlStim','JustcCSMnStim','JustCSPlNoStim','JustCSMnNoStim','AllStim','AllNoStim'};

figure
for StimType = 1:6
subplot(6,3,1+(StimType-1)*3)
PlotErrorBarN_KJ({StayAct.(StimTypeVals{StimType})(IsGFP),StayAct.(StimTypeVals{StimType})(not(IsGFP))},'paired',0,'newfig',0)
title('StayAct')
ylabel(StimTypeVals{StimType})
subplot(6,3,2+(StimType-1)*3)
PlotErrorBarN_KJ({StayFz.(StimTypeVals{StimType})(IsGFP),StayFz.(StimTypeVals{StimType})(not(IsGFP))},'paired',0,'newfig',0)
title('StayFz')
subplot(6,3,3+(StimType-1)*3)
PlotErrorBarN_KJ({TotFzDur.(StimTypeVals{StimType})(IsGFP),TotFzDur.(StimTypeVals{StimType})(not(IsGFP))},'paired',0,'newfig',0)
title('TotFzDur')
end


%% using Dani's parameters
clear all
cd /home/vador/Downloads
load('sophie.mat')

StimTypeVals = {'JustCSPlStim','JustcCSMnStim','JustCSPlNoStim','JustCSMnNoStim','AllStim','AllNoStim'};

minFreezeDur = 1;
FreezeThresh = 2;
DropnonFrDur = 0.1;
stepsize = 2;
tps = [0:stepsize:1000]*1e4;
for i = 1:length(dataOF)
    
    % come back to this - dirty code
        Num = sqrt(diff(dataOF(i).track(1:end-500,2)).^2+diff(dataOF(i).track(1:end-500,3)).^2);
        Denom = diff(dataOF(i).track(1:end-500,1));
        Speed = runmean(Num./Denom,2);
        Vtsd = tsd(dataOF(i).track(1:end-501,1)*1e4',Speed);
    Vtsd = tsd(dataOF(i).track(1:end-501,1)*1e4',Speed);
    [M,T] = PlotRipRaw(Vtsd,dataOF(i).csPBeg(1:4),20000,0,0);
    TriggerOnCSPlus(i,:) = M(:,2);
    [M,T] = PlotRipRaw(Vtsd,dataOF(i).csMBeg(1:4),20000,0,0);close all
    TriggerOnCSMinus(i,:) = M(:,2);
    [M,T] = PlotRipRaw(Vtsd,dataOF(i).csPBeg(4:8),20000,0,0);
    TriggerOnCSPlusSt(i,:) = M(:,2);
    [M,T] = PlotRipRaw(Vtsd,dataOF(i).csMBeg(4:8),20000,0,0);
    TriggerOnCSMinusSt(i,:) = M(:,2);
    IsGFP(i) = dataOF(i).isGFP;

end


figure
subplot(221)
shadedErrorBar(M(:,1),nanmean(TriggerOnCSMinus(IsGFP,:)),stdError(TriggerOnCSMinus(IsGFP,:)),'g')
hold on
shadedErrorBar(M(:,1),nanmean(TriggerOnCSMinus(~IsGFP,:)),stdError(TriggerOnCSMinus(~IsGFP,:)),'b')
xlim([-4 14])
title('CSMinusNoStim')
subplot(222)
shadedErrorBar(M(:,1),nanmean(TriggerOnCSPlus(IsGFP,:)),stdError(TriggerOnCSPlus(IsGFP,:)),'g')
hold on
shadedErrorBar(M(:,1),nanmean(TriggerOnCSPlus(~IsGFP,:)),stdError(TriggerOnCSPlus(~IsGFP,:)),'b')
xlim([-4 14])
title('CSplusNoStim')
subplot(223)
shadedErrorBar(M(:,1),nanmean(TriggerOnCSMinusSt(IsGFP,:)),stdError(TriggerOnCSMinusSt(IsGFP,:)),'g')
hold on
shadedErrorBar(M(:,1),nanmean(TriggerOnCSMinusSt(~IsGFP,:)),stdError(TriggerOnCSMinusSt(~IsGFP,:)),'b')
xlim([-4 14])
title('CSMinusStim')
subplot(224)
shadedErrorBar(M(:,1),nanmean(TriggerOnCSPlusSt(IsGFP,:)),stdError(TriggerOnCSPlusSt(IsGFP,:)),'g')
hold on
shadedErrorBar(M(:,1),nanmean(TriggerOnCSPlusSt(~IsGFP,:)),stdError(TriggerOnCSPlusSt(~IsGFP,:)),'b')
xlim([-4 14])
title('CSPlusStim')
