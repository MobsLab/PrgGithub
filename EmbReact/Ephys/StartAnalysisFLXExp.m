SessionNames={'UMazeCondExplo_PreDrug', 'UMazeCondBlockedShock_PreDrug', 'UMazeCondBlockedSafe_PreDrug'};
[SpecData.Pre,NumRip.Pre,DurPer.Pre,Spectrogram.Pre,GammaOB.Pre,HRInfo.Pre]=GetSpectraDataForTwoFreezingOverview(SessionNames);

SessionNames={'UMazeCondExplo_PostDrug', 'UMazeCondBlockedShock_PostDrug', 'UMazeCondBlockedSafe_PostDrug'};
[SpecData.Post,NumRip.Post,DurPer.Poqt,Spectrogram.Poqt,GammaOB.Post,HRInfo.Post]=GetSpectraDataForTwoFreezingOverview(SessionNames);

SessionNames={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
[SpecData.Ext,NumRip.Ext,DurPer.Ext,Spectrogram.Ext,GammaOB.Ext,HRInfo.Ext]=GetSpectraDataForTwoFreezingOverview(SessionNames);

SessionNames={'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};
[SpecData.OldExp,NumRip.OldExp,DurPer.OldExp,Spectrogram.OldExp,GammaOB.Ext,HRInfo.OldExp]=GetSpectraDataForTwoFreezingOverview(SessionNames);

MiceNum = [  688   689   739   740   750   775   777   778   779];
FLXMice = [689,740,750,778,775] ;
SALMice = [739,688,779,777];
MiceType = [0 1 0 1 1 1 0 1 0]

figure
for k = 1:9
    subplot(3,9,k)
    plot(fLow,nanmean(SpecData.Pre.OB{k}.Shock),'r')
    hold on
    plot(fLow,nanmean(SpecData.Pre.OB{k}.Safe),'b')
    line([3 3],ylim,'color','k')
    line([6 6],ylim,'color','k')
        xlim([0 10])
        title(num2str(MiceNum(k)))

    subplot(3,9,k+9)
    plot(fLow,nanmean(SpecData.Post.OB{k}.Shock),'r')
    hold on
    plot(fLow,nanmean(SpecData.Post.OB{k}.Safe),'b')
    line([3 3],ylim,'color','k')
    line([6 6],ylim,'color','k')
    xlim([0 10])
        subplot(3,9,k+18)
    plot(fLow,nanmean(SpecData.Ext.OB{k}.Shock),'r')
    hold on
    plot(fLow,nanmean(SpecData.Ext.OB{k}.Safe),'b')
    line([3 3],ylim,'color','k')
    line([6 6],ylim,'color','k')
    xlim([0 10])
end

figure
SalNumber = find(not(MiceType));
for k = 1:4
    OB_Pre_Shock_Sal(k,:) = nanmean(zscore(SpecData.Pre.OB{SalNumber(k)}.Shock')');
    OB_Pre_Safe_Sal(k,:) = nanmean(zscore(SpecData.Pre.OB{SalNumber(k)}.Safe')');
    OB_Post_Shock_Sal(k,:) = nanmean(zscore(SpecData.Post.OB{SalNumber(k)}.Shock')');
    OB_Post_Safe_Sal(k,:) = nanmean(zscore(SpecData.Post.OB{SalNumber(k)}.Safe')');
    OB_Ext_Shock_Sal(k,:) = nanmean(zscore(SpecData.Ext.OB{SalNumber(k)}.Shock')');
    OB_Ext_Safe_Sal(k,:) = nanmean(zscore(SpecData.Ext.OB{SalNumber(k)}.Safe')');
    Fr_Post_Safe_Sal(k) = nansum(DurPer.Poqt.Safe.Sess(SalNumber(k),:));
    Fr_Post_Shock_Sal(k) = nansum(DurPer.Poqt.Shock.Sess(SalNumber(k),:));
    Fr_Ext_Safe_Sal(k) = nansum(DurPer.Ext.Safe.Sess(SalNumber(k),:));
    Fr_Ext_Shock_Sal(k) = nansum(DurPer.Ext.Shock.Sess(SalNumber(k),:));

end
    FlxNum = find((MiceType));
for k = 1:5
    OB_Pre_Shock_Flx(k,:) = nanmean(zscore(SpecData.Pre.OB{FlxNum(k)}.Shock')');
    OB_Pre_Safe_Flx(k,:) = nanmean(zscore(SpecData.Pre.OB{FlxNum(k)}.Safe')');
    OB_Post_Shock_Flx(k,:) = nanmean(zscore(SpecData.Post.OB{FlxNum(k)}.Shock')');
    OB_Post_Safe_Flx(k,:) = nanmean(zscore(SpecData.Post.OB{FlxNum(k)}.Safe')');
    OB_Ext_Shock_Flx(k,:) = nanmean(zscore(SpecData.Ext.OB{FlxNum(k)}.Shock')');
    OB_Ext_Safe_Flx(k,:) = nanmean(zscore(SpecData.Ext.OB{FlxNum(k)}.Safe')');
    Fr_Post_Safe_Flx(k) = nansum(DurPer.Poqt.Safe.Sess(FlxNum(k),:));
    Fr_Post_Shock_Flx(k) = nansum(DurPer.Poqt.Shock.Sess(FlxNum(k),:));
    Fr_Ext_Safe_Flx(k) = nansum(DurPer.Ext.Safe.Sess(FlxNum(k),:));
    Fr_Ext_Shock_Flx(k) = nansum(DurPer.Ext.Shock.Sess(FlxNum(k),:));

end
subplot(2,3,1)
plot(fLow,nanmean(OB_Pre_Shock_Sal),'r'), hold on
plot(fLow,nanmean(OB_Pre_Safe_Sal),'b')
line([3 3],ylim)
subplot(2,3,2)
plot(fLow,nanmean(OB_Post_Shock_Sal),'r'), hold on
plot(fLow,nanmean(OB_Post_Safe_Sal),'b')
line([3 3],ylim)
subplot(2,3,3)
plot(fLow,nanmean(OB_Ext_Shock_Sal),'r'), hold on
plot(fLow,nanmean(OB_Ext_Safe_Sal),'b')
line([3 3],ylim)
subplot(2,3,4)
plot(fLow,nanmean(OB_Pre_Shock_Flx),'r'), hold on
plot(fLow,nanmean(OB_Pre_Safe_Flx),'b')
line([3 3],ylim)
subplot(2,3,5)
plot(fLow,nanmean(OB_Post_Shock_Flx),'r'), hold on
plot(fLow,nanmean(OB_Post_Safe_Flx),'b')
line([3 3],ylim)
subplot(2,3,6)
plot(fLow,nanmean(OB_Ext_Shock_Flx),'r'), hold on
plot(fLow,nanmean(OB_Ext_Safe_Flx),'b')
line([3 3],ylim)



figure
for k = 1:9
    subplot(4,9,k)
    bar(1,nansum(DurPer.Pre.Safe.Sess(k,:)),'b')
    hold on
    bar(2,nansum(DurPer.Pre.Shock.Sess(k,:)),'r')
    ylim([0 300])
        title(num2str(MiceNum(k)))

    subplot(4,9,k+9)
    bar(1,nansum(DurPer.Poqt.Safe.Sess(k,:)),'b')
    hold on
    bar(2,nansum(DurPer.Poqt.Shock.Sess(k,:)),'r')
    ylim([0 300])

    subplot(4,9,k+18)
    bar(1,nansum(DurPer.Ext.Safe.Sess(k,4)),'b')
    hold on
    bar(2,nansum(DurPer.Ext.Shock.Sess(k,1)),'r')
    ylim([0 100])
    
        subplot(4,9,k+27)
    bar(1,nansum(DurPer.Ext.Safe.Sess(k,5)),'b')
    hold on
    bar(2,nansum(DurPer.Ext.Shock.Sess(k,2)),'r')
    ylim([0 150])

end



figure
for k = 1:5
    subplot(3,5,k)
    plot(fHi,nanmean(log(SpecData.Pre.HHi{k}.Shock)),'r')
    hold on
    plot(fHi,nanmean(log(SpecData.Pre.HHi{k}.Safe)),'b')
   

    subplot(3,5,k+5)
    plot(fHi,nanmean(log(SpecData.Post.HHi{k}.Shock)),'r')
    hold on
    plot(fHi,nanmean(log(SpecData.Post.HHi{k}.Safe)),'b')
    
    subplot(3,5,k+10)
    plot(fHi,nanmean(log(SpecData.Ext.HHi{k}.Shock)),'r')
    hold on
    plot(fHi,nanmean(log(SpecData.Ext.HHi{k}.Safe)),'b')
    
end


figure
for k = 1:5
    subplot(3,5,k)
    bar(1,nansum(NumRip.Pre.Safe.Sess(k,:))./nansum(DurPer.Pre.Safe.Sess(k,:)),'b')
    hold on
    bar(2,nansum(NumRip.Pre.Shock.Sess(k,:))./nansum(DurPer.Pre.Shock.Sess(k,:)),'r')

    subplot(3,5,k+5)
    bar(1,nansum(NumRip.Post.Safe.Sess(k,:))./nansum(DurPer.Poqt.Safe.Sess(k,:)),'b')
    hold on
    bar(2,nansum(NumRip.Post.Shock.Sess(k,:))./nansum(DurPer.Poqt.Shock.Sess(k,:)),'r')

    subplot(3,5,k+10)
    bar(1,nansum(NumRip.Ext.Safe.Sess(k,:))./nansum(DurPer.Ext.Safe.Sess(k,:)),'b')
    hold on
    bar(2,nansum(NumRip.Ext.Shock.Sess(k,:))./nansum(DurPer.Ext.Shock.Sess(k,:)),'r')
end

figure
subplot(3,1,1)
bar(nanmean(NumRip.Pre.Safe.Sess(:,[1,2,4,5,7,8])'./DurPer.Pre.Safe.Sess(:,[1,2,4,5,7,8])'))
subplot(3,1,2)
bar(nanmean(NumRip.Post.Safe.Sess(:,[1,2,4,5,7,8])'./DurPer.Poqt.Safe.Sess(:,[1,2,4,5,7,8])'))
subplot(3,1,3)
bar(nanmean(NumRip.Ext.Safe.Sess(:,[1,2,4,5])'./DurPer.Ext.Safe.Sess(:,[1,2,4,5])'))
subplot(3,1,1)
bar(nanmean(NumRip.Pre.Shock.Sess(:,[1,2,4,5,7,8])'./DurPer.Pre.Shock.Sess(:,[1,2,4,5,7,8])'))
subplot(3,1,2)
bar(nanmean(NumRip.Post.Shock.Sess(:,[1,2,4,5,7,8])'./DurPer.Poqt.Shock.Sess(:,[1,2,4,5,7,8])'))
subplot(3,1,3)
bar(nanmean(NumRip.Ext.Shock.Sess(:,[1,2,4,5])'./DurPer.Ext.Shock.Sess(:,[1,2,4,5])'))

SessionNames = {'SleepPre_PreDrug','SleepPost_PreDrug','SleepPost_PostDrug'};
figure
for ss = 1:3
    Dir=PathForExperimentsEmbReact(SessionNames{ss});
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            load('StateEpochSB.mat','SWSEpoch','REMEpoch')
            RemSleep(d,dd)  = sum(Stop(REMEpoch)-Start(REMEpoch))./sum(Stop(or(SWSEpoch,REMEpoch))-Start(or(SWSEpoch,REMEpoch)));    end
    end
    subplot(3,1,ss)
    bar(RemSleep)
    set(gca,'XTick',[1:5], 'SAL-old','FLX-old','SAL-old','FLX-old','FLX-new')
end



SessionNames={'UMazeCondExplo_PreDrug','UMazeCondExplo_PostDrug'};
for ss = 1:2
    Dir=PathForExperimentsEmbReact(SessionNames{ss});
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            load('behavResources_SB.mat')
            OccupTime{ss}(d,dd,:) = Results.Occup(1:5);
            FreezeTime{ss}(d,dd,:) = Results.FreezeTime(1:5);
        end
    end
end
figure
subplot(211)
PlotErrorBarN_KJ(squeeze(nanmean(OccupTime{1}([1,3],:,:),2)),'newfig',0)
subplot(212)
PlotErrorBarN_KJ(squeeze(nanmean(OccupTime{2}([1,3],:,:),2)),'newfig',0)
figure
subplot(211)
PlotErrorBarN_KJ(squeeze(nanmean(OccupTime{1}([4,5],:,:),2)),'newfig',0)
subplot(212)
PlotErrorBarN_KJ(squeeze(nanmean(OccupTime{2}([4,5],:,:),2)),'newfig',0)

%%% 

SessionNames={'ExtinctionBlockedShock_EyeShock','ExtinctionBlockedSafe_EyeShock'};
for ss = 1:2
    Dir=PathForExperimentsEmbReact(SessionNames{ss});
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            load('behavResources_SB.mat')
            OccupTime{ss}(d,dd,:) = Results.Occup(1:5);
            FreezeTime{ss}(d,dd,:) = Results.FreezeTime(1:5);
        end
    end
end