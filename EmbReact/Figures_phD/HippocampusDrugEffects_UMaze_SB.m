clear all, close all

[Group,Mice] = GetMiceDrugGroupsUMaze;
SessType = {'Pre','Post'};
SpeedIntervals = [0:1:10,12:2:25];

for grp = 1:length(Group)
    for mm = 1:length(Mice.(Group{grp}))
        
        FileNames=GetAllMouseTaskSessions(Mice.(Group{grp})(mm));
        
        BehavSessions.Pre = find((~cellfun(@isempty,strfind(FileNames,'Pre'))) & (cellfun(@isempty,strfind(FileNames,'Sleep'))));
        BehavSessions.Pre = BehavSessions.Pre(11:end);
        BehavSessions.Post = find((~cellfun(@isempty,strfind(FileNames,'Post'))) & (cellfun(@isempty,strfind(FileNames,'Sleep'))) & (cellfun(@isempty,strfind(FileNames,'Ext4'))) & (cellfun(@isempty,strfind(FileNames,'Ext3'))));
        BehavSessions.Post = BehavSessions.Post(1:6);
        SleepSession.Pre = find((~cellfun(@isempty,strfind(FileNames,'Pre'))) & (~cellfun(@isempty,strfind(FileNames,'Sleep'))));
        SleepSession.Post = find((~cellfun(@isempty,strfind(FileNames,'Post'))) & (~cellfun(@isempty,strfind(FileNames,'Sleep'))));
        
        % Behaviour
        for ss = 1 : length(SessType)
            % Load the data
            clear Spec Wv Pt Fz Zn Noise Speed Acc
            Spec = ConcatenateDataFromFolders_SB(FileNames(BehavSessions.(SessType{ss})),'spectrum','prefix','H_Low');
            Wv = ConcatenateDataFromFolders_SB(FileNames(BehavSessions.(SessType{ss})),'instfreq','method','WV','suffix_instfreq','H');
            Pt = ConcatenateDataFromFolders_SB(FileNames(BehavSessions.(SessType{ss})),'instfreq','method','PT','suffix_instfreq','H');
            Fz = ConcatenateDataFromFolders_SB(FileNames(BehavSessions.(SessType{ss})),'epoch','epochname','freezeepoch');
            Zn = ConcatenateDataFromFolders_SB(FileNames(BehavSessions.(SessType{ss})),'epoch','epochname','zoneepoch');
            Noise = ConcatenateDataFromFolders_SB(FileNames(BehavSessions.(SessType{ss})),'epoch','epochname','noiseepoch');
            Speed = ConcatenateDataFromFolders_SB(FileNames(BehavSessions.(SessType{ss})),'speed');
            Acc = ConcatenateDataFromFolders_SB(FileNames(BehavSessions.(SessType{ss})),'accelero');
            
            temp = Data((Wv));
            temp(temp>12) = NaN;
            Wv = tsd(Range(Wv),temp);
            
            % Get the epochs
            TotalEpoch = intervalSet(0,max(Range(Speed)));
            CleanFreezeEpoch  = Fz-Noise;
            CleanNoFreezeEpoch  = (TotalEpoch-Fz)-Noise;
            SafeZone = and(Fz,or(Zn{2},Zn{5}))-Noise;
            ShockZone = and(Fz,Zn{1})-Noise;
            ActivePeriod = mergeCloseIntervals(thresholdIntervals(Speed,5,'Direction','Above'),2*1E4)-Noise;
            
            % Get average spectra
            Res.AverageSpecAct.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,ActivePeriod)));
            Res.AverageSpecFzSk.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,ShockZone)));
            Res.AverageSpecFzSf.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,SafeZone)));
            Res.AverageSpecAllFz.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,CleanFreezeEpoch)));
            Res.AverageSpecNoFz.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,CleanNoFreezeEpoch)));
            
            % Get average frequency
            Res.AverageWvAct.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Wv,ActivePeriod)));
            Res.AverageWvFzSk.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Wv,ShockZone)));
            Res.AverageWvFzSf.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Wv,SafeZone)));
            Res.AverageWvAllFz.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Wv,CleanFreezeEpoch)));
            Res.AverageWvNoFz.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Wv,CleanNoFreezeEpoch)));

            Res.AveragePtAct.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Pt,ActivePeriod)));
            Res.AveragePtFzSk.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Pt,ShockZone)));
            Res.AveragePtFzSf.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Pt,SafeZone)));
            Res.AveragePtAllFz.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Pt,CleanFreezeEpoch)));
            Res.AveragePtNoFz.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Pt,CleanNoFreezeEpoch)));

            % Get average speed and movement
            Res.AverageSpAct.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Speed,ActivePeriod)));
            Res.AverageSpFzSk.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Speed,ShockZone)));
            Res.AverageSpFzSf.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Speed,SafeZone)));
            Res.AverageSpAllFz.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Speed,CleanFreezeEpoch)));
            Res.AverageSpNoFz.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Speed,CleanNoFreezeEpoch)));

            Res.AverageAccAct.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,ActivePeriod)));
            Res.AverageAccFzSk.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,ShockZone)));
            Res.AverageAccFzSf.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,SafeZone)));
            Res.AverageAccAllFz.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,CleanFreezeEpoch)));
            Res.AverageAccNoFz.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,CleanNoFreezeEpoch)));
            
            % Relate theta to speed
            for sp = 1:length(SpeedIntervals)-1
                LitEpoch = (and(thresholdIntervals(Speed,SpeedIntervals(sp),'Direction','Above'),thresholdIntervals(Speed,SpeedIntervals(sp+1),'Direction','Below'))-CleanFreezeEpoch)-Noise;;
                LitEpoch = mergeCloseIntervals(LitEpoch,0.5*1e4);
                LitEpoch = dropShortIntervals(LitEpoch,0.5*1e4);
                Res.AverageSpecBySpeed.(SessType{ss}).(Group{grp})(mm,sp,:) = nanmean(Data(Restrict(Spec,LitEpoch)));
                Res.AverageFreqBySpeedWv.(SessType{ss}).(Group{grp})(mm,sp) = nanmean(Data(Restrict(Wv,LitEpoch)));
                Res.AverageFreqBySpeedPt.(SessType{ss}).(Group{grp})(mm,sp) = nanmean(Data(Restrict(Pt,LitEpoch)));
            end
        end
        
        
        %         % homecage
        %         for ss = 1 : length(SessType)
        %             % Load the data
        %             Spec = ConcatenateDataFromFolders_SB(FileNames(SleepSession.(SessType{ss})),'spectrum','prefix','H_Low');
        %             Wv = ConcatenateDataFromFolders_SB(FileNames(SleepSession.(SessType{ss})),'instfreq','method','WV','suffix_instfreq','H');
        %             Pt = ConcatenateDataFromFolders_SB(FileNames(SleepSession.(SessType{ss})),'instfreq','method','PT','suffix_instfreq','H');
        %             Noise = ConcatenateDataFromFolders_SB(FileNames(SleepSession.(SessType{ss})),'epoch','epochname','noiseepoch');
        %             Speed = ConcatenateDataFromFolders_SB(FileNames(SleepSession.(SessType{ss})),'speed');
        %             Acc = ConcatenateDataFromFolders_SB(FileNames(SleepSession.(SessType{ss})),'accelero');
        %             SleepStates = ConcatenateDataFromFolders_SB(FileNames(SleepSession.(SessType{ss})),'epoch','epochname','sleepstates');
        %
        %
        %             % Get the epochs
        %             TotalEpoch = intervalSet(0,max(Range(Speed)));
        %
        %             Wake = SleepStates{1} -Noise;
        %             NREM = SleepStates{2} -Noise;
        %             REM = SleepStates{2} -Noise;
        %             ActivePeriod = mergeCloseIntervals(thresholdIntervals(Speed,5,'Direction','Above'),2*1E4)-Noise;
        %
        %             % Get average spectra
        %             AverageSpecActHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,ActivePeriod)));
        %             AverageSpecWakeHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,Wake)));
        %             AverageSpecREMHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,REM)));
        %             AverageSpecNREMHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Spec,NREM)));
        %
        %             % Get average frequency
        %             AverageWvActHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Wv,ActivePeriod)));
        %             AverageWvWakeHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Wv,Wake)));
        %             AverageWvREMHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Wv,REM)));
        %             AverageWvNREMHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Wv,NREM)));
        %
        %             AveragePtActHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Pt,ActivePeriod)));
        %             AveragePtWakeHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Pt,Wake)));
        %             AveragePtREMHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Pt,REM)));
        %             AveragePtNREMHC.(SessType{ss}).(Group{grp})(mm,:) = nanmean(Data(Restrict(Pt,NREM)));
        %
        %             % Get average speed and movement
        %             AverageSpActHC.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Speed,ActivePeriod)));
        %             AverageSpWakeHC.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Speed,Wake)));
        %             AverageSpREMHC.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Speed,REM)));
        %             AverageSpNREMHC.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Speed,NREM)));
        %
        %             AverageAccActHC.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,ActivePeriod)));
        %             AverageAccWakeHC.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,Wake)));
        %             AverageAccREMHC.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,REM)));
        %             AverageAccNREMHC.(SessType{ss}).(Group{grp})(mm) = nanmean(Data(Restrict(Acc,NREM)));
        %
        %
        %             % Relate theta to speed
        %             for sp = 1:length(SpeedIntervals)-1
        %                 LitEpoch = and(and(thresholdIntervals(Speed,SpeedIntervals(sp),'Direction','Above'),thresholdIntervals(Speed,SpeedIntervals(sp+1),'Direction','Below'))-Noise,Wake);
        %                 LitEpoch = mergeCloseIntervals(LitEpoch,0.5*1e4);
        %                 LitEpoch = dropShortIntervals(LitEpoch,0.5*1e4);
        %                 AverageSpecBySpeedHC.(SessType{ss}).(Group{grp})(mm,sp,:) = nanmean(Data(Restrict(Spec,LitEpoch)));
        %                 AverageFreqBySpeedWvHC.(SessType{ss}).(Group{grp})(mm,sp) = nanmean(Data(Restrict(Wv,LitEpoch)));
        %                 AverageFreqBySpeedPtHC.(SessType{ss}).(Group{grp})(mm,sp) = nanmean(Data(Restrict(Pt,LitEpoch)));
        %             end
        %         end
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPCOnDrugs

clf

for grp = 1:length(Group)
    subplot(211)
    errorbar(SpeedIntervals(1:end-1),nanmean((Res.AverageFreqBySpeedPt.Pre.(Group{grp}))),stdError((Res.AverageFreqBySpeedPt.Pre.(Group{grp}))))
    hold on
    xlabel('Speed (cm/s)')
    ylabel('Theta freq')
    box off
    ylim([6.5 10])
        set(gca,'LineWidth',2,'FontSize',15), box off
    subplot(212)
    errorbar(SpeedIntervals(1:end-1),nanmean((Res.AverageFreqBySpeedPt.Post.(Group{grp}))),stdError((Res.AverageFreqBySpeedPt.Post.(Group{grp}))))
    hold on
    box off
    xlabel('Speed (cm/s)')
    ylabel('Theta freq (Hz)')
    set(gca,'LineWidth',2,'FontSize',15), box off
    ylim([6.5 10])
end
subplot(211)
legend(Group(1:3));
subplot(212)
legend(Group(1:3));

figure
Cols2 = {[0.6 0.6 0.6],[0.6 1 0.6],[1 0.8 1],[0.6 0.4 0.6]};
for grp = length(Group):-1:1
    errorbar(SpeedIntervals(1:end-1),nanmean((Res.AverageFreqBySpeedPt.Post.(Group{grp}))),stdError((Res.AverageFreqBySpeedPt.Post.(Group{grp}))),'color',Cols2{grp},'linewidth',3)
    hold on
    box off
    xlabel('Speed (cm/s)')
    ylabel('Theta freq (Hz)')
    set(gca,'LineWidth',2,'FontSize',15), box off
    ylim([6.5 10])
end

figure
clf
    subplot(211)
for grp = 1:length(Group)
    for ms = 1:size(Res.AverageSpecAllFz.Post.(Group{grp}),1)
        AverageSpecAllFz2.Post.(Group{grp})(ms,:) = Res.AverageSpecNoFz.Post.(Group{grp})(ms,:)./nanmean(Res.AverageSpecNoFz.Pre.(Group{grp})(ms,20:end));
        AverageSpecAllFz2.Pre.(Group{grp})(ms,:) = Res.AverageSpecNoFz.Pre.(Group{grp})(ms,:)./nanmean(Res.AverageSpecNoFz.Pre.(Group{grp})(ms,20:end));
    end
    plot(fLow,log(nanmean((AverageSpecAllFz2.Post.(Group{grp})))),'linewidth',3,'color',Cols2{grp})
    title('PreDrug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
    hold on
end
    subplot(212)

for grp = 1:length(Group)
    for ms = 1:size(Res.AverageSpecAllFz.Post.(Group{grp}),1)
        AverageSpecAllFz2.Post.(Group{grp})(ms,:) = Res.AverageSpecFzSk.Post.(Group{grp})(ms,:)./nanmean(Res.AverageSpecFzSk.Pre.(Group{grp})(ms,20:end));
        AverageSpecAllFz2.Pre.(Group{grp})(ms,:) = Res.AverageSpecFzSk.Pre.(Group{grp})(ms,:)./nanmean(Res.AverageSpecFzSk.Pre.(Group{grp})(ms,20:end));
    end
    
    plot(fLow,log(nanmean((AverageSpecAllFz2.Post.(Group{grp})))),'linewidth',3,'color',Cols2{grp})
    hold on
    title('Post Drug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
end



figure

for grp = 1:length(Group)
    errorbar(SpeedIntervals(1:end-1),nanmean((Res.AverageFreqBySpeedPt.Post.(Group{grp}))-(Res.AverageFreqBySpeedPt.Pre.(Group{grp}))),...
        stdError((Res.AverageFreqBySpeedPt.Post.(Group{grp}))-(Res.AverageFreqBySpeedPt.Pre.(Group{grp}))))
    hold on

end
legend(Group(1:3));
line(xlim,[0 0],'color','k','linewidth',1)
>> set(gca,'LineWidth',2,'FontSize',15), box off
>> box off
>> xlabel('Speed (cm/s)')
>> ylabel('Theta freq Post - Pre(Hz)')
>> line(xlim,[0 0])
>> line(xlim,[0 0],'color','k','linewidth',1)



figure
for grp = 1:length(Group)
    for ms = 1:size(Res.AverageSpecAct.Post.(Group{grp}),1)
        AverageSpecAct2.Post.(Group{grp})(ms,:) = Res.AverageSpecNoFz.Post.(Group{grp})(ms,:);%./nanmean(Res.AverageSpecNoFz.Pre.(Group{grp})(ms,20:end));
        AverageSpecAct2.Pre.(Group{grp})(ms,:) = Res.AverageSpecNoFz.Pre.(Group{grp})(ms,:);%./nanmean(Res.AverageSpecNoFz.Pre.(Group{grp})(ms,20:end));
    end
    subplot(121)
    errorbar(fLow,nanmean((AverageSpecAct2.Pre.(Group{grp}))),stdError((AverageSpecAct2.Pre.(Group{grp}))))
    hold on
    subplot(122)
    errorbar(fLow,nanmean((AverageSpecAct2.Post.(Group{grp}))),stdError((AverageSpecAct2.Post.(Group{grp}))))
    
    hold on
end


figure
for grp = 1:length(Group)
    for ms = 1:size(Res.AverageSpecAllFz.Post.(Group{grp}),1)
        AverageSpecAllFz2.Post.(Group{grp})(ms,:) = (Res.AverageSpecAllFz.Post.(Group{grp})(ms,:)./nanmean(Res.AverageSpecAllFz.Pre.(Group{grp})(ms,20:end)));
        AverageSpecAllFz2.Pre.(Group{grp})(ms,:) = (Res.AverageSpecAllFz.Pre.(Group{grp})(ms,:)./nanmean(Res.AverageSpecAllFz.Pre.(Group{grp})(ms,20:end)));
    end
    subplot(121)
    errorbar(fLow,nanmean((AverageSpecAllFz2.Pre.(Group{grp}))),stdError((AverageSpecAllFz2.Pre.(Group{grp}))))
    hold on
    subplot(122)
    errorbar(fLow,nanmean((AverageSpecAllFz2.Post.(Group{grp}))),stdError((AverageSpecAllFz2.Post.(Group{grp}))))
    
    hold on
end


clf
for grp = 1:length(Group)
    for ms = 1:size(Res.AverageSpecAllFz.Post.(Group{grp}),1)
        AverageSpecAllFz2.Post.(Group{grp})(ms,:) = Res.AverageSpecFzSk.Post.(Group{grp})(ms,:)./nanmean(Res.AverageSpecFzSk.Pre.(Group{grp})(ms,20:end));
        AverageSpecAllFz2.Pre.(Group{grp})(ms,:) = Res.AverageSpecFzSk.Pre.(Group{grp})(ms,:)./nanmean(Res.AverageSpecFzSk.Pre.(Group{grp})(ms,20:end));
    end
    subplot(221)
    plot(fLow,log(nanmean((AverageSpecAllFz2.Pre.(Group{grp})))),'linewidth',2)
    title('PreDrug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
    hold on
    subplot(222)
    plot(fLow,log(nanmean((AverageSpecAllFz2.Post.(Group{grp})))),'linewidth',2)
    hold on
    title('Post Drug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
end

for grp = 1:length(Group)
    for ms = 1:size(Res.AverageSpecAllFz.Post.(Group{grp}),1)
        AverageSpecAllFz2.Post.(Group{grp})(ms,:) = Res.AverageSpecFzSf.Post.(Group{grp})(ms,:)./nanmean(Res.AverageSpecFzSk.Pre.(Group{grp})(ms,20:end));
        AverageSpecAllFz2.Pre.(Group{grp})(ms,:) = Res.AverageSpecFzSf.Pre.(Group{grp})(ms,:)./nanmean(Res.AverageSpecFzSk.Pre.(Group{grp})(ms,20:end));
    end
    subplot(223)
    plot(fLow,log(nanmean((AverageSpecAllFz2.Pre.(Group{grp})))),'linewidth',2)
    title('PreDrug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
    hold on
    subplot(224)
    plot(fLow,log(nanmean((AverageSpecAllFz2.Post.(Group{grp})))),'linewidth',2)
    hold on
    title('Post Drug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
end


figure
clf
subplot(211)
ss=1;
PlotErrorBarN_KJ({Res.AveragePtFzSk.(SessType{ss}).Sal,Res.AveragePtFzSk.(SessType{ss}).Mdz,Res.AveragePtFzSk.(SessType{ss}).Flx},'newfig',0,'paired',0)
title('PreDrug')
ylabel('Frequency (Hz)')
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:3, 'XTickLabel',Group(1:3)), box off

subplot(212)
ss=2;
PlotErrorBarN_KJ({Res.AveragePtFzSk.(SessType{ss}).Sal,Res.AveragePtFzSk.(SessType{ss}).Mdz,Res.AveragePtFzSk.(SessType{ss}).Flx},'newfig',0,'paired',0)
title('PostDrug')
ylabel('Frequency (Hz)')
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:3, 'XTickLabel',Group(1:3)), box off

figure
clf
subplot(211)
ss=1;
PlotErrorBarN_KJ({Res.AveragePtAct.(SessType{ss}).Sal,Res.AveragePtAct.(SessType{ss}).Mdz,Res.AveragePtAct.(SessType{ss}).Flx},'newfig',0,'paired',0)
title('PreDrug')
ylabel('Frequency (Hz)')
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:3, 'XTickLabel',Group(1:3)), box off

subplot(212)
ss=2;
PlotErrorBarN_KJ({Res.AveragePtAct.(SessType{ss}).Sal,Res.AveragePtAct.(SessType{ss}).Mdz,Res.AveragePtAct.(SessType{ss}).Flx},'newfig',0,'paired',0)
title('PostDrug')
ylabel('Frequency (Hz)')
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:3, 'XTickLabel',Group(1:3)), box off

figure
clf
subplot(211)
ss=1;
PlotErrorBarN_KJ({Res.AveragePtFzSf.(SessType{ss}).Sal,Res.AveragePtFzSf.(SessType{ss}).Mdz,Res.AveragePtFzSf.(SessType{ss}).Flx},'newfig',0,'paired',0)
title('PreDrug')
ylabel('Frequency (Hz)')
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:3, 'XTickLabel',Group(1:3)), box off

subplot(212)
ss=2;
PlotErrorBarN_KJ({Res.AveragePtFzSf.(SessType{ss}).Sal,Res.AveragePtFzSf.(SessType{ss}).Mdz,Res.AveragePtFzSf.(SessType{ss}).Flx},'newfig',0,'paired',0)
title('PostDrug')
ylabel('Frequency (Hz)')
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:3, 'XTickLabel',Group(1:3)), box off

figure
clf
for grp = 1:length(Group)-1
    for ms = 1:size(Res.AverageSpecAllFz.Post.(Group{grp}),1)
        AverageSpecAllFz2.Post.(Group{grp})(ms,:) = Res.AverageSpecAct.Post.(Group{grp})(ms,:)./nanmean(Res.AverageSpecAct.Pre.(Group{grp})(ms,20:end));
        AverageSpecAllFz2.Pre.(Group{grp})(ms,:) = Res.AverageSpecAct.Pre.(Group{grp})(ms,:)./nanmean(Res.AverageSpecAct.Pre.(Group{grp})(ms,20:end));
    end
    subplot(211)
    plot(fLow,log(nanmean((AverageSpecAllFz2.Pre.(Group{grp})))),'linewidth',2)
    title('PreDrug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
    hold on
    subplot(212)
    plot(fLow,log(nanmean((AverageSpecAllFz2.Post.(Group{grp})))),'linewidth',2)
    hold on
    title('Post Drug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
end


figure
clf
for grp = 1:length(Group)-1
    for ms = 1:size(Res.AverageSpecAllFz.Post.(Group{grp}),1)
        AverageSpecAllFz2.Post.(Group{grp})(ms,:) = Res.AverageSpecNoFz.Post.(Group{grp})(ms,:);%./nanmean(Res.AverageSpecNoFz.Pre.(Group{grp})(ms,20:end));
        AverageSpecAllFz2.Pre.(Group{grp})(ms,:) = Res.AverageSpecNoFz.Pre.(Group{grp})(ms,:);%./nanmean(Res.AverageSpecNoFz.Pre.(Group{grp})(ms,20:end));
    end
    subplot(211)
    plot(fLow,log(nanmean((AverageSpecAllFz2.Pre.(Group{grp})))),'linewidth',2)
    title('PreDrug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
    hold on
    subplot(212)
    plot(fLow,log(nanmean((AverageSpecAllFz2.Post.(Group{grp})))),'linewidth',2)
    hold on
    title('Post Drug')
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Frequency (Hz)')
    ylabel('Power - norm')
end

