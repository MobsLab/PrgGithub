clear all
MouseToAvoid=[560,117,431]; % mice with noisy data to exclude
dt_end=0.5;

for k =5
    if k==1
        SessionNames={'UMazeCondExplo_PreDrug', 'UMazeCondBlockedShock_PreDrug', 'UMazeCondBlockedSafe_PreDrug'};
    elseif k==2
        SessionNames={'UMazeCondExplo_PostDrug', 'UMazeCondBlockedShock_PostDrug', 'UMazeCondBlockedSafe_PostDrug'};
    elseif k==3
        SessionNames={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
    elseif k==4
        SessionNames={'UMazeCond_EyeShock', 'UMazeCondBlockedShock_EyeShock', 'UMazeCondBlockedSafe_EyeShock'};
    elseif k==5
        SessionNames={'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock' };
    elseif k==6
        SessionNames={'UMazeCond_PreDrug_TempProt', 'UMazeCondBlockedShock_PreDrug_TempProt', 'UMazeCondBlockedSafe_PreDrug_TempProt'};
    elseif k==7
        SessionNames={'ExtinctionBlockedShock_PostDrug_TempProt', 'ExtinctionBlockedSafe_PostDrug_TempProt'};
    elseif k==8
        SessionNames={'UMazeCond'};
    end
    disp(SessionNames{1})
    
    clear FreezingTime FzEpochLg PeakSafe TroughSafe PeakShock TroughShock
    Files=PathForExperimentsEmbReact(SessionNames{1});
    Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
    for mm=1:length(Files.path)
        
        disp(['Mouse ', num2str(Files.ExpeInfo{mm}{1}.nmouse)])
        AllInfo.OBFreqWV{mm}=[];
        AllInfo.OBFreqPT{mm}=[];
        AllInfo.HBRate{mm}=[];
        AllInfo.HBVar{mm}=[];
        AllInfo.Ripples{mm}=[];
        AllInfo.Position{mm}=[];
        AllInfo.Freeze{mm}=[];
        PeakShock{mm}=[];PeakSafe{mm}=[];
        TroughShock{mm}=[];TroughSafe{mm}=[];
        for ss=1:length(SessionNames)
            Files=PathForExperimentsEmbReact(SessionNames{ss});
            Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
            for c=1:length(Files.path{mm})
                
                clear RipBand LocalFreq Spectro Behav
                cd(Files.path{mm}{c})
                load('behavResources_SB.mat')
                dt=median(diff(Range(Behav.Vtsd,'s')));
                if not(isempty(Behav.FreezeAccEpoch))
                    FreezeEpoch=Behav.FreezeAccEpoch;
                else
                    FreezeEpoch=Behav.FreezeEpoch;
                end
                
                clear TotalNoiseEpoch smooth_ghi
                load('StateEpochSB.mat','TotalNoiseEpoch','smooth_ghi')
                RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));
                
                %% resample everything
                
                load('InstFreqAndPhase_B.mat')
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP',num2str(channel),'.mat'])
                
                AllPeaks_ts = ts(AllPeaks(AllPeaks(:,2)==1,1)*1E4);
                AllTroughs_ts = ts(AllPeaks(AllPeaks(:,2)==-1,1)*1E4);
                LitEp=dropShortIntervals(and(FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch,3*1e4);
                [M,T] = PlotRipRaw(LFP, Range(Restrict(AllPeaks_ts,LitEp),'s'),500,0,0);
                if not(isempty(M)), PeakShock{mm} = [PeakShock{mm},M(:,2)];end
                [M,T] = PlotRipRaw(LFP, Range(Restrict(AllTroughs_ts,LitEp),'s'),500,0,0);
                if not(isempty(M)), TroughShock{mm} = [TroughShock{mm},M(:,2)];end
                
                LitEp=dropShortIntervals(and(FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch,3*1e4);
                [M,T] = PlotRipRaw(LFP, Range(Restrict(AllPeaks_ts,LitEp),'s'),500,0,0);
                if not(isempty(M)),PeakSafe{mm} = [PeakSafe{mm},M(:,2)];end
                [M,T] = PlotRipRaw(LFP, Range(Restrict(AllTroughs_ts,LitEp),'s'),500,0,0);
                if not(isempty(M)),TroughSafe{mm} = [TroughSafe{mm},M(:,2)];end
            end
        end
        
    end
    
    tps  = M(:,1);
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis
    if k ==1
        save('PreDrugAnalysis_BreathShapeFz.mat','TroughSafe','PeakSafe','TroughShock','PeakShock','tps')
    elseif k==2
        save('PostDrugAnalysis_BreathShapeFz.mat','TroughSafe','PeakSafe','TroughShock','PeakShock','tps')
    elseif k==3
        save('PostDrugExtAnalysis_BreathShapeFz.mat','TroughSafe','PeakSafe','TroughShock','PeakShock','tps')
    elseif k==4
        save('EyeshockNotreatmentAnalysis_BreathShapeFz.mat','TroughSafe','PeakSafe','TroughShock','tps','PeakShock')
    elseif k==5
        save('EyeshockExtNotreatmentAnalysis_BreathShapeFz.mat','TroughSafe','PeakSafe','TroughShock','tps','PeakShock')
    elseif k==6
        save('TempFLXProtPreDrugAnalysis_BreathShapeFz.mat','TroughSafe','PeakSafe','TroughShock','tps','PeakShock')
    elseif k==7
        save('TempFLXProtPostDrugExtAnalysis_BreathShapeFz.mat','TroughSafe','PeakSafe','tps','TroughShock','PeakShock')
    elseif k==8
        save('PAGAnalysis_BreathShapeFz.mat','TroughSafe','PeakSafe','TroughShock','tps','PeakShock')
    end
end


%%
figure
for mm = 1 : length(TroughShock)
    subplot(2,2,1), hold on
    plot(tps,nanmean(TroughShock{mm},2))
    ylim([-5000 5000])
    subplot(2,2,2), hold on
    plot(tps,nanmean(PeakShock{mm},2))
    ylim([-5000 5000])
    subplot(2,2,3), hold on
    plot(tps,nanmean(TroughSafe{mm},2))
    ylim([-5000 5000])
    subplot(2,2,4), hold on
    plot(tps,nanmean(PeakSafe{mm},2))
    ylim([-5000 5000])
end
subplot(2,2,1)
title('Trough Shock')
subplot(2,2,2)
title('Peak Shock')
subplot(2,2,3)
title('Trough Safe')
subplot(2,2,4)
title('Peak Safe')

% Compare shape
for mm = 1 : length(TroughShock)
    dat = nanmean(TroughShock{mm},2);
    if not(isempty(dat))
        Start = find(dat(1:625)>0,1,'last');
        Stop = find(dat(625:end)>0,1,'first')+625;
        TrShock(mm,2) = Stop-625;
        TrShock(mm,1) = 625-Start;
    else
        TrShock(mm,1:2)  = NaN;
    end
    
    dat = nanmean(TroughSafe{mm},2);
    if not(isempty(dat))
        Start = find(dat(1:625)>0,1,'last');
        Stop = find(dat(625:end)>0,1,'first')+625;
        TrSafe(mm,2) = Stop-625;
        TrSafe(mm,1) = 625-Start;
    else
        TrSafe(mm,1:2)  = NaN;
    end
    
    dat = nanmean(PeakShock{mm},2);
    if not(isempty(dat))
        Start = find(dat(1:625)<0,1,'last');
        Stop = find(dat(625:end)<0,1,'first')+625;
        PkShock(mm,2) = Stop-625;
        PkShock(mm,1) = 625-Start;
    else
        PkShock(mm,1:2)  = NaN;
    end
    
    dat = nanmean(PeakSafe{mm},2);
    if not(isempty(dat))
        Start = find(dat(1:625)<0,1,'last');
        Stop = find(dat(625:end)<0,1,'first')+625;
        PkSafe(mm,2) = Stop-625;
        PkSafe(mm,1) = 625-Start;
    else
        PkSafe(mm,1:2)  = NaN;
    end
end
figure
subplot(2,2,1)
PlotErrorBarN_KJ(TrShock,'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Bef','Aft'}), ylim([0 150])
title('Trough Shock')
subplot(2,2,2)
PlotErrorBarN_KJ(PkShock,'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Bef','Aft'}), ylim([0 150])
title('Peak Shock')
subplot(2,2,3)
PlotErrorBarN_KJ(TrSafe,'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Bef','Aft'}), ylim([0 150])
title('Trough Safe')
subplot(2,2,4)
PlotErrorBarN_KJ(PkSafe,'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Bef','Aft'}), ylim([0 150])
title('Peak Safe')


TroughShock_All=[];TroughSafe_All=[];
PeakShock_All=[];PeakSafe_All=[];

for mm = 1 : length(TroughShock)
    subplot(2,2,1), hold on
    TroughShock_All = [TroughShock_All,nanmean(TroughShock{mm},2)];
    TroughSafe_All = [TroughSafe_All,nanmean(TroughSafe{mm},2)];
    PeakShock_All = [PeakShock_All,nanmean(PeakShock{mm},2)];
    PeakSafe_All = [PeakSafe_All,nanmean(PeakSafe{mm},2)];
end

figure
subplot(221)
errorbar(tps,nanmean(TroughSafe_All'),stdError(TroughSafe_All')), hold on
subplot(222)
errorbar(tps,nanmean(PeakSafe_All'),stdError(PeakSafe_All'))
subplot(223)
errorbar(tps,nanmean(TroughShock_All'),stdError(TroughShock_All')), hold on
subplot(224)
errorbar(tps,nanmean(PeakShock_All'),stdError(PeakShock_All'))
