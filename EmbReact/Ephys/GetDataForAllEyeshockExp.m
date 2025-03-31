clear all
MouseToAvoid=[560,117,431]; % mice with noisy data to exclude
for k =8
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
    
    clear SpecData SpecDataH SpecDataHLo AllSpecHPC AllSpec NumRip DurPer HRInfo Spectrogram FreezingTime FzEpochLg
    Files=PathForExperimentsEmbReact(SessionNames{1});
    Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
    for mm=1:length(Files.path)
        SpecData{mm}.Shock=[];SpecData{mm}.Safe=[];
        SpecDataH{mm}.Shock=[];SpecDataH{mm}.Safe=[];
        SpecDataHLo{mm}.Shock=[];SpecDataHLo{mm}.Safe=[];
        AllSpecHPC{mm}=[];AllSpec{mm}=[];
               FzEpochLg{mm}.Shock=[];FzEpochLg{mm}.Safe=[];
 for ss=1:length(SessionNames)
            Files=PathForExperimentsEmbReact(SessionNames{ss});
            Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
            for c=1:length(Files.path{mm})
                cd(Files.path{mm}{c})
                load('behavResources_SB.mat')
                dt=median(diff(Range(Behav.Vtsd,'s')));
                if not(isempty(Behav.FreezeAccEpoch))
                    FreezeEpoch=Behav.FreezeAccEpoch;
                else
                    FreezeEpoch=Behav.FreezeEpoch;
                end
                
                load('B_Low_Spectrum.mat')
                fLow=Spectro{3};
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                load('H_Low_Spectrum.mat')
                SptsdHLo=tsd(Spectro{2}*1e4,Spectro{1});
                clear TotalNoiseEpoch smooth_ghi
                load('StateEpochSB.mat','TotalNoiseEpoch','smooth_ghi')
                RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));
                
                
                
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    clear Rip Riptsd RiptsdSL maps stats data
                    load('H_VHigh_Spectrum.mat')
                    SptsdH=tsd(Spectro{2}*1e4,Spectro{1});
                    fHigh=Spectro{3};
                    try
                        load('RipplesSleepThresh.mat')
                        RiptsdSL=ts(RipplesR(:,2)*10);
                        load('Ripples.mat')
                        Riptsd=ts(RipplesR(:,2)*10);
                    catch
                        disp('ripple problem')
                        Riptsd=ts(0.1*1e4);
                        RiptsdSL=ts(0.1*1e4);
                    end
                end
                
                %% On the safe side
                LitEp=dropShortIntervals(and(FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch,3*1e4);
                                FzEpochLg{mm}.Safe=[FzEpoch{mm}.Safe;Stop(LitEpoch,'s')-Start(LitEpoch,'s')];
SpecData{mm}.Safe=[SpecData{mm}.Safe;Data(Restrict(Sptsd,LitEp))];
                SpecDataHLo{mm}.Safe=[SpecDataHLo{mm}.Safe;Data(Restrict(SptsdHLo,LitEp))];
                GammaOB.Safe(mm,c+(ss-1)*3)=nanmean(Data(Restrict(smooth_ghi,LitEp)));
                FreezingTime.Safe(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    SpecDataH{mm}.Safe=[SpecDataH{mm}.Safe;Data(Restrict(SptsdH,LitEp))];
                    if not(isempty(Start(LitEp)))
                        NumRip.Safe.Sess(mm,c+(ss-1)*3)=length(Range(Restrict(Riptsd,LitEp)));
                        DurPer.Safe.Sess(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                        NumRip.Safe.Sleep(mm,c+(ss-1)*3)=length(Range(Restrict(RiptsdSL,LitEp)));
                        DurPer.Safe.Sleep(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                    else
                        NumRip.Safe.Sess(mm,c+(ss-1)*3)=NaN;
                        DurPer.Safe.Sess(mm,c+(ss-1)*3)=NaN;
                        NumRip.Safe.Sleep(mm,c+(ss-1)*3)=NaN;
                        DurPer.Safe.Sleep(mm,c+(ss-1)*3)=NaN;
                        RipAmp.Safe.Sess{mm,c+(ss-1)*3}=NaN;
                        RipDur.Safe.Sess{mm,c+(ss-1)*3}=NaN;
                        RipFreq.Safe.Sess{mm,c+(ss-1)*3}=NaN;
                    end
                    [Spectrogram.Safe{mm,c+(ss-1)*3},S,t]=AverageSpectrogram(SptsdH,fHigh,ts(Range(Restrict(Riptsd,LitEp))),3,200,0,0,0);
                else
                    SpecDataH{mm}.Safe = nan(1,length(fHigh));
                    NumRip.Safe.Sess(mm,c+(ss-1)*3)=NaN;
                    DurPer.Safe.Sess(mm,c+(ss-1)*3)=NaN;
                    NumRip.Safe.Sleep(mm,c+(ss-1)*3)=NaN;
                    DurPer.Safe.Sleep(mm,c+(ss-1)*3)=NaN;
                    RipAmp.Safe.Sess{mm,c+(ss-1)*3}=NaN;
                    RipDur.Safe.Sess{mm,c+(ss-1)*3}=NaN;
                    RipFreq.Safe.Sess{mm,c+(ss-1)*3}=NaN;
                end
                
                %% On the shock side
                LitEp=dropShortIntervals(and(FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch,3*1e4);
                               FzEpochLg{mm}.Shock=[FzEpoch{mm}.Shock;Stop(LitEpoch,'s')-Start(LitEpoch,'s')];
 SpecData{mm}.Shock=[SpecData{mm}.Shock;Data(Restrict(Sptsd,LitEp))];
                SpecDataHLo{mm}.Shock=[SpecDataHLo{mm}.Shock;Data(Restrict(SptsdHLo,LitEp))];
                FreezingTime.Shock(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    SpecDataH{mm}.Shock=[SpecDataH{mm}.Shock;Data(Restrict(SptsdH,LitEp))];
                    if not(isempty(Start(LitEp)))
                        NumRip.Shock.Sess(mm,c+(ss-1)*3)=length(Range(Restrict(Riptsd,LitEp)));
                        DurPer.Shock.Sess(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                        NumRip.Shock.Sleep(mm,c+(ss-1)*3)=length(Range(Restrict(RiptsdSL,LitEp)));
                        DurPer.Shock.Sleep(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
                    else
                        NumRip.Shock.Sess(mm,c+(ss-1)*3)=NaN;
                        DurPer.Shock.Sess(mm,c+(ss-1)*3)=NaN;
                        NumRip.Shock.Sleep(mm,c+(ss-1)*3)=NaN;
                        DurPer.Shock.Sleep(mm,c+(ss-1)*3)=NaN;
                        RipAmp.Shock.Sess{mm,c+(ss-1)*3}=NaN;
                        RipDur.Shock.Sess{mm,c+(ss-1)*3}=NaN;
                        RipFreq.Shock.Sess{mm,c+(ss-1)*3}=NaN;
                        
                    end
                    [Spectrogram.Shock{mm,c+(ss-1)*3},S,t]=AverageSpectrogram(SptsdH,fHigh,ts(Range(Restrict(Riptsd,LitEp))),5,200,0,0,0);
                else
                    SpecDataH{mm}.Shock = nan(1,length(fHigh));
                    NumRip.Shock.Sess(mm,c+(ss-1)*3)=NaN;
                    DurPer.Shock.Sess(mm,c+(ss-1)*3)=NaN;
                    NumRip.Shock.Sleep(mm,c+(ss-1)*3)=NaN;
                    DurPer.Shock.Sleep(mm,c+(ss-1)*3)=NaN;
                    RipAmp.Shock.Sess{mm,c+(ss-1)*3}=NaN;
                    RipDur.Shock.Sess{mm,c+(ss-1)*3}=NaN;
                    RipFreq.Shock.Sess{mm,c+(ss-1)*3}=NaN;
                end
                GammaOB.Shock(mm,c+(ss-1)*3)=nanmean(Data(Restrict(smooth_ghi,LitEp)));
                
                if exist('ChannelsToAnalyse/EKG.mat')
                    load('HeartBeatInfo.mat')
                    LitEp=dropShortIntervals(and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch,5*1e4);
                    [HRInfo.Shk{mm,c+(ss-1)*3},HRSliceBySlice.Shk{mm,c+(ss-1)*3},SliceDur.Shk{mm,c+(ss-1)*3}]=CharacterizeHeartRateEpoch(EKG,LitEp,2);
                    LitEp=dropShortIntervals(and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch,5*1e4);
                    [HRInfo.Sf{mm,c+(ss-1)*3},HRSliceBySlice.Sf{mm,c+(ss-1)*3},SliceDur.Sf{mm,c+(ss-1)*3}]=CharacterizeHeartRateEpoch(EKG,LitEp,2);
                    LitEp=dropShortIntervals(intervalSet(0,max(Range(EKG.HBRate)))-RemovEpoch,5*1e4);
                    [HRInfo.Mv{mm,c+(ss-1)*3},HRSliceBySlice.Mv{mm,c+(ss-1)*3},SliceDur.Mv{mm,c+(ss-1)*3}]=CharacterizeHeartRateEpoch(EKG,LitEp,2);
                    
                end
            end
            
        end
    end
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis
    if k ==1
        save('PreDrugAnalysis.mat','SpecData','FzEpochLg','SpecDataH','SpecDataHLo','AllSpecHPC','AllSpec','HRInfo','NumRip','DurPer','fLow','fHigh','FreezingTime')
    elseif k==2
        save('PostDrugAnalysis.mat','SpecData','FzEpochLg','SpecDataH','SpecDataHLo','AllSpecHPC','AllSpec','HRInfo','NumRip','DurPer','fLow','fHigh','FreezingTime')
    elseif k==3
        save('PostDrugExtAnalysis.mat','SpecData','FzEpochLg','SpecDataH','SpecDataHLo','AllSpecHPC','AllSpec','HRInfo','NumRip','DurPer','fLow','fHigh','FreezingTime')
    elseif k==4
        save('EyeshockNotreatmentAnalysis.mat','FzEpochLg','SpecData','SpecDataH','SpecDataHLo','AllSpecHPC','AllSpec','HRInfo','NumRip','DurPer','fLow','fHigh','FreezingTime')
    elseif k==5
        save('EyeshockExtNotreatmentAnalysis.mat','FzEpochLg','SpecData','SpecDataH','SpecDataHLo','AllSpecHPC','AllSpec','HRInfo','NumRip','DurPer','fLow','fHigh','FreezingTime')
    elseif k==6
        save('TempFLXProtPreDrugAnalysis.mat','FzEpochLg','SpecData','SpecDataH','SpecDataHLo','AllSpecHPC','AllSpec','HRInfo','NumRip','DurPer','fLow','fHigh','FreezingTime')
    elseif k==7
        save('TempFLXProtPostDrugExtAnalysis.mat','FzEpochLg','SpecData','SpecDataH','SpecDataHLo','AllSpecHPC','AllSpec','HRInfo','NumRip','DurPer','fLow','fHigh','FreezingTime')
    elseif k==8
        save('PAGAnalysis.mat','FzEpochLg','SpecData','SpecDataH','SpecDataHLo','AllSpecHPC','AllSpec','HRInfo','NumRip','DurPer','fLow','fHigh','FreezingTime')
    end
end


%% Now use it
ToLoad = {'EyeshockNotreatmentAnalysis','PreDrugAnalysis','PostDrugAnalysis','EyeshockExtNotreatmentAnalysis','PostDrugExtAnalysis'};
Split=[0,1,1,0,1];
figure
for t = 1:length(ToLoad)
    load(ToLoad{t})
    for mm=1:size(SpecData,2)
        denom = 1;
        AllShockB(mm,:)=nanmean(SpecData{mm}.Shock)./denom;
        AllSafeB(mm,:)=nanmean(SpecData{mm}.Safe)./denom;
        denom = 1;
        AllShockH(mm,:)=nanmean(SpecDataH{mm}.Shock)./denom;
        AllSafeH(mm,:)=nanmean(SpecDataH{mm}.Safe)./denom;
        denom = 1;
        AllShockHLo(mm,:)=nanmean(SpecDataHLo{mm}.Shock)./denom;
        AllSafeHLo(mm,:)=nanmean(SpecDataHLo{mm}.Safe)./denom;
    end
    AllShock = (AllShockB);
    AllSafe = (AllSafeB);
    f = fLow;
    if Split(t) ==0
        subplot(2,length(ToLoad),t)
        [hl,hp]=boundedline( f,nanmean(AllShock),[stdError(AllShock);stdError(AllShock)]','r','alpha');hold on
        [hl,hp]=boundedline( f,nanmean(AllSafe),[stdError(AllSafe);stdError(AllSafe)]','b','alpha');
        title(ToLoad{t})
        %         line([6 6],ylim,'color','k')
        %         line([3 3],ylim,'color','k')
    else
        subplot(2,length(ToLoad),t)
        try,[hl,hp]=boundedline( f,nanmean(AllShock(Inj==0,:)),[stdError(AllShock(Inj==0,:));stdError(AllShock(Inj==0,:))]','r','alpha');hold on,end
        try,[hl,hp]=boundedline( f,nanmean(AllSafe(Inj==0,:)),[stdError(AllSafe(Inj==0,:));stdError(AllSafe(Inj==0,:))]','b','alpha');,end
        title(ToLoad{t})
        %         line([6 6],ylim,'color','k')
        %         line([3 3],ylim,'color','k')
        subplot(2,length(ToLoad),t+length(ToLoad))
        try,[hl,hp]=boundedline( f,nanmean(AllShock(Inj==1,:)),[stdError(AllShock(Inj==1,:));stdError(AllShock(Inj==1,:))]','r','alpha');hold on,end
        try,[hl,hp]=boundedline( f,nanmean(AllSafe(Inj==1,:)),[stdError(AllSafe(Inj==1,:));stdError(AllSafe(Inj==1,:))]','b','alpha');,end
        title(ToLoad{t})
        %         line([6 6],ylim,'color','k')
        %         line([3 3],ylim,'color','k')
        
    end
end


%% HB
figure
for t = 1:length(ToLoad)
    load(ToLoad{t})
    
    for mm = 1:size(HRInfo.Shk,1)
        for c=1:size(HRInfo.Shk,2)
            if isempty( HRInfo.Shk{mm,c})
                HRSk(mm,c) =NaN;
            else
                HRSk(mm,c) = HRInfo.Shk{mm,c}.MeanHR;
            end
            if isempty( HRInfo.Sf{mm,c})
                HRSf(mm,c) =NaN;
            else
                HRSf(mm,c) = HRInfo.Sf{mm,c}.MeanHR;
            end
            if isempty( HRInfo.Mv{mm,c})
                HRMv(mm,c) =NaN;
            else
                HRMv(mm,c) = HRInfo.Mv{mm,c}.MeanHR;
            end
            
        end
    end
    
    if Split(t) ==0
        subplot(2,length(ToLoad),t)
        bar(1,nanmean(nanmean(HRSf)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk)),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv)),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf'),nanmean(HRSk'),nanmean(HRMv')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 14])
        ylabel('HR (Hz)')
        title(ToLoad{t})
        
    else
        subplot(2,length(ToLoad),t)
        bar(1,nanmean(nanmean(HRSf(Inj==0,:))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk(Inj==0,:))),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv(Inj==0,:))),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf(Inj==0,:)'),nanmean(HRSk(Inj==0,:)'),nanmean(HRMv(Inj==0,:)')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 14])
        ylabel('HR (Hz)')
        title(ToLoad{t})
        
        subplot(2,length(ToLoad),t+length(ToLoad))
        bar(1,nanmean(nanmean(HRSf(Inj==1,:))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk(Inj==1,:))),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv(Inj==1,:))),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf(Inj==1,:)'),nanmean(HRSk(Inj==1,:)'),nanmean(HRMv(Inj==1,:)')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 14])
        ylabel('HR (Hz)')
        
    end
end


%% HB
figure
for t = 1:length(ToLoad)
    load(ToLoad{t})
    
    for mm = 1:size(HRInfo.Shk,1)
        for c=1:size(HRInfo.Shk,2)
            if isempty( HRInfo.Shk{mm,c})
                HRSk(mm,c) =NaN;
            else
                HRSk(mm,c) = HRInfo.Shk{mm,c}.StdHR;
            end
            if isempty( HRInfo.Sf{mm,c})
                HRSf(mm,c) =NaN;
            else
                HRSf(mm,c) = HRInfo.Sf{mm,c}.StdHR;
            end
            if isempty( HRInfo.Mv{mm,c})
                HRMv(mm,c) =NaN;
            else
                HRMv(mm,c) = HRInfo.Mv{mm,c}.StdHR;
            end
            
        end
    end
    
    if Split(t) ==0
        subplot(2,length(ToLoad),t)
        bar(1,nanmean(nanmean(HRSf)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk)),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv)),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf'),nanmean(HRSk'),nanmean(HRMv')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 2])
        ylabel('HR var')
        title(ToLoad{t})
        
    else
        subplot(2,length(ToLoad),t)
        bar(1,nanmean(nanmean(HRSf(Inj==0,:))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk(Inj==0,:))),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv(Inj==0,:))),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf(Inj==0,:)'),nanmean(HRSk(Inj==0,:)'),nanmean(HRMv(Inj==0,:)')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 2])
        ylabel('HR var')
        title(ToLoad{t})
        
        subplot(2,length(ToLoad),t+length(ToLoad))
        bar(1,nanmean(nanmean(HRSf(Inj==1,:))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk(Inj==1,:))),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv(Inj==1,:))),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf(Inj==1,:)'),nanmean(HRSk(Inj==1,:)'),nanmean(HRMv(Inj==1,:)')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 2])
        ylabel('HR var')
        
    end
end


%% ripples


figure
for t = 1:length(ToLoad)
    load(ToLoad{t})
  
    if Split(t) ==0
        subplot(2,length(ToLoad),t)
        
        RipSk = nansum(NumRip.Shock.Sleep')./nansum(DurPer.Shock.Sleep');
        RipSf = nansum(NumRip.Safe.Sleep')./nansum(DurPer.Safe.Sleep');

        bar(1,nanmean(nanmean(RipSf)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(RipSk)),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(RipSf'),(RipSk')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 1])
        ylabel('Ripple /s')
        title(ToLoad{t})
        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
    else
        RipSk = nansum(NumRip.Shock.Sess')./nansum(DurPer.Shock.Sess');
        RipSf = nansum(NumRip.Safe.Sess')./nansum(DurPer.Safe.Sess');

        subplot(2,length(ToLoad),t)
        bar(1,nanmean(nanmean(RipSf(Inj==0))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(RipSk(Inj==0))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(RipSf(Inj==0)'),(RipSk(Inj==0)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 1])
        ylabel('Ripple /s')
        title(ToLoad{t})
        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
        subplot(2,length(ToLoad),t+length(ToLoad))
        bar(1,nanmean(nanmean(RipSf(Inj==1))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(RipSk(Inj==1))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(RipSf(Inj==1)'),(RipSk(Inj==1)')},'distributionColors',[ 0 0 0;0 0 0;],'xValues',[1,2])
        ylim([0 1])
        ylabel('Ripples /s')
        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
    end
end
