%% This codes looks at what neurons are doing
clear all, close all

MiceNumber=[490,507,508,509,510,514]; % add 512 back in later
SessNames={'Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction'};
NumBt=200;
UMazeRegNames={'Shock','NoShock','Centre','CentreShock','CentreNoShock';'ShockRun','NoShockRun','CentreRun','CentreShockRun','CentreNoShockRun'};
SpeedThresh=5; % cm/s
Alpha2Side=[2.5,97.5];
Alpha1Side=[5,95];
MinNumSpikes=100;
SoundPSTHDur=40;
NaNForPhaseLocking.NonTransf=NaN;
NaNForPhaseLocking.Transf=NaN;
for ss=2
    Dir=PathForExperimentsEmbReactMontreal(SessNames{ss});
    for mm=1:length(MiceNumber)
        for d=1:length(Dir.path)
            if Dir.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                
                %% UmazeHab
                if strcmp(SessNames{ss},'Habituation') | strcmp(SessNames{ss},'HabituationNight')
                    cd(Dir.path{d}{1})
                    disp(['Mouse' num2str(MiceNumber(mm)),' UmazeHab'])
                    load('SpikeData.mat')
                    load('behavResources.mat')
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('LFPData/LFP0.mat')
                    TotEpoch=intervalSet(0,max(Range(LFP)));
                    TotEpoch=TotEpoch-SleepyEpoch;
                    for sp=1:length(S)
                        [UMazeHab.map{mm}{sp},UMazeHab.stats{mm}{sp},UMazeHab.ZoneFr{mm}{sp},UMazeHab.ZoneFrRand{mm}{sp}]=UMazeSpatialPatterns(S{sp},Behav.Xtsd,Behav.Ytsd,TotEpoch,SpeedThresh,Behav.ZoneEpoch,0,NumBt);
                    end
                end
                
                %% UmazeExt
                if strcmp(SessNames{ss},'Extinction') | strcmp(SessNames{ss},'ExtinctionNight')
                    cd(Dir.path{d}{1})
                    disp(['Mouse' num2str(MiceNumber(mm)),' UmazeExt'])
                    load('SpikeData.mat')
                    load('behavResources.mat')
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('LFPData/LFP0.mat')
                    TotEpoch=intervalSet(0,max(Range(LFP)));
                    TotEpoch=TotEpoch-SleepyEpoch;
                    for sp=1:length(S)
                        [UMazeExt.map{mm}{sp},UMazeExt.stats{mm}{sp},UMazeExt.ZoneFr{mm}{sp},UMazeExt.ZoneFrRand{mm}{sp}]=UMazeSpatialPatterns(S{sp},Behav.Xtsd,Behav.Ytsd,TotEpoch,SpeedThresh,Behav.ZoneEpoch,0,NumBt);
                    end
                end
                
                %% TestPre
                if strcmp(SessNames{ss},'TestPre') | strcmp(SessNames{ss},'TestPreNight')
                    for dd=1:4
                        cd(Dir.path{d}{dd})
                        load('SpikeData.mat')
                        load('behavResources.mat')
                        load('ExpeInfo.mat')
                        load('StateEpochSB.mat','SleepyEpoch')
                        load('LFPData/LFP0.mat')
                        TotEpoch=intervalSet(0,max(Range(LFP)));
                        TotEpoch=TotEpoch-SleepyEpoch;
                        AllS{ExpeInfo.SessionNumber}=S;
                        AllBehav{ExpeInfo.SessionNumber}=Behav;
                        TEnd(ExpeInfo.SessionNumber+1)=max(Range(LFP));
                        AllZoneEpoch{ExpeInfo.SessionNumber}=Behav.ZoneEpoch;
                        AllTotEpoch{ExpeInfo.SessionNumber}=TotEpoch;
                        keyboard
                        if ExpeInfo.SessionNumber==4
                            disp(['Mouse' num2str(MiceNumber(mm)),' UmazeTestPre'])
                            TEnd=[cumsum(TEnd)];
                            % Concatenate
                            X=[]; Y=[]; XYTimes=[];
                            TotEpochStrStp=[];
                            for z=1:5,ZoneEpStrStp{z}=[];end
                            for sp=1:length(S),STimes{sp}=[];end
                            for k=1:4
                                for sp=1:length(S),STimes{sp}=[STimes{sp};Range(AllS{k}{sp})+TEnd(k)]; end
                                X=[X;Data(AllBehav{k}.Xtsd)];
                                Y=[Y;Data(AllBehav{k}.Ytsd)];
                                TotEpochStrStp=[TotEpochStrStp;[Start(AllTotEpoch{k})+TEnd(k),Stop(AllTotEpoch{k})+TEnd(k)]];
                                XYTimes=[XYTimes;Range(AllBehav{k}.Ytsd)+TEnd(k)];
                                for z=1:5,ZoneEpStrStp{z}=[ZoneEpStrStp{z};[Start(AllZoneEpoch{k}{z})+TEnd(k),Stop(AllZoneEpoch{k}{z})+TEnd(k)]];end
                            end
                            clear S Xtsd Ytsd ZoneEpoch TotEpoch
                            Xtsd=tsd(XYTimes,X);
                            Ytsd=tsd(XYTimes,Y);
                            for z=1:5,ZoneEpoch{z}=intervalSet(ZoneEpStrStp{z}(:,1),ZoneEpStrStp{z}(:,2));end
                            for sp=1:length(STimes),S{sp}=tsd(STimes{sp},STimes{sp}); end
                            TotEpoch=intervalSet(TotEpochStrStp(:,1),TotEpochStrStp(:,2));
                            for sp=1:length(S)
                                [UMazeTestPre.map{mm}{sp},UMazeTestPre.stats{mm}{sp},UMazeTestPre.ZoneFr{mm}{sp},UMazeTestPre.ZoneFrRand{mm}{sp}]=UMazeSpatialPatterns(S{sp},Xtsd,Ytsd,TotEpoch,SpeedThresh,ZoneEpoch,0,NumBt);
                            end
                            
                            clear AllS AllBehav TEnd X Y XYTimes STimes ZoneEpStrStp AllZoneEpoch AllTotEpoch TotEpochStrStp
                            
                        end
                    end
                end
                
                %% TestPost
                if strcmp(SessNames{ss},'TestPost') | strcmp(SessNames{ss},'TestPostNight')
                    for dd=1:4
                        cd(Dir.path{d}{dd})
                        load('SpikeData.mat')
                        load('behavResources.mat')
                        load('ExpeInfo.mat')
                        load('StateEpochSB.mat','SleepyEpoch')
                        load('LFPData/LFP0.mat')
                        TotEpoch=intervalSet(0,max(Range(LFP)));
                        TotEpoch=TotEpoch-SleepyEpoch;
                        AllS{ExpeInfo.SessionNumber}=S;
                        AllBehav{ExpeInfo.SessionNumber}=Behav;
                        TEnd(ExpeInfo.SessionNumber+1)=max(Range(LFP));
                        AllZoneEpoch{ExpeInfo.SessionNumber}=Behav.ZoneEpoch;
                        AllTotEpoch{ExpeInfo.SessionNumber}=TotEpoch;
                        
                        if ExpeInfo.SessionNumber==4
                            disp(['Mouse' num2str(MiceNumber(mm)),' UMazeTestPost'])
                            TEnd=[cumsum(TEnd)];
                            % Concatenate
                            X=[]; Y=[]; XYTimes=[];
                            TotEpochStrStp=[];
                            for z=1:5,ZoneEpStrStp{z}=[];end
                            for sp=1:length(S),STimes{sp}=[];end
                            for k=1:4
                                for sp=1:length(S),STimes{sp}=[STimes{sp};Range(AllS{k}{sp})+TEnd(k)]; end
                                X=[X;Data(AllBehav{k}.Xtsd)];
                                Y=[Y;Data(AllBehav{k}.Ytsd)];
                                TotEpochStrStp=[TotEpochStrStp;[Start(AllTotEpoch{k})+TEnd(k),Stop(AllTotEpoch{k})+TEnd(k)]];
                                XYTimes=[XYTimes;Range(AllBehav{k}.Ytsd)+TEnd(k)];
                                for z=1:5,ZoneEpStrStp{z}=[ZoneEpStrStp{z};[Start(AllZoneEpoch{k}{z})+TEnd(k),Stop(AllZoneEpoch{k}{z})+TEnd(k)]];end
                            end
                            clear S Xtsd Ytsd ZoneEpoch TotEpoch
                            Xtsd=tsd(XYTimes,X);
                            Ytsd=tsd(XYTimes,Y);
                            for z=1:5,ZoneEpoch{z}=intervalSet(ZoneEpStrStp{z}(:,1),ZoneEpStrStp{z}(:,2));end
                            for sp=1:length(STimes),S{sp}=tsd(STimes{sp},STimes{sp}); end
                            TotEpoch=intervalSet(TotEpochStrStp(:,1),TotEpochStrStp(:,2));
                            
                            for sp=1:length(S)
                                [UMazeTestPost.map{mm}{sp},UMazeTestPost.stats{mm}{sp},UMazeTestPost.ZoneFr{mm}{sp},UMazeTestPost.ZoneFrRand{mm}{sp}]=UMazeSpatialPatterns(S{sp},Xtsd,Ytsd,TotEpoch,SpeedThresh,ZoneEpoch,0,NumBt);
                            end
                            
                            clear AllS AllBehav TEnd X Y XYTimes STimes ZoneEpStrStp AllZoneEpoch AllTotEpoch TotEpochStrStp
                        end
                    end
                end
                
                %% UMazeCond
                if strcmp(SessNames{ss},'UMazeCond') | strcmp(SessNames{ss},'UMazeCondNight')
                    for dd=1:5
                        cd(Dir.path{d}{dd})
                        load('SpikeData.mat')
                        load('behavResources.mat')
                        load('ExpeInfo.mat')
                        load('LFPData/LFP0.mat')
                        load('StateEpochSB.mat','SleepyEpoch')
                        load('LFPData/LFP0.mat')
                        TotEpoch=intervalSet(0,max(Range(LFP)))-SleepyEpoch;
                        AllS{ExpeInfo.SessionNumber}=S;
                        AllBehav{ExpeInfo.SessionNumber}=Behav;
                        TEnd(ExpeInfo.SessionNumber+1)=max(Range(LFP));
                        AllZoneEpoch{ExpeInfo.SessionNumber}=Behav.ZoneEpoch;
                        AllZFreezeEpoch{ExpeInfo.SessionNumber}=Behav.FreezeEpoch;
                        AllTotEpoch{ExpeInfo.SessionNumber}=TotEpoch;
                        load('ChannelsToAnalyse/Bulb_deep.mat'),load(['LFPData/LFP',num2str(channel),'.mat'])
                        Fil=FilterLFP(LFP,[2 8],1024);
                        AllFil{ExpeInfo.SessionNumber}=Fil;
                        load('InstFreqAndPhase.mat','LocalPhase')
                        AllWv{ExpeInfo.SessionNumber}=tsd(Range(LocalPhase.WV),mod(Data(LocalPhase.WV)+2*pi,2*pi));
                        
                        if ExpeInfo.SessionNumber==5
                            disp(['Mouse' num2str(MiceNumber(mm)),' UMazeCond'])
                            TEnd=[cumsum(TEnd)];
                            % Concatenate
                            X=[]; Y=[]; XYTimes=[];
                            FilData=[]; FilTimes=[];
                            WVData=[]; WVTimes=[];
                            for z=1:5,ZoneEpStrStp{z}=[];end
                            FreezeEpStpStr=[];
                            TotEpochStrStp=[];
                            for sp=1:length(S),STimes{sp}=[];end
                            for k=1:4
                                for sp=1:length(S),STimes{sp}=[STimes{sp};Range(AllS{k}{sp})+TEnd(k)]; end
                                X=[X;Data(AllBehav{k}.Xtsd)];Y=[Y;Data(AllBehav{k}.Ytsd)];
                                XYTimes=[XYTimes;Range(AllBehav{k}.Ytsd)+TEnd(k)];
                                FilData=[FilData;Data(AllFil{k})];
                                FilTimes=[FilTimes;Range(AllFil{k})+TEnd(k)];
                                WVData=[WVData;Data(AllWv{k})];
                                WVTimes=[WVTimes;Range(AllWv{k})+TEnd(k)];
                                for z=1:5,ZoneEpStrStp{z}=[ZoneEpStrStp{z};[Start(AllZoneEpoch{k}{z})+TEnd(k),Stop(AllZoneEpoch{k}{z})+TEnd(k)]];end
                                FreezeEpStpStr=[FreezeEpStpStr;[Start(AllZFreezeEpoch{z})+TEnd(k),Stop(AllZFreezeEpoch{z})+TEnd(k)]];
                                TotEpochStrStp=[TotEpochStrStp;[Start(AllTotEpoch{k})+TEnd(k),Stop(AllTotEpoch{k})+TEnd(k)]];
                            end
                            clear S Xtsd Ytsd ZoneEpoch TotEpoch FreezeEpoch LitEp
                            Xtsd=tsd(XYTimes,X);
                            Ytsd=tsd(XYTimes,Y);
                            Filtsd=tsd(FilTimes,FilData);
                            WVtsd=tsd(WVTimes,WVData);
                            for z=1:5,ZoneEpoch{z}=intervalSet(ZoneEpStrStp{z}(:,1),ZoneEpStrStp{z}(:,2));end
                            for sp=1:length(STimes),S{sp}=tsd(STimes{sp},STimes{sp}); end
                            FreezeEpoch=intervalSet(FreezeEpStpStr(:,1),FreezeEpStpStr(:,2));
                            TotEpoch=intervalSet(TotEpochStrStp(:,1),TotEpochStrStp(:,2));
                            LitEp{1}=and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5}));LitEp{1}=and(LitEp{1},TotEpoch);
                            LitEp{2}=and(FreezeEpoch,ZoneEpoch{1});LitEp{2}=and(LitEp{2},TotEpoch);
                            for sp=1:length(S)
                                sp
                                [UMazeCond.map{mm}{sp},UMazeCond.stats{mm}{sp},UMazeCond.ZoneFr{mm}{sp},UMazeCond.ZoneFrRand{mm}{sp}]=UMazeSpatialPatterns(S{sp},Xtsd,Ytsd,TotEpoch,SpeedThresh,ZoneEpoch,MinNumSpikes,NumBt);
                                for z=1:2
                                    UMazeCond.FRZones{mm}{sp}(z)=length(Data(Restrict(S{sp},LitEp{z})))./sum(Stop(LitEp{z},'s')-Start(LitEp{z},'s'));
                                    for k=1:NumBt
                                        ISI=diff(Range(S{sp}));
                                        ISI=ISI(randperm(length(ISI)));
                                        tppossstart=max(Stop(TotEpoch))-sum(ISI);
                                        NewSp=cumsum([tppossstart*rand;ISI]);
                                        NewSp=tsd(NewSp,NewSp);
                                        UMazeCond.FRZonesRand{mm}{sp}(z,k)=length(Data(Restrict(NewSp,LitEp{z})))./sum(Stop(LitEp{z},'s')-Start(LitEp{z},'s'));
                                    end
                                    if (length(Data(Restrict(S{sp},LitEp{z}))))>MinNumSpikes
                                        disp('ok')
                                        [UMazeCond.Fil.PhasesSpikes{mm}{sp,z},UMazeCond.Fil.mu{mm}{sp,z},UMazeCond.Fil.Kappa{mm}{sp,z},UMazeCond.Fil.pval{mm}{sp,z}]=SpikeLFPModulationTransform(S{sp},Filtsd,LitEp{z},15,0,1);
                                        [UMazeCond.WV.PhasesSpikes{mm}{sp,z},UMazeCond.WV.mu{mm}{sp,z},UMazeCond.WV.Kappa{mm}{sp,z},UMazeCond.WV.pval{mm}{sp,z}]=SpikeLFPModulationTransform(S{sp},WVtsd,LitEp{z},15,0,2);
                                    else
                                        disp('no ok')
                                        UMazeCond.Fil.PhasesSpikes{mm}{sp,z}=NaNForPhaseLocking;
                                        UMazeCond.Fil.mu{mm}{sp,z}=NaNForPhaseLocking;
                                        UMazeCond.Fil.Kappa{mm}{sp,z}=NaNForPhaseLocking;
                                        UMazeCond.Fil.pval{mm}{sp,z}=NaNForPhaseLocking;
                                        UMazeCond.WV.PhasesSpikes{mm}{sp,z}=NaNForPhaseLocking;
                                        UMazeCond.WV.mu{mm}{sp,z}=NaNForPhaseLocking;
                                        UMazeCond.WV.Kappa{mm}{sp,z}=NaNForPhaseLocking;
                                        UMazeCond.WV.pval{mm}{sp,z}=NaNForPhaseLocking;
                                    end
                                end
                            end
                            
                            clear AllS AllBehav TEnd X Y XYTimes STimes ZoneEpStrStp AllZoneEpoch AllTotEpoch TotEpochStrStp FreezeEpStpStr FilData AllFil FilTimes WVTimes AllWv WVData
                        end
                    end
                end
            end
        end
    end
end
figure
AllPhase=[];AllKappa=[];
for mm=1:length(MiceNumber)
    for sp=1:length(UMazeCond.Fil.PhasesSpikes{mm})
        AllKappa=[AllKappa;[UMazeCond.WV.Kappa{mm}{sp,1}.Transf,UMazeCond.WV.Kappa{mm}{sp,2}.Transf]];
        AllPhase=[AllPhase;[UMazeCond.WV.mu{mm}{sp,1}.Transf,UMazeCond.WV.mu{mm}{sp,2}.Transf]];
    end
end
subplot(221)
plot(AllKappa(:,1),AllKappa(:,1),'k*')
hold on
plot(AllKappa(:,1),AllKappa(:,2),'b*')
xlabel('NoShck'),ylabel('Shck')
axis square
subplot(222)
plot(AllPhase(:,1),AllPhase(:,2),'*')
axis square
xlabel('NoShck'),ylabel('Shck')
xlim([0 2*pi]),ylim([0 2*pi])
subplot(223)
[Y,X]=hist([AllPhase(:,1);AllPhase(:,1)+2*pi],20);Y=Y/sum(Y);
stairs(X,Y,'linewidth',2)
hold on
[Y,X]=hist([AllPhase(:,2);AllPhase(:,2)+2*pi],20);Y=Y/sum(Y);
stairs(X,Y,'linewidth',2)
legend('NoShck','Shck')

figure
AllPhase=[];AllKappa=[];
for mm=1:length(MiceNumber)
    for sp=1:length(UMazeCond.Fil.PhasesSpikes{mm})
        AllKappa=[AllKappa;[UMazeCond.Fil.Kappa{mm}{sp,1}.Transf,UMazeCond.Fil.Kappa{mm}{sp,2}.Transf]];
        AllPhase=[AllPhase;[UMazeCond.Fil.mu{mm}{sp,1}.Transf,UMazeCond.Fil.mu{mm}{sp,2}.Transf]];
    end
end
subplot(221)
plot(AllKappa(:,1),AllKappa(:,1),'k*')
hold on
plot(AllKappa(:,1),AllKappa(:,2),'b*')
xlabel('NoShck'),ylabel('Shck')
axis square
subplot(222)
plot(AllPhase(:,1),AllPhase(:,2),'*')
axis square
xlabel('NoShck'),ylabel('Shck')
xlim([0 2*pi]),ylim([0 2*pi])
subplot(223)
[Y,X]=hist([AllPhase(:,1);AllPhase(:,1)+2*pi],20);Y=Y/sum(Y);
stairs(X,Y,'linewidth',2)
hold on
[Y,X]=hist([AllPhase(:,2);AllPhase(:,2)+2*pi],20);Y=Y/sum(Y);
stairs(X,Y,'linewidth',2)
legend('NoShck','Shck')

figure
AllFR=[];
for mm=1:length(MiceNumber)
    for sp=1:length(UMazeCond.Fil.PhasesSpikes{mm})
        AllFR=[AllFR;UMazeCond.FRZones{mm}{sp}];
    end
end
subplot(221)
plot(AllFR(:,1),AllFR(:,2),'*')
hold on
plot(AllFR(:,1),AllFR(:,1),'k*')
axis square
xlabel('NoShck'),ylabel('Shck')
subplot(222)
plot(log(AllFR(:,1)),log(AllFR(:,2)),'*')
hold on
plot(log(AllFR(:,1)),log(AllFR(:,1)),'k*')
axis square
xlabel('NoShck'),ylabel('Shck')
subplot(223)
ModInd=(AllFR(:,1)-AllFR(:,2))./(AllFR(:,1)+AllFR(:,2));
plotSpread(ModInd)
xlim([0 2])
line(xlim,[0 0],'color','k')
line([0.5 1.5],[1 1]*nanmean(ModInd),'color','b','linewidth',2)
[h,p]=ttest(ModInd);
text(1,1.3,'***')
ylim([-1.5 1.5])



for mm=1:length(MiceNumber)
    for sp=1:length(UMazeCond.Fil.PhasesSpikes{mm})
        try
            subplot(221)
            imagesc(UMazeHab.map{mm}{sp}.Run.rate)
            subplot(222)
            imagesc(UMazeTestPre.map{mm}{sp}.Run.rate)
            subplot(223)
            imagesc(UMazeTestPost.map{mm}{sp}.Run.rate)
            subplot(224)
            imagesc(UMazeExt.map{mm}{sp}.Run.rate)
            pause
        end
    end
end